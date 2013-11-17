/**
 * Created by xiaochuan on 13-11-12.
 */
module.exports = function(app) {
    return new Handler(app);
};

var Table = require('../../../model/table');

var playerm = require('../../../model/player');

var Handler = function(app) {
    this.app = app;
    this.channelService = this.app.get('channelService');
    app.tables = {};

    var rooms = require('../../../../resource/room');
    for(var roomindex in rooms){
        var room = rooms[roomindex];
        var channel = this.channelService.getChannel(room.key, true);
        var table = Table(channel,room);
        app.tables[room.key] = table;
    }

};

/**
 * New client entry chat server.
 *
 * @param  {Object}   msg     request message
 * @param  {Object}   session current session object
 * @param  {Function} next    next stemp callback
 * @return {Void}
 */
Handler.prototype.roomEnter = function(msg, session, next) {
    var roomid = msg.roomid;
    var table = this.app.tables[roomid];
    playerm.findByPlayerId(session.uid,function(err,docs){
        if(!err){
            table.emit("enterRoom",docs[0],session);
        }
    });

    next(null);
};

Handler.prototype.roomExit = function(msg,session,next){
    var roomid = session.get('roomid');
    var table = this.app.tables[roomid];
    table.emit('exitRoom',session,function(desc,player){
        if(!!desc){
            next(null,{
                code:500,
                desc:desc
            });
        }else{
            next(null,{
                code:200,
                player:player
            });
        }
    });

};
Handler.prototype.answer = function(msg,session,next){
    var roomid = session.get('roomid');
    var table = this.app.tables[roomid];
    table.emit('receiveAnswer',session.uid,msg.answerid,function(desc){
        if(!!desc){
            next(null,{
                code:500,
                desc:desc
            });
        }else{
            next(null,{
                code:200
            });
        }
    });
};