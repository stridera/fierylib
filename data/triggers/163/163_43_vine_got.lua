-- Trigger: vine_got
-- Zone: 163, ID: 43
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #16343
--
-- Pickup hook for the Vine of Mielikki: advance moonwell_spell_quest from
-- stage 1 -> 2 the first time it's picked up.
--
-- TODO(parity): the original DG script reads %got_vine% but never sets it,
-- making the "already picked up" branch dead code. The got_flask sibling
-- (16346) does the same thing but DOES set the flag. Preserved as-is to match
-- legacy behavior; consider promoting to a real per-quest single-pickup guard.

if actor:get_quest_stage("moonwell_spell_quest") == 1 then
    if globals.got_vine == 1 then
        self.room:send("The Vine of Mielikki glows brightly then fades...its holy glow fading.")
        return false
    else
        actor:advance_quest("moonwell_spell_quest")
    end
end
return true
