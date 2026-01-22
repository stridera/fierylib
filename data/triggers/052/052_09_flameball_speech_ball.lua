-- Trigger: flameball_speech_ball
-- Zone: 52, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5209

-- Converted from DG Script #5209: flameball_speech_ball
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: ball ball? flameball flameball?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ball") or string.find(string.lower(speech), "ball?") or string.find(string.lower(speech), "flameball") or string.find(string.lower(speech), "flameball?")) then
    return true  -- No matching keywords
end
wait(2)
if actor.id == -1 then
    if actor:get_quest_stage("emmath_flameball") == 1 then
        self:command("sigh")
        self:say("You've already inquired about the ball of flame.")
        wait(2)
        self:command("peer " .. tostring(actor.name))
        self:say("I'm not sure you're prepared for such power.")
    elseif actor:get_quest_stage("emmath_flameball") == 2 then
        self:command("sigh")
        self:say("You've already inquired about the ball of flame.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I told you to bring me the three parts of fire and we")
        self.room:send("</>would see about it.'")
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        self:command("growl")
        self:say("Stop bothering me.  You know what I want already.")
        wait(2)
        self:command("sigh")
        self:say("The renegade flame--bring it to me.")
    else
        actor.name:start_quest("emmath_flameball")
        self:say("You seek this ball of flame, do you?")
        self:command("ponder")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Ah, to hold it in your palm...  You would need to prove")
        self.room:send("</>your worth for such power.'")
        self:emote("looks thoughtful for a moment.")
    end
end