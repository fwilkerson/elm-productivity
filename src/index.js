'use strict'

require('font-awesome/css/font-awesome.css')
require('../public/css/normalize.css')
require('../public/css/skeleton.css')
require('../public/css/custom.css')
require('../public/index.html')
require('../public/images/favicon.ico')

var Elm = require('./Main.elm')

var app = Elm.Main.embed(document.getElementById('main'))
