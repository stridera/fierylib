-- Trigger: group_heal_new_rite
-- Zone: 185, ID: 25
-- Type: MOB, Flags: SPEECH
--
-- If the player has lost their copy of the rite, the doctor reissues
-- it. Triggered by the phrase "I lost the Rite" while at stage 5 or 6
-- of the group_heal quest.
--
-- TODO(parity): legacy DG marked this prob 0%, suggesting manual fire.
-- Treating it as a real speech keyword match instead. Confirm whether
-- the manual-fire path is required somewhere.

local s = string.lower(speech)
if not (string.find(s, "i lost the rite") or
        (string.find(s, "lost") and string.find(s, "rite"))) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("group_heal")
if stage == 5 or stage == 6 then
    self:say("You need to be more careful!")
    wait(1)
    self:say("Fortunately I made a copy of the original.")
    self.room:spawn_object(185, 14)
    self:command("give rite-heroes-feast " .. tostring(actor.name))
end
