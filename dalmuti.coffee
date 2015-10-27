'use strict'

_ = require('lodash')

App = {}


LList =
  pos: 0

  find: (item) ->
    for each in @
      if each is item
        return each
    false
    # i = 0
    # while i < @length
    #   if @[i] == item
    #     return i
    #   i++
    # false

  focus: (item) ->
    if typeof item is 'number' and 0 <= item and item < @length
      @pos = item
      return true
    else 
      for each, i in @
        if each is item
          @pos = i
          return true
    false

  current: ->
    @[@pos]

  prev: ->
    @pos--
    if @pos < 0
      @pos = @length - 1
    @[@pos]

  next: ->
    @pos++
    if @pos > @length - 1
      @pos = 0
    @[@pos]



# class Node
#   constructor: (@element) ->
#     @next = null
#     @previous = null



# class LList
#   constructor: ->
#     @head = new Node('head')
#     @head.next = @head


#   find: (item) ->
#     currNode = @head
#     while currNode isnt null and currNode.element isnt item
#       currNode = currNode.next
#     # TODO: 못찾으면 무한루프
#     currNode

#   findPrevious: (item) ->
#     currNode = @head
#     while !currNode.next isnt null and currNode.next.element isnt item
#       currNode = currNode.next
#     currNode

#   findLast: ->
#     currNode = @head
#     while !currNode.next isnt null and currNode.next.element isnt 'head'
#       currNode = currNode.next
#     currNode


#   append: (newElement) ->


#   insert: (newElement, item) ->
#     newNode = new Node(newElement)
#     current = @find(item)
#     newNode.next = current.next
#     newNode.previous = current
#     current.next = newNode

#   remove: (item) ->
#     prevNode = @findPrevious item
#     if prevNode.next isnt null
#       prevNode.next = prevNode.next.next
#     return


#   display: ->
#     currNode = @head
#     while currNode.next isnt null and currNode.next.element isnt 'head'
#       console.log currNode.next.element
#       currNode = currNode.next
#     return


class App.Player
  constructor: (@client, @dalmuti) ->
    @_id = Math.floor(Math.random() * 100000)
    @cards = []
    @reset()

  reset: ->
    return

  setup: ->
    @dalmuti.setup()
    return

  pick: (card) ->
    @dalmuti.setup_pick @, card

  revolution: ->
    @dalmuti.revolution @

  doTaxation: (cards) ->
    @dalmuti.taxation @, cards

  drawCard: (cards) ->
    @dalmuti.drawCard @, cards


    # console.log card

class App.Card
  constructor: (@rank, @index) ->
  
  @DALMUTI: 1
  @ARCHBISHOP: 2
  @EARL_MARSHAL: 3
  @BARONESS: 4
  @ABBESS: 5
  @KNIGHT: 6
  @SEAMSTRESS: 7
  @MASON: 8
  @COOK: 9
  @SHEPHERDESS: 10
  @STONECUTTER: 11
  @PEASANT: 12
  @JESTER: 13
  
class App.Deck
  constructor: ->
    @cards = []
    # 1 ~ 12
    for i in [1..12]
      for j in [1..i]
        @cards.push new App.Card(i, j - 1)
    # joker
    @cards.push new App.Card(App.Card.JESTER, 0)
    @cards.push new App.Card(App.Card.JESTER, 1)
    @cards

  shuffle: ->
    @cards = _.shuffle @cards
    return

