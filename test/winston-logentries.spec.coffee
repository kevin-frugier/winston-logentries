require 'coffee-errors'

chai = require 'chai'
winston = require 'winston'
sinon = require 'sinon'
{Logentries} = require '../src/winston-logentries'

expect = chai.expect
chai.use require 'sinon-chai'

describe 'Logentries', ->
  logger = null
  transport = null

  beforeEach ->
    transport = new Logentries token: ''
    logger = new winston.Logger transports: [transport]

    sinon.spy transport.logentries, 'log'

  it 'calls service `log` method without meta', ->
    logger.info 'hello!'
    expect(transport.logentries.log).to.have.been.calledWith 'info', 'hello!'

  it 'calls service `log` method with meta', ->
    logger.info 'hello!', foo: 123
    expect(transport.logentries.log).to.have.been.calledWith 'info', 'hello! {"foo":123}'

  it 'calls `log` method with `warning` level which has been translated from  `warn`', ->
    logger.warn 'hello!', foo: 123
    expect(transport.logentries.log).to.have.been.calledWith 'warning', 'hello! {"foo":123}'

  it 'calls `log` method with `err` level which has been translated from  `error`', ->
    logger.error 'hello!', foo: 123
    expect(transport.logentries.log).to.have.been.calledWith 'err', 'hello! {"foo":123}'