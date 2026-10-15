"""Zone 60 mini-games: ConnectFour (60:61-72) and Hearts (60:75-83).

The triggers are thin wrappers over the `connectfour` and `hearts` script libraries; the games
keep their state in the board's / table's `globals`. These tests run the real trigger files and
libraries in a Lua 5.4 interpreter against a fake room and fake players, firing every trigger of
the object for each typed command the way the engine does. The fake environment only knows the
standard library plus the names the engine binds for a COMMAND trigger, so a script that reads
any other global fails the test (the same hazard test_trigger_globals.py scans for).
"""

import shutil
import subprocess
from pathlib import Path

import pytest

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")

ROOT = Path(__file__).resolve().parents[1]
TRIGGERS = ROOT / "data" / "triggers" / "060"
LIBRARIES = ROOT / "data" / "script_libraries"

HARNESS = r"""
local ROOT = @ROOT@
local FILES = @FILES@

local SAFE = { "assert", "error", "getmetatable", "ipairs", "math", "next",
    "pairs", "pcall", "select", "setmetatable", "string", "table", "tonumber",
    "tostring", "type", "utf8" }

local function sandbox(extra)
    local env = {}
    for _, k in ipairs(SAFE) do env[k] = _G[k] end
    for k, v in pairs(extra or {}) do env[k] = v end
    return setmetatable(env, { __index = function(_, k)
        error("read of undefined global '" .. tostring(k) .. "'", 2)
    end })
end

local function slurp(path)
    local f = assert(io.open(path))
    local src = f:read("a")
    f:close()
    return src
end

local libs = {}
local function require_(name)
    if libs[name] == nil then
        local path = ROOT .. "/data/script_libraries/" .. name .. ".lua"
        libs[name] = assert(load(slurp(path), "lib:" .. name, "t",
            sandbox()))()
    end
    return libs[name]
end

local seed = 12345
local function random(lo, hi)
    seed = (seed * 1103515245 + 12345) % 2147483648
    return lo + (seed // 65536) % (hi - lo + 1)
end

local function new_room()
    local room = { actors = {} }
    function room:send(msg)
        for _, a in ipairs(self.actors) do a.log[#a.log + 1] = msg end
    end
    function room:send_except(who, msg)
        for _, a in ipairs(self.actors) do
            if a ~= who then a.log[#a.log + 1] = msg end
        end
    end
    return room
end

local function new_actor(room, name)
    local a = { name = name, log = {}, is_player = true, objective = "him" }
    function a:send(msg) self.log[#self.log + 1] = msg end
    room.actors[#room.actors + 1] = a
    return a
end

local function leave(room, actor)
    for i, a in ipairs(room.actors) do
        if a == actor then table.remove(room.actors, i) return end
    end
end

local function new_object()
    local room = new_room()
    return { room = room, globals = {} }
end

-- Fire every trigger on the object for a typed command, as the engine does;
-- true means the command carries on to the normal handler.
local function type_cmd(obj, actor, cmd, arg)
    for _, path in ipairs(FILES) do
        local env = sandbox({
            actor = actor, self = obj, globals = obj.globals,
            location = "room", cmd = cmd, arg = arg or "",
            require = require_, random = random,
        })
        local ret = assert(load(slurp(path), "@" .. path, "t", env))()
        if ret == false then return false end
    end
    return true
end

local function has(actor, text)
    for _, line in ipairs(actor.log) do
        if line:find(text, 1, true) then return true end
    end
    return false
end

local function last(actor) return actor.log[#actor.log] end
local function wipe(...)
    for _, a in ipairs({ ... }) do a.log = {} end
end
local function check(cond, msg)
    if not cond then error("CHECK FAILED: " .. tostring(msg), 2) end
end
"""


def _lua_list(paths):
    return "{" + ", ".join('"' + str(p) + '"' for p in paths) + "}"


def run_lua(pattern: str, scenario: str) -> None:
    files = sorted(TRIGGERS.glob(pattern))
    assert files, pattern
    code = (
        HARNESS.replace("@ROOT@", f'"{ROOT}"').replace("@FILES@", _lua_list(files))
        + scenario
        + '\nprint("OK")\n'
    )
    r = subprocess.run([LUA, "-"], input=code, capture_output=True, text=True)
    assert r.returncode == 0 and r.stdout.strip().endswith("OK"), r.stderr + r.stdout


