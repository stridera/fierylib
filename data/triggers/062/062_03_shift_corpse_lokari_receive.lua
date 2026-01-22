-- Trigger: shift_corpse_lokari_receive
-- Zone: 62, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #6203

-- Converted from DG Script #6203: shift_corpse_lokari_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 6228 and actor:get_quest_stage("shift_corpse") == 1 then
    _return_value = false
    actor.name:advance_quest("shift_corpse")
    self.room:send(tostring(objects.template(62, 28).name) .. " flares with <blue>&9darkness visible!</>")
    wait(1)
    self.room:send("<blue>&9" .. tostring(self.name) .. "</> <red>ROARS</> <blue>&9with divine fury!</>")
    self:say("You will never destroy me!!")
    combat.engage(self, actor.name)
end
return _return_value