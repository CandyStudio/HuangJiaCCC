/**
 * Created by xiaochuan on 13-11-12.
 */
var Schema, idSchema, mongoose;

mongoose = require('mongoose');

Schema = mongoose.Schema;

idSchema = new Schema({
    id: {
        type: Number
    },
    tablename: {
        type: String
    }
});

idSchema["static"]({
    'get': function(table, cb) {
        var _this;
        cb = cb || function() {};
        _this = this;
        return this.findOneAndUpdate({
            "tablename": table
        }, {
            "$inc": {
                'id': 1
            }
        }, function(err, docs) {
            if (err) {
                return cb(err);
            }
            if (!docs) {
                return _this.create({
                    "tablename": table,
                    "id": 1
                }, function(err, doc) {
                    if (err) {
                        return cb(err);
                    }
                    return cb(null, doc.id);
                });
            } else {
                return cb(null, docs.id);
            }
        });
    }
});

module.exports = mongoose.model('hjcccid', idSchema);