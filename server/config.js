module.exports = {
    development: {
        port: process.env.PORT || 3000,
        saltingRounds: 10
    },
    production: {
        port: process.env.PORT || 3000,
        saltingRounds: 10
    },
    test: {
        port: process.env.PORT || 3000,
        saltingRounds: 10
    },
}