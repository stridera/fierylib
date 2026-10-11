-- Trigger: hearts look table
-- Zone: 60, ID: 80
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): part of broken Hearts mini-game; see 060_75. Branch-scoped
-- `local leader` writes never escape; needs full rewrite.
--
-- Original DG Script: #6080

-- Converted from DG Script #6080: hearts look table
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
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
    local leader
    if card1 == 9 then
        actor:send("</>  " .. tostring(name1))
        if trick1 == 1 then
            leader = name1
        end
    end
    local leader
    if card2 == 9 then
        actor:send("</>  " .. tostring(name2))
        if trick1 == 2 then
            leader = name2
        end
    end
    local leader
    if card3 == 9 then
        actor:send("</>  " .. tostring(name3))
        if trick1 == 3 then
            leader = name3
        end
    end
    local leader
    if card4 == 9 then
        actor:send("</>  " .. tostring(name4))
        if trick1 == 4 then
            leader = name4
        end
    end
    local leader
    if card5 == 9 then
        actor:send("</>  " .. tostring(name5))
        if trick1 == 5 then
            leader = name5
        end
    end
    local leader
    if card6 == 9 then
        actor:send("</>  " .. tostring(name6))
        if trick1 == 6 then
            leader = name6
        end
    end
    local leader
    if card7 == 9 then
        actor:send("</>  " .. tostring(name7))
        if trick1 == 7 then
            leader = name7
        end
    end
    local leader
    if card8 == 9 then
        actor:send("</>  " .. tostring(name8))
        if trick1 == 8 then
            leader = name8
        end
    end
    local leader
    if card9 == 9 then
        actor:send("</>  " .. tostring(name9))
        if trick1 == 9 then
            leader = name9
        end
    end
    local leader
    if card10 == 9 then
        actor:send("</>  " .. tostring(name10))
        if trick1 == 10 then
            leader = name10
        end
    end
    local leader
    if card11 == 9 then
        actor:send("</>  " .. tostring(name11))
        if trick1 == 11 then
            leader = name12
        end
    end
    local leader
    if card12 == 9 then
        actor:send("</>  " .. tostring(name12))
        if trick1 == 12 then
            leader = name11
        end
    end
    local leader
    if card13 == 9 then
        actor:send("</>  " .. tostring(name13))
        if trick1 == 13 then
            leader = name13
        end
    end
    local leader
    if card14 == 9 then
        actor:send("</>  " .. tostring(name14))
        if trick1 == 14 then
            leader = name14
        end
    end
    local leader
    if card15 == 9 then
        actor:send("</>  " .. tostring(name15))
        if trick1 == 15 then
            leader = name15
        end
    end
    local leader
    if card16 == 9 then
        actor:send("</>  " .. tostring(name16))
        if trick1 == 16 then
            leader = name16
        end
    end
    local leader
    if card17 == 9 then
        actor:send("</>  " .. tostring(name17))
        if trick1 == 17 then
            leader = name17
        end
    end
    local leader
    if card18 == 9 then
        actor:send("</>  " .. tostring(name18))
        if trick1 == 18 then
            leader = name18
        end
    end
    local leader
    if card19 == 9 then
        actor:send("</>  " .. tostring(name19))
        if trick1 == 19 then
            leader = name19
        end
    end
    local leader
    if card20 == 9 then
        actor:send("</>  " .. tostring(name20))
        if trick1 == 20 then
            leader = name20
        end
    end
    local leader
    if card21 == 9 then
        actor:send("</>  " .. tostring(name21))
        if trick1 == 21 then
            leader = name21
        end
    end
    local leader
    if card22 == 9 then
        actor:send("</>  " .. tostring(name22))
        if trick1 == 22 then
            leader = name22
        end
    end
    local leader
    if card23 == 9 then
        actor:send("</>  " .. tostring(name23))
        if trick1 == 23 then
            leader = name23
        end
    end
    local leader
    if card24 == 9 then
        actor:send("</>  " .. tostring(name24))
        if trick1 == 24 then
            leader = name24
        end
    end
    local leader
    if card25 == 9 then
        actor:send("</>  " .. tostring(name25))
        if trick1 == 25 then
            leader = name25
        end
    end
    local leader
    if card26 == 9 then
        actor:send("</>  " .. tostring(name26))
        if trick1 == 26 then
            leader = name26
        end
    end
    local leader
    if card27 == 9 then
        actor:send("</>  " .. tostring(name27))
        if trick1 == 27 then
            leader = name27
        end
    end
    local leader
    if card28 == 9 then
        actor:send("</>  " .. tostring(name28))
        if trick1 == 28 then
            leader = name28
        end
    end
    local leader
    if card29 == 9 then
        actor:send("</>  " .. tostring(name29))
        if trick1 == 29 then
            leader = name29
        end
    end
    local leader
    if card30 == 9 then
        actor:send("</>  " .. tostring(name30))
        if trick1 == 30 then
            leader = name30
        end
    end
    local leader
    if card31 == 9 then
        actor:send("</>  " .. tostring(name31))
        if trick1 == 31 then
            leader = name31
        end
    end
    local leader
    if card32 == 9 then
        actor:send("</>  " .. tostring(name32))
        if trick1 == 32 then
            leader = name32
        end
    end
    local leader
    if card33 == 9 then
        actor:send("</>  " .. tostring(name33))
        if trick1 == 33 then
            leader = name33
        end
    end
    local leader
    if card34 == 9 then
        actor:send("</>  " .. tostring(name34))
        if trick1 == 34 then
            leader = name34
        end
    end
    local leader
    if card35 == 9 then
        actor:send("</>  " .. tostring(name35))
        if trick1 == 35 then
            leader = name35
        end
    end
    local leader
    if card36 == 9 then
        actor:send("</>  " .. tostring(name36))
        if trick1 == 36 then
            leader = name36
        end
    end
    local leader
    if card37 == 9 then
        actor:send("</>  " .. tostring(name37))
        if trick1 == 37 then
            leader = name37
        end
    end
    local leader
    if card38 == 9 then
        actor:send("</>  " .. tostring(name38))
        if trick1 == 38 then
            leader = name38
        end
    end
    local leader
    if card39 == 9 then
        actor:send("</>  " .. tostring(name39))
        if trick1 == 39 then
            leader = name39
        end
    end
    local leader
    if card40 == 9 then
        actor:send("</>  " .. tostring(name40))
        if trick1 == 40 then
            leader = name40
        end
    end
    local leader
    if card41 == 9 then
        actor:send("</>  " .. tostring(name41))
        if trick1 == 41 then
            leader = name41
        end
    end
    local leader
    if card42 == 9 then
        actor:send("</>  " .. tostring(name42))
        if trick1 == 42 then
            leader = name42
        end
    end
    local leader
    if card43 == 9 then
        actor:send("</>  " .. tostring(name43))
        if trick1 == 43 then
            leader = name43
        end
    end
    local leader
    if card44 == 9 then
        actor:send("</>  " .. tostring(name44))
        if trick1 == 44 then
            leader = name44
        end
    end
    local leader
    if card45 == 9 then
        actor:send("</>  " .. tostring(name45))
        if trick1 == 45 then
            leader = name45
        end
    end
    local leader
    if card46 == 9 then
        actor:send("</>  " .. tostring(name46))
        if trick1 == 46 then
            leader = name46
        end
    end
    local leader
    if card47 == 9 then
        actor:send("</>  " .. tostring(name47))
        if trick1 == 47 then
            leader = name47
        end
    end
    local leader
    if card48 == 9 then
        actor:send("</>  " .. tostring(name48))
        if trick1 == 48 then
            leader = name48
        end
    end
    local leader
    if card49 == 9 then
        actor:send("</>  " .. tostring(name49))
        if trick1 == 49 then
            leader = name49
        end
    end
    local leader
    if card50 == 9 then
        actor:send("</>  " .. tostring(name50))
        if trick1 == 50 then
            leader = name50
        end
    end
    local leader
    if card51 == 9 then
        actor:send("</>  " .. tostring(name51))
        if trick1 == 51 then
            leader = name51
        end
    end
    local leader
    if card52 == 9 then
        actor:send("</>  " .. tostring(name52))
        if trick1 == 52 then
            leader = name52
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
    _return_value = true
end
return _return_value