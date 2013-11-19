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
    console.log('roomRemote.prototype.roomEixt');
    console.log(arguments);
    var table = this.app.tables[roomid];
    console.log(table);
    if(!!table){
        table.emit('exitRoom',playerid,sid,null);
    }

}