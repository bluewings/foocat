'use strict'

_ = require('lodash')

App = {}

class App.Rank
  constructor: (@value) ->
    @letter = '23456789TJQKA'.charAt @value
  nextLower: ->
    if 0 is @value then null else App.ranks[@value - 1]
  nextHigher: ->
    if 12 is @value then null else App.ranks[@value + 1]
  @letterToValue: (letter) ->
    '23456789TJQKA'.indexOf letter

App.ranks = (->
  ranks = []
  rank = i = 0
  while 13 > i
    ranks.push new App.Rank(rank)
    rank = ++i
  ranks
)()

class App.Suit
  constructor: (@value) ->
    @letter = 'SHCD'.charAt @value
  color: ->
    if 'C' is @letter or 'S' is @letter then 'black' else 'red'
  @letterToValue: (letter) ->
    'SHCD'.indexOf letter

App.suits = (->
  suits = []
  suit = i = 0
  while 4 > i
    suits.push new App.Suit(suit)
    suit = ++i
  suits
)()

class App.Card
  constructor: (@rank, @suit) ->

class App.Player
  constructor: (@client, @mighty) ->
    @_id = Math.floor(Math.random() * 100000)
    @reset()

  reset: ->
    return

  setup: ->
    @mighty.setup()
    return

class App.Deck
  constructor: ->
    @cards = []
    for suit in App.suits
      for rank in App.ranks
        @cards.push new App.Card rank, suit
    @cards.push new App.Card {}, {letter: 'JOKER'}
    @cards

  shuffle: ->
    @cards = _.shuffle @cards
    return

class App.Mighty
  constructor: (@socket, @roomAPI, @resource) ->
    @state = 'ready'
    @players = []
    @deck = new App.Deck()

  reset: ->
    for player in @players
      player.reset()
    return

  setup: ->
    # 카드를 모은다.
    # 카드를 섞는다.
    @deck.shuffle()
    return

  enter: (client) ->
    player = new App.Player(client, @)
    @players.push player
    player

  leave: (client) ->
    for player, i in @players
      if player.client.id is client.id
        delete player.mighty
        @players.splice i, 1
        return
    return

module.exports = App