-- Library: hearts
-- Zone: 60
-- Description: Hearts card game rules for the zone 60 table (60:75-83).
--
-- The table object's triggers (start, deal, hand, look, play, endgame) each
-- call one function here; the game itself lives in the table's
-- `globals.hearts`, so it is per table and ends when the table despawns.
--
--   local hearts = require("hearts")
--   return hearts.play(globals, self.room, actor, arg, random)
--
-- Every command function returns true when the command should carry on to
-- the normal handler ("not my command") and false when it was consumed, the
-- same convention as a COMMAND trigger's return value.
--
-- Cards are numbered 1-52 as in the DG scripts: suit = (card - 1) // 13
-- (0 clubs, 1 diamonds, 2 spades, 3 hearts), rank = (card - 1) % 13 + 1
-- (1 = Two ... 13 = Ace). Card 1, the Two of Clubs, leads the first trick.
--
-- State (globals.hearts), plain data only (no actor handles):
--   players  names in seat order (1-4)
--   status   0 gathering players, 1 four seated and ready to deal,
--            3 a hand is being played, 4 the hand is over (scored at once)
--   hands    hands[seat] = the cards still held, sorted
--   trick    cards on the table, in play order: { { card = 12, seat = 2 } }
--   taken    taken[seat] = cards that seat has won this hand
--   turn     seat to play; first_turn is true until the Two of Clubs is led
--   played   cards played this hand; totals[seat] = points over the game
--
-- Ported from DG scripts #6075-#6083. Rules as written there: follow suit
-- when you can, a trick goes to the highest card of the suit led, each heart
-- scores 1 and the Queen of Spades 13, taking all 26 points gives you 0 and
-- everyone else 26 ("shooting the moon"), and the game ends once someone is
-- over 99. There is no passing and hearts need not be broken. Changes: the
-- hand is scored when the last card is played, totals reset when a game
-- ends, and a table whose player has left the room is cleared.

local M = {}

local RANKS = {
    "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
    "Jack", "Queen", "King", "Ace",
}
local SUITS = { [0] = "Clubs", "Diamonds", "Spades", "Hearts" }
local HEARTS, QUEEN_OF_SPADES = 3, 37
local LIMIT = 99

function M.suit(card) return (card - 1) // 13 end
function M.rank(card) return (card - 1) % 13 + 1 end

function M.card_name(card)
    return RANKS[M.rank(card)] .. " of " .. SUITS[M.suit(card)]
end

-- Penalty points a card is worth in the score.
function M.points(card)
    if card == QUEEN_OF_SPADES then return 13 end
    if M.suit(card) == HEARTS then return 1 end
    return 0
end

function M.new()
    return {
        players = {}, status = 0, hands = {}, trick = {}, taken = {},
        turn = 0, first_turn = false, played = 0, totals = { 0, 0, 0, 0 },
    }
end

-- The game stored in `globals`, created on first use.
function M.state(globals)
    if type(globals.hearts) ~= "table" then globals.hearts = M.new() end
    return globals.hearts
end

local function clear(g)
    for k in pairs(g) do g[k] = nil end
    for k, v in pairs(M.new()) do g[k] = v end
end

local function seat_of(g, name)
    for i, p in ipairs(g.players) do
        if p == name then return i end
    end
    return nil
end

