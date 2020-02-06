const controller = require('../controllers/users');
const validateToken = require('../utils').validateToken;


module.exports = (router) => {
    router.route("/client/register")
        .post(controller.add)
    router.route('/client/login')
        .post(controller.login);
    router.route('/client/activate/:clientId')
        .get(controller.activate);
    router.route('/client/:clientId/settings')
        .put(controller.changeSettings);
    router.route('/client/:clientId/details')
        .get(controller.details);
};