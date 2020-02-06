const controller = require('../controllers/reservation');
const validateToken = require('../utils').validateToken;


module.exports = (router) => {
    router.route("/reservation/add")
        .post(controller.add)
    router.route('/reservation/business/:businessId')
        .get(controller.getFromBussinesId);
    router.route('/reservation/service/:specializationId')
        .get(controller.getFromServiceId);
    router.route('/reservation/client/:clientId')
        .get(controller.getFromClientId);
    router.route('/reservation/:reservationId')
        .delete(controller.delete);
};