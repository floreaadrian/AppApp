const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const connUri = process.env.MONGODB_URI;

const Reservation = require('../models/reservation');
const Business = require('../models/business');
const Specialization = require('../models/specialization');
const Users = require('../models/users');
const sendEmailRez = require('../rezervare');

const refactorForClient = (myArray) => {
    const promises = myArray.map(async(x) => {
        var newData = {
            "startTime": x.startTime,
            "endTime": x.endTime,
            "_id": x._id,
            "date": x.date
        };
        var newOne;
        try {
            newOne = await Business.findOne({
                _id: x.businessId,
            });
        } catch (e) {
            console.error(e);
        }
        newData["business"] = {
            "id": newOne._id,
            "name": newOne.name,
            "email": newOne.email,
            "imageString": newOne.imageString,
            "phone": newOne.phone,
            "desc": newOne.desc,
            "adress": newOne.adress,
            "latLang": newOne.latLang
        };
        try {
            newOne = await Specialization.findOne({
                _id: x.specializationId,
            });
        } catch (e) {
            console.error(e);
        }
        newData["specializaton"] = newOne.name;
        return newData;
    });
    return Promise.all(promises);
}

const refactorForService = (myArray) => {
    const promises = myArray.map(async(x) => {
        var newData = {
            "startTime": x.startTime,
            "endTime": x.endTime,
            "date": x.date
        };
        var newOne;
        try {
            newOne = await Users.findOne({
                _id: x.clientId,
            });
        } catch (e) {
            console.error(e);
        }

        newData["userName"] = newOne.name;
        try {
            newOne = await Specialization.findOne({
                _id: x.specializationId,
            });
        } catch (e) {
            console.error(e);
        }
        newData["specializatonName"] = newOne.name;
        return newData;
    });
    return Promise.all(promises);
}

module.exports = {
    add: async(req, res) => {
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            let result = {};
            let status = 201;
            if (!err) {
                const {
                    businessId,
                    specializationId,
                    clientId,
                    startTime,
                    endTime,
                    date,
                } = req.body;
                const reservation = new Reservation({
                    businessId,
                    specializationId,
                    clientId,
                    startTime,
                    endTime,
                    date,
                });
                reservation.save(async(err, reservation) => {
                    if (!err) {
                        result.status = status;
                        result.result = reservation;
                        var newOne;
                        try {
                            newOne = await Business.findOne({
                                _id: businessId,
                            });
                        } catch (e) {
                            console.error(e);
                        }
                        var newClient;
                        try {
                            newClient = await Users.findOne({
                                _id: clientId,
                            });
                        } catch (e) {
                            console.error(e);
                        }
                        var newService;
                        try {
                            newService = await Specialization.findOne({
                                _id: specializationId,
                            });
                        } catch (e) {
                            console.error(e);
                        }
                        await sendEmailRez(newClient.email, date, startTime, newOne.adress, endTime, newOne.name, newService.name);
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
    getFromBussinesId: async(req, res) => {
        const {
            businessId,
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
                Reservation.find({
                    businessId,
                    date
                }, async(err, reservation) => {
                    if (!err && reservation.length > 0) {
                        status = 200;
                        result.status = status;
                        result.result = await refactorForService(reservation);
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
    getFromServiceId: async(req, res) => {
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
                Reservation.find({
                    specializationId,
                    date
                }, async(err, reservation) => {
                    if (!err && reservation.length > 0) {
                        status = 200;
                        result.status = status;
                        result.result = await refactorForService(reservation);
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
    getFromClientId: async(req, res) => {
        const {
            clientId,
        } = req.params;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Reservation.find({
                    clientId
                }, async(err, reservation) => {
                    if (!err && reservation.length > 0) {
                        status = 200;
                        result.status = status;
                        result.result = await refactorForClient(reservation);
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
    delete: (req, res) => {
        const {
            reservationId,
        } = req.params;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, (err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Reservation.deleteOne({
                    _id: reservationId
                }, (err, reservation) => {
                    if (!err) {
                        status = 200;
                        result.status = status;
                        result.result = "Succeseful";
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