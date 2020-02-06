const controller = require('../controllers/business');
const validateToken = require('../utils').validateToken;


module.exports = (router) => {
    router.route("/business/register")
        .post(controller.add)
    router.route('/business/login')
        .post(controller.login);
    router.route('/businesses')
        .get(controller.filter);
    router.route('/business/activate/:businessId')
        .get(controller.activate);
    router.route('/business/:businessId/settings')
        .put(controller.changeSettings);
    router.route('/business/:businessId/details')
        .get(controller.details);
};