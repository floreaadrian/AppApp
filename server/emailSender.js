const nodemailer = require('nodemailer');
let transport = nodemailer.createTransport({
    host: 'smtp.mailtrap.io',
    port: 2525,
    auth: {
        user: process.env.STMP_USER,
        pass: process.env.STMP_PASSWORD
    }
});

const toReturn = require('./emailHtmlReturn.js');

const sendEmail = async(email, numeUtilizator, linkConfirmare) => {
    const htmlToSend = await toReturn(numeUtilizator, linkConfirmare);
    const message = {
        from: 'ok', // Sender address
        to: email, // List of recipients
        subject: 'Confirma adresa de email!', // Subject line
        html: htmlToSend
    };
    transport.sendMail(message, function(err, info) {
        if (err) {
            console.log(err)
        } else {
            //console.log(info);
        }
    });
};

module.exports = sendEmail;