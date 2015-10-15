App = require('./app')

should = require('should')

describe 'mighty test suite', ->

  mighty = null

  it 'create a new game', ->
    mighty = new App.Mighty()

  it 'add a player', ->
    player1 = mighty.enter()
    player2 = mighty.enter()
    player3 = mighty.enter()
    mighty.players.length.should.equal(3)

  it 'leave a player', -> 