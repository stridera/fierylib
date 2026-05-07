-- Trigger: Ill-subclass: Grand Master responds to 'hi'
-- Zone: 172, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player greets the Grand Master. If they're a fresh sorcerer in the
-- right level band he pitches the quest. If they're already mid-quest
-- (any class) he reminds them about the 'help' keyword.
--
-- Original DG Script: #17215

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "hi")
    or string.find(speech_lower, "hello")
    or string.find(speech_lower, "howdy")) then
    return true  -- keyword not heard
end

local stage = actor:get_quest_stage("illusionist_subclass")

if string.find(actor.class, "Sorcerer") and stage == 0 then
    wait(1)
    if actor.level >= 10 and actor.level <= 45 then
        actor:send(tostring(self.name) .. " says, 'Well, hello there.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Do you have time to do me the very tiniest of favors?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Nope, too unrefined, next!'")
    else
        actor:send(tostring(self.name) .. " says, 'Nope, too small, next!'")
    end
    return true
end

if stage > 0 and not actor:get_has_completed("illusionist_subclass") then
    actor:send(tostring(self.name) .. " says, 'Quest going well, I hope?'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Just say <b:cyan>'help'</> if you get stuck.'")
end