-- Trigger: wall_ice_crystalize_speech
-- Zone: 533, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #53310
--
-- "crystalize" cast on an ice creature: roll random(1,100); if it's
-- <= the mob's level, mark the creature for crystalization (its death
-- trigger 533/11 spawns a block of living ice). Player must hold the
-- spell notes (object 533/26) and have the wall_ice quest at stage 1.
--
-- Special-case: if cast on the sculptor mob (id 53316) at quest
-- stage 2 with the notes, complete the quest and grant Wall of Ice.
--
-- TODO: Original DG had probability 1% which doesn't match the speech
-- match semantics; left as percent_chance(1) here but the original
-- author may have intended this to fire on every keyword match.
-- TODO: 'globals.ice' / per-mob 'ice' flag is the only mechanism the
-- death trigger 533/11 has to know whether crystalize succeeded. Verify
-- self.flags or a per-mob persistent var works under the Rust runtime.

-- 1% chance to trigger (preserved from DG)
if not percent_chance(1) then
    return true
end

-- Speech keywords: crystalize
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "crystalize") then
    return true  -- No matching keywords
end

if actor:get_quest_stage("wall_ice") == 1 and actor:has_item(533, 26) and self.id ~= 53316 then
    if self.flags and self.flags.ice_crystalize_attempted then
        actor:send("<cyan>You have already cast this spell on " .. tostring(self.name) .. "!</>")
    else
        local roll = random(1, 100)
        local drop = tonumber(actor:get_quest_var("wall_ice:drop")) or 0
        if drop < 21 then
            if roll <= self.level then
                self.room:send("<cyan>A dark glow surrounds <b:cyan>" .. tostring(self.name) .. "</><cyan> briefly!</>")
                self.flags = self.flags or {}
                self.flags.ice_crystalize_attempted = true
                self.flags.ice_crystalize_success = true
                actor:set_quest_var("wall_ice", "drop", drop + 1)
            else
                self.room:send("<cyan>The spell seems to have no effect!</>")
                self.flags = self.flags or {}
                self.flags.ice_crystalize_attempted = true
            end
        end
    end
elseif self.id == 53316 and actor:get_quest_stage("wall_ice") == 2 and actor:has_item(533, 26) then
    self.room:send("<b:cyan>The blocks of living ice slowly fuse together!</>")
    wait(1)
    self:say("Well done!")
    self:command("nod " .. tostring(actor.name))
    wait(1)
    self:say("All in a good day's work!")
    wait(1)
    self:say("Keep the notes.  It should be everything you need to cast Wall of Ice yourself.")
    actor:send("<b:cyan>You have learned Wall of Ice!</>")
    actor:complete_quest("wall_ice")
    skills.set_level(actor, "wall of ice", 100)
end
