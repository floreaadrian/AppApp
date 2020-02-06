const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const environment = process.env.NODE_ENV;
const stage = require('../config')[environment];

const connUri = process.env.MONGODB_URI;

const User = require('../models/users');

const emailSender = require('../emailSender');

const toReturn = require('../thanksPage');

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
                    name,
                    password,
                    email,
                    username,
                    dob,
                    imageString,
                    phone
                } = req.body;
                const activated = false;
                const user = new User({
                    name,
                    password,
                    email,
                    username,
                    dob,
                    imageString,
                    phone,
                    activated
                });
                user.save(async(err, user) => {
                    if (!err) {
                        await emailSender(user.email, user.name,
                            'http://localhost:300/client/activate/' + user._id, );
                        result.status = status;
                        result.result = {
                            "_id": user._id,
                            "name": user.name,
                            "email": user.email,
                            "phone": user.phone,
                            "username": user.username,
                            "dob": user.dob,
                            "activated": user.activated
                        };
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
    login: (req, res) => {
        const {
            email,
            password
        } = req.body;

        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, (err) => {
            let result = {};
            let status = 200;
            if (!err) {
                User.findOne({
                    email
                }, (err, user) => {
                    if (!err && user) {
                        bcrypt.compare(password, user.password).then(match => {
                            if (match) {
                                status = 200;
                                // Create a token
                                const payload = {
                                    user: user.name
                                };
                                const options = {
                                    expiresIn: '2d',
                                    issuer: 'ceplm'
                                };
                                const secret = process.env.JWT_SECRET;
                                const token = jwt.sign(payload, secret, options);

                                result.token = token;
                                result.status = status;
                                result.result = {
                                    "_id": user._id,
                                    "name": user.name,
                                    "email": user.email,
                                    "phone": user.phone,
                                    "username": user.username,
                                    "dob": user.dob,
                                    "activated": user.activated
                                };
                            } else {
                                status = 401;
                                result.status = status;
                                result.error = `Authentication error`;
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
                    }
                }).then(() =>
                    mongoose.connection.close());
            } else {
                status = 500;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
    activate: async(req, res) => {
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
                User.updateOne({
                    _id: clientId
                }, {
                    "activated": true
                }, async(err, user) => {
                    if (!err && user) {
                        result = await toReturn();
                    } else {
                        status = 404;
                        result.status = status;
                        result.error = err;
                    }
                    res.status(status).send(result);
                }).then(() =>
                    mongoose.connection.close());
            } else {
                status = 500;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
    changeSettings: async(req, res) => {
        const {
            clientId,
        } = req.params;

        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            var objForUpdate = {};
            if (req.body.dob) objForUpdate.dob = req.body.dob;
            if (req.body.password) {
                try {
                    objForUpdate.password = await bcrypt.hash(req.body.password, stage.saltingRounds);
                } catch (err) {
                    console.error("Couldn't hash the password");
                }
            }
            objForUpdate = {
                $set: objForUpdate
            }
            let result = {};
            let status = 200;
            if (!err) {
                User.updateOne({
                    _id: clientId
                }, objForUpdate, async(err, user) => {
                    if (!err && user) {
                        status = 200;
                        result.status = status;
                        result.result = user;
                    } else {
                        status = 404;
                        result.status = status;
                        result.error = err;
                    }
                    res.status(status).send(result);
                }).then(() =>
                    mongoose.connection.close());
            } else {
                status = 500;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
    details: async(req, res) => {
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
                User.findOne({
                    _id: clientId
                }, async(err, user) => {
                    if (!err && user) {
                        status = 200;
                        result.status = status;
                        result.result = {
                            "_id": user._id,
                            "name": user.name,
                            "email": user.email,
                            "phone": user.phone,
                            "username": user.username,
                            "dob": user.dob
                        };
                    } else {
                        status = 404;
                        result.status = status;
                        result.error = err;
                    }
                    res.status(status).send(result);
                }).then(() =>
                    mongoose.connection.close());
            } else {
                status = 500;
                result.status = status;
                result.error = err;
                res.status(status).send(result);
                mongoose.connection.close();
            }
        });
    },
};