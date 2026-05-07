-- Trigger: Major Globe Lirne receive 3
-- Zone: 534, ID: 67
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53467

-- Converted from DG Script #53467: Major Globe Lirne receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 8 then
    wait(1)
    -- TODO(parity): original DG looked up "major_globe_spell:ward_<vnum>"
    -- via `%get.quest_var(major_globe_spell, ward_%object.vnum%)%`. With
    -- composite ids, key the var by the local object id within zone 534
    -- (wards are objects 53-57 in zone 534 — see trigger 53457).
    local number = object.local_id
    local ward = actor:get_quest_var("major_globe_spell:ward_" .. tostring(number))
    self:destroy_item("majorglobe-ward")
    if ward == 0 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'How could you have gotten this?  Do the quest yourself!'")
    elseif ward == 1 then
        -- mark this specific ward as turned in (2 = consumed)
        actor:set_quest_var("major_globe_spell", "ward_" .. tostring(number), 2)
        local wards = actor:get_quest_var("major_globe_spell:ward_count") + 1
        actor:set_quest_var("major_globe_spell", "ward_count", wards)
        local wards_left = 5 - wards
        self:command("smile")
        if wards_left > 0 then
            actor:send(tostring(self.name) .. " says, 'Excellent, only " .. tostring(wards_left) .. " more, and we'll be almost ready.'")
        else
            actor:advance_quest("major_globe_spell")
            actor:send(tostring(self.name) .. " says, 'Okay!  That's enough elemental wards to power the spell.  We only need one more item to channel the power...'")
            self:command("think")
            self:emote("quickly studies the spellbook again.")
            -- final_item: pick one of the four legendary items (objects in
            -- zone 534 ids 58-61); store its local id in the quest var.
            local roll = random(1, 4)
            local final_local
            local place
            if roll == 1 then
                final_local = 58
                place = "in a border keep"
            elseif roll == 2 then
                final_local = 59
                place = "on an emerald isle"
            elseif roll == 3 then
                final_local = 60
                place = "within a misty fortress"
            else
                final_local = 61
                place = "in an underground city"
            end
            actor:set_quest_var("major_globe_spell", "final_item", final_local)
            wait(3)
            local final_name = objects.template(534, final_local).name
            actor:send(tostring(self.name) .. " says, 'Yes, the last item for the spell is here.  It is <b:yellow>" .. tostring(final_name) .. "</>.'")
            self:emote("thinks hard for a moment.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'It is rumored that it can be found <b:cyan>" .. tostring(place) .. "</>.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Quickly, go now and retrieve it so that we might defeat the demon!'")
        end
    elseif ward == 2 then
        local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
        self:command("eyebrow")
        if wards_left > 1 then
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different ones!")
        else
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different one!")
        end
    end
elseif stage < 8 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm not quite ready to deal with those yet.  Do the quest in order.'")
elseif stage > 8 then
    wait(1)
    self:destroy_item("majorglobe-ward")
    actor:send(tostring(self.name) .. " says, 'You already gave me all the elemental wards!'")
end
return true