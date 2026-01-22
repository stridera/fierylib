-- Trigger: Ill-subclass: Grand Master responds to 'hi'
-- Zone: 172, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17215

-- Converted from DG Script #17215: Ill-subclass: Grand Master responds to 'hi'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hi hello howdy
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "howdy")) then
    return true  -- No matching keywords
end
-- switch on actor:get_quest_stage("illusionist_subclass")
if string.find(actor.class, "Sorcerer") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 45
    -- msend %actor% &1Your race may not subclass to illusionist.&0
    -- endif
    -- break
    wait(1)
    if actor.level >= 10 and actor.level <= 45 then
        actor:send(tostring(self.name) .. " says, 'Well, hello there.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Do you have time to do me the very tiniest of favors?'")
    elseif actor.level >= 10 then
        actor:send(tostring(self.name) .. " says, 'Nope, too small, next!'")
    else
        actor:send(tostring(self.name) .. " says, 'Nope, too unrefined, next!'")
    end
end
actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?'")
wait(3)
actor:send(tostring(self.name) .. " says, 'Just say <b:cyan>'help'</> if you get stuck.'")