def cf(scenario: str) -> None:
    run_lua("060_*_connectfour_*.lua", CF_SETUP + scenario)


def hearts(scenario: str) -> None:
    run_lua("060_*_hearts_*.lua", HEARTS_SETUP + scenario)


CF_SETUP = r"""
local board = new_object()
local room = board.room
local ann = new_actor(room, "Ann")
local bob = new_actor(room, "Bob")
local cat = new_actor(room, "Cat")
local function cmd(who, c, arg) return type_cmd(board, who, c, arg) end
local function game() return board.globals.cf end

-- Ann starts and picks red, Bob joins: Ann (player 1) moves first.
local function begin()
    cmd(ann, "start")
    cmd(ann, "select", "red")
    cmd(bob, "start")
end

-- Alternate Ann, Bob, Ann ... dropping into the given columns. Returns the
-- 1-based move on which the game ended, or nil.
local function play_cols(cols)
    for i, col in ipairs(cols) do
        local who = (i % 2 == 1) and ann or bob
        cmd(who, "drop", tostring(col))
        if game().status == 2 then return i end
    end
    return nil
end

local function mirror(cols)
    local out = {}
    for i, c in ipairs(cols) do out[i] = 8 - c end
    return out
end
"""


@needs_lua
def test_connectfour_game_flow_and_colours():
    cf(r"""
    cmd(ann, "start")
    check(has(ann, "You are player 1"), "ann is player 1")
    check(has(bob, "starts a new ConnectFour game as player 1"), "echo")
    check(cmd(cat, "drop", "3") == true, "outsiders' drop passes through")
    cmd(bob, "start")
    check(has(bob, "You are now joining the ConnectFour game!"), "join")
    check(game().status == 0, "waits for the colour")
    check(cmd(bob, "select", "red") == true, "only player 1 selects")
    cmd(ann, "select", "purple")
    check(has(ann, "You may only select 'red' or 'black'."), "bad colour")
    cmd(ann, "select", "red")
    check(has(ann, "You get to go first!"), "ann goes first")
    check(has(bob, "<b:black>black</> pieces"), "bob is black")
    check(game().status == 1 and game().turn == 1, "playing")
    cmd(cat, "start")
    check(has(cat, "are already playing ConnectFour!"), "full table")
    cmd(bob, "drop", "4")
    check(has(bob, "It's not your turn!"), "turn order")
    cmd(ann, "drop", "4")
    check(has(ann, "You drop a piece in column 4."), "drop")
    check(has(bob, "Ann drops a piece in column 4."), "echo")
    wipe(ann, bob, cat)
    cmd(bob, "drop", "4")
    cmd(cat, "look", "board")
    local text = table.concat(cat.log, "\n")
    check(text:find("<b:red>O</>", 1, true), "red piece drawn")
    check(text:find("<b:black>O</>", 1, true), "black piece drawn")
    check(text:find("|1|2|3|4|5|6|7|", 1, true), "column header")
    check(has(cat, "Ann and Bob are playing."), "spectator status")
    check(has(cat, "It's Ann's turn."), "turn line")
    cmd(ann, "look", "board")
    check(has(ann, "It's your turn!"), "own turn line")
    check(cmd(ann, "look", "sword") == true, "look at other things passes")
    """)


@needs_lua
def test_connectfour_horizontal_win():
    cf(r"""
    begin()
    -- Ann fills the bottom row, Bob stacks on top of her
    local ended = play_cols({ 1, 1, 2, 2, 3, 3, 4 })
    check(ended == 7, "Ann wins on her fourth in a row, move " .. tostring(ended))
    check(has(ann, "You win!"), "winner told")
    check(has(bob, "Ann wins!"), "others told")
    check(game().winner == 1, "winner recorded")
    cmd(bob, "drop", "5")
    check(has(bob, "The game is already over!"), "no moves after the end")
    cmd(bob, "look", "board")
    check(has(bob, "Ann won the game."), "status line")
    """)


@needs_lua
def test_connectfour_vertical_win():
    cf(r"""
    begin()
    local ended = play_cols({ 1, 2, 1, 2, 1, 2, 1 })
    check(ended == 7, "vertical four, move " .. tostring(ended))
    check(game().winner == 1, "Ann wins")
    """)


