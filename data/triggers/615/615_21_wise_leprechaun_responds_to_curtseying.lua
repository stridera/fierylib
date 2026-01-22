-- Trigger: Wise leprechaun responds to curtseying
-- Zone: 615, ID: 21
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61521

-- Converted from DG Script #61521: Wise leprechaun responds to curtseying
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: curtsey
if not (cmd == "curtsey") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "c" or cmd == "cu" or cmd == "cur" then
    _return_value = false
    return _return_value
end
if actor.id == -1 then
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " bows before " .. tostring(self.name) .. ".")
    actor:send("you bow before " .. tostring(self.name) .. ".")
    wait(1)
    if actor.gender == "female" then
        local noun = "lassie"
    elseif actor.gender == "male" then
        local noun = "laddie"
    else
        local noun = "my dear"
    end
    self:say("Well now, " .. tostring(noun) .. ", I don't suppose you have any fruit on ye?")
    wait(2)
    self:say("If you bring me some, I can help you with those awful spiders, oh yes...  Mind you, I'm particular to cherries.")
else
    _return_value = false
end
return _return_value