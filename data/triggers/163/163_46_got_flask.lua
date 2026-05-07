-- Trigger: got_flask
-- Zone: 163, ID: 46
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #16346
--
-- Pickup hook for Eleweiss' Flask: advance moonwell_spell_quest stage 4 -> 5
-- on first pickup. Subsequent pickups just dim the flask (return false).
--
-- TODO(parity): The legacy DG script set %got_flask% only in the elseif
-- branch (i.e. when actor was NOT on stage 4), which means a second pickup
-- by a stage-4 druid would still advance them. Logic preserved verbatim.

if actor:get_quest_stage("moonwell_spell_quest") == 4 then
    if globals.got_flask == 1 then
        self.room:send("Eleweiss' Flask grows dark as its power fades.")
        return false
    else
        actor:advance_quest("moonwell_spell_quest")
    end
else
    globals.got_flask = 1
end
return true
