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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" or _sw1 == "cu" or _sw1 == "cur" then
        _return_value = true
        return _return_value
    end
end
if actor.is_player then
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " bows before " .. tostring(self.name) .. ".")
    actor:send("you bow before " .. tostring(self.name) .. ".")
    wait(1)
    local noun
    if actor.gender == "female" then
        noun = "lassie"
    elseif actor.gender == "male" then
        noun = "laddie"
    else
        noun = "my dear"
    end
    self:say("Well now, " .. tostring(noun) .. ", I don't suppose you have any fruit on ye?")
    wait(2)
    self:say("If you bring me some, I can help you with those awful spiders, oh yes...  Mind you, I'm particular to cherries.")
else
    _return_value = true
end
return _return_value