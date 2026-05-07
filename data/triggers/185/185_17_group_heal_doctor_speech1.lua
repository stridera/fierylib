-- Trigger: group_heal_doctor_speech1
-- Zone: 185, ID: 17
-- Type: MOB, Flags: SPEECH
--
-- Doctor explains group healing when asked about it. If the listener is
-- a sufficiently high-level Cleric/Priest/Diabolist with no active
-- group_heal quest, pitches the quest to them. The 1% probability is
-- legacy DG flavor (rare unsolicited explanation).

if not percent_chance(1) then
    return true
end

local s = string.lower(speech)
if not (string.find(s, "healing") or string.find(s, "group") or string.find(s, "assist")) then
    return true
end
wait(2)
self:command("nod")
self.room:send(tostring(self.name) .. " says, 'I specialize in group healing.  It's a powerful spell")
self.room:send("</>involving complex prayers.  Not easy to learn.'")
if ((string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But you look like a very capable healer!  Perhaps you can")
    self.room:send("</>help me out.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I've heard there once was a way to create a portable")
    self.room:send("</>version of the spell.  I've been trying to figure it out, but most of my time")
    self.room:send("</>is spent tending to the abbey's injured.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Raiders from Split Skull and bandits from the Gothra Desert")
    self.room:send("</>have made it very difficult to get anything done around here!'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'If you can help me work on it, I can teach you the proper")
    self.room:send("</>prayers in exchange.'")
    wait(3)
    self:say("What do you say, are you interested in working with me?")
end