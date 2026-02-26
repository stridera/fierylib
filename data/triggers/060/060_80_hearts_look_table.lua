-- Trigger: hearts look table
-- Zone: 60, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 111 if statements
--   Large script: 9320 chars
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
    if card1 == 9 then
        actor:send("</>  " .. tostring(name1))
        if trick1 == 1 then
            local leader = name1
        end
    end
    if card2 == 9 then
        actor:send("</>  " .. tostring(name2))
        if trick1 == 2 then
            local leader = name2
        end
    end
    if card3 == 9 then
        actor:send("</>  " .. tostring(name3))
        if trick1 == 3 then
            local leader = name3
        end
    end
    if card4 == 9 then
        actor:send("</>  " .. tostring(name4))
        if trick1 == 4 then
            local leader = name4
        end
    end
    if card5 == 9 then
        actor:send("</>  " .. tostring(name5))
        if trick1 == 5 then
            local leader = name5
        end
    end
    if card6 == 9 then
        actor:send("</>  " .. tostring(name6))
        if trick1 == 6 then
            local leader = name6
        end
    end
    if card7 == 9 then
        actor:send("</>  " .. tostring(name7))
        if trick1 == 7 then
            local leader = name7
        end
    end
    if card8 == 9 then
        actor:send("</>  " .. tostring(name8))
        if trick1 == 8 then
            local leader = name8
        end
    end
    if card9 == 9 then
        actor:send("</>  " .. tostring(name9))
        if trick1 == 9 then
            local leader = name9
        end
    end
    if card10 == 9 then
        actor:send("</>  " .. tostring(name10))
        if trick1 == 10 then
            local leader = name10
        end
    end
    if card11 == 9 then
        actor:send("</>  " .. tostring(name11))
        if trick1 == 11 then
            local leader = name12
        end
    end
    if card12 == 9 then
        actor:send("</>  " .. tostring(name12))
        if trick1 == 12 then
            local leader = name11
        end
    end
    if card13 == 9 then
        actor:send("</>  " .. tostring(name13))
        if trick1 == 13 then
            local leader = name13
        end
    end
    if card14 == 9 then
        actor:send("</>  " .. tostring(name14))
        if trick1 == 14 then
            local leader = name14
        end
    end
    if card15 == 9 then
        actor:send("</>  " .. tostring(name15))
        if trick1 == 15 then
            local leader = name15
        end
    end
    if card16 == 9 then
        actor:send("</>  " .. tostring(name16))
        if trick1 == 16 then
            local leader = name16
        end
    end
    if card17 == 9 then
        actor:send("</>  " .. tostring(name17))
        if trick1 == 17 then
            local leader = name17
        end
    end
    if card18 == 9 then
        actor:send("</>  " .. tostring(name18))
        if trick1 == 18 then
            local leader = name18
        end
    end
    if card19 == 9 then
        actor:send("</>  " .. tostring(name19))
        if trick1 == 19 then
            local leader = name19
        end
    end
    if card20 == 9 then
        actor:send("</>  " .. tostring(name20))
        if trick1 == 20 then
            local leader = name20
        end
    end
    if card21 == 9 then
        actor:send("</>  " .. tostring(name21))
        if trick1 == 21 then
            local leader = name21
        end
    end
    if card22 == 9 then
        actor:send("</>  " .. tostring(name22))
        if trick1 == 22 then
            local leader = name22
        end
    end
    if card23 == 9 then
        actor:send("</>  " .. tostring(name23))
        if trick1 == 23 then
            local leader = name23
        end
    end
    if card24 == 9 then
        actor:send("</>  " .. tostring(name24))
        if trick1 == 24 then
            local leader = name24
        end
    end
    if card25 == 9 then
        actor:send("</>  " .. tostring(name25))
        if trick1 == 25 then
            local leader = name25
        end
    end
    if card26 == 9 then
        actor:send("</>  " .. tostring(name26))
        if trick1 == 26 then
            local leader = name26
        end
    end
    if card27 == 9 then
        actor:send("</>  " .. tostring(name27))
        if trick1 == 27 then
            local leader = name27
        end
    end
    if card28 == 9 then
        actor:send("</>  " .. tostring(name28))
        if trick1 == 28 then
            local leader = name28
        end
    end
    if card29 == 9 then
        actor:send("</>  " .. tostring(name29))
        if trick1 == 29 then
            local leader = name29
        end
    end
    if card30 == 9 then
        actor:send("</>  " .. tostring(name30))
        if trick1 == 30 then
            local leader = name30
        end
    end
    if card31 == 9 then
        actor:send("</>  " .. tostring(name31))
        if trick1 == 31 then
            local leader = name31
        end
    end
    if card32 == 9 then
        actor:send("</>  " .. tostring(name32))
        if trick1 == 32 then
            local leader = name32
        end
    end
    if card33 == 9 then
        actor:send("</>  " .. tostring(name33))
        if trick1 == 33 then
            local leader = name33
        end
    end
    if card34 == 9 then
        actor:send("</>  " .. tostring(name34))
        if trick1 == 34 then
            local leader = name34
        end
    end
    if card35 == 9 then
        actor:send("</>  " .. tostring(name35))
        if trick1 == 35 then
            local leader = name35
        end
    end
    if card36 == 9 then
        actor:send("</>  " .. tostring(name36))
        if trick1 == 36 then
            local leader = name36
        end
    end
    if card37 == 9 then
        actor:send("</>  " .. tostring(name37))
        if trick1 == 37 then
            local leader = name37
        end
    end
    if card38 == 9 then
        actor:send("</>  " .. tostring(name38))
        if trick1 == 38 then
            local leader = name38
        end
    end
    if card39 == 9 then
        actor:send("</>  " .. tostring(name39))
        if trick1 == 39 then
            local leader = name39
        end
    end
    if card40 == 9 then
        actor:send("</>  " .. tostring(name40))
        if trick1 == 40 then
            local leader = name40
        end
    end
    if card41 == 9 then
        actor:send("</>  " .. tostring(name41))
        if trick1 == 41 then
            local leader = name41
        end
    end
    if card42 == 9 then
        actor:send("</>  " .. tostring(name42))
        if trick1 == 42 then
            local leader = name42
        end
    end
    if card43 == 9 then
        actor:send("</>  " .. tostring(name43))
        if trick1 == 43 then
            local leader = name43
        end
    end
    if card44 == 9 then
        actor:send("</>  " .. tostring(name44))
        if trick1 == 44 then
            local leader = name44
        end
    end
    if card45 == 9 then
        actor:send("</>  " .. tostring(name45))
        if trick1 == 45 then
            local leader = name45
        end
    end
    if card46 == 9 then
        actor:send("</>  " .. tostring(name46))
        if trick1 == 46 then
            local leader = name46
        end
    end
    if card47 == 9 then
        actor:send("</>  " .. tostring(name47))
        if trick1 == 47 then
            local leader = name47
        end
    end
    if card48 == 9 then
        actor:send("</>  " .. tostring(name48))
        if trick1 == 48 then
            local leader = name48
        end
    end
    if card49 == 9 then
        actor:send("</>  " .. tostring(name49))
        if trick1 == 49 then
            local leader = name49
        end
    end
    if card50 == 9 then
        actor:send("</>  " .. tostring(name50))
        if trick1 == 50 then
            local leader = name50
        end
    end
    if card51 == 9 then
        actor:send("</>  " .. tostring(name51))
        if trick1 == 51 then
            local leader = name51
        end
    end
    if card52 == 9 then
        actor:send("</>  " .. tostring(name52))
        if trick1 == 52 then
            local leader = name52
        end
    end
    actor:send("The trick was led by the " .. tostring(leader) .. ".")
    if turn == 1 then
        actor:send("It is " .. tostring(player1.name) .. "'s turn.")
    elseif turn == 2 then
        actor:send("It is " .. tostring(player2.name) .. "'s turn.")
    elseif turn == 3 then
        actor:send("It is " .. tostring(player3.name) .. "'s turn.")
    elseif turn == 4 then
        actor:send("It is " .. tostring(player4.name) .. "'s turn.")
    end
else
    _return_value = false
end
return _return_value