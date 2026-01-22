-- Trigger: Major Globe Lirne receive 3
-- Zone: 534, ID: 67
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53467

-- Converted from DG Script #53467: Major Globe Lirne receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 8 then
    wait(1)
    local ward = actor.quest_variable[major_globe_spell:ward_object.vnum]
    local number = object.id
    self:destroy_item("majorglobe-ward")
    if ward == 0 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'How could you have gotten this?  Do the quest yourself!'")
    elseif ward == 1 then
        local ward = actor.quest_variable[major_globe_spell:ward_number] + 1
        actor.name:set_quest_var("major_globe_spell", "ward_%number%", ward)
        ward = nil
        local wards = actor:get_quest_var("major_globe_spell:ward_count") + 1
        actor.name:set_quest_var("major_globe_spell", "ward_count", wards)
        local wards_left = 5 - wards
        self:command("smile")
        if wards_left then
            actor:send(tostring(self.name) .. " says, 'Excellent, only " .. tostring(wards_left) .. " more, and we'll be almost ready.'")
        else
            actor.name:advance_quest("major_globe_spell")
            actor:send(tostring(self.name) .. " says, 'Okay!  That's enough elemental wards to power the spell.  We only need one more item to channel the power...'")
            self:command("think")
            self:emote("quickly studies the spellbook again.")
            local item = random(1, 4)
            -- switch on item
            if item == 1 then
                local item = 53458
                local place = "in a border keep"
            elseif item == 2 then
                local item = 53459
                local place = "on an emerald isle"
            elseif item == 3 then
                local item = 53460
                local place = "within a misty fortress"
            else
                local item = 53461
                local place = "in an underground city"
            end
            actor.name:set_quest_var("major_globe_spell", "final_item", item)
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Yes, the last item for the spell is here.  It is <b:yellow>" .. "%get.obj_shortdesc[%item%]%</>.'")
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