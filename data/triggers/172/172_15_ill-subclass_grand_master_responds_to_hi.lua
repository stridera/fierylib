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

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello", "howdy"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

local stage = actor:get_quest_stage("illusionist_subclass")

if string.find(actor.class, "sorcerer") and stage == 0 then
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