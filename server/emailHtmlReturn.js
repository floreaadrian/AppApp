var fs = require('fs');

const formatWithData = (content, name, activationLink) => {
    content = content.replace("${name}", name);
    content = content.replace(/\${confirmation-link}/, activationLink);
    content = content.replace(/\${confirmation-link}/, activationLink);
    content = content.replace(/\${confirmation-link}/, activationLink);
    return content;
}

const toReturn = async(nume, activationLink) => {
    var contents = await fs.readFileSync('email.html', 'utf8');
    const formated = formatWithData(contents, nume, activationLink)
    return formated;
};

module.exports = toReturn;