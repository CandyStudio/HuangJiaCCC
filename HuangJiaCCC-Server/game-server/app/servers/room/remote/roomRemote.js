/**
 * Created by xiaochuan on 13-11-13.
 */
module.exports = function (app) {
    return new roomRemote(app);
};

var roomRemote = function (app) {
    this.app = app;
};

roomRemote.prototype.roomEixt = function(playerid,sid,roomid){
    var table = this.app.tables[roomid];
    if(!!table){
        table.emit('exitRoom',playerid,sid,null);
    }

}