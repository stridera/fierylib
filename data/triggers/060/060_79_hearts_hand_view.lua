-- Trigger: hearts hand view
-- Zone: 60, ID: 79
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 57 if statements
--   Large script: 7654 chars
--
-- Original DG Script: #6079

-- Converted from DG Script #6079: hearts hand view
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: hand
if not (cmd == "hand") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "h" or cmd == "ha" then
    _return_value = false
    return _return_value
end
if player1 and (actor.name == player1.name) then
    local plyr = 1
elseif player2 and (actor.name == player2.name) then
    local plyr = 2
elseif player3 and (actor.name == player3.name) then
    local plyr = 3
elseif player4 and (actor.name == player4.name) then
    local plyr = 4
else
    _return_value = false
    return _return_value
end
if status < 2 then
    actor:send("The game hasn't started yet!  You don't have any cards.")
    return _return_value
elseif status > 3 then
    actor:send("The game is over already!")
    return _return_value
end
local count = 1
actor:send("Your hand contains:")
if card1 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name1))
    local count = count + 1
end
if card2 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name2))
    local count = count + 1
end
if card3 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name3))
    local count = count + 1
end
if card4 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name4))
    local count = count + 1
end
if card5 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name5))
    local count = count + 1
end
if card6 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name6))
    local count = count + 1
end
if card7 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name7))
    local count = count + 1
end
if card8 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name8))
    local count = count + 1
end
if card9 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name9))
    local count = count + 1
end
if card10 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name10))
    local count = count + 1
end
if card11 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name11))
    local count = count + 1
end
if card12 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name12))
    local count = count + 1
end
if card13 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name13))
    local count = count + 1
end
if card14 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name14))
    local count = count + 1
end
if card15 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name15))
    local count = count + 1
end
if card16 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name16))
    local count = count + 1
end
if card17 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name17))
    local count = count + 1
end
if card18 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name18))
    local count = count + 1
end
if card19 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name19))
    local count = count + 1
end
if card20 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name20))
    local count = count + 1
end
if card21 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name21))
    local count = count + 1
end
if card22 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name22))
    local count = count + 1
end
if card23 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name23))
    local count = count + 1
end
if card24 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name24))
    local count = count + 1
end
if card25 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name25))
    local count = count + 1
end
if card26 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name26))
    local count = count + 1
end
if card27 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name27))
    local count = count + 1
end
if card28 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name28))
    local count = count + 1
end
if card29 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name29))
    local count = count + 1
end
if card30 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name30))
    local count = count + 1
end
if card31 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name31))
    local count = count + 1
end
if card32 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name32))
    local count = count + 1
end
if card33 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name33))
    local count = count + 1
end
if card34 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name34))
    local count = count + 1
end
if card35 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name35))
    local count = count + 1
end
if card36 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name36))
    local count = count + 1
end
if card37 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name37))
    local count = count + 1
end
if card38 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name38))
    local count = count + 1
end
if card39 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name39))
    local count = count + 1
end
if card40 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name40))
    local count = count + 1
end
if card41 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name41))
    local count = count + 1
end
if card42 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name42))
    local count = count + 1
end
if card43 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name43))
    local count = count + 1
end
if card44 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name44))
    local count = count + 1
end
if card45 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name45))
    local count = count + 1
end
if card46 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name46))
    local count = count + 1
end
if card47 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name47))
    local count = count + 1
end
if card48 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name48))
    local count = count + 1
end
if card49 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name49))
    local count = count + 1
end
if card50 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name50))
    local count = count + 1
end
if card51 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name51))
    local count = count + 1
end
if card52 == "plyr" then
    actor:send("</> " .. tostring(count) .. ". " .. tostring(name52))
    local count = count + 1
end
return _return_value