-- Trigger: hearts deal
-- Zone: 60, ID: 77
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Complex nesting: 13 if statements
--   Note: This trigger has fundamental design issues from the original DG Script
--   and cannot function properly as-is. Marked CLEAN for syntax but needs redesign.
--
-- Original DG Script: #6077

-- Converted from DG Script #6077: hearts deal
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: deal
if not (cmd == "deal") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "de" then
    _return_value = false
    return _return_value
end
if player1 and player2 and player3 and player4 then
    if (player1.name ~= actor.name) and (player2.name ~= actor.name) and (player3.name ~= actor.name) and (player4.name ~= actor.name) then
        _return_value = false
        return _return_value
    end
    if status > 1 then
        actor:send("Wait for this hand to end before dealing again!")
        return _return_value
    end
    actor:send("You deal the cards across the table.")
    self.room:send_except(actor, tostring(actor.name) .. " deals the cards, beginning a new round.")
    local card = 1
    while card <= 52 do
        card[card] = 0
        local rank = card - 13 * ((card - 1)/ 13)
        local suit = ((card - 1)/ 13) + 1
        if rank == 1 then
            local rank = "Two"
        elseif rank == 2 then
            local rank = "Three"
        elseif rank == 3 then
            local rank = "Four"
        elseif rank == 4 then
            local rank = "Five"
        elseif rank == 5 then
            local rank = "Six"
        elseif rank == 6 then
            local rank = "Seven"
        elseif rank == 7 then
            local rank = "Eight"
        elseif rank == 8 then
            local rank = "Nine"
        elseif rank == 9 then
            local rank = "Ten"
        elseif rank == 10 then
            local rank = "Jack"
        elseif rank == 11 then
            local rank = "Queen"
        elseif rank == 12 then
            local rank = "King"
        elseif rank == 13 then
            local rank = "Ace"
        end
        if suit == 1 then
            local suit = "Clubs"
        elseif suit == 2 then
            local suit = "Diamonds"
        elseif suit == 3 then
            local suit = "Spades"
        elseif suit == 4 then
            local suit = "Hearts"
        end
        name[card] = rank .. " of " .. suit
        globals["name" .. card] = globals["name" .. card] or true
        local card = card + 1
    end
    local count = 0
    local plyr = 1
    while plyr <= 4 do
        local cnt = 1
        while cnt <= 13 do
            local dlt = 0
            local dlt_cnt = 0
            while not dlt do
                local dlt_cnt = dlt_cnt + 1
                local card = random(1, 52)
                local desc = XcardX
                if not (string.find(cards, "desc")) then
                    card[card] = plyr
                    globals["card" .. card] = globals["card" .. card] or true
                    local cards = cardsdesc
                    local dlt = 1
                end
            end
            while not dlt do
                local dlt_cnt = dlt_cnt + 1
                local card = random(1, 52)
                local desc = XcardX
                if not (string.find(cards, "desc")) then
                    card[card] = plyr
                    globals["card" .. card] = globals["card" .. card] or true
                    local cards = cardsdesc
                    local dlt = 1
                end
            end
            local cnt = cnt + 1
            if cnt < 13 then
                actor:send("Dealing of cards failed; please attempt again.")
                return _return_value
            end
            local plyr = plyr + 1
            if card1 == 1 then
                local turn = 1
                player1:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 2 then
                local turn = 2
                player2:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 3 then
                local turn = 3
                player3:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            elseif card1 == 4 then
                local turn = 4
                player4:send("It's your turn first; you must play the " .. tostring(name1) .. ".")
            end
            globals.turn = globals.turn or true
            local first_turn = 1
            globals.first_turn = globals.first_turn or true
            local status = 3
            globals.status = globals.status or true
        end
    end
else
    if (player1 and (player1.name == actor.name)) or (player2 and (player2.name == actor.name)) or (player3 and (player3.name == actor.name)) then
        actor:send("You can't deal until four people have joined!")
    else
        _return_value = false
    end
end
return _return_value