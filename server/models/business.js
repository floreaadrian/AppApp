const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const environment = process.env.NODE_ENV;
const stage = require('../config')[environment];

// schema maps to a collection
const Schema = mongoose.Schema;

const businessSchema = new Schema({
    name: {
        type: 'String',
        required: true,
        trim: true
    },
    password: {
        type: 'String',
        required: true,
        trim: true
    },
    email: {
        type: 'String',
        required: true,
        trim: true,
        unique: true
    },
    phone: {
        type: 'Number',
        required: true,
        trim: true,
    },
    desc: {
        type: 'String',
        required: true,
        trim: true,
    },
    latLang: {
        type: 'String',
        required: false,
        trim: true
    },
    adress: {
        type: 'String',
        required: true,
        trim: true
    },
    category: {
        type: 'String',
        required: true,
        trim: true
    },
    cartier: {
        type: 'String',
        required: true,
        trim: true
    },
    activated: {
        type: 'Boolean',
        required: true
    }
});

// encrypt password before save
businessSchema.pre('save', function(next) {
    const business = this;
    if (!business.isModified || !business.isNew) {
        next();
    } else {
        bcrypt.hash(business.password, stage.saltingRounds, function(err, hash) {
            if (err) {
                console.log('Error hashing password for business', business.name);
                next(err);
            } else {
                business.password = hash;
                next();
            }
        });
    }
});

module.exports = mongoose.model('Business', businessSchema); // instance of schema