/**
 * Created by xiaochuan on 13-11-12.
 */
var utils = require('util'),
    EventEmitter = require('events').EventEmitter;
var Const = require('../const');
var underscore = require('underscore');
var playerServer = require('./player');

var allQuestions = require('../../resource/question');

var app = require('pomelo').app;

var Table = function(channel,room){
    this.channel = channel;
    this.room = room;
    this.status = Const.TabelStatus.Wait;
    this.players = {};
    this.tablePlayers = {};
    this.leavePlayers = {};
    this.questions = [];
    this.currentQuestionIndex = 0;
    this.isAnswered = false;
    this.answerid = 0;

    setInterval(update.bind(this), 1000);

    this.readyTime = 0;

    this.answerTime = 0;
};


function update(){
    var t =   Date.now();
    if(this.status == Const.TabelStatus.Wait){
        //延迟3秒
        if(t-this.readyTime > 3000){
            //满场了 开始
            var playercount = underscore.values(this.players).length;


            if(playercount == this.room.people){
                this.emit('gameStart');
            }
        }
    }else{
        if(!this.isAnswered){
            //时间到
            if(t-this.answerTime>15000){
                this.emit('receiveAnswer');
            }
        }



    }
}

utils.inherits(Table,EventEmitter);

var chenckIfFinish = function(){
    console.log('chenckIfFinish');
    if(this.status === Const.TabelStatus.Start){
        var isFinish = false;
        do{
            console.log('this.currentQuestionIndex:'+this.currentQuestionIndex + ' this.room.questioncount :'+this.room.questioncount);
            if(this.currentQuestionIndex === this.room.questioncount){
                console.log('题全部打完');
                //题全部打完
                isFinish = true;
                break;
            }

            var leftPlayers = underscore.values(this.tablePlayers);

            console.log('leftPlayers.length:'+leftPlayers.length);
            if(leftPlayers.length<2){
                console.log('剩余人数不够');
                //剩余人数不够
                isFinish = true;
                break;
            }

            var aliveCount = 0;
            for(var index in leftPlayers){
                var tPlayer = leftPlayers[index];
                if(tPlayer.hp>0){
                    aliveCount++;
                }
            }
            console.log('aliveCount:'+aliveCount);
            if(aliveCount<2){
                console.log('活着的人数不够了');
                //活着的人数不够了
                isFinish = true;
                break;
            }


        }while(0);

        if(isFinish){
            console.log('游戏结束');
            this.emit('oneGameFinish');
        }else{
            console.log('3秒后发题');
            var _this = this;
            //3秒以后发题
            setTimeout(function(){
                _this.emit('sendQuestion');
            },3000);
        }

    }
};



var oneGameFinish = function(){
    this.status = Const.TabelStatus.Wait;
    this.readyTime = Date.now()+3000;
    var resl = {};
    underscore.extend(resl,this.leavePlayers);
    underscore.extend(resl,this.tablePlayers);
    //为了简单  这里有的有username  没有的需要客户端查

    console.log(this.leavePlayers);
    console.log(this.tablePlayers);
    console.log(resl);
    this.channel.pushMessage('onGemeover',{
        players:resl
    });


    var _this = this;
    var  channelService = app.get('channelService');
    playerServer.findByPlayerIds(underscore.keys(resl),function(err,players){
        if(!err){
            for(var i in players){
                var tp = players[i];
                tp.score += resl[tp.playerid].score;
                tp.save();
                var member = _this.channel.getMember(tp.playerid);
                if(!!member){
                    var serverid = member['sid'];
                    channelService.pushMessageByUids('onPlayerInfo',{
                        player:tp
                    }, [
                        {
                            uid: tp.playerid,
                            sid: serverid
                        }
                    ]);
                }
            }
        }
    });
}

var enterRoom = function(player,session){

    _this = this;
    var playercount = underscore.values(this.players).length;
    if(this.status === Const.TabelStatus.Wait){
        if(playercount<this.room.people){
            this.players[player.playerid]=player;
            //房间玩家初始化数据
            this.tablePlayers[player.playerid] = {
                playerid:player.playerid,
                hp : _this.room.hp,
                score:0
            };

            _this.channel.pushMessage("onRoomEnter",{
                player:player,
                roomplayer:_this.tablePlayers[player.playerid]
            });
            this.channel.add(player.playerid,session.frontendId);
            session.set('roomid',_this.room.key);
            session.push('roomid');
            this.channel.pushMessage("onRoomInfo",{
                code:200,
                players:_this.players,
                roomplayers:_this.tablePlayers
            });
            this.readyTime = Date.now();
        }else{
            //方便push  用全局push 最好
            this.channel.add(player.playerid,session.frontendId);
            this.channel.pushMessage("onRoomInfo",{
                code:500,
                desc:'房间满了'
            },function(){
                _this.channel.level(player.playerid,session.frontendId);
            });
        }

    }else{
        this.channel.add(player.playerid,session.frontendId);
        this.channel.pushMessage("onRoomInfo",{
            code:500,
            desc:'游戏开始了'
        },function(){
            _this.channel.level(player.playerid,session.frontendId);
        });
    }



};

