-- Trigger: meteorswarm_dargentan_bow
-- Zone: 482, ID: 62
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48262

-- Converted from DG Script #48262: meteorswarm_dargentan_bow
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "dargentan") or string.find(arg, "dar") or string.find(arg, "huge") or string.find(arg, "large") or string.find(arg, "dragon") or string.find(arg, "sleeping") or string.find(arg, "peaceful") then
    actor:send("You bow before him.")
    self.room:send_except(actor, tostring(actor.name) .. " bows before Dargentan.")
    if actor:get_quest_stage("meteorswarm") == 4 then
        wait(2)
        self:command("glare")
        actor:send(tostring(self.name) .. " says, 'Wherefore hast thou awakened one such as this from deepest slumber?'")
    end
else
    _return_value = false
end
return _return_value