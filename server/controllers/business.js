const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const connUri = process.env.MONGODB_URI;

const Business = require('../models/business');

const geocode = require('../geocode.js');

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
                    phone,
                    desc,
                    categoryB,
                    cartierB
                } = req.body;
                var {
                    adress
                } = req.body;
                const activated = false;
                const imageString = "default";
                var latLang = "default";
                var geo;
                try {
                    geo = await geocode.decodeAdress(adress);
                } catch (e) {
                    console.log(e);
                }
                const cartier = cartierB != null ? cartierB : "default";
                const category = categoryB != null ? categoryB : "default";
                latLang = geo[0].latitude + "," + geo[0].longitude;
                adress = geo[0].formattedAddress;
                const business = new Business({
                    name,
                    password,
                    email,
                    imageString,
                    phone,
                    desc,
                    latLang,
                    adress,
                    cartier,
                    category,
                    activated
                });
                business.save(async(err, business) => {
                    if (!err) {
                        await emailSender(business.email, business.name,
                            'http://localhost:300/business/activate/' + business._id, );
                        result.status = status;
                        result.result = {
                            "id": business._id,
                            "name": business.name,
                            "email": business.email,
                            "phone": business.phone,
                            "desc": business.desc,
                            "adress": business.adress,
                            "latLang": business.latLang,
                            "cartier": business.cartier,
                            "category": business.category,
                            "activated": business.activated
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
                Business.findOne({
                    email
                }, (err, business) => {
                    if (!err && business) {
                        bcrypt.compare(password, business.password).then(match => {
                            if (match) {
                                status = 200;
                                // Create a token
                                const payload = {
                                    business: business.email
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
                                    "id": business._id,
                                    "name": business.name,
                                    "email": business.email,
                                    "phone": business.phone,
                                    "desc": business.desc,
                                    "adress": business.adress,
                                    "latLang": business.latLang,
                                    "cartier": business.cartier,
                                    "category": business.category,
                                    "activated": business.activated
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
    filter: (req, res) => {
        const {
            categorie,
            cartier,
            nume
        } = req.query;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, (err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Business.find({
                    name: {
                        '$regex': nume,
                        '$options': 'i'
                    },
                    category: {
                        '$regex': categorie,
                        '$options': 'i'
                    },
                    cartier: {
                        '$regex': cartier,
                        '$options': 'i'
                    }
                }, (err, business) => {
                    if (!err && business.length > 0) {
                        status = 200;
                        result.status = status;
                        result.result = business.map((x) => {
                            const newOne = {
                                "id": x._id,
                                "name": x.name,
                                "email": x.email,
                                "phone": x.phone,
                                "desc": x.desc,
                                "adress": x.adress,
                                "latLang": x.latLang,
                                "cartier": x.cartier,
                                "category": x.category,
                                "activated": x.activated
                            };
                            return newOne;
                        });
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
    activate: async(req, res) => {
        const {
            businessId,
        } = req.params;

        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Business.updateOne({
                    _id: businessId
                }, {
                    "activated": true
                }, async(err, business) => {
                    if (!err && business) {
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
            businessId,
        } = req.params;

        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            var objForUpdate = {};
            if (req.body.category) objForUpdate.category = req.body.category;
            if (req.body.cartier) objForUpdate.cartier = req.body.cartier;
            if (req.body.phone) objForUpdate.phone = req.body.phone;
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
                Business.updateOne({
                    _id: businessId
                }, objForUpdate, async(err, business) => {
                    if (!err && business) {
                        status = 200;
                        result.status = status;
                        result.result = {
                            "id": business._id,
                            "name": business.name,
                            "email": business.email,
                            "phone": business.phone,
                            "desc": business.desc,
                            "adress": business.adress,
                            "latLang": business.latLang,
                            "cartier": business.cartier,
                            "category": business.category,
                            "activated": business.activated
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
    details: async(req, res) => {
        const {
            businessId,
        } = req.params;
        mongoose.connect(connUri, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        }, async(err) => {
            let result = {};
            let status = 200;
            if (!err) {
                Business.findOne({
                    _id: businessId
                }, async(err, business) => {
                    if (!err && business) {
                        status = 200;
                        result.status = status;
                        result.result = {
                            "id": business._id,
                            "name": business.name,
                            "email": business.email,
                            "phone": business.phone,
                            "desc": business.desc,
                            "adress": business.adress,
                            "latLang": business.latLang,
                            "cartier": business.cartier,
                            "category": business.category,
                            "activated": business.activated
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