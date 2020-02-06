const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const environment = process.env.NODE_ENV;
const stage = require('../config')[environment];

// schema maps to a collection
const Schema = mongoose.Schema;

const specializationSchema = new Schema({
    bussniesId: {
        type: 'String',
        required: true,
        trim: true
    },
    name: {
        type: 'String',
        required: true,
        trim: true
    },
    desc: {
        type: 'String',
        required: true,
        trim: true,
    },
    startTime: {
        type: 'String',
        required: true,
        trim: true,
    },
    endTime: {
        type: 'String',
        required: true,
        trim: true,
    },
    duration: {
        type: 'Number',
        required: true,
    },
    zile: {
        type: 'String',
        required: true
    }
});

module.exports = mongoose.model('Specialization', specializationSchema); // instance of schema