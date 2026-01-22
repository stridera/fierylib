-- Trigger: megalith_quest_keeper_receive
-- Zone: 123, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 6302 chars
--
-- Original DG Script: #12315

-- Converted from DG Script #12315: megalith_quest_keeper_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- This trigger is used to collect all the items for stage 2
local item = object.id
local me = self.id
-- switch on self.id
-- North, Earth - Granite Ring from Tech
if self.id == 12303 then
    local direction = "north"
    local part = 4
    local next = 12301
    local need = 55020
    -- South, Fire - Fiery Eye from Fiery Island
elseif self.id == 12304 then
    local direction = "south"
    local part = 2
    local next = 12306
    local need = 48109
    -- East, Air - cumulus bracelet from Dargentan
elseif self.id == 12305 then
    local direction = "east"
    local part = 1
    local next = 12304
    local need = 8301
    -- West, Water - water from the hidden spring, or not - BAD STUFF
    -- This Keeper's request is the one to watch out for.
elseif self.id == 12306 then
    local direction = "west"
    local part = 3
    local next = 12303
    local need = actor:get_quest_var("megalith_quest:goblet")
end
if actor:get_quest_stage("megalith_quest") == 2 then
    if (item == "need") or (me == 12306 and (item == 41110 or item == 41111 or item == 18512)) then
        -- Already given, right item
        if actor:get_quest_var("megalith_quest:item" .. tostring(part)) == 1 then
            _return_value = false
            self:command("shake")
            self:say("You've already given me this.")
            return _return_value
        elseif actor:get_quest_var("megalith_quest:" .. tostring(direction)) == 1 then
            -- Right item, wrong order
            if part > 1 then
                local check = part - 1
                if actor:get_quest_var("megalith_quest:item" .. tostring(check)) == 0 then
                    _return_value = false
                    self:command("shake")
                    self.room:send(tostring(self.name) .. " says, 'We must cast the circle in order:")
                    self.room:send("East, South, West, North.")
                    self.room:send("Please deliver your offerings in that order.'")
                    return _return_value
                end
            end
            -- Right set, wrong specific vessel at West
            if (me == 12306) and ((item ~= "need") or (object.val2 ~= 0)) then
                _return_value = false
                self:command("shake")
                self:say("I need water returned in the cup " .. tostring(mobiles.template(123, 1).name) .. " has consecrated.")
                return _return_value
                -- unique part of the incantation
            else
                wait(2)
                actor.name:set_quest_var("megalith_quest", "%direction%", 0)
                actor.name:set_quest_var("megalith_quest", "item%part%", 1)
                if direction == "north" then
                    self:say("Ah, excellent!  This will make a perfect offering.")
                    wait(6)
                    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " before the menhir and kneels.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the North")
                    self.room:send("</>Spirits of Earth and Determination")
                elseif direction == "south" then
                    self:say("Marvelous!  This will make a perfect offering.")
                    wait(6)
                    self.room:send(tostring(self.name) .. " raises " .. tostring(object.shortdesc) .. " above her head.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the South")
                    self.room:send("</>Spirits of Fire and Feeling")
                elseif direction == "east" then
                    self:say("Great!  This will make a perfect offering.")
                    wait(6)
                    self.room:send(tostring(self.name) .. " shakes out " .. tostring(object.shortdesc) .. " like a blanket.")
                    self.room:send("She watches with delight as it dissolves into wisps of cloudy mist.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the East")
                    self.room:send("</>Spirits of Air and Intellect")
                elseif direction == "west" then
                    if actor:get_quest_var("megalith_quest:item5") == 1 then
                        self:say("Ah, delightful!  This water will make a perfect offering.")
                        wait(6)
                    else
                        self:say("This will do.")
                        actor.name:set_quest_var("megalith_quest", "bad2", 1)
                        wait(6)
                    end
                    self.room:send(tostring(self.name) .. " pours the water from " .. tostring(object.shortdesc) .. " before the menhir.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the West")
                    self.room:send("</>Spirits of Water and Intuition")
                end
                self.room:send("</>I present this offering to you.")
                self.room:send("</>Aid us in our magical working on this great day.'")
                wait(5)
                world.destroy(object.name)
                self.room:send("The menhir begins to hum and glow!")
                wait(3)
                -- Next person
                if (actor:get_quest_var("megalith_quest:item1")) and (actor:get_quest_var("megalith_quest:item2")) and (actor:get_quest_var("megalith_quest:item3")) and (actor:get_quest_var("megalith_quest:item4")) then
                    self:say("Now, return to " .. tostring(mobiles.template(123, 1).name) .. " at the altar and help her finish the call!")
                else
                    self:say("Now, proceed to " .. "%get.mob_shortdesc[%next%]% and continue invoking the elements.")
                end
            end
        end
    end
end
return _return_value