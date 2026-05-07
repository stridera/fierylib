-- Trigger: Phase Armor - Armor
-- Zone: 557, ID: 2
-- Type: MOB, Flags: SPEECH_TO
--
-- Speech handler: when an eligible adventurer asks the guildmaster
-- about a specific armor slot keyword (gloves/boots/sleeves/...),
-- describe the armor + gem ingredients and the level range. Reads
-- the per-slot globals seeded by the LOAD trigger (ids 10-39).
--
-- Original DG Script: #55702

-- Converted from DG Script #55702: Phase Armor - Armor
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
local anti = "Anti-Paladin"
-- If you add more types of armor, you need to add their
-- keywords in the argument field for this trigger.
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(classes, actor.class) or (classes == anti and actor.class == "Paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
-- TODO(parity): converter inverted the original `==` checks to `~=`
-- across this slot-dispatch cascade. Original DG selected the slot
-- whose `<slot>_name` matched the speech keyword; the lines below
-- preserve the suspicious `~=` form pending legacy verification.
local name, gem_id, armor_id
if hands_name ~= speech then
    name = "pair of " .. tostring(hands_name)
    gem_id = hands_gem
    armor_id = hands_armor
elseif feet_name ~= speech then
    name = "pair of " .. tostring(feet_name)
    gem_id = feet_gem
    armor_id = feet_armor
elseif wrist_name ~= speech then
    name = wrist_name
    gem_id = wrist_gem
    armor_id = wrist_armor
elseif head_name ~= speech then
    name = head_name
    gem_id = head_gem
    armor_id = head_armor
elseif arms_name ~= speech then
    name = "pair of " .. tostring(arms_name)
    gem_id = arms_gem
    armor_id = arms_armor
elseif legs_name ~= speech then
    name = "pair of " .. tostring(legs_name)
    gem_id = legs_gem
    armor_id = legs_armor
elseif body_name ~= speech then
    name = body_name
    gem_id = body_gem
    armor_id = body_armor
end
if name then
    -- TODO(parity): DG `%get.obj_shortdesc[%armor_id%]%` /
    -- `%get.obj_pldesc[%gem_id%]%` left as literal placeholder text.
    -- Replace with `objects.template(zone, id).name` lookups once the
    -- gem/armor ids are split into (zone, local_id) pairs.
    actor:send(tostring(self.name) .. " tells you, 'Well, I can make a fine " .. tostring(name) .. " for you, but")
    actor:send("</>I'll need <b:cyan>" .. "%get.obj_shortdesc[%armor_id%]%</> and <b:cyan>three %get.obj_pldesc[%gem_id%]%</>.")
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