'use strict';

var app = require('../index');
var chai = require('chai');
const mongoose = require('mongoose')
var request = require('supertest');

var expect = chai.expect;

var business = {
    "name": "yeet",
    "password": "verysecure",
    "email": "yeetus@gmail.com",
    "phone": "987654321",
    "desc": "Just a business like any other",
    "adress": "somewhere",
    "cartier": "Manastur",
    "category": "Doctor"
}

var businessId;

var specialization = {
    "bussniesId": "",
    "name": "Dentist",
    "desc": "We specialize in teeth",
    "startTime": "10:00",
    "endTime": "17:00",
    "duration": 30,
    "zile": "Luni,Joi,Vineri"
}

var businessToken;
var specializationId;

var client = {
    "name": "not not me",
    "password": "not me",
    "email": "notme@gmail.com",
    "username": "notnotme",
    "dob": "1999-01-17",
    "imageString": "default",
    "phone": "987654312"
}
var clientId;

var reservation = {
    'businessId': "",
    'specializationId': "",
    'clientId': "",
    'startTime': "10:00",
    'endTime': '10:30',
    'date': '2020-01-20'
}

var reservationId;

describe('Business Tests', function () {
    before(() => mongoose.connection.collections['businesses'].drop(function (err) {
        console.log('businesses dropped');
    }))
    it('## Business registration', function (done) {
        request(app).post('/business/register').send(business).end(function (err, res) {
            expect(res.statusCode).to.equal(201);
            expect(res.body.result.name).to.equal("yeet");
            businessId = res.body.result.id;
            specialization["bussniesId"] = businessId;
            reservation["businessId"] = businessId;
            done();
        })
    })
    /* it('## Business registration - duplicate', function (done) {
        request(app).post('/business/register').send(business).end(function (err, res) {
            expect(res.statusCode).to.equal(500);
            done();
        })
    })*/
    it('## Business login', function (done) {
        request(app).post('/business/login').send({ "email": business.email, "password": business.password }).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            expect(res.body.result.email).to.equal("yeetus@gmail.com");
            businessToken = res.body.token;
            done();
        })
    })
    it('## Business login - incorrect password', function (done) {
        request(app).post('/business/login').send({ "email": business.email, "password": "business.password" }).end(function (err, res) {
            expect(res.statusCode).to.equal(401);
            done();
        })
    })
    it('## Business login - nonexistent user', function (done) {
        request(app).post('/business/login').send({ "email": "business.email", "password": "business.password" }).end(function (err, res) {
            expect(res.statusCode).to.equal(404);
            done();
        })
    })
    it('## Business filter', function (done) {
        request(app).get('/businesses?cartier=&categorie=&nume=').end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Business activation', function (done) {
        request(app).get('/business/activate/' + businessId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Business settings', function (done) {
        request(app).put('/business/' + businessId + '/settings').send({ "phone": "123456789" }).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Business details', function (done) {
        request(app).get('/business/' + businessId + '/details').end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            expect(res.body.result.name).to.equal("yeet");
            done();
        })
    })
})

describe('Specialization Tests', function () {
    before(() => mongoose.connection.collections['specializations'].drop(function (err) {
        console.log('specializations dropped');
    }))
    it('## Specialization add', function (done) {
        request(app).post('/business/add').set('Authorization', 'Bearer ' + businessToken).send(specialization).end(function (err, res) {
            expect(res.statusCode).to.equal(201);
            expect(res.body.result.startTime).to.equal("10:00");
            specializationId = res.body.result._id;
            reservation['specializationId'] = specializationId;
            done();
        })
    })
    it('## Business Services', function (done) {
        request(app).get('/business/' + businessId + '/services').end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Available dates', function (done) {
        request(app).get('/business/' + specializationId + '/datesAvalible').end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
})

describe('Client Tests', function () {
    before(() => mongoose.connection.collections['users'].drop(function (err) {
        console.log('users dropped');
    }))
    it('## Client registration', function (done) {
        request(app).post('/client/register').send(client).end(function (err, res) {
            expect(res.statusCode).to.equal(201);
            expect(res.body.result.name).to.equal("not not me");
            clientId = res.body.result._id;
            reservation['clientId'] = clientId;
            done();
        })
    })
    /*it('## Client registration - duplicate', function (done) {
        request(app).post('/client/register').send(client).end(function (err, res) {
            expect(res.statusCode).to.equal(500);
            done();
        })
    })*/
    it('## Client login', function (done) {
        request(app).post('/client/login').send({ "email": client.email, "password": client.password }).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            expect(res.body.result.name).to.equal("not not me");
            done();
        })
    })
    it('## Client login - wrong password', function (done) {
        request(app).post('/client/login').send({ "email": client.email, "password": "client.password" }).end(function (err, res) {
            expect(res.statusCode).to.equal(401);
            done();
        })
    })
    it('## Client login - nonexistent user', function (done) {
        request(app).post('/client/login').send({ "email": "client.email", "password": "client.password" }).end(function (err, res) {
            expect(res.statusCode).to.equal(404);
            done();
        })
    })
    it('## Client activation', function (done) {
        request(app).get('/client/activate/' + clientId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Client details', function (done) {
        request(app).get('/client/' + clientId + '/details').end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            expect(res.body.result.name).to.equal("not not me");
            done();
        })
    })
    it('## Client settings', function (done) {
        request(app).put('/client/' + clientId + '/settings').send({ "dob": "1999-01-16" }).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
})

describe('Reservation Tests', function () {
    before(() => mongoose.connection.collections['reservations'].drop(function (err) {
        console.log('reservations dropped');
    }))
    it('## Reservation Add - tests', function (done) {
        request(app).post('/reservation/add').send(reservation).end(function (err, res) {
            expect(res.statusCode).to.equal(201);
            reservationId = res.body.status._id;
            done();
        })
    })
    /*it('## Reservation Get - Business Edition', function (done) {
        request(app).get('/reservation/' + businessId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Reservation Get - Client Edition', function (done) {
        request(app).get('/reservation/' + clientId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Reservation Get - Specialization Edition', function (done) {
        request(app).get('/reservation/' + specializationId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })
    it('## Reservation delete', function (done) {
        request(app).delete('/reservation/' + reservationId).end(function (err, res) {
            expect(res.statusCode).to.equal(200);
            done();
        })
    })*/
    setTimeout(process.exit, 15000);
})