-- Trigger: wizard_eye_seer_speech
-- Zone: 550, ID: 35
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55035

-- Converted from DG Script #55035: wizard_eye_seer_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("wizard_eye") == 3 then
    actor.name:advance_quest("wizard_eye")
    actor:send(tostring(self.name) .. " says, 'As I suspected.'")
    self:command("peer " .. tostring(actor))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'So you want to learn Wizard Eye do you?  No simple feat, that.'")
    wait(4)
    self:emote("tents her fingers and paces back and forth.")
    actor:send(tostring(self.name) .. " says, 'Now, what is best for you, hmmmm?'")
    wait(4)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Perhaps an infusion of poppies?'")
    wait(4)
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Nah.  Overkill.'")
    wait(4)
    self:command("point " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'Perhaps basilisk oil?'")
    wait(2)
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'No, extinct.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Wait, I see it!'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'A sachet of oracular herbs!  Yes!  For prophetic dreams!'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I can make it for you too, if you bring me the materials.")
    actor:send("I need the following:")
    actor:send("- <magenta>" .. tostring(objects.template(480, 5).name) .. "</>")
    actor:send("- <green>Thyme</>")
    actor:send("- <b:green>Bay</>")
    actor:send("</>")
    actor:send("<b:yellow>Bring these back to me</> and I'll get you on your way.  I'll send a note to the Master Shaman in the meantime.'")
end