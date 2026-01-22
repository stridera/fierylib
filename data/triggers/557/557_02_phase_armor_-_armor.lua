-- Trigger: Phase Armor - Armor
-- Zone: 557, ID: 2
-- Type: MOB, Flags: SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55702

-- Converted from DG Script #55702: Phase Armor - Armor
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
-- If you add more types of armor, you need to add their
-- keywords in the argument field for this trigger.
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
if hands_name and hands_name ~= speech then
    local name = "pair of " .. hands_name
    local gem_vnum = hands_gem
    local armor_vnum = hands_armor
elseif feet_name and feet_name ~= speech then
    local name = "pair of " .. feet_name
    local gem_vnum = feet_gem
    local armor_vnum = feet_armor
elseif wrist_name and wrist_name ~= speech then
    local name = wrist_name
    local gem_vnum = wrist_gem
    local armor_vnum = wrist_armor
elseif head_name and head_name ~= speech then
    local name = head_name
    local gem_vnum = head_gem
    local armor_vnum = head_armor
elseif arms_name and arms_name ~= speech then
    local name = "pair of " .. arms_name
    local gem_vnum = arms_gem
    local armor_vnum = arms_armor
elseif legs_name and legs_name ~= speech then
    local name = "pair of " .. legs_name
    local gem_vnum = legs_gem
    local armor_vnum = legs_armor
elseif body_name and body_name ~= speech then
    local name = body_name
    local gem_vnum = body_gem
    local armor_vnum = body_armor
end
if name then
    actor:send(tostring(self.name) .. " tells you, 'Well, I can make a fine " .. tostring(name) .. " for you, but")
    actor:send("</>I'll need <b:cyan>" .. "%get.obj_shortdesc[%armor_vnum%]%</> and <b:cyan>three %get.obj_pldesc[%gem_vnum%]%</>.")
    actor:send("</>Bring these things to me in any order, at any time, and I will reward you.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'You will find them on creatures across the world.")
    if phase == 1 then
        actor:send("</>Creatures <b:cyan>up to level 20</> will drop them.'")
    elseif phase == 2 then
        actor:send("</>Creatures <b:cyan>level 20 to 40</> will drop them.'")
    elseif phase == 3 then
        actor:send("</>Creatures <b:cyan>level 40 to 70</> will drop them.'")
    end
else
    actor:send(tostring(self.name) .. " peers at you oddly.")
    self.room:send_except(actor, tostring(self.name) .. " peers at " .. tostring(actor.name) .. " oddly.")
    actor:send(tostring(self.name) .. " tells you, 'I don't think I can make that for you.'")
end