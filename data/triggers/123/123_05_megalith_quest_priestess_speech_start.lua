-- Trigger: megalith_quest_priestess_speech_start
-- Zone: 123, ID: 5
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN (fixed malformed condition on line 73)
--
-- Original DG Script: #12305

-- Converted from DG Script #12305: megalith_quest_priestess_speech_start
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: yes yes?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?")) then
    return true  -- No matching keywords
end
-- This trigger serves as both the starting, restarting, and advancing from stage 3 to stage 4 trigger
-- If starting for the first time
-- 
if actor:get_quest_stage("megalith_quest") < 1 then
    actor.name:start_quest("megalith_quest")
    wait(2)
    self:say("May the Goddess smile upon you!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'First, I'll need your help replacing the <b:cyan>implements</> destroyed in the maze getting here.'")
    -- 
    -- If restarting
    -- 
elseif actor:get_has_failed("megalith_quest") then
    actor.name:restart_quest("megalith_quest")
    self.room:send("</>")
    self:command("smile")
    self:say("Then let us give it another go!")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'Some of our <b:cyan>implements</> were destroyed in our previous attempt.'")
end
-- 
-- List tools for stage 1
-- 
if actor:get_quest_stage("megalith_quest") == 1 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'We need the following:")
    self.room:send("- <b:white>Salt</>.")
    -- (empty room echo)
    self.room:send("- A <b:cyan>goblet or chalice</> to hold water.")
    self.room:send("</>    My home island in the Green Green Sea has several goblets, though do be")
    self.room:send("</>    careful which one you pick.  Some of them tend to be poisoned.")
    -- (empty room echo)
    self.room:send("</>    I understand there is a beautiful chalice recently lost from the Abbey of")
    self.room:send("</>    St. George that might work as well.")
    -- (empty room echo)
    self.room:send("- Some kind of <yellow>censer</> to burn incense in.")
    self.room:send("</>    There are a few other more nefarious religions which use incense burners in")
    self.room:send("</>    their rituals.  You may be able to steal one from them.")
    -- (empty room echo)
    self.room:send("- A <b:red>candle</>.")
    self.room:send("</>    Candles are common to light the dark in the far north, and in some")
    self.room:send("</>    underground communities.'")
    wait(6)
    self:say("Bring these to me to begin the Great Rite!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you want to know more about what my Sisters and I are doing, you can ask any of us <b:cyan>who are you?</>'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you need a reminder of your <b:cyan>[progress]</>, you may ask me at any time.'")
    self:command("bow " .. tostring(actor.name))
    -- 
    -- If ready to continue stage 4
    -- 
elseif (actor:get_quest_stage("megalith_quest") == 4) and (self.room == 12389) and (actor:get_quest_var("megalith_quest:reliquary") == 1) then
    wait(2)
    self:say("The Great Rite of Invocation has a great deal of call and response.  I will chant a line and you must repeat it to continue the ritual.  The coven will chant their response after you do.")
    wait(4)
    self:say("Repeat after me.")
    wait(2)
    self:emote("raises her arms to the sky.")
    self.room:send(tostring(self.name) .. " chants, '<b:cyan>Great Lady of the Stars, hear our prayer!</>'")
    actor.name:set_quest_var("megalith_quest", "prayer", 1)
end