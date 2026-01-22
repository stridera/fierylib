-- Trigger: hearts look table
-- Zone: 60, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Refactored: Replaced 52 if-statements with indexed loop
--
-- Original DG Script: #6080

-- Converted from DG Script #6080: hearts look table
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end

local _return_value = true  -- Default: allow action

if (arg == "table") or (arg == "hearts") then
    if status < 3 then
        actor:send("The deck of cards is undealt.")
        return _return_value
    end
    if status > 3 then
        actor:send("The table is empty.")
        return _return_value
    end
    if trick == 1 then
        actor:send("No cards have been played yet this trick.")
        return _return_value
    end

    actor:send("The following cards have been played this trick:")

    -- Card variable lookup tables (using _G for global access)
    local cards = {}
    local names = {}
    for i = 1, 52 do
        cards[i] = _G["card" .. i]
        names[i] = _G["name" .. i]
    end

    -- Find and display played cards, track leader
    local leader = nil
    for i = 1, 52 do
        if cards[i] == 9 then
            actor:send("</>  " .. tostring(names[i]))
            if trick1 == i then
                -- Note: Original DG script had swapped names for indices 11/12
                if i == 11 then
                    leader = names[12]
                elseif i == 12 then
                    leader = names[11]
                else
                    leader = names[i]
                end
            end
        end
    end

    actor:send("The trick was led by the " .. tostring(leader) .. ".")

    -- Display whose turn it is
    local players = { player1, player2, player3, player4 }
    if turn >= 1 and turn <= 4 then
        actor:send("It is " .. tostring(players[turn].name) .. "'s turn.")
    end
else
    _return_value = false
end

return _return_value
