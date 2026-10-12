-- Trigger: flameball_speech_ball
-- Zone: 52, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5209
--
-- "ball"/"flameball" speech. First-time askers start the emmath_flameball
-- quest; subsequent stages get a stage-appropriate brush-off.

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"ball", "ball?", "flameball", "flameball?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(2)
if actor.is_player then
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
        self:say("I told you to bring me the three parts of fire and we would see about it.")
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        self:command("growl")
        self:say("Stop bothering me.  You know what I want already.")
        wait(2)
        self:command("sigh")
        self:say("The renegade flame--bring it to me.")
    else
        actor:start_quest("emmath_flameball")
        self:say("You seek this ball of flame, do you?")
        self:command("ponder")
        wait(2)
        self:say("Ah, to hold it in your palm...  You would need to prove your worth for such power.")
        self:emote("looks thoughtful for a moment.")
    end
end