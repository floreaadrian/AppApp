const controller = require('../controllers/specialization');
const validateToken = require('../utils').validateToken;


module.exports = (router) => {
    router.route("/business/add")
        .post(validateToken, controller.add)
    router.route("/business/:bussniesId/services")
        .get(controller.getFromBussinesId)
    router.route("/business/:specializationId/datesAvalible")
        .get(controller.getAvalibleDates)
};