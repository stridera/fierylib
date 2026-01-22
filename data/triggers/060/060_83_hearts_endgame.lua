-- Trigger: hearts endgame
-- Zone: 60, ID: 83
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 5677 chars
--
-- Original DG Script: #6083

-- Converted from DG Script #6083: hearts endgame
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: endgame
if not (cmd == "endgame") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" or cmd == "en" then
    _return_value = false
    return _return_value
end
if status == 4 then
    local plyr = 1
    while plyr <= 4 do
        if card37 == plyr + 4 then
            local score = 13
        end
        if card40 == plyr + 4 then
            local score = score + 1
        end
        if card41 == plyr + 4 then
            local score = score + 1
        end
        if card42 == plyr + 4 then
            local score = score + 1
        end
        if card43 == plyr + 4 then
            local score = score + 1
        end
        if card44 == plyr + 4 then
            local score = score + 1
        end
        if card45 == plyr + 4 then
            local score = score + 1
        end
        if card46 == plyr + 4 then
            local score = score + 1
        end
        if card47 == plyr + 4 then
            local score = score + 1
        end
        if card48 == plyr + 4 then
            local score = score + 1
        end
        if card49 == plyr + 4 then
            local score = score + 1
        end
        if card50 == plyr + 4 then
            local score = score + 1
        end
        if card51 == plyr + 4 then
            local score = score + 1
        end
        if card52 == plyr + 4 then
            local score = score + 1
        end
        if plyr == 1 then
            local score1 = score
        elseif plyr == 2 then
            local score2 = score
        elseif plyr == 3 then
            local score3 = score
        elseif plyr == 4 then
            local score4 = score
        end
    end
    if (score1 == 26) or (score2 == 26) or (score3 == 26) or (score4 == 26) then
        if score1 == 26 then
            player1:send("You took all the point cards!  Everyone else gets 26 points.")
            player2:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            player3:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            player4:send(tostring(player1.name) .. " took all the point cards, so you get 26 points.")
            local score1 = 0
            local score2 = 26
            local score3 = 26
            local score4 = 26
        elseif score2 == 26 then
            player1:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            player2:send("You took all the point cards!  Everyone else gets 26 points.")
            player3:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            player4:send(tostring(player2.name) .. " took all the point cards, so you get 26 points.")
            local score1 = 26
            local score2 = 0
            local score3 = 26
            local score4 = 26
        elseif score3 == 26 then
            player1:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            player2:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            player3:send("You took all the point cards!  Everyone else gets 26 points.")
            player4:send(tostring(player3.name) .. " took all the point cards, so you get 26 points.")
            local score1 = 26
            local score2 = 26
            local score3 = 0
            local score4 = 26
        elseif score4 == 26 then
            player1:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player2:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player3:send(tostring(player4.name) .. " took all the point cards, so you get 26 points.")
            player4:send("You took all the point cards!  Everyone else gets 26 points.")
            local score1 = 26
            local score2 = 26
            local score3 = 26
            local score4 = 0
        end
    end
    local total1 = total1 + score1
    local total2 = total2 + score2
    local total3 = total3 + score3
    local total4 = total4 + score4
    player1:send("You scored " .. tostring(score1) .. " points this round, bringing your total to " .. tostring(total1) .. ".")
    player2:send("You scored " .. tostring(score2) .. " points this round, bringing your total to " .. tostring(total2) .. ".")
    player3:send("You scored " .. tostring(score3) .. " points this round, bringing your total to " .. tostring(total3) .. ".")
    player4:send("You scored " .. tostring(score4) .. " points this round, bringing your total to " .. tostring(total4) .. ".")
    if (total1 > 99) or (total2 > 99) or (total3 > 99) or (total4 > 99) then
        self.room:send("The game is over!")
        self.room:send(tostring(player1.name) .. " scored a total of " .. tostring(total1) .. " points.")
        self.room:send(tostring(player2.name) .. " scored a total of " .. tostring(total2) .. " points.")
        self.room:send(tostring(player3.name) .. " scored a total of " .. tostring(total3) .. " points.")
        self.room:send(tostring(player4.name) .. " scored a total of " .. tostring(total4) .. " points.")
        player1 = nil
        player2 = nil
        player3 = nil
        player4 = nil
        status = nil
    else
        local status = 1
        globals.status = globals.status or true
    end
else
    _return_value = false
end
return _return_value