-- Shuffle with `rand(low, high)` (the engine's `random`) and give each seat
-- 13 cards. Sets the turn to whoever holds the Two of Clubs.
function M.deal_cards(g, rand)
    local deck = {}
    for i = 1, 52 do deck[i] = i end
    for i = 52, 2, -1 do
        local j = rand(1, i)
        deck[i], deck[j] = deck[j], deck[i]
    end
    g.hands, g.taken, g.trick = {}, {}, {}
    for seat = 1, 4 do
        local hand = {}
        for i = 1, 13 do hand[i] = deck[(seat - 1) * 13 + i] end
        table.sort(hand)
        g.hands[seat] = hand
        g.taken[seat] = {}
        if hand[1] == 1 then g.turn = seat end
    end
    g.first_turn = true
    g.played = 0
    g.status = 3
end

local function has_suit(hand, suit)
    for _, c in ipairs(hand) do
        if M.suit(c) == suit then return true end
    end
    return false
end

-- Can `seat` play hand position `index`? Returns the card, or nil and the
-- message to show.
function M.check_play(g, seat, index)
    local hand = g.hands[seat]
    if g.first_turn and index ~= 1 then
        return nil, "You must start the game by playing the "
            .. M.card_name(1) .. "!"
    end
    local card = hand[index]
    if not card then return nil, "You don't have that many cards!" end
    local lead = g.trick[1] and M.suit(g.trick[1].card)
    if lead and M.suit(card) ~= lead and has_suit(hand, lead) then
        return nil, "You must follow suit!"
    end
    return card
end

-- Seat that wins a full trick: the highest card of the suit that was led.
function M.trick_winner(trick)
    local lead = M.suit(trick[1].card)
    local best = trick[1]
    for i = 2, #trick do
        local t = trick[i]
        if M.suit(t.card) == lead and M.rank(t.card) > M.rank(best.card) then
            best = t
        end
    end
    return best.seat
end

-- Points each seat took this hand, after the shooting-the-moon rule.
-- Returns the four scores and the seat that shot the moon (or nil).
function M.hand_scores(g)
    local scores, moon = {}, nil
    for seat = 1, 4 do
        local sum = 0
        for _, c in ipairs(g.taken[seat]) do sum = sum + M.points(c) end
        scores[seat] = sum
        if sum == 26 then moon = seat end
    end
    if moon then
        for seat = 1, 4 do scores[seat] = (seat == moon) and 0 or 26 end
    end
    return scores, moon
end

local function present(room, name)
    for _, a in ipairs(room.actors) do
        if a.name == name then return a end
    end
    return nil
end

local function tell(room, name, msg)
    local a = present(room, name)
    if a then a:send(msg) end
end

-- DG oechoaround: everyone in the room except the named player.
local function around(room, name, msg)
    local a = present(room, name)
    if a then room:send_except(a, msg) else room:send(msg) end
end

-- Score the finished hand, report it, and either ready the next deal or
-- end the game.
function M.finish_hand(g, room)
    local names = g.players
    local scores, moon = M.hand_scores(g)
    if moon then
        for seat = 1, 4 do
            if seat == moon then
                tell(room, names[seat], "You took all the point cards!  "
                    .. "Everyone else gets 26 points.")
            else
                tell(room, names[seat], names[moon] .. " took all the "
                    .. "point cards, so you get 26 points.")
            end
        end
    end
    for seat = 1, 4 do
        g.totals[seat] = g.totals[seat] + scores[seat]
        tell(room, names[seat], "You scored " .. scores[seat]
            .. " points this round, bringing your total to "
            .. g.totals[seat] .. ".")
    end
    local over = false
    for seat = 1, 4 do
        if g.totals[seat] > LIMIT then over = true end
    end
    if not over then
        g.status = 1
        return
    end
    room:send("The game is over!")
    local low = 1
    for seat = 1, 4 do
        room:send(names[seat] .. " scored a total of " .. g.totals[seat]
            .. " points.")
        if g.totals[seat] < g.totals[low] then low = seat end
    end
    room:send(names[low] .. " has the lowest score and wins!")
    clear(g)
end

local function trim(s) return s:match("^%s*(.-)%s*$") end

-- Wrap a command so it runs against the stored game and writes it back.
local function command(fn)
    return function(globals, room, actor, arg, rand)
        local g = M.state(globals)
        for _, name in ipairs(g.players) do
            if not present(room, name) then
                room:send(name .. " has left the table; the Hearts game "
                    .. "is called off.")
                clear(g)
                break
            end
        end
        local pass = fn(g, room, actor, trim(string.lower(arg or "")), rand)
        globals.hearts = g
        return pass
    end
end

M.start = command(function(g, room, actor)
    if g.status ~= 0 then
        actor:send("The game has already started.  "
            .. "You must wait for it to finish.")
        return false
    end
    local n = #g.players
    if seat_of(g, actor.name) then
        actor:send("You're already in the game!")
        return false
    end
    local seat = n + 1
    g.players[seat] = actor.name
    if seat == 1 then
        room:send_except(actor, actor.name
            .. " starts a new game of Hearts as player 1.")
        actor:send("Alright!  Starting a new game of Hearts.  "
            .. "You are player 1.")
        return false
    end
    room:send_except(actor, actor.name .. " joins the Hearts game as player "
        .. seat .. ".")
    actor:send("You are now joining the Hearts game as player " .. seat
        .. ".")
    if seat == 4 then
        for _, name in ipairs(g.players) do
            tell(room, name, "The cards are now ready to be dealt.")
        end
        g.status = 1
    end
    return false
end)

M.deal = command(function(g, room, actor, arg, rand)
    local me = seat_of(g, actor.name)
    if #g.players < 4 then
        if not me then return true end
        actor:send("You can't deal until four people have joined!")
        return false
    end
    if not me then return true end
    if g.status > 1 then
        actor:send("Wait for this hand to end before dealing again!")
        return false
    end
    actor:send("You deal the cards across the table.")
    room:send_except(actor, actor.name
        .. " deals the cards, beginning a new round.")
    M.deal_cards(g, rand)
    tell(room, g.players[g.turn], "It's your turn first; you must play the "
        .. M.card_name(1) .. ".")
    return false
end)

M.hand = command(function(g, room, actor)
    local me = seat_of(g, actor.name)
    if not me then return true end
    if g.status < 2 then
        actor:send("The game hasn't started yet!  "
            .. "You don't have any cards.")
    elseif g.status > 3 then
        actor:send("The game is over already!")
    else
        actor:send("Your hand contains:")
        for i, card in ipairs(g.hands[me]) do
            actor:send("</> " .. i .. ". " .. M.card_name(card))
        end
    end
    return false
end)

M.look = command(function(g, room, actor, arg)
    if arg ~= "table" and arg ~= "hearts" then return true end
    if g.status < 3 then
        actor:send("The deck of cards is undealt.")
    elseif g.status > 3 then
        actor:send("The table is empty.")
    else
        if #g.trick == 0 then
            actor:send("No cards have been played yet this trick.")
        else
            actor:send("The following cards have been played this trick:")
            for _, t in ipairs(g.trick) do
                actor:send("</>  " .. M.card_name(t.card))
            end
            actor:send("The trick was led by the "
                .. M.card_name(g.trick[1].card) .. ".")
        end
        actor:send("It is " .. g.players[g.turn] .. "'s turn.")
    end
    return false
end)

M.play = command(function(g, room, actor, arg)
    local me = seat_of(g, actor.name)
    if not me then return true end
    if g.status < 3 then
        actor:send("The game hasn't started yet!")
        return false
    elseif g.status > 3 then
        actor:send("The game is over already!")
        return false
    elseif g.turn ~= me then
        actor:send("It's not your turn.")
        return false
    end
    local index = tonumber(arg)
    if not index or index < 1 or index > 13 or index ~= math.floor(index) then
        actor:send("Play what!?")
        return false
    end
    local card, err = M.check_play(g, me, index)
    if not card then
        actor:send(err)
        return false
    end
    table.remove(g.hands[me], index)
    g.trick[#g.trick + 1] = { card = card, seat = me }
    g.first_turn = false
    g.played = g.played + 1
    actor:send("You play the " .. M.card_name(card) .. ".")
    room:send_except(actor, actor.name .. " plays the " .. M.card_name(card)
        .. ".")
    g.turn = me % 4 + 1
    if #g.trick == 4 then
        local winner = M.trick_winner(g.trick)
        for _, t in ipairs(g.trick) do
            table.insert(g.taken[winner], t.card)
        end
        tell(room, g.players[winner], "You take the trick.")
        around(room, g.players[winner], g.players[winner]
            .. " takes the trick.")
        g.trick = {}
        g.turn = winner
    end
    if g.played == 52 then
        g.status = 4
        M.finish_hand(g, room)
        return false
    end
    local next_name = g.players[g.turn]
    tell(room, next_name, "It's now your turn.")
    around(room, next_name, "It's now " .. next_name .. "'s turn.")
    return false
end)

-- The DG `endgame` command scored a finished hand. play now scores it as
-- the last card falls, so this only matters if a hand is ever left at 4.
M.endgame = command(function(g, room, actor)
    if g.status ~= 4 then return true end
    M.finish_hand(g, room)
    return false
end)

return M
