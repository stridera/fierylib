-- Trigger: degeneration_cat_speech1
-- Zone: 55, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5519

-- Converted from DG Script #5519: degeneration_cat_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes arts?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "arts?")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Necromancer") and actor.level > 80 and actor:get_quest_stage("degeneration") == 0 then
    self.room:send(tostring(self.name) .. " says, 'I've been working for many years on a new spell to suffuse")
    self.room:send("</>beings with the energy of the dead.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'There are seven dark wizards whose work I believe will help")
    self.room:send("</>me complete the spell.  Each one carries a focus I need you to bring back so I")
    self.room:send("</>can better understand their spellcraft techniques.'")
    wait(6)
    self:say("I'll start you off with the weakest of the targets.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'On the Emerald Isle is a man named Yajiro.  Although his")
    self.room:send("</>magic is underdeveloped, he has somehow managed to summon an impressive demon")
    self.room:send("</>and imprison a goddess.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Bring me his book so I may glean what information I can")
    self.room:send("</>about his techniques.'")
    actor.name:start_quest("degeneration")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'If you need, I can remind you of your <b:white>[spell progress]</>.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Say <b:white>[faction status]</> if you wish to speak with the Third")
    self.room:send("</>Black Legion Quartermaster over there.'")
elseif actor:get_quest_stage("degeneration") > 0 then
    self:say("Give it to me then!")
end