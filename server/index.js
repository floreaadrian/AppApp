require('dotenv').config();

const express = require('express');
var cors = require('cors')

// const logger = require('morgan');
const bodyParser = require('body-parser');

const app = express();
const router = express.Router();


const environment = process.env.NODE_ENV;

const stage = require('./config')[environment];

const routes = require('./routes/index.js');


app.use(cors())

// if (environment !== 'production') {
//     app.use(logger('dev'));
// }
app.use(bodyParser.json({
    limit: '50mb',
    extended: true,
}));
app.use(bodyParser.urlencoded({
    extended: true,
    limit: "50mb"
}));
app.use('/', routes(router));

app.listen(`${stage.port}`, () => {
    console.log(`Server now listening at localhost:${stage.port}`);
});

module.exports = app;