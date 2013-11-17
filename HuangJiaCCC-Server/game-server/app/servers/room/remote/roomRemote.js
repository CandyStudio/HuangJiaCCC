/**
 * Created by xiaochuan on 13-11-13.
 */
module.exports = function (app) {
    return new roomRemote(app);
};

var roomRemote = function (app) {
    this.app = app;
};

roomRemote.prototype.roomEixt = function(playerid,roomid,sid){
    var table = this.app.tables[roomid];
    if(!!table){
        table.emit('disconnectRoom',playerid,sid,null);
    }

}