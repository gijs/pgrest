#!/usr/bin/env lsc -cj
author:
  name: ['Chia-liang Kao']
  email: 'clkao@clkao.org'
name: 'pgrest'
description: 'enable REST in postgres'
version: '0.0.8'
main: \lib/index.js
bin:
  pgrest: 'bin/cmd.js'
repository:
  type: 'git'
  url: 'git://github.com/clkao/pgrest.git'
scripts:
  test: """
    mocha
  """
  prepublish: """
    lsc -cj package.ls &&
    lsc -bpc bin/cmd.ls > bin/cmd.js &&
    chmod 755 bin/cmd.js &&
    lsc -bc -o lib src &&
    lsc -bc client/ref.ls &&
    browserify client/index.js -o client/dist/pgbase.js
  """
engines: {node: '*'}
dependencies:
  optimist: \0.6.x
  trycatch: \1.0.x
  plv8x: \0.6.x
  express: \3.4.x
  cors: \2.1.x
  \connect-csv : \*
  winston: \~0.7.2
  async: \0.2.x
  "socket.io": \*
  "socket.io-client": \*
devDependencies:
  mocha: \*
  supertest: \0.7.x
  chai: \*
  LiveScript: \1.2.x
  browserify: \*
optionalDependencies:
  passport: \0.1.x
  'passport-facebook': \1.0.x
  'passport-twitter': \1.0.x
  'passport-google-oauth': \0.1.x
