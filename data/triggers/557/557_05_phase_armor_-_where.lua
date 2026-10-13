-- Trigger: Phase Armor - Where
-- Zone: 557, ID: 5
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55705

-- Converted from DG Script #55705: Phase Armor - Where
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where"}) do
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
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local anti = "Anti-Paladin"
local max_phase = 3
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase - 1 then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
local low_level = (phase - 1) * 20 + 1
local high_level = phase * 20
wait(2)
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level " .. tostring(low_level) .. " to " .. tostring(high_level) .. ", so the items I desire can be found in areas of that difficulty.'")
if phase < max_phase then
    actor:send(tostring(self.name) .. " tells you, 'Once you have agreed to take on my quests you can seek another like me for tasks a bit more difficult.'")
end