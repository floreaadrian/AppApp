var fs = require('fs');

const toReturn = async() => {
    var contents = await fs.readFileSync('thankYou.html', 'utf8');
    return contents;
};

module.exports = toReturn;