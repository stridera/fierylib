-- Trigger: Keeper refuse
-- Zone: 123, ID: 42
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #12342

-- Converted from DG Script #12342: Keeper refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
if self.id == 12303 then
    local direction = "north"
    local part = 4
    local need = 55020
elseif self.id == 12304 then
    local direction = "south"
    local part = 2
    local need = 48109
elseif self.id == 12305 then
    local direction = "east"
    local part = 1
    local need = 8301
elseif self.id == 12306 then
    local direction = "west"
    local part = 3
    local need = actor:get_quest_var("megalith_quest:goblet")
end
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
else
    if actor:get_quest_stage("megalith_quest") < 2 then
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("I'm sorry, I'm quite busy right now.")
    elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and actor.quest_variable[megalith_quest:itempart] == 1) then
        _return_value = false
        self:command("shake")
        self:say("I don't need any additional assistance at the moment, thank you.")
        if self.id == 12306 then
            self:command("curtsy " .. tostring(actor.name))
        else
            self:command("bow " .. tostring(actor.name))
        end
    elseif actor:get_quest_stage("megalith_quest") == 2 then
        if (actor.quest_variable[megalith_quest:direction] == 0) and (not actor.quest_variable[megalith_quest:itempart]) then
            _return_value = false
            if self.id == 12303 then
                self:command("eye " .. tostring(actor.name))
                self:say("I haven't yet told you what I need.")
            elseif self.id == 12304 then
                self:command("sigh")
                self:say("You have yet to receive instructions.  A little patience, please!")
            elseif self.id == 12305 then
                self:emote("yelps in surprise.")
                self:say("Did Umberto tell you what I need already?!")
            elseif self.id == 12306 then
                self:emote("looks confused.")
                self:say("I have yet to tell you what I need.")
            end
        else
            if (self.id == 12303 and object.id == 55020) or (self.id == 12304 and object.id == 48109) or (self.id == 12305 and object.id == 8301) or (self.id == 12306 and ((object.id == 41110) or (object.id == 41111) or (object.id == 18512))) then
                return _return_value
            else
                _return_value = false
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(2)
                if self.id == 12306 then
                    self:say("Unfortunately, I need " .. "%get.obj_shortdesc[%need%]% filled with water, not this.")
                else
                    self:say("Unfortunately, I need " .. "%get.obj_shortdesc[%need%]%, not this.")
                end
            end
        end
    end
end
return _return_value