class App.Dalmuti
  constructor: (@socket, @roomAPI, @resource) ->
    @state = 'ready'
    @players = []
    @deck = new App.Deck()

    _.extend @players, LList

  reset: ->
    for player in @players
      player.reset()
    return

  # setup
  # the deal
  # taxation
  # revolution



  # setup: 
  # # Shuffle and fan the deck,
  # # and let each player draw and reveal a card.
  # # The person who drew the best card wins and takes the seat of his or her choice.
  # # To that person’s left sits the person who drew the second best card, and so forth around the table.
  # # Treat the Jesters as the worst cards possible.
  # # @deck.shuffle()
  setup_shuffle: ->
    @draw = []
    for card in @deck.cards
      if card.index is 0
        @draw.push card

    @draw = _.shuffle @draw

  setup_pick: (player, card) ->

    player.draw = card


    # Greater Dalmuti
    # e Lesser Dalmuti
    # Greater Peon
    #  Lesser Peon.
    #   Merchants
    return

  setup_reveal: ->

    # for player in @players
    #   console.log player.draw

    compareRank = (a, b) ->
      return 0 if a.draw.rank is b.draw.rank
      if a.draw.rank > b.draw.rank then 1 else -1

    @players.sort compareRank

    # console.log '>>> after sort'
    @setup_rank()
    return

  setup_rank: ->


    for player, i in @players
      # console.log player.draw
      if i is 0
        player.rank = 'Greater Dalmuti'
        player.taxation = true
      else if i is @players.length - 1
        player.rank = 'Greater Peon'
        player.taxation = true
      else if i is 1 and i isnt @players.length - 2
        player.rank = 'Lesser Dalmuti'
        player.taxation = true
      else if i is @players.length - 2 and i isnt 1
        player.rank = 'Lesser Peon'
        player.taxation = true
      else
        player.rank = 'Merchants'




    return



    # Greater Dalmuti
    # e Lesser Dalmuti
    # Greater Peon
    #  Lesser Peon.
    #   Merchants
    return

  findPlayerByRank: (rank) ->
    for player in @players

      if player.rank is rank
        return player
    false




  revolution: (player) ->

    jesterCount = 0
    for card in player.cards
      if card.rank is App.Card.JESTER
        jesterCount++
    if jesterCount isnt 2
      return false

    if player.rank is 'Greater Peon'
      
      @players.reverse()
      return 'greater revolution'





    else
      # console.log 'no taxation'
      for player, i in @players
        delete player.taxation
      return 'no taxation'

    true

  drawCard: (player, cards) ->

    unless @dummy
      @dummy = []

    others = []
    jesters = []
    anothers = []
    for card in cards
      if card.rank is App.Card.JESTER
        jesters.push cards
      else
        if others.length is 0
          others.push card
        else if others[0].rank is card.rank
          others.push card
        else
          anothers.push card

    if anothers.length > 0
      return false

    console.log '>> ' + (jesters.length + others.length) + ' , ' + others[0].rank
    for card in cards
      for each, i in player.cards
        if card is each
          player.cards.splice i, 1
          break
    true
    # console.log "  '#{player.client.name}' (#{player.rank}) is drawing."

  taxation: (player, cards) ->

    compareRank = (a, b) ->
      return 0 if a.rank is b.rank
      if a.rank > b.rank then 1 else -1

    getBestCards = (player, num) ->
      tmp = []
      for card in player.cards
        tmp.push card

      tmp.sort compareRank
      bestCards = tmp.slice(0, num)
      
      for i in [player.cards.length - 1..0] by -1
        if bestCards.indexOf(player.cards[i]) isnt -1
          player.cards.splice(i, 1)

      bestCards


    getAnyCards = (player, cards) ->

      anyCards = []
      for i in [player.cards.length - 1..0] by -1
        if cards.indexOf(player.cards[i]) isnt -1
          anyCards.push player.cards[i]
          player.cards.splice(i, 1)
          

      anyCards




    if player.rank is 'Greater Dalmuti'
      anyCards = getAnyCards player, cards
      if anyCards.length isnt 2
        # 카드 원복처리 필요
        return false 

      peon = @findPlayerByRank 'Greater Peon'
      peon.cards = peon.cards.concat anyCards
      delete player.taxation
      return {
        to: peon
        cards: anyCards
      }
    else if player.rank is 'Lesser Dalmuti'
      
      anyCards = getAnyCards player, cards

      if anyCards.length isnt 1
        # 카드 원복처리 필요
        return false 
      peon = @findPlayerByRank 'Lesser Peon'
      peon.cards = peon.cards.concat anyCards
      delete player.taxation
      return {
        to: peon
        cards: anyCards
      }
    else if player.rank is 'Lesser Peon'
      

      # console.log bestCards
      # console.log '>>> before taxation'
      # showCards(player.cards)
      
      bestCards = getBestCards player, 1
      # console.log '>>> after taxation ,, his best'
      # showCards(bestCards)
      # console.log '>>> after taxation ,, his remaind'
      # showCards(player.cards)

      dalmuti = @findPlayerByRank 'Lesser Dalmuti'
      dalmuti.cards = dalmuti.cards.concat bestCards 
      delete player.taxation
      return {
        to: dalmuti
        cards: bestCards
      }
    else if player.rank is 'Greater Peon'
      
      # console.log bestCards
      # console.log '>>> before taxation'
      # showCards(player.cards)
      bestCards = getBestCards player, 2
      # console.log '>>> after taxation ,, his best'
      # showCards(bestCards)
      # console.log '>>> after taxation ,, his remaind'
      # showCards(player.cards)
      dalmuti = @findPlayerByRank 'Greater Dalmuti'
      dalmuti.cards = dalmuti.cards.concat bestCards
      delete player.taxation
      return {
        to: dalmuti
        cards: bestCards
      }

    true

  deal: ->
    @deck.shuffle()
    for player in @players
      player.cards = []
    for card, i in @deck.cards
      @players[i % @players.length].cards.push card



    for player in @players
      jesterCount = 0
      for card in player.cards
        if card.rank is App.Card.JESTER
          jesterCount++
      if jesterCount is 2
        player.canRequestRevolution = true
      else
        delete player.canRequestRevolution




      # tmp = []
      # for card in player.cards
      #   if card.rank < 10
      #     tmp.push ' ' + card.rank
      #   else
      #     tmp.push card.rank
      # console.log tmp.join ', '

    


    return

  enter: (client) ->
    player = new App.Player(client, @)
    @players.push player
    player

  leave: (client) ->
    for player, i in @players
      if player.client.id is client.id
        delete player.dalmuti
        @players.splice i, 1
        return
    return



