-- Trigger: Phase Armor - Start
-- Zone: 557, ID: 1
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55701

-- Converted from DG Script #55701: Phase Armor - Start
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "quests", "quest", "hello", "hi"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_name = self:getvar("feet_name")
local head_name = self:getvar("head_name")
local hands_name = self:getvar("hands_name")
local arms_name = self:getvar("arms_name")
local legs_name = self:getvar("legs_name")
local body_name = self:getvar("body_name")
local wrist_name = self:getvar("wrist_name")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
wait(2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return _return_value
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return _return_value
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return _return_value
elseif actor:get_quest_stage("phase_armor") < phase - 1 then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return _return_value
end
if actor:get_quest_stage("phase_armor") == 0 then
    actor:start_quest("phase_armor")
elseif actor:get_quest_stage("phase_armor") == phase - 1 then
    actor:advance_quest("phase_armor")
end
actor:send(tostring(self.name) .. " tells you, 'Excellent.  I can make " .. tostring(hands_name) .. ", " .. tostring(feet_name) .. ",")
actor:send("</>a " .. tostring(wrist_name) .. ", a " .. tostring(head_name) .. ", " .. tostring(arms_name) .. ", " .. tostring(legs_name) .. ", or a " .. tostring(body_name) .. ".'")
wait(2)
actor:send(tostring(self.name) .. " tells you, 'If you want to know about how to quest for")
actor:send("</>one, ask me about it and I will tell you the components you need to get for me")
actor:send("</>in order to receive your reward.'")
wait(2)
actor:send(tostring(self.name) .. " tells you, 'Remember, you can ask me <b:cyan>armor progress</> at any")
actor:send("</>time and I'll tell you what you have given me so far.'")
wait(2)
if not actor:has_item(2, 99) and not actor:has_equipped(2, 99) then
    actor:send("You can also track the progress of all your quests in this journal.")
    self.room:spawn_object(2, 99)
    self:command("give quest-journal " .. tostring(actor.name))
    wait(2)
    actor:send("<b:cyan>[Look]</> at the journal for instructions on how to use it.")
end