-- Trigger: Major Globe Lirne receive 3
-- Zone: 534, ID: 67
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
-- Fixed: Corrected quest_variable syntax, fixed variable scoping, converted %placeholders%
--
-- Original DG Script: #53467

-- Converted from DG Script #53467: Major Globe Lirne receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 8 then
    wait(1)
    local ward_key = "ward_" .. tostring(object.vnum)
    local ward = actor:get_quest_var("major_globe_spell:" .. ward_key) or 0
    self:destroy_item("majorglobe-ward")
    if ward == 0 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'How could you have gotten this?  Do the quest yourself!'")
    elseif ward == 1 then
        actor:set_quest_var("major_globe_spell", ward_key, 2)
        local wards = (actor:get_quest_var("major_globe_spell:ward_count") or 0) + 1
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
            local roll = random(1, 4)
            local final_item
            local place
            -- switch on roll
            if roll == 1 then
                final_item = 53458
                place = "in a border keep"
            elseif roll == 2 then
                final_item = 53459
                place = "on an emerald isle"
            elseif roll == 3 then
                final_item = 53460
                place = "within a misty fortress"
            else
                final_item = 53461
                place = "in an underground city"
            end
            actor:set_quest_var("major_globe_spell", "final_item", final_item)
            wait(3)
            local item_obj = objects.template(vnum_to_zone(final_item), vnum_to_local(final_item))
            actor:send(tostring(self.name) .. " says, 'Yes, the last item for the spell is here.  It is <b:yellow>" .. tostring(item_obj.shortdesc) .. "</>.'")
            self:emote("thinks hard for a moment.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'It is rumored that it can be found <b:cyan>" .. place .. "</>.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Quickly, go now and retrieve it so that we might defeat the demon!'")
        end
    elseif ward == 2 then
        local wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
        self:command("eyebrow")
        if wards_left > 1 then
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different ones!")
        else
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different one!")
        end
    end
elseif stage < 8 then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm not quite ready to deal with those yet.  Do the quest in order.'")
elseif stage > 8 then
    wait(1)
    self:destroy_item("majorglobe-ward")
    actor:send(tostring(self.name) .. " says, 'You already gave me all the elemental wards!'")
end
return _return_value