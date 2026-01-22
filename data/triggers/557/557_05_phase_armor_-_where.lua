-- Trigger: Phase Armor - Where
-- Zone: 557, ID: 5
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55705

-- Converted from DG Script #55705: Phase Armor - Where
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
local anti = "Anti-Paladin"
local max_phase = 3
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return _return_value
elseif not (string.find(classes, "actor.class")) or (classes == "anti" and actor.class == "Paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
    end
    return _return_value
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
    return _return_value
elseif actor:get_quest_stage("phase_armor") < phase - 1 then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return _return_value
end
local low_level = (phase - 1) * 20 + 1
local high_level = phase * 20
wait(2)
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level " .. tostring(low_level) .. " to " .. tostring(high_level) .. ", so the items I desire can be found in areas of that difficulty.'")
if phase < max_phase then
    actor:send(tostring(self.name) .. " tells you, 'Once you have agreed to take on my quests you can seek another like me for tasks a bit more difficult.'")
end