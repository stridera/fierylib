-- Library: connectfour
-- Zone: 60
-- Description: Connect Four rules for the zone 60 board (triggers 60:61-72).
--
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
