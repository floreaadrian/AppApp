const users = require('./users');
const business = require('./business');
const specialization = require('./specialization');
const reservation = require('./reservation');

module.exports = (router) => {
    users(router);
    business(router);
    specialization(router);
    reservation(router)
    return router;
};