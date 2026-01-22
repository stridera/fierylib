-- Trigger: flood_lady_speech
-- Zone: 390, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39002

-- Converted from DG Script #39002: flood_lady_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: flood help? flood? How? Why?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "flood") or string.find(string.lower(speech), "help?") or string.find(string.lower(speech), "flood?") or string.find(string.lower(speech), "how?") or string.find(string.lower(speech), "why?")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("flood")
if stage == 0 then
    if string.find(actor.class, "Cryomancer") and actor.level > 80 then
        actor.name:start_quest("flood")
        self.room:send(tostring(self.name) .. " says, 'The masters of this settlement stole my most")
        self.room:send("</>precious treasures.  I will punish them with a cataclysm of rising tide and")
        self.room:send("</>raging torrents by calling to the great waters of Ethilien to my aid.  You will")
        self.room:send("</>be my envoy to their domains.'")
        wait(3)
        self:say("The great waters are:")
        self.room:send("<b:white>The Blue-Fog River and Lake</>")
        self.room:send("<b:white>Phoenix Feather Hot Springs</>")
        self.room:send("<b:white>Three-Falls River in the canyon</>")
        self.room:send("<b:white>The Greengreen Sea</>")
        self.room:send("<b:white>Sea's Lullaby</>")
        self.room:send("<b:white>Frost Lake</>")
        self.room:send("<b:white>Black Lake</>")
        self.room:send("<b:white>The Dreaming River in the Realm of the King of Dreams</>")
        wait(4)
        self.room:spawn_object(390, 0)
        self:command("give heart-ocean " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'Standing in the waters with this, say:")
        self.room:send("<b:blue>the Arabel Ocean calls for aid</>.'")
        wait(4)
        self:say("They will respond.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Tell them I long for <b:blue>revenge</>.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'You will acquiesce to this request.  In exchange, I")
        self.room:send("</>will teach you to control the raging tides to demolish your enemies.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'If you need, I can update you on your <b:white>[progress]</>.'")
    end
elseif stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Why have you not yet convinced the other great")
    self.room:send("</>waters to assist me??'")
    self:emote("fumes.")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'The waters are ready!  Give me back the heart and")
    self.room:send("</>the ocean will rage!'")
end