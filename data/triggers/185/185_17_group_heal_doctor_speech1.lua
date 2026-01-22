-- Trigger: group_heal_doctor_speech1
-- Zone: 185, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18517

-- Converted from DG Script #18517: group_heal_doctor_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: healing healing? group assist?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "healing") or string.find(string.lower(speech), "healing?") or string.find(string.lower(speech), "group") or string.find(string.lower(speech), "assist?")) then
    return true  -- No matching keywords
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