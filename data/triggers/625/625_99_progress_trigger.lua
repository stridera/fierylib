-- Trigger: Progress trigger
-- Zone: 625, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #62599

-- Converted from DG Script #62599: Progress trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("ursa_quest")
local path = actor:get_quest_var("ursa_quest:choice")
wait(2)
-- for debug, say stage %stage% path %path%
if actor:get_has_completed("ursa_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have brought me the remedy, and I thank you")
    self.room:send("</>for that.'")
    wait(1)
    if path==1 then
        self:say("I hope the Redeeming Staff was a good reward.")
    elseif path==2 then
        self:say("I hope the glass bear was a good reward.")
    elseif path==3 then
        self:say("I hope the misty blue sword was a good reward.")
    end
    return _return_value
end
if stage == 0 then
    self:say("Will you help me?!  Please!")
elseif stage == 1 then
    if path == 0 then
        self.room:send(tostring(self.name) .. " says, 'Please visit one of these powerful people, and")
        self.room:send("</>ask for a cure:'")
        self.room:send("The Emperor, on a nearby island of very refined people")
        self.room:send("Ruin Wormheart in the Red City")
        self.room:send("The crazy hermit of the swamps")
    end
    -- Stage 2 checks
elseif stage == 2 then
    if path == 1 then
        self:say("Please bring me some pepper.")
    elseif path == 2 then
        self.room:send(tostring(self.name) .. " says, 'You need to return to me a particular sceptre")
        self.room:send("</>of gold that symbolized a king's undying leadership.'")
    elseif path == 3 then
        self.room:send(tostring(self.name) .. " says, 'A devourer has a ring with power to heal.")
        self.room:send("</>Please bring me this ring.'")
    end
    -- stage 3 checks
elseif stage == 3 then
    if path == 1 then
        self.room:send(tostring(self.name) .. " says, 'Please bring me a plant, found as \"a bit of")
        self.room:send("</>bones and plants\" from Blue-Fog Trail.'")
    elseif path == 2 then
        self.room:send(tostring(self.name) .. " says, 'Please bring me an emblem of a king's power.")
        self.room:send("</>An emblem of the sun.  The one written of in legends of the warring gods in the")
        self.room:send("</>far north.'")
    elseif path == 3 then
        self.room:send(tostring(self.name) .. " says, 'Find the Golhen DrubStatt the hermit wrote")
        self.room:send("</>about from the Highlands, and bring it back to me quickly.'")
    end
    -- stage 4 checks
elseif stage == 4 then
    if path == 1 then
        self.room:send(tostring(self.name) .. " says, 'I need a particular thorny wood.  Because of")
        self.room:send("</>it's unpleasant nature there are some unpleasant people that make staffs and")
        self.room:send("</>walking sticks out of it.  Please find one, and bring it back here.'")
    elseif path == 2 then
        self.room:send(tostring(self.name) .. " says, 'Please bring be the dagger that radiates")
        self.room:send("</>glorious light.  The priests of South Caelia know its fierce beauty.'")
    elseif path == 3 then
        self:say("Bring me milk, in any container.")
    end
    -- stage 5 checks
elseif stage == 5 then
    if path == 1 then
        self.room:send(tostring(self.name) .. " says, 'Bring me a pitcher from the hot springs or the")
        self.room:send("</>Dancing Dolphin Inn.  Either will do.'")
    elseif path == 2 then
        self.room:send(tostring(self.name) .. " says, 'I can't do this sober!  Fetch me something to")
        self.room:send("</>drink, and make it strong!'")
    elseif path == 3 then
        self.room:send(tostring(self.name) .. " says, 'Off of the great road is a lumber mill.  Their")
        self.room:send("</>smith has an anvil that will do our work perfectly.  Please fetch it for me.'")
    end
    -- stage 6 checks
elseif stage == 6 then
    if path == 2 then
        self.room:send(tostring(self.name) .. " says, 'I need a large container for a sarcophagus,")
        self.room:send("</>like a body-bag or a large chest.'")
    end
end