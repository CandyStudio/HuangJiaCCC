var pomelo = require('pomelo');


var playerm = require('./app/model/player');

var handShake = function(msg,cb){
    var username,password;
    var userinfo = msg.user;
    if(!!userinfo){
        username = userinfo.username;
        password = userinfo.password;
        //参数没做验证
        if(!!username && !!password){
            playerm.findByUsernameAndPassword(username,password,function(err,docs){
                if(!!err){
                    return cb(null,{
                        code:500,
                        error:{
                            code:1,
                            desc:"服务器错误"
                        }
                    });
                }else{

                    if(!!docs && docs.length>0){

                        return cb(null,{
                            code:200,
                            player:docs[0]
                        });
                    }else{
                        player = new playerm();
                        player.username = username;
                        player.password = password;
                        player.save(function(err,player){
                            return cb(null,{
                                code:200,
                                player:player
                            });
                        });
                    }

                }
            });
        }else{
            return cb(null,{
                code:500,
                desc:"参数错误"

            });
        }

    }else{
        return cb(null,{
            code:500,
            error:{
                code:1,
                desc:"参数错误"
            }
        });
    }

};


/**
 * Init app for client.
 */
var app = pomelo.createApp();
app.set('name', 'HuangJiaCCC');

// app configuration
app.configure('production|development', 'connector', function(){
	app.set('connectorConfig',
		{
			connector : pomelo.connectors.hybridconnector,
			heartbeat : 20,
			useDict : true,
			useProtobuf : true,
            disconnectOnTimeout: true,
            handshake:handShake
		});
});

//设置数据库
app.configure(function(){
    var mongoose = require('mongoose');
    var dbconf = require('./config/config').database;
    var myMongo = dbconf['mongodb'];
    //创建数据连接，并设置链接池
    var opts = { db: { native_parser: true }, server: { poolSize: myMongo.poolSize, socketOptions: { keepAlive: myMongo.keepAlive } } };
    var mongoConnect = 'mongodb://' + myMongo.user + ":" + myMongo.password + "@" + myMongo.host + ":" + myMongo.port + '/' + myMongo.database;
    mongoose.connect(mongoConnect, opts, function(err){
        if(err){
            console.error('connect to %s error: ', mongoConnect, err.message);
            process.exit(1);
        }
    });
    app.set('mongoose', mongoose);
});

// start app
app.start();

process.on('uncaughtException', function (err) {
  console.error(' Caught exception: ' + err.stack);
});