@needs_lua
def test_connectfour_diagonal_wins_in_both_directions():
    cf(r"""
    -- Ann gets c1h1, c2h2, c3h3, c4h4; Bob never has four
    local rising = { 1, 2, 2, 3, 4, 3, 3, 4, 7, 4, 6, 5, 4 }
    begin()
    check(play_cols(rising) == 13, "rising diagonal on move 13")
    check(game().winner == 1, "Ann wins the rising diagonal")
    """)
    cf(r"""
    local rising = { 1, 2, 2, 3, 4, 3, 3, 4, 7, 4, 6, 5, 4 }
    begin()
    check(play_cols(mirror(rising)) == 13, "falling diagonal on move 13")
    check(game().winner == 1, "Ann wins the falling diagonal")
    """)


@needs_lua
def test_connectfour_three_in_a_row_does_not_win():
    cf(r"""
    begin()
    check(play_cols({ 1, 1, 2, 2, 3 }) == nil, "three in a row is not a win")
    check(game().status == 1, "still playing")
    """)


@needs_lua
def test_connectfour_full_column_is_rejected():
    cf(r"""
    begin()
    -- alternating pieces fill column 1 (7 rows) without any four in a line
    check(play_cols({ 1, 1, 1, 1, 1, 1, 1 }) == nil, "no win yet")
    check(game().turn == 2, "Bob is up")
    wipe(bob)
    cmd(bob, "drop", "1")
    check(has(bob, "Column 1 is full!  Try a different one."), "rejected")
    check(game().turn == 2, "a rejected drop keeps the turn")
    cmd(bob, "drop", "2")
    check(has(bob, "You drop a piece in column 2."), "other columns work")
    check(game().turn == 1, "turn passes")
    wipe(ann)
    cmd(ann, "drop", "8")
    check(has(ann, "Drop a piece in where!?"), "no such column")
    check(cmd(ann, "drop", "sword") == true, "a normal drop passes through")
    """)


@needs_lua
def test_connectfour_full_board_is_a_draw():
    cf(r"""
    begin()
    -- fill without a four: a repeating 2-column pattern with a shifted third
    local order = { 1, 2, 3, 4, 5, 6, 7 }
    -- Pre-fill the board directly with a known drawn position, leave one cell.
    local pattern = {
        { 1, 2, 1, 2, 1, 2, 1 }, { 1, 2, 1, 2, 1, 2, 1 },
        { 2, 1, 2, 1, 2, 1, 2 }, { 2, 1, 2, 1, 2, 1, 2 },
        { 1, 2, 1, 2, 1, 2, 1 }, { 1, 2, 1, 2, 1, 2, 1 },
        { 2, 1, 2, 1, 2, 1, 2 },
    }
    local g = game()
    for r = 1, 7 do for c = 1, 7 do g.board[r][c] = pattern[r][c] end end
    g.board[1][4] = 0
    local cf = require_("connectfour")
    check(not cf.has_four(g.board, 1) and not cf.has_four(g.board, 2),
        "the filler position has no four")
    g.turn = 1
    cmd(ann, "drop", "4")
    check(g.status == 2 and g.draw, "full board ends the game")
    check(has(bob, "the game is a draw!"), "draw announced")
    """)


@needs_lua
def test_connectfour_forfeit_asks_first_then_ends_the_game():
    cf(r"""
    cmd(ann, "forfeit")
    check(has(ann, "But the game hasn't even started yet!"), "before start")
    begin()
    wipe(ann, bob, cat)
    cmd(cat, "forfeit")
    check(has(cat, "You can't forfeit a game you're not even playing!"), "cat")
    cmd(bob, "forfeit")
    check(has(bob, "type 'forfeit yes'"), "asks for confirmation")
    check(game().status == 1, "not forfeited yet")
    cmd(bob, "forfeit", "yes")
    check(has(bob, "You forfeit the game!"), "bob forfeits")
    check(has(ann, "Bob forfeits the game!"), "echo")
    check(game().status == 2 and game().forfeit == 2, "game over")
    cmd(ann, "look", "board")
    check(has(ann, "Bob forfeited the game."), "status line")
    cmd(ann, "forfeit", "yes")
    check(has(ann, "But the game's already over!"), "only once")
    """)


