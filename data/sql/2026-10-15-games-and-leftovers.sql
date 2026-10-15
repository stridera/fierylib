-- Zone 60 ConnectFour and Hearts rewritten on the connectfour and hearts script libraries; Hearts play trigger (60:82) was never imported (its conversion did not compile), so it is created and attached to the table (60:75).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- file (md5 of the body or of the whole file, with or without the final
-- newline), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/060/060_61_connectfour_start.lua
  (60, 61, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "start" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.start(globals, self.room, actor, arg)$trig$, ARRAY['be686986852bcd7e77b5aff38c9955fe', '66f7c09ad3332b0be1cd6c3d6e7bf172', 'c805e1f9c1da373bfa382556afd7fd33']),
  -- data/triggers/060/060_63_connectfour_select_color.lua
  (60, 63, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "select" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.select(globals, self.room, actor, arg)$trig$, ARRAY['c5603455208d1354782be9eaffb35c50', 'b9f3eda481aca6ffe120d324d4e1e5c9', '5745bcac049afee82be04dc4587f6e66']),
  -- data/triggers/060/060_64_connectfour_look_board.lua
  (60, 64, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "look" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.look(globals, self.room, actor, arg)$trig$, ARRAY['76c62a098e621539bf207c710655c07a', 'c3108a541f092c74c7ae90b9cb26eb64', 'e566b0b979adaca250587faf5a40b335']),
  -- data/triggers/060/060_66_connectfour_drop_piece.lua
  (60, 66, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "drop" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.drop(globals, self.room, actor, arg)$trig$, ARRAY['5e17dd1f5478539c7ef8879d8e4e6323', '43c2e847c8c09aca39c581ea81e62d17', '0a09fb801201189e4e008a69b2263119']),
  -- data/triggers/060/060_68_connectfour_reset_game.lua
  (60, 68, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "reset" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.reset(globals, self.room, actor, arg)$trig$, ARRAY['ae68a9dee2e6005b92f9284f6896d18b', 'a6a3fc2446b248f5386bdf7093a6386f', 'c297577e3c2b0faff6b3b9834a1832eb']),
  -- data/triggers/060/060_70_connectfour_forfeit_game.lua
  (60, 70, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "forfeit" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.forfeit(globals, self.room, actor, arg)$trig$, ARRAY['4b7494d084dbc06011e0da557e2b7637', '4ea98b562d6a7ac1f6873ffb032dc102', 'a65b21d2858f949e81ad54b39334387c']),
  -- data/triggers/060/060_72_connectfour_rules.lua
  (60, 72, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "rules" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.rules(globals, self.room, actor, arg)$trig$, ARRAY['bbc43af5cdf148d32cf6edb37c11613c', '4a1a9829e15f303f1b10a2968144d5a6', '45c3e20de3b7c9a2073d7bd10c518b7e']),
  -- data/triggers/060/060_75_hearts_start.lua
  (60, 75, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "start" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.start(globals, self.room, actor, arg)$trig$, ARRAY['00bc9dee8235488238be0fbdc521c0df', '62e1c2e4b964359d43f92cc3e85c5cdb', '28d0363d20367d9819a08630622fb2fc']),
  -- data/triggers/060/060_77_hearts_deal.lua
  (60, 77, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "deal" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.deal(globals, self.room, actor, arg, random)$trig$, ARRAY['9ffb00f6e18452a81b0a92878fe18892', '89b2f383fdb6f8eff6326dd87ccd862b', 'aae66d45e492217ccbf20fe17c262a44']),
  -- data/triggers/060/060_79_hearts_hand_view.lua
  (60, 79, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "hand" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.hand(globals, self.room, actor, arg)$trig$, ARRAY['447ba12999149238d0d978e8e689db8c', 'b231f14689502c6b39d4ce83b7fcd13b', '6a16bcf675cdc4974100125902bf552b']),
  -- data/triggers/060/060_80_hearts_look_table.lua
  (60, 80, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "look" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.look(globals, self.room, actor, arg)$trig$, ARRAY['05c4cbd14b363d191e1e9a5fa237bbaa', '78e3a818874cfc92ccd2b6af8d048a5c', '9dc9422193c77f3698a12b48a38a4969']),
  -- data/triggers/060/060_83_hearts_endgame.lua
  (60, 83, $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "endgame" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.endgame(globals, self.room, actor, arg)$trig$, ARRAY['d2d0d4976e54c265c287ca096222847e', '0dcc2341198456ed4b2c2f0082f4fe0f', 'ac3e65351f262ba85b368f91b5c74103'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

-- The script libraries behind the rewritten triggers (data/script_libraries/connectfour.lua and
-- hearts.lua, the bodies `fierylib seed script-libraries` would write). Rerunning rewrites a library
-- only when its code differs.
INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at")
VALUES ('connectfour', 60, 'Connect Four rules for the zone 60 board (triggers 60:61-72).', $lib$--
-- The board object's triggers (start, select, look, drop, reset, forfeit,
-- rules) each call one function here; the game itself lives in the board's
-- `globals.cf` table, so it is per board and ends when the board despawns.
--
--   local cf = require("connectfour")
--   return cf.drop(globals, self.room, actor, arg)
--
-- Every command function returns true when the command should carry on to
-- the normal handler ("not my command") and false when it was consumed, the
-- same convention as a COMMAND trigger's return value.
--
-- State (globals.cf): status 0 setting up, 1 playing, 2 over; p1, p2 are the
-- players' names; p1col, p2col are "red" or "black"; turn is 1 or 2; board
-- is 7 rows (1 = top) of 7 cells, each 0 (empty), 1 or 2 (a player's piece).
-- Only plain data is stored, never actor handles.
--
-- Ported from DG scripts #6061-#6072, which kept 49 board cells in globals
-- and tested rows with string searches. The rules are the same: four in a
-- line wins, vertically, horizontally or diagonally. Additions: a full board
-- is a draw, and a player who leaves the room forfeits (as the rules text
-- always said).

local M = {}

local ROWS, COLS, WIN = 7, 7, 4

local COLOUR = {
    red = { cell = "<b:red>O</>", word = "<b:red>red</>" },
    black = { cell = "<b:black>O</>", word = "<b:black>black</>" },
}

local RULES = {
    "Playing Connect Four is simple!  Your goal is simply to get four of",
    "your pieces in a line before your opponent.  The pieces can be",
    "horizontal, vertical, or even diagonal.",
    "</>",
    "To begin a game, you and a friend must type 'start' in the room with",
    "the game.  Whoever starts first gets to select their color, red or",
    "black, with 'select red' or 'select black'.  The second player",
    "automatically gets the other color.  If you type 'start' first, you",
    "also get the first turn.",
    "</>",
    "At any time, you can 'look board' to see what the board looks like.",
    "</>",
    "On your turn, you can 'drop' a piece into one of the 7 columns.  For",
    "instance, if you want to drop a piece in the third column, you'd type",
    "'drop 3'.  The piece will then fall down to the bottom of the third",
    "column.  If the column is full, you'll have to pick another one.",
    "</>",
    "During the game, you may use the 'forfeit' command to end the game.",
    "If you leave the room, you automatically forfeit.",
    "</>",
    "Once a game is over, either by someone winning or forfeiture, anyone",
    "in the room can use the 'reset' command to clear the board to start a",
    "new game.",
}

local function blank_board()
    local board = {}
    for r = 1, ROWS do
        board[r] = {}
        for c = 1, COLS do board[r][c] = 0 end
    end
    return board
end

function M.new()
    return { status = 0, turn = 0, board = blank_board() }
end

-- The game stored in `globals`, created on first use.
function M.state(globals)
    if type(globals.cf) ~= "table" then globals.cf = M.new() end
    return globals.cf
end

-- Empty the game in place.
local function clear(g)
    for k in pairs(g) do g[k] = nil end
    for k, v in pairs(M.new()) do g[k] = v end
end

-- Drop a piece for player `who` (1 or 2) into column `col`. Returns the row
-- it landed in, or nil when the column is full.
function M.drop_piece(board, col, who)
    for r = ROWS, 1, -1 do
        if board[r][col] == 0 then
            board[r][col] = who
            return r
        end
    end
    return nil
end

-- True when `who` has four pieces in a line anywhere on the board.
function M.has_four(board, who)
    local dirs = { { 0, 1 }, { 1, 0 }, { 1, 1 }, { 1, -1 } }
    for r = 1, ROWS do
        for c = 1, COLS do
            for _, d in ipairs(dirs) do
                local n = 0
                while n < WIN do
                    local row = board[r + d[1] * n]
                    if not row or row[c + d[2] * n] ~= who then break end
                    n = n + 1
                end
                if n == WIN then return true end
            end
        end
    end
    return false
end

function M.is_full(board)
    for c = 1, COLS do
        if board[1][c] == 0 then return false end
    end
    return true
end

-- The 15 lines of the board as drawn for `look board`.
function M.render(g)
    local border = "<blue>+-+-+-+-+-+-+-+</>"
    local lines = {
        "<blue> Connect Four!</>",
        "</>",
        border,
        "<blue>|1|2|3|4|5|6|7|</>",
        border,
    }
    for r = 1, ROWS do
        local cells = {}
        for c = 1, COLS do
            local v = g.board[r][c]
            local col = (v == 1 and g.p1col) or (v == 2 and g.p2col)
            cells[c] = col and COLOUR[col].cell or "O"
        end
        lines[#lines + 1] = "<blue>|" .. table.concat(cells, "<blue>|")
            .. "<blue>|</>"
        lines[#lines + 1] = border
    end
    lines[#lines + 1] = "</>"
    return lines
end

-- Who `name` is in this game: 1, 2 or nil.
local function seat(g, name)
    if g.p1 == name then return 1 end
    if g.p2 == name then return 2 end
    return nil
end

local function present(room, name)
    for _, a in ipairs(room.actors) do
        if a.name == name then return a end
    end
    return nil
end

-- Message the named player wherever they stand in the room.
local function tell(room, name, msg)
    local a = name and present(room, name)
    if a then a:send(msg) end
end

-- DG oechoaround: everyone in the room except the named player.
local function around(room, name, msg)
    local a = present(room, name)
    if a then room:send_except(a, msg) else room:send(msg) end
end

local function colour_word(g, who)
    local col = (who == 1) and g.p1col or g.p2col
    return col and COLOUR[col].word
end

-- A player who left the room before the game started loses their seat; one
-- who left mid-game forfeits.
local function settle(g, room)
    if g.status == 1 then
        for who = 1, 2 do
            local name = (who == 1) and g.p1 or g.p2
            if not present(room, name) then
                g.forfeit = who
                g.status = 2
                room:send(name .. " left the room and forfeits the game.")
                return
            end
        end
    elseif g.status == 0 then
        if g.p1 and not present(room, g.p1) then
            clear(g)
        elseif g.p2 and not present(room, g.p2) then
            g.p2 = nil
        end
    end
end

local function trim(s) return s:match("^%s*(.-)%s*$") end

-- Wrap a command so it runs against the stored game and writes it back.
local function command(fn)
    return function(globals, room, actor, arg)
        local g = M.state(globals)
        settle(g, room)
        local pass = fn(g, room, actor, trim(string.lower(arg or "")))
        globals.cf = g
        return pass
    end
end

M.start = command(function(g, room, actor)
    if g.p1 then
        if g.p2 then
            if g.status == 2 then
                actor:send("That game is over.  Type 'reset' to clear "
                    .. "the board.")
            else
                actor:send(g.p1 .. " and " .. g.p2
                    .. " are already playing ConnectFour!")
            end
        elseif actor.name == g.p1 then
            actor:send("You're already in the game!")
        else
            room:send_except(actor, actor.name
                .. " joins the ConnectFour game as player 2.")
            actor:send("You are now joining the ConnectFour game!")
            g.p2 = actor.name
            if g.p2col then
                local word = colour_word(g, 2)
                actor:send("You are the " .. word .. " pieces!")
                room:send_except(actor, actor.name .. " gets the " .. word
                    .. " pieces.")
                tell(room, g.p1, "You get to go first!")
                g.status = 1
                g.turn = 1
            end
        end
    else
        room:send_except(actor, actor.name
            .. " starts a new ConnectFour game as player 1.")
        actor:send("Alright!  Starting new ConnectFour game.  "
            .. "You are player 1.")
        actor:send("Do you want to be red or black?  "
            .. "Use the select command to choose.")
        g.p1 = actor.name
    end
    return false
end)

M.select = command(function(g, room, actor, arg)
    if g.status ~= 0 or g.p1 ~= actor.name then return true end
    if arg ~= "red" and arg ~= "black" then
        actor:send("You may only select 'red' or 'black'.")
        return false
    end
    local other = (arg == "red") and "black" or "red"
    g.p1col, g.p2col = arg, other
    actor:send("You are the " .. COLOUR[arg].word .. " pieces!")
    room:send_except(actor, actor.name .. " chooses to play with the "
        .. COLOUR[arg].word .. " pieces!")
    if g.p2 then
        tell(room, g.p2, "You are the " .. COLOUR[other].word .. " pieces!")
        around(room, g.p2, g.p2 .. " gets the " .. COLOUR[other].word
            .. " pieces.")
        actor:send("You get to go first!")
        g.status = 1
        g.turn = 1
    end
    return false
end)

M.drop = command(function(g, room, actor, arg)
    local me = seat(g, actor.name)
    if not me then return true end
    local col = tonumber(arg)
    -- `drop sword` is an ordinary drop; only a column (or nothing) is ours
    if arg ~= "" and not col then return true end
    if g.status == 0 then
        actor:send("The game hasn't started yet!")
        return false
    elseif g.status == 2 then
        actor:send("The game is already over!")
        return false
    elseif g.turn ~= me then
        actor:send("It's not your turn!")
        return false
    end
    if not col or col < 1 or col > COLS or col ~= math.floor(col) then
        actor:send("Drop a piece in where!?")
        return false
    end
    if not M.drop_piece(g.board, col, me) then
        actor:send("Column " .. arg .. " is full!  Try a different one.")
        return false
    end
    actor:send("You drop a piece in column " .. arg .. ".")
    room:send_except(actor, actor.name .. " drops a piece in column "
        .. arg .. ".")
    if M.has_four(g.board, me) then
        actor:send("You win!")
        room:send_except(actor, actor.name .. " wins!")
        g.winner = me
        g.status = 2
    elseif M.is_full(g.board) then
        room:send("The board is full: the game is a draw!")
        g.draw = true
        g.status = 2
    end
    g.turn = (me == 1) and 2 or 1
    return false
end)

M.forfeit = command(function(g, room, actor, arg)
    local me = seat(g, actor.name)
    if g.status == 0 or not g.p1 or not g.p2 then
        actor:send("But the game hasn't even started yet!")
    elseif not me then
        actor:send("You can't forfeit a game you're not even playing!")
    elseif g.status == 2 then
        actor:send("But the game's already over!")
    elseif arg == "yes" then
        actor:send("You forfeit the game!")
        room:send_except(actor, actor.name .. " forfeits the game!")
        g.forfeit = me
        g.status = 2
    else
        actor:send("Are you absolutely sure you want to forfeit?  "
            .. "If so, type 'forfeit yes'.")
    end
    return false
end)

M.reset = command(function(g, room, actor)
    local me = seat(g, actor.name)
    if g.status == 2 then
        room:send("Resetting ConnectFour.")
        clear(g)
        room:send("Board cleared.")
    elseif g.status == 1 then
        if me then
            actor:send("If you want to end the game, forfeit first, "
                .. "then reset.")
        else
            actor:send("Wait until " .. g.p1 .. " and " .. g.p2
                .. " are done playing!")
        end
    elseif me == 1 then
        actor:send("You can't reset the board until the game is over.")
    else
        actor:send("The board is already cleared!")
    end
    return false
end)

M.rules = function(globals, room, actor)
    for _, line in ipairs(RULES) do actor:send(line) end
    return false
end

-- Who is playing and whose turn it is, from `viewer`'s point of view.
local function status_lines(g, room, viewer)
    local out = {}
    local function add(s) out[#out + 1] = s end
    local p1, p2 = g.p1, g.p2
    local d1, d2 = colour_word(g, 1), colour_word(g, 2)
    if g.status == 0 then
        if not p1 then return out end
        if p2 then
            if viewer == p1 then
                add("You and " .. p2 .. " are getting ready to start a game!")
                add("You need to choose a color!  Type 'select red' or "
                    .. "'select black'.")
            elseif viewer == p2 then
                add("You and " .. p1 .. " are getting ready to start a game!")
                add("We are waiting for " .. p1 .. " to choose a color.")
            else
                add(p1 .. " and " .. p2
                    .. " are getting ready to start a game.")
            end
        elseif viewer == p1 then
            add("You are waiting for someone to join you.")
            if d1 then
                add("You are playing as " .. d1 .. ".")
            else
                add("You need to choose a color!  Type 'select red' or "
                    .. "'select black'.")
            end
        else
            local a = present(room, p1)
            add(p1 .. " is waiting for someone to join "
                .. (a and a.objective or "them") .. ".")
            if d1 then add(p1 .. " is playing as " .. d1 .. ".") end
        end
    elseif g.status == 1 then
        if viewer == p1 or viewer == p2 then
            local me, you = p1, p2
            local mine, yours, mynum = d1, d2, 1
            if viewer == p2 then
                me, you, mine, yours, mynum = p2, p1, d2, d1, 2
            end
            add("You and " .. you .. " are playing.")
            add("You are " .. mine .. " and " .. you .. " is " .. yours .. ".")
            if g.turn == mynum then
                add("It's your turn!")
            else
                add("It's " .. you .. "'s turn.")
            end
        else
            add(p1 .. " and " .. p2 .. " are playing.")
            add(p1 .. " is " .. d1 .. " and " .. p2 .. " is " .. d2 .. ".")
            add("It's " .. (g.turn == 1 and p1 or p2) .. "'s turn.")
        end
    elseif g.status == 2 then
        if viewer == p1 then
            add("You and " .. p2 .. " were playing.")
        elseif viewer == p2 then
            add("You and " .. p1 .. " were playing.")
        else
            add(p1 .. " and " .. p2 .. " were playing.")
        end
        local names = { p1, p2 }
        if g.winner then
            add(viewer == names[g.winner] and "You won the game!"
                or names[g.winner] .. " won the game.")
        elseif g.forfeit then
            add(viewer == names[g.forfeit] and "You forfeited the game."
                or names[g.forfeit] .. " forfeited the game.")
        elseif g.draw then
            add("The game ended in a draw.")
        else
            add("The game is over.")
        end
    end
    return out
end

M.look = command(function(g, room, actor, arg)
    if arg ~= "board" and arg ~= "connectfour" and arg ~= "game" then
        return true
    end
    for _, line in ipairs(M.render(g)) do actor:send(line) end
    for _, line in ipairs(status_lines(g, room, actor.name)) do
        actor:send(line)
    end
    return false
end)

return M
$lib$, now())
ON CONFLICT ("name") DO UPDATE
SET "zone_id" = EXCLUDED."zone_id",
    "description" = EXCLUDED."description",
    "code" = EXCLUDED."code",
    "updated_at" = now()
WHERE "ScriptLibrary"."code" IS DISTINCT FROM EXCLUDED."code";

INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at")
VALUES ('hearts', 60, 'Hearts card game rules for the zone 60 table (60:75-83).', $lib$--
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
$lib$, now())
ON CONFLICT ("name") DO UPDATE
SET "zone_id" = EXCLUDED."zone_id",
    "description" = EXCLUDED."description",
    "code" = EXCLUDED."code",
    "updated_at" = now()
WHERE "ScriptLibrary"."code" IS DISTINCT FROM EXCLUDED."code";

-- Hearts "play" (DG #6082) never reached the database: its converted body did not compile, so the
-- importer skipped it and nobody could play a card. Create it and attach it to the Hearts table
-- (object 60:75) next to start/deal/hand/look/endgame. Rerunning inserts nothing.
INSERT INTO "Triggers" ("zone_id", "id", "name", "attachType", "num_args", "arg_list", "commands", "flags", "updated_at")
VALUES (60, 82, 'hearts play', 'OBJECT', 0, ARRAY[]::text[], $trig$-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "play" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.play(globals, self.room, actor, arg)$trig$, ARRAY['COMMAND']::"TriggerFlag"[], now())
ON CONFLICT ("zone_id", "id") DO NOTHING;

INSERT INTO "ObjectTriggers" ("object_zone_id", "object_id", "trigger_zone_id", "trigger_id")
SELECT 60, 75, 60, 82
WHERE EXISTS (SELECT 1 FROM "Objects" WHERE "zone_id" = 60 AND "id" = 75)
ON CONFLICT DO NOTHING;

COMMIT;
