-- Trigger: vine_got
-- Zone: 163, ID: 43
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #16343

-- Converted from DG Script #16343: vine_got
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 1 then
    if got_vine == 1 then
        self.room:send("The Vine of Mielikki glows brightly then fades...its holy glow fading.")
        _return_value = false
    else
        actor.name:advance_quest("moonwell_spell_quest")
    end
end
return _return_value