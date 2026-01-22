-- Trigger: Phase Armor - Status
-- Zone: 557, ID: 4
-- Type: MOB, Flags: SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 28 if statements
--   Large script: 6280 chars
--
-- Original DG Script: #55704

-- Converted from DG Script #55704: Phase Armor - Status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
wait(2)
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return _return_value
elseif not (string.find(classes, "actor.class")) or (classes == "anti" and actor.class == "Paladin") then
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
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return _return_value
end
local got_hands = actor:get_quest_var("phase_armor:" .. hands_armor .. "_armor_acquired")
local got_feet = actor:get_quest_var("phase_armor:" .. feet_armor .. "_armor_acquired")
local got_wrist = actor:get_quest_var("phase_armor:" .. wrist_armor .. "_armor_acquired")
local got_head = actor:get_quest_var("phase_armor:" .. head_armor .. "_armor_acquired")
local got_arms = actor:get_quest_var("phase_armor:" .. arms_armor .. "_armor_acquired")
local got_legs = actor:get_quest_var("phase_armor:" .. legs_armor .. "_armor_acquired")
local got_body = actor:get_quest_var("phase_armor:" .. body_armor .. "_armor_acquired")
local hands_count = actor:get_quest_var("phase_armor:" .. hands_gem .. "_gems_acquired")
local feet_count = actor:get_quest_var("phase_armor:" .. feet_gem .. "_gems_acquired")
local wrist_count = actor:get_quest_var("phase_armor:" .. wrist_gem .. "_gems_acquired")
local head_count = actor:get_quest_var("phase_armor:" .. head_gem .. "_gems_acquired")
local arms_count = actor:get_quest_var("phase_armor:" .. arms_gem .. "_gems_acquired")
local legs_count = actor:get_quest_var("phase_armor:" .. legs_gem .. "_gems_acquired")
local body_count = actor:get_quest_var("phase_armor:" .. body_gem .. "_gems_acquired")
local done_hands = got_hands == 1  and  hands_count == 3
local done_feet = got_feet == 1  and  feet_count == 3
local done_wrist = got_wrist == 1  and  wrist_count == 3
local done_head = got_head == 1  and  head_count == 3
local done_arms = got_arms == 1  and  arms_count == 3
local done_legs = got_legs == 1  and  legs_count == 3
local done_body = got_body == 1  and  body_count == 3
local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
local given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
local unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
local unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
actor:send(tostring(self.name) .. " tells you, 'Look for treasures from creatures:")
if phase == 1 then
    actor:send("<b:cyan>below level 20</>.'_")
elseif phase == 2 then
    actor:send("<b:cyan>level 20 to 40</>.'_")
elseif phase == 3 then
    actor:send("<b:cyan>level 40 to 70</>.'_")
end
if not given then
    actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
    return _return_value
elseif unrewarded then
    actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
end
if got_hands and not done_hands then
    actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
end
if hands_count and not done_hands then
    actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
end
if got_feet and not done_feet then
    actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
end
if feet_count and not done_feet then
    actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
end
if got_wrist and not done_wrist then
    actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
end
if wrist_count and not done_wrist then
    actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
end
if got_head and not done_head then
    actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
end
if head_count and not done_head then
    actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
end
if got_arms and not done_arms then
    actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
end
if arms_count and not done_arms then
    actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
end
if got_legs and not done_legs then
    actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
end
if legs_count and not done_legs then
    actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
end
if got_body and not done_body then
    actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
end
if body_count and not done_body then
    actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
end
if done_hands or done_feet or done_wrist or done_head or done_arms or done_legs or done_body then
    actor:send("_")
    actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
end
if done_hands then
    actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
end
if done_feet then
    actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
end
if done_wrist then
    actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
end
if done_head then
    actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
end
if done_arms then
    actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
end
if done_legs then
    actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
end
if done_body then
    actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
end