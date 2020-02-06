const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const connUri = process.env.MONGODB_URI;

const Specialization = require('../models/specialization');
const calculate = require('../calculateDays');
const Reservation = require('../models/reservation');

const dateInReserved = (result, item) => {
    for (var i = 0; i < result.length; ++i) {
        if (result[i].startTime == item) {
            return false;
        }
    }
    return true;
}

const getTheDates = async(specialization, date) => {
    var datesGenerated = calculate(specialization.startTime,
        specialization.endTime,
        specialization.duration,
        date,
        specialization.zile, );

    var result = await Reservation.find({
        specializationId: specialization._id,
        date
    });
    datesGenerated = datesGenerated.filter(function(item, idx) {
        return dateInReserved(result, item.split("-")[0]);
    }).map((x) => {
        return {
            "startTime": x.split("-")[0],
            "endTime": x.split("-")[1]
        }
    });
    return datesGenerated;
}

module.exports = {
    add: (req, res) => {
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, (err) => {
            let result = {};
            let status = 201;
            if (!err) {
                const {
                    bussniesId,
                    name,
                    desc,
                    startTime,
                    endTime,
                    duration,
                    zile
                } = req.body;
                const specialization = new Specialization({
                    bussniesId,
                    name,
                    desc,
                    startTime,
                    endTime,
                    duration,
                    zile
                });
                specialization.save((err, specialization) => {
                    if (!err) {
                        result.status = status;
                        result.result = specialization;
                    } else {
                        status = 500;
                        result.status = status;
                        result.error = err;
                    }
                    res.status(status).send(result);
                    // Close the connection after saving
                    mongoose.connection.close();
                });
            } else {
                status = 500;
                result.status = status;
                result.error = err;
                res.status(status).send(result);

                mongoose.connection.close();
            }
        });
    },
    getFromBussinesId: (req, res) => {
        const {
            bussniesId,
        } = req.params;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, (err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Specialization.find({
                    bussniesId
                }, (err, specialization) => {
                    if (!err && specialization.length > 0) {
                        status = 200;
                        result.status = status;
                        result.result = specialization;
                    } else {
                        status = 401;
                        result.status = status;
                        result.error = `Didn't found anything`;
                    }
                    res.status(status).send(result);
                }).catch(err => {
                    status = 500;
                    result.status = status;
                    result.error = err;
                    res.status(status).send(result);
                    mongoose.connection.close();
                });
            } else {
                status = 404;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
    getAvalibleDates: async(req, res) => {
        const {
            specializationId,
        } = req.params;
        const {
            date
        } = req.query;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Specialization.findOne({
                    _id: specializationId
                }, async(err, specialization) => {
                    if (!err && specialization != null) {
                        status = 200;
                        result.status = status;
                        result.result = await getTheDates(specialization, date);
                    } else {
                        status = 401;
                        result.status = status;
                        result.error = `Didn't found anything`;
                    }
                    res.status(status).send(result);
                }).catch(err => {
                    status = 500;
                    result.status = status;
                    result.error = err;
                    res.status(status).send(result);
                    mongoose.connection.close();
                });
            } else {
                status = 404;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
};