var gameStart = function(){
    console.log('开始');
    var theQuest = allQuestions.slice(0);
    for (var i = theQuest.length; --i >= 1; ) {
        var j = Math.round(Math.random() * i);
        var swap = theQuest[i];

        theQuest[i] = theQuest[j];
        theQuest[j] = swap;
    }
    this.answerTime = Date.now() + 18000;

    this.status = Const.TabelStatus.Start;
    this.leavePlayers = {};
    this.questions = theQuest.slice(0,this.room.questioncount);
    this.currentQuestionIndex = 0;
    this.isAnswered = false;
    for(var i in this.tablePlayers){
        var ttp = this.tablePlayers[i];
        ttp.score = 0;
        ttp.hp = 100;
    }
    var _this = this;
    this.channel.pushMessage('onGameStart',{
        players:_this.tablePlayers
    });

    setTimeout(function(){
        _this.emit('sendQuestion');
    },3000);
}

var sendQuestion = function(){
    console.log('sendQuestion');
    if(this.status === Const.TabelStatus.Start){
        var question = this.questions[this.currentQuestionIndex++];
        if(!!question){
            this.answerid = Math.round(Math.random() * 9999)+999;//防止出现0
            var _this = this;
            _this.isAnswered = false;
            this.channel.pushMessage("onQuestion",{
                questionid:question.id,
                answerid:_this.answerid
            });
            this.answerTime = Date.now() + 15000;
        }
    }

}

var receiveAnswer = function(playerid,answerid,cb){
    console.log('receiveAnswer');
    console.log(arguments);
    if(this.status === Const.TabelStatus.Start){
        console.log('开始状态');
        if(!this.isAnswered){
            console.log('没有回答');
                if((!playerid&&!answerid)||answerid == this.answerid){
                    if(cb){
                        cb(null);
                    }
                    var _this = this;
                    _this.isAnswered = true;
                    if(!!playerid){
                        //有玩家答对
                        console.log(playerid +' 答对了');
                        var t = Date.now();
                        var tablePlayer = _this.tablePlayers[playerid];
                        var tScore = Math.ceil( (_this.answerTime - t)/1000);

                        console.log('加分:'+tScore);
                        tScore = tScore<0?0:tScore;
                        if(!!tablePlayer){
                            console.log('加上分');
                            tablePlayer.hp +=tScore;
                            tablePlayer.score += tScore;
                        }
                    }
                    for(var tin in _this.tablePlayers){
                        var tablePlayer = _this.tablePlayers[tin];
                        if(tin !== playerid){
                            tablePlayer.hp -= 15;
                            if(tablePlayer.hp <0){
                                tablePlayer.hp = 0;
                            }
                        }else{
                            var t = Date.now();
                            tablePlayer.hp +=Math.ceil( (_this.answerTime - t)/1000);
                        }
                    }
                    console.log('pushMessage onAnswer');
                    _this.channel.pushMessage('onAnswer',{
                        playerid:playerid,
                        players:_this.tablePlayers,
                        answerid:_this.answerid
                    });
                    _this.emit('chenckIfFinish');

                }else{
                    if(cb){
                        cb('回答错误');
                    }

                }

        }else{
            if(cb){
                cb('已经答过了');
            }
        }
    }else{
        if(cb){
            cb('游戏已经结束');
        }
    }
}

var exitRoom = function(playerid,frontendId,cb){
    console.log('离开房间');
    console.log(playerid);
    this.channel.leave(playerid,frontendId);

    this.channel.pushMessage('onRoomExit',{
        playerid:playerid
    });
    console.log(this.status);
    if(this.status === Const.TabelStatus.Start){
        this.leavePlayers[playerid] = this.tablePlayers[playerid];
        this.leavePlayers[playerid].username = this.players[playerid].username;
    }
    delete  this.players[playerid];
    delete  this.tablePlayers[playerid];
    console.log('chenckIfFinish');
    this.emit('chenckIfFinish');
    console.log('this.emit(chenckIfFinish);');
    playerServer.findByPlayerId(playerid,function(err,docs){
        console.log('findByPlayerId');
        if(!!cb){
            console.log('cb');
            cb(null,docs[0]);
        }
    });

}



var useHelp = function(playerid,id,cb){
    var _this = this;
    playerServer.findByPlayerId(playerid,function(err,docs){
        var player = docs[0];
        if(player.coin>=50){
            player.coin -=50;
            _this.players[playerid] = player;
            _this.channel.pushMessage('onHelp',{
                player:playerid,
                helpid:id,
                players:_this.tablePlayers
            });
            var member = _this.channel.getMember(playerid);
            if(!!member){
                var serverid = member['sid'];
                var  channelService = app.get('channelService');
                channelService.pushMessageByUids('onPlayerInfo',{
                    player:player
                }, [
                    {
                        uid: playerid,
                        sid: serverid
                    }
                ]);
            }
            if(cb){
                cb(null);
            }
        }else
        {
            if(cb){
                cb('钱不够');
            }

        }

    });
}

var createNewTable = function(channel,room){
    var t = new Table(channel,room);
    t.on('enterRoom',enterRoom);

    t.on('gameStart',gameStart);

    t.on('exitRoom',exitRoom);

    t.on('sendQuestion',sendQuestion);

    t.on('receiveAnswer',receiveAnswer);


    t.on('chenckIfFinish',chenckIfFinish);

    t.on('oneGameFinish',oneGameFinish);

    t.on('useHelp',useHelp);
    return t;
}





utils.inherits(Table,EventEmitter);

module.exports = createNewTable;