# deck = new App.Deck()
# console.log deck

showCards = (cards) ->
  tmp = []
  for card in cards
    if card.rank < 10
      tmp.push ' ' + card.rank
    else
      tmp.push card.rank
  return tmp.join ', '


class Client
  constructor: (@name) ->


dalmuti = new App.Dalmuti()

console.log '> player enters.'

player1 = dalmuti.enter(new Client('Yun Ho'))
player2 = dalmuti.enter(new Client('Yun Jae'))
player3 = dalmuti.enter(new Client('Sung Won'))
player4 = dalmuti.enter(new Client('Keum Ok'))

console.log "> number of player is #{dalmuti.players.length}."


for player in dalmuti.players
  console.log "  '#{player.client.name}'"

dalmuti.setup_shuffle()

console.log '> cards shuffle to pick first greater dalmuti.'

selection = _.shuffle [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

player1.pick dalmuti.draw[selection[0]]
player2.pick dalmuti.draw[selection[1]]
player3.pick dalmuti.draw[selection[2]]
player4.pick dalmuti.draw[selection[3]]

console.log '> every player pick a card.'
# player5.pick dalmuti.draw[selection[4]]
# player6.pick dalmuti.draw[selection[5]]
# player4.pick dalmuti.draw[selection[3]]

console.log '> players reveal their card.'


for player in dalmuti.players
  console.log "  '#{player.client.name}' picked #{player.draw.rank}"



dalmuti.setup_reveal()

console.log '> here is the player\'s rank.'

for player in dalmuti.players
  console.log "  '#{player.client.name}' is #{player.rank}. (card rank: #{player.draw.rank})"


console.log '> cards deal.'


dalmuti.deal()

console.log '> cards deal results are below.'



for player in dalmuti.players

  console.log "  '#{player.client.name}' (#{player.rank}) has..."
  console.log '    [' + showCards(player.cards) + ']'



for player in dalmuti.players

  if player.canRequestRevolution
    console.log "> '#{player.client.name}' (#{player.rank}) claims REVOLUTION."
    result = player.revolution()
    if result
      console.log '  ' + result + '!'

for player in dalmuti.players
  if player.taxation
    
    if player.rank is 'Greater Dalmuti'
      anyCards = [player.cards[3], player.cards[5]]
      taxResult = player.doTaxation(anyCards)
    else if player.rank is 'Lesser Dalmuti'
      anyCards = [player.cards[Math.floor(Math.random() * player.cards.length)]]
      taxResult = player.doTaxation(anyCards)
    else if player.rank is 'Lesser Peon'
      taxResult = player.doTaxation()
    else if player.rank is 'Greater Peon'
      taxResult = player.doTaxation()

    if taxResult
      # console.log taxResult.cards
      cards = showCards taxResult.cards
      console.log "> '#{player.client.name}' (#{player.rank}) gives cards to '#{taxResult.to.client.name}' (#{taxResult.to.rank}). [#{cards}]"


console.log '> lead player for first round is Greater Dalmuti.'

dalmuti.players.focus()

available = (cards) ->
  dict = {}
  for card in cards
    unless dict[card.rank]
      dict[card.rank] = 
        rank: card.rank
        items: []
    dict[card.rank].items.push card

  avails = []
  jesters = []
  for name, each of dict
    if each.rank is App.Card.JESTER
      jesters.push each
    else
      avails.push each

  compareRank = (a, b) ->
    return 0 if a.rank is b.rank
    if a.rank < b.rank then 1 else -1

  avails.sort compareRank
  avails: avails


  jesters: jesters

currPlayer = dalmuti.players.current()
ret = available dalmuti.players.current().cards

# console.log currPlayer

if ret.avails.length > 0
  # console.log ret.avails[0].items
  console.log "> '#{currPlayer.client.name}' (#{currPlayer.rank}) is drawing."
  console.log "  #{ret.avails[0].items[0].rank} * #{ret.avails[0].items.length}"
  cardCnt = currPlayer.cards.length
  currPlayer.drawCard ret.avails[0].items
  console.log "  '#{currPlayer.client.name}'s cards : #{cardCnt} → #{currPlayer.cards.length}"

console.log dalmuti.players.current().client.name
dalmuti.players.next()

console.log dalmuti.players.current().client.name
currPlayer = dalmuti.players.current()
ret = available dalmuti.players.current().cards
console.log ret

# dalmuti.players.next()


# console.log avails

  # avails = []
  # for name, items of dict
  #   avails.push




# for player in dalmuti.players

# #   console.log player.rank
# #   showCards(player.cards)

# gPeon = dalmuti.findPlayerByRank('Greater Peon')

# # console.log gPeon
# dalmuti.taxation gPeon

# gPeon = dalmuti.findPlayerByRank('Lesser Peon')

# dalmuti.taxation gPeon




# gDalmuti = dalmuti.findPlayerByRank('Greater Dalmuti')

# # cardIndex = Math.floor(Math.random() * gDalmuti.cards.length)

# anyCards = [gDalmuti.cards[3], gDalmuti.cards[5]]
# dalmuti.taxation gDalmuti, anyCards


# gDalmuti = dalmuti.findPlayerByRank('Lesser Dalmuti')
# # 
# cardIndex = Math.floor(Math.random() * gDalmuti.cards.length)

# anyCards = [gDalmuti.cards[cardIndex]]
# dalmuti.taxation gDalmuti, anyCards

console.log ''
console.log ''
console.log ''




module.exports = App