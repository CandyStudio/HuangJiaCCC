/**
 * Created by xiaochuan on 13-11-12.
 */
var Schema,mongoose,ID;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ID = require('./id');

playerSchema = new Schema({
    playerid:{
        type:Number
    },
    username:{
        type:String,
        index:true
    },
    password:{
        type:String,
        index:true
    },
    coin:{
        type:Number,
        default:10000
    },
    score:{
        type:Number,
        default:0
    }

},
    {
        versionKey: false
    }
);


playerSchema.pre('save',function(next){
    var _this;
    if(this.isNew){
        _this = this;
        return ID.get('player',function(err,id){
            if(err){
                return next(err);
            }
            _this.playerid = id;
            return next();
        });
    }else{
        return next();
    }
});

playerSchema.post('save',function(player){
    return player;
});

playerSchema['static']({
   'findByUsernameAndPassword':function(username,password,cb){
       return this.find({
           username:username,
           password:password
       },function(err,docs){
           if(err){
               return cb(err);
           }else{
               return cb(null,docs);
           }
       });
   },
    'findByPlayerId':function(playerid,cb){
        return this.find({
            playerid:playerid
        },function(err,docs){
            if(err){
                return cb(err);
            }else{
                return cb(null,docs);
            }
        });
    },
    'findByPlayerIds':function(playerids,cb){
        if (!Array.isArray(playerids)) {
            playerids = [playerids];
        }
        return this.find({
            playerid: {
                $in: playerids
            }
        },function(err,docs){
            if(err){
                return cb(err);
            }else{
                return cb(null,docs);
            }
        });

    }
});

module.exports = mongoose.model('Player', playerSchema);
