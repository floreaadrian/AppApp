const nodemailer = require('nodemailer');
let transport = nodemailer.createTransport({
    host: 'smtp.mailtrap.io',
    port: 2525,
    auth: {
        user: process.env.STMP_USER,
        pass: process.env.STMP_PASSWORD
    }
});

var fs = require('fs');

const formatWithData = (content, data, ora, adresa, durata, business, serviciu) => {
    console.log(data, ora, adresa, durata, business, serviciu);
    content = content.replace(/\${data}/, data);
    content = content.replace(/\${ora}/, ora);
    content = content.replace(/\${adresa}/, adresa);
    content = content.replace(/\${durata}/, durata);
    content = content.replace(/\${business}/, business);
    content = content.replace(/\${serviciu}/, serviciu);
    return content;
}

const toReturn = async(data, ora, adresa, durata, business, serviciu) => {
    var contents = await fs.readFileSync('reservation.html', 'utf8');
    const formated = formatWithData(contents, data, ora, adresa, durata, business, serviciu)
    return formated;
};


const sendEmailRez = async(email, data, ora, adresa, durata, business, serviciu) => {
    const htmlToSend = await toReturn(data, ora, adresa, durata, business, serviciu);
    const message = {
        from: 'ok', // Sender address
        to: email, // List of recipients
        subject: 'Rezervare', // Subject line
        html: htmlToSend
    };
    transport.sendMail(message, function(err, info) {
        if (err) {
            console.log(err)
        } else {
            console.log(info);
        }
    });
};

module.exports = sendEmailRez;