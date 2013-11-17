module.exports = function(app) {
  return new Handler(app);
};

var Handler = function(app) {
  this.app = app;
  this.players = {};
};

/**
 * New client entry chat server.
 *
 * @param  {Object}   msg     request message
 * @param  {Object}   session current session object
 * @param  {Function} next    next stemp callback
 * @return {Void}
 */
Handler.prototype.entry = function(msg, session, next) {
    var playerid = msg.playerid;
    console.log(msg);
    if(!!playerid){
        var player = this.players[playerid];
        console.log(player);
        if(!player){
            console.log('没登陆');
            this.players[playerid]= 1;
            session.bind(playerid);
            session.on('closed', onUserLeave.bind(this, this.app));
            return next(null,{
               code:200
            });
        }else{
            console.log('重复登陆');
            return next(null,{
                code:500,
                desc:"重复登录"
            });
        }
    }
    else{
        return next(null,{
            code:500,
            desc:"参数错误"
        });
    }

};


var onUserLeave = function(app,session){
    delete this.players[session.uid];
    var roomid = session.get('roomid');
    if(!!roomid){
        app.rpc.room.roomRemote.roomEixt(session,session.uid,roomid,session.frontendId,null);
    }
    console.log('玩家离开');
};