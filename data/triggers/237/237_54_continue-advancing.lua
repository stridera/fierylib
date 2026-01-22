-- Trigger: continue-advancing
-- Zone: 237, ID: 54
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23754

-- Converted from DG Script #23754: continue-advancing
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
-- OK, this is in two parts.  It represents the player wishing to
-- continue the quest rather than stopping and accepting
-- a lesser prize.  The first one is after returning the
-- drow master's heart (the dude from Anduin) and the second
-- is after returning the drider king's head (who's in
-- this area).  It follows trigger 23752 parts 1 and 2.
wait(2)
if actor.id == -1 then
    if actor:get_quest_stage("vilekka_stew") == 4 then
        actor.name:advance_quest("vilekka_stew")
        actor:send("<b:white>You have advanced the quest!</>")
        self:emote("looks pleased.")
        self.room:send("The High Priestess begins chanting to her goddess.")
        wait(2)
        self:emote("continues to chant...")
        wait(4)
        self:emote("looks like she just swallowed something very unpleasant.")
        self:say("Disgusting.")
    elseif actor:get_quest_stage("vilekka_stew") == 2 then
        actor.name:advance_quest("vilekka_stew")
        actor:send("<b:white>You have advanced the quest!</>")
        self:say("Yes, the driders....")
        self:command("shudder")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Driders are ancient enemies of all true drow.  A drider is a half-drow, half-spider abomination.  When a young drow fails the coming of age test that the Spider Queen requires, it is turned into a drider as punishment and exiled from our race.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'I say \"it\", but all drow who have ever failed the test have been male.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Males are weak and inferior.  So they often become driders.'")
        wait(3)
        self:command("sigh")
        self:say("They have lately been harassing Dheduu.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Bring me the head of their king!  That should discourage them.'")
        self:command("cackle")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'You may ask about your <b:white>[progress]</> if you need.'")
        wait(2)
        self:emote("waves you away.  'Go on.'")
    end
end