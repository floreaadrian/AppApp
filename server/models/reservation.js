const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const environment = process.env.NODE_ENV;
const stage = require('../config')[environment];

// schema maps to a collection
const Schema = mongoose.Schema;

const reservationSchema = new Schema({
    businessId: {
        type: 'String',
        required: true,
        trim: true
    },
    specializationId: {
        type: 'String',
        required: true,
        trim: true
    },
    clientId: {
        type: 'String',
        required: true,
        trim: true
    },
    startTime: {
        type: 'String',
        required: true,
        trim: true,
    },
    endTime: {
        type: 'String',
        required: true,
    },
    date: {
        type: 'String',
        required: true,
        trim: true,
    },
});


module.exports = mongoose.model('Reservation', reservationSchema); // instance of schema