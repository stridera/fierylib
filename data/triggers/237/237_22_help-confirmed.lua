-- Trigger: help-confirmed
-- Zone: 237, ID: 22
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #23722

-- Converted from DG Script #23722: help-confirmed
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: yes yes! ok ok! okay okay! sure sure! help help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes!") or string.find(string.lower(speech), "ok") or string.find(string.lower(speech), "ok!") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "okay!") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "sure!") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
wait(2)
if (actor.id == -1) and (actor.alignment > 349) then
    if actor:get_quest_stage("sunfire_rescue") == 0 then
        -- Responding to the trigger in 23721...rescuing poor elf boy.
        self.room:send("The prisoner smiles.")
        self:say("My name is Serin Sunfire.  I was captured...")
        wait(1)
        self:emote("counts on his fingers, looks a bit puzzled, then shakes his head and continues.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I was captured from my hometown of Templace by the drow.")
        self.room:send("</>Please, tell me.  Is Templace still the land of peace and beauty?'")
    elseif actor:get_quest_stage("sunfire_rescue") == 1 then
        self:emote("smiles brightly at " .. tostring(actor.name) .. " and looks hopeful.")
        self.room:send(tostring(self.name) .. " says, 'Thank you!  Please return to me with the items and I will")
        self.room:send("</>be most grateful.'")
        wait(1)
        self:emote("pauses a moment.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Oh, and do not bother with the cursed items.  I can tell")
        self.room:send("</>the difference.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'If you forget what you need to do, you can ask me for a")
        self.room:send("</><b:white>[progress]</> report.'")
        wait(3)
        self.room:send("The prisoner looks apprehensive.")
        wait(1)
        self:whisper(actor.name, "You should leave here before the guards come!")
        self:emote("relaxes back into a position of pain, though he smiles at you.")
    end
elseif (actor.id == -1) and (actor.alignment <= 349) then
    actor.name:send("The prisoner sighs and turns away from you.")
    self:say("I cannot be helped by one such as you.")
end