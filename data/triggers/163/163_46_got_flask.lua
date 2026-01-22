-- Trigger: got_flask
-- Zone: 163, ID: 46
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #16346

-- Converted from DG Script #16346: got_flask
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 4 then
    if got_flask == 1 then
        self.room:send("Eleweiss' Flask grows dark as its power fades.")
        _return_value = false
    else
        actor.name:advance_quest("moonwell_spell_quest")
    end
    local got_flask = 1
    globals.got_flask = globals.got_flask or true
end
return _return_value