@needs_lua
def test_connectfour_reset_clears_the_state_only_when_over():
    cf(r"""
    cmd(ann, "reset")
    check(has(ann, "The board is already cleared!") or
          has(ann, "You can't reset the board until the game is over."),
        "nothing to reset")
    begin()
    wipe(ann, cat)
    cmd(ann, "reset")
    check(has(ann, "forfeit first, then reset"), "players must forfeit")
    cmd(cat, "reset")
    check(has(cat, "Wait until Ann and Bob are done playing!"), "bystander")
    check(game().status == 1, "game untouched")
    play_cols({ 1, 1, 2, 2, 3, 3, 4 })
    check(game().winner == 1, "Ann won")
    cmd(cat, "reset")
    check(has(cat, "Resetting ConnectFour.") and has(cat, "Board cleared."),
        "anyone can reset a finished game")
    local g = game()
    check(g.status == 0 and g.p1 == nil and g.p2 == nil, "players cleared")
    check(g.winner == nil and g.forfeit == nil and g.turn == 0, "flags cleared")
    for r = 1, 7 do
        for c = 1, 7 do check(g.board[r][c] == 0, "empty cell") end
    end
    -- and a new game can be played on the cleared board
    cmd(cat, "start")
    check(has(cat, "You are player 1"), "Cat starts the next game")
    """)


@needs_lua
def test_connectfour_forfeit_then_reset():
    cf(r"""
    begin()
    cmd(ann, "forfeit", "yes")
    cmd(bob, "reset")
    check(game().status == 0 and game().p1 == nil, "reset after a forfeit")
    for r = 1, 7 do for c = 1, 7 do
        check(game().board[r][c] == 0, "empty cell")
    end end
    """)


@needs_lua
def test_connectfour_leaving_the_room_forfeits():
    cf(r"""
    begin()
    leave(room, bob)
    cmd(ann, "look", "board")
    check(has(ann, "Bob left the room and forfeits the game."), "forfeit")
    check(game().status == 2 and game().forfeit == 2, "game over")
    """)
    cf(r"""
    cmd(ann, "start")
    leave(room, ann)
    cmd(bob, "start")
    check(has(bob, "You are player 1"), "an abandoned seat is freed")
    """)


@needs_lua
def test_connectfour_rules_text():
    cf(r"""
    cmd(cat, "rules")
    check(has(cat, "four of"), "rules shown")
    check(#cat.log > 15, "full text")
    """)


HEARTS_SETUP = r"""
local table_ = new_object()
local room = table_.room
local names = { "Ann", "Bob", "Cat", "Dan" }
local P = {}
for i, n in ipairs(names) do P[i] = new_actor(room, n) end
local eve = new_actor(room, "Eve")
local hearts = require_("hearts")
local function cmd(who, c, arg) return type_cmd(table_, who, c, arg) end
local function game() return table_.globals.hearts end
local function seat_up()
    for i = 1, 4 do cmd(P[i], "start") end
end
local function everyone_wipes() for i = 1, 4 do wipe(P[i]) end wipe(eve) end

-- The seat to move plays the first hand position the rules accept. Returns
-- false when no position is accepted (cannot happen with a legal hand).
local function bot_move()
    local g = game()
    local seat = g.turn
    for index = 1, #g.hands[seat] do
        local before = g.played
        cmd(P[seat], "play", tostring(index))
        if game() == nil or game().played ~= before then return true end
    end
    return false
end
"""


@needs_lua
def test_hearts_seating_and_deal_rules():
    hearts(r"""
    cmd(P[1], "start")
    check(has(P[1], "You are player 1"), "player 1")
    check(has(eve, "Ann starts a new game of Hearts as player 1."), "echo")
    cmd(P[1], "start")
    check(has(P[1], "You're already in the game!"), "no double seating")
    cmd(P[1], "deal")
    check(has(P[1], "You can't deal until four people have joined!"), "early")
    check(cmd(eve, "deal") == true, "outsiders' deal passes through")
    check(cmd(eve, "hand") == true and cmd(eve, "play", "1") == true,
        "outsiders' hand/play pass through")
    cmd(P[2], "start")
    cmd(P[3], "start")
    check(has(P[3], "You are now joining the Hearts game as player 3."), "3")
    check(game().status == 0, "not ready with three")
    cmd(P[4], "start")
    check(game().status == 1, "four seated")
    for i = 1, 4 do
        check(has(P[i], "The cards are now ready to be dealt."), "ready " .. i)
    end
    cmd(eve, "start")
    check(has(eve, "The game has already started."), "table is full")
    cmd(P[1], "hand")
    check(has(P[1], "The game hasn't started yet!"), "no cards yet")
    cmd(P[1], "look", "table")
    check(has(P[1], "The deck of cards is undealt."), "undealt")
    """)


@needs_lua
def test_hearts_deal_gives_each_player_13_cards():
    hearts(r"""
    for trial = 1, 25 do
        local t = new_object()
        local ps = {}
        for i, n in ipairs(names) do ps[i] = new_actor(t.room, n) end
        for i = 1, 4 do type_cmd(t, ps[i], "start") end
        type_cmd(t, ps[2], "deal")
        local g = t.globals.hearts
        check(g.status == 3, "playing")
        local seen, count = {}, 0
        for seat = 1, 4 do
            check(#g.hands[seat] == 13, "13 cards for seat " .. seat)
            for i, card in ipairs(g.hands[seat]) do
                check(card >= 1 and card <= 52 and not seen[card], "unique")
                seen[card] = true
                count = count + 1
                if i > 1 then check(g.hands[seat][i - 1] < card, "sorted") end
            end
        end
        check(count == 52, "the whole deck is dealt")
        local first = g.turn
        check(g.hands[first][1] == 1, "the Two of Clubs leads")
        check(has(ps[first], "It's your turn first; you must play the "
            .. "Two of Clubs."), "first player told")
    end
    -- the dealer is told, the others see it, and `hand` lists 13 cards
    seat_up()
    wipe(P[1], P[2], eve)
    cmd(P[1], "deal")
    check(has(P[1], "You deal the cards across the table."), "dealer")
    check(has(P[2], "Ann deals the cards, beginning a new round."), "echo")
    cmd(P[3], "hand")
    local lines = 0
    for _, l in ipairs(P[3].log) do
        if l:match("^</> %d+%. ") then lines = lines + 1 end
    end
    check(lines == 13, "hand view shows 13 numbered cards, saw " .. lines)
    check(has(P[3], "Your hand contains:"), "heading")
    cmd(P[2], "deal")
    check(has(P[2], "Wait for this hand to end before dealing again!"),
        "no redeal mid-hand")
    """)


@needs_lua
def test_hearts_card_names_and_points():
    hearts(r"""
    check(hearts.card_name(1) == "Two of Clubs", hearts.card_name(1))
    check(hearts.card_name(13) == "Ace of Clubs", "ace")
    check(hearts.card_name(14) == "Two of Diamonds", "diamonds")
    check(hearts.card_name(37) == "Queen of Spades", hearts.card_name(37))
    check(hearts.card_name(52) == "Ace of Hearts", "last card")
    local total = 0
    for c = 1, 52 do total = total + hearts.points(c) end
    check(total == 26, "a deck holds 26 penalty points")
    check(hearts.points(37) == 13 and hearts.points(40) == 1, "scoring")
    check(hearts.points(36) == 0, "king of spades is free")
    """)


@needs_lua
def test_hearts_first_play_must_be_the_two_of_clubs():
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    local first = g.turn
    local other = first % 4 + 1
    everyone_wipes()
    cmd(P[other], "play", "1")
    check(has(P[other], "It's not your turn."), "turn order")
    cmd(P[first], "play", "2")
    check(has(P[first], "You must start the game by playing the "
        .. "Two of Clubs!"), "not the two of clubs")
    check(g.played == 0, "nothing played")
    cmd(P[first], "play", "0")
    check(has(P[first], "Play what!?"), "bad number")
    cmd(P[first], "play", "")
    cmd(P[first], "play", "14")
    cmd(P[first], "play", "1")
    check(has(P[first], "You play the Two of Clubs."), "plays it")
    check(has(eve, g.players[first] .. " plays the Two of Clubs."), "echo")
    check(g.played == 1 and g.first_turn == false, "game under way")
    local nxt = first % 4 + 1
    check(g.turn == nxt, "turn moves on")
    check(has(P[nxt], "It's now your turn."), "next player told")
    check(has(eve, "It's now " .. g.players[nxt] .. "'s turn."), "echo")
    cmd(eve, "look", "table")
    check(has(eve, "The following cards have been played this trick:"), "look")
    check(has(eve, "The trick was led by the Two of Clubs."), "leader")
    check(has(eve, "It is " .. g.players[nxt] .. "'s turn."), "whose turn")
    """)


@needs_lua
def test_hearts_play_must_follow_suit_when_able():
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    -- Ann leads the Five of Clubs (4); Bob holds a club, a diamond, hearts.
    g.first_turn = false
    g.hands = {
        { 5, 20, 30 },        -- Ann
        { 7, 25, 41, 50 },    -- Bob: Eight of Clubs, King of Diamonds, hearts
        { 2, 3 },             -- Cat
        { 14, 15 },           -- Dan
    }
    g.trick = { { card = 4, seat = 1 } }
    g.turn = 2
    g.played = 1
    everyone_wipes()
    cmd(P[2], "play", "3")          -- Three of Hearts with a club in hand
    check(has(P[2], "You must follow suit!"), "off-suit with a club held")
    cmd(P[2], "play", "2")          -- a diamond with a club in hand
    check(has(P[2], "You must follow suit!"), "diamond is also wrong")
    check(g.turn == 2 and #g.hands[2] == 4, "nothing was played")
    cmd(P[2], "play", "5")
    check(has(P[2], "You don't have that many cards!"), "out of range")
    cmd(P[2], "play", "1")
    check(has(P[2], "You play the Eight of Clubs."), "follows suit")
    -- Cat holds clubs (2, 3) so she follows; Dan holds none and may discard.
    cmd(P[3], "play", "1")
    check(has(P[3], "You play the Three of Clubs."), "Cat follows")
    cmd(P[4], "play", "2")
    check(has(P[4], "You play the Three of Diamonds."), "Dan may discard")
    check(g.played == 4, "four cards played")
    """)
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    g.first_turn = false
    -- a player with no card of the suit led may play anything
    g.hands = { { 5 }, { 14, 41 }, { 2 }, { 3 } }
    g.trick = { { card = 4, seat = 1 } }
    g.turn = 2
    g.played = 1
    cmd(P[2], "play", "2")
    check(has(P[2], "You play the Three of Hearts."), "free discard")
    """)


@needs_lua
def test_hearts_trick_goes_to_highest_card_of_the_suit_led():
    hearts(r"""
    check(hearts.trick_winner({
        { card = 4, seat = 1 }, { card = 52, seat = 2 },
        { card = 9, seat = 3 }, { card = 6, seat = 4 },
    }) == 3, "off-suit aces never win; the Ten of Clubs does")
    check(hearts.trick_winner({
        { card = 40, seat = 3 }, { card = 41, seat = 4 },
        { card = 13, seat = 1 }, { card = 52, seat = 2 },
    }) == 2, "Ace of Hearts takes a heart trick")
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    g.first_turn = false
    g.hands = { { 5, 33 }, { 9, 31 }, { 6, 32 }, { 8, 34 } }
    g.trick = {}
    g.turn = 1
    g.played = 0
    everyone_wipes()
    cmd(P[1], "play", "1")   -- Six of Clubs led
    cmd(P[2], "play", "1")   -- Ten of Clubs
    cmd(P[3], "play", "1")   -- Seven of Clubs
    cmd(P[4], "play", "1")   -- Nine of Clubs
    check(g.turn == 2, "Bob took the trick and leads")
    check(#g.trick == 0, "table cleared")
    check(#g.taken[2] == 4 and #g.taken[1] == 0, "cards go to the winner")
    check(has(P[2], "You take the trick."), "winner told")
    check(has(P[1], "Bob takes the trick."), "others told")
    check(has(P[2], "It's now your turn."), "winner leads next")
    cmd(P[2], "look", "table")
    check(has(P[2], "No cards have been played yet this trick."), "new trick")
    """)


@needs_lua
def test_hearts_hand_is_scored_and_totals_accumulate():
    hearts(r"""
    -- hearts count 1 each, the Queen of Spades 13
    local g = { taken = {
        { 37, 40, 41 }, { 42, 43, 1 }, { 2 }, { 3, 4, 52 },
    } }
    local s, moon = hearts.hand_scores(g)
    check(s[1] == 15 and s[2] == 2 and s[3] == 0 and s[4] == 1 and not moon,
        table.concat(s, ","))
    -- shooting the moon: 0 for the shooter, 26 for everybody else
    local all = {}
    for c = 40, 52 do all[#all + 1] = c end
    all[#all + 1] = 37
    local s2, moon2 = hearts.hand_scores({ taken = { {}, all, {}, { 1 } } })
    check(moon2 == 2 and s2[1] == 26 and s2[2] == 0 and s2[3] == 26
        and s2[4] == 26, "moon")
    -- end to end: the last card of the hand scores it
    seat_up()
    cmd(P[1], "deal")
    local game_ = game()
    game_.first_turn = false
    game_.hands = { { 52 }, { 51 }, { 50 }, { 49 } }   -- one heart each
    game_.trick = {}
    game_.turn = 1
    game_.played = 48
    game_.taken = { { 37, 40 }, {}, { 41 }, {} }
    game_.totals = { 10, 20, 30, 40 }
    everyone_wipes()
    for i = 1, 4 do cmd(P[i], "play", "1") end
    check(game_.status == 1, "ready for the next deal")
    -- Ann (lead 52, Ace of Hearts) wins the trick: +4 hearts, so 13+1+4 = 18
    check(has(P[1], "You scored 18 points this round, bringing your total "
        .. "to 28."), table.concat(P[1].log, " | "))
    check(has(P[3], "You scored 1 points this round, bringing your total "
        .. "to 31."), "Cat")
    check(has(P[2], "You scored 0 points this round, bringing your total "
        .. "to 20."), "Bob")
    check(game_.totals[1] == 28 and game_.totals[4] == 40, "totals kept")
    -- the same table can deal again
    cmd(P[2], "deal")
    check(game().status == 3 and #game().hands[1] == 13, "next hand")
    """)


@needs_lua
def test_hearts_shooting_the_moon_and_game_end():
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    g.first_turn = false
    g.hands = { { 52 }, { 2 }, { 3 }, { 4 } }
    g.trick = {}
    g.turn = 1
    g.played = 48
    local all = {}
    for c = 40, 51 do all[#all + 1] = c end
    all[#all + 1] = 37
    g.taken = { {}, all, {}, {} }      -- Bob holds 25 points; the trick adds 1
    g.totals = { 0, 0, 0, 0 }
    -- Ann leads the Ace of Hearts; nobody follows, so she takes it: Ann 1
    everyone_wipes()
    for i = 1, 4 do cmd(P[i], "play", "1") end
    check(has(P[2], "You scored 25 points"), "no moon at 25")
    -- now a real moon: Bob gets all 26
    g = game()
    cmd(P[1], "deal")
    g.first_turn = false
    g.hands = { { 2 }, { 52 }, { 3 }, { 4 } }
    g.trick = {}
    g.turn = 2
    g.played = 48
    g.taken = { {}, all, {}, {} }
    g.totals = { 0, 0, 0, 0 }
    everyone_wipes()
    for _, seat in ipairs({ 2, 3, 4, 1 }) do cmd(P[seat], "play", "1") end
    check(has(P[2], "You took all the point cards!  Everyone else gets 26 "
        .. "points."), "moon announced")
    check(has(P[1], "Bob took all the point cards, so you get 26 points."),
        "others told")
    check(has(P[1], "You scored 26 points this round, bringing your total "
        .. "to 26."), "26 each")
    check(has(P[2], "You scored 0 points this round, bringing your total "
        .. "to 0."), "shooter scores 0")
    """)
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    local g = game()
    g.first_turn = false
    g.hands = { { 2 }, { 3 }, { 4 }, { 5 } }
    g.trick = {}
    g.turn = 1
    g.played = 48
    g.taken = { {}, {}, {}, { 37 } }
    g.totals = { 99, 50, 60, 87 }
    everyone_wipes()
    for i = 1, 4 do cmd(P[i], "play", "1") end
    -- Dan's trick winner is the Five of Clubs holder, Dan: +13 -> 100
    check(has(eve, "The game is over!"), "game over announced")
    check(has(eve, "Ann scored a total of 99 points."), "totals listed")
    check(has(eve, "Dan scored a total of 100 points."), "dan over 99")
    check(has(eve, "Bob has the lowest score and wins!"), "winner")
    local after = game()
    check(#after.players == 0 and after.status == 0, "table is cleared")
    check(after.totals[1] == 0 and after.totals[4] == 0, "totals reset")
    cmd(eve, "start")
    check(has(eve, "You are player 1"), "a new game can start")
    """)


@needs_lua
def test_hearts_full_games_play_to_the_end():
    hearts(r"""
    for trial = 1, 6 do
        local t = new_object()
        local ps = {}
        for i, n in ipairs(names) do ps[i] = new_actor(t.room, n) end
        for i = 1, 4 do type_cmd(t, ps[i], "start") end
        local hands_played = 0
        local totals_before = { 0, 0, 0, 0 }
        while t.globals.hearts.status ~= 0 do
            type_cmd(t, ps[1], "deal")
            local g = t.globals.hearts
            check(g.status == 3, "dealt")
            for move = 1, 52 do
                local seat = g.turn
                local before = g.played
                local moved = false
                for index = 1, #g.hands[seat] do
                    type_cmd(t, ps[seat], "play", tostring(index))
                    if g.played ~= before or t.globals.hearts ~= g
                        or g.status ~= 3 then moved = true break end
                    if g.played == before then
                        -- rejected: must be a follow-suit refusal
                        check(has(ps[seat], "You must follow suit!"),
                            "only follow-suit refusals")
                        ps[seat].log = {}
                    end
                end
                check(moved, "a legal play always exists")
            end
            hands_played = hands_played + 1
            local g2 = t.globals.hearts
            local delta = 0
            for seat = 1, 4 do
                delta = delta + g2.totals[seat] - totals_before[seat]
                totals_before[seat] = g2.totals[seat]
            end
            if g2.status == 0 then
                break          -- game over: the table was cleared
            end
            check(delta == 26 or delta == 78,
                "a hand is worth 26 points (78 for the moon), got " .. delta)
            check(hands_played < 40, "the game must end")
        end
        check(hands_played >= 2, "a game lasts several hands")
    end
    """)


@needs_lua
def test_hearts_player_leaving_calls_off_the_table():
    hearts(r"""
    seat_up()
    cmd(P[1], "deal")
    leave(room, P[3])
    cmd(P[1], "hand")
    check(has(P[1], "Cat has left the table; the Hearts game is called off."),
        "announced")
    check(#game().players == 0 and game().status == 0, "table cleared")
    """)


@needs_lua
def test_hearts_endgame_command_only_acts_on_an_unscored_hand():
    hearts(r"""
    seat_up()
    check(cmd(P[1], "endgame") == true, "nothing to score")
    cmd(P[1], "deal")
    check(cmd(P[1], "endgame") == true, "mid-hand it passes through")
    """)


# --- static checks -------------------------------------------------------------------------------

GAME_FILES = (
    sorted(TRIGGERS.glob("060_*_connectfour_*.lua"))
    + sorted(TRIGGERS.glob("060_*_hearts_*.lua"))
    + [LIBRARIES / "connectfour.lua", LIBRARIES / "hearts.lua"]
)


def test_game_scripts_stay_within_79_columns():
    long = [
        f"{p.name}:{n} ({len(line)})"
        for p in GAME_FILES
        for n, line in enumerate(p.read_text(encoding="utf-8").splitlines(), 1)
        if len(line) > 79
    ]
    assert not long, long


def test_every_game_trigger_exists_for_its_dg_script():
    ids = {int(p.name.split("_")[1]) for p in GAME_FILES if p.parent == TRIGGERS}
    # DG #6082 (hearts play) was never converted, so Hearts could not be played at all
    assert {61, 63, 64, 66, 68, 70, 72, 75, 77, 79, 80, 82, 83} <= ids


@pytest.mark.skipif(shutil.which("luac5.4") is None, reason="luac not installed")
def test_game_scripts_compile():
    for p in GAME_FILES:
        r = subprocess.run(["luac5.4", "-p", str(p)], capture_output=True, text=True)
        assert r.returncode == 0, f"{p.name}: {r.stderr}"
