-- Trigger: megalith_quest_keeper_receive
-- Zone: 123, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12315

-- Converted from DG Script #12315: megalith_quest_keeper_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55020 48109 8301 41110 41111 18512): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 20) or
    (object.zone_id == 481 and object.id == 9) or
    (object.zone_id == 83 and object.id == 1) or
    (object.zone_id == 411 and object.id == 10) or
    (object.zone_id == 411 and object.id == 11) or
    (object.zone_id == 185 and object.id == 12)
) then
    return true
end

local _return_value = true  -- Default: allow action
-- This trigger is used to collect all the items for stage 2.
--
-- TODO(parity): self.id checks use legacy 5-digit vnums (12303..12306).
-- Once split, swap to self.local_id (3..6 in zone 123). Same for the
-- vessel checks (41110, 41111, 18512) and per-Keeper "need" object IDs
-- (55020, 48109, 8301).

local item = object.id
local me = self.id

-- Hoisted from branch-scoped locals in the converter output.
local direction
local part
local nxt
local need

if (self.zone_id == 123 and self.id == 3) then
    -- North, Earth - Granite Ring from Tech
    direction = "north"
    part = 4
    nxt = 12301
    need = 55020
elseif (self.zone_id == 123 and self.id == 4) then
    -- South, Fire - Fiery Eye from Fiery Island
    direction = "south"
    part = 2
    nxt = 12306
    need = 48109
elseif (self.zone_id == 123 and self.id == 5) then
    -- East, Air - cumulus bracelet from Dargentan
    direction = "east"
    part = 1
    nxt = 12304
    need = 8301
elseif (self.zone_id == 123 and self.id == 6) then
    -- West, Water - water from the hidden spring, or not - BAD STUFF
    -- This Keeper's request is the one to watch out for.
    direction = "west"
    part = 3
    nxt = 12303
    need = actor:get_quest_var("megalith_quest:goblet")
end

if actor:get_quest_stage("megalith_quest") == 2 then
    if (item == need) or ((self.zone_id == 123 and me == 6) and ((object.zone_id == 411 and item == 10) or (object.zone_id == 411 and item == 11) or (object.zone_id == 185 and item == 12))) then
        -- Already given, right item.
        local part_key = "item" .. tostring(part)
        if (actor:get_quest_var("megalith_quest:" .. part_key) or 0) == 1 then
            self:command("shake")
            self:say("You've already given me this.")
            return false  -- legacy return 0: the giver keeps the item
        elseif (actor:get_quest_var("megalith_quest:" .. direction) or 0) == 1 then
            -- Right item, wrong order.
            if part > 1 then
                local check = part - 1
                local check_key = "item" .. tostring(check)
                if (actor:get_quest_var("megalith_quest:" .. check_key) or 0) == 0 then
                    self:command("shake")
                    self.room:send(tostring(self.name) .. " says, 'We must cast the circle in order:")
                    self.room:send("East, South, West, North.")
                    self.room:send("Please deliver your offerings in that order.'")
                    return false  -- legacy return 0: the giver keeps the item
                end
            end
            -- Right set, wrong specific vessel at West.
            if (self.zone_id == 123 and me == 6) and ((item ~= need) or (object.val2 ~= 0)) then
                self:command("shake")
                self:say("I need water returned in the cup " .. tostring(mobiles.template(123, 1).name) .. " has consecrated.")
                return false  -- legacy return 0: the giver keeps the item
            else
                wait(0.2)
                actor:set_quest_var("megalith_quest", direction, 0)
                actor:set_quest_var("megalith_quest", part_key, 1)
                if direction == "north" then
                    self:say("Ah, excellent!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " before the menhir and kneels.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the North")
                    self.room:send("</>Spirits of Earth and Determination")
                elseif direction == "south" then
                    self:say("Marvelous!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " raises " .. tostring(object.shortdesc) .. " above her head.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the South")
                    self.room:send("</>Spirits of Fire and Feeling")
                elseif direction == "east" then
                    self:say("Great!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " shakes out " .. tostring(object.shortdesc) .. " like a blanket.")
                    self.room:send("She watches with delight as it dissolves into wisps of cloudy mist.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the East")
                    self.room:send("</>Spirits of Air and Intellect")
                elseif direction == "west" then
                    if (actor:get_quest_var("megalith_quest:item5") or 0) == 1 then
                        self:say("Ah, delightful!  This water will make a perfect offering.")
                        wait(0.6)
                    else
                        self:say("This will do.")
                        actor:set_quest_var("megalith_quest", "bad2", 1)
                        wait(0.6)
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
                world.destroy(object)
                self.room:send("The menhir begins to hum and glow!")
                wait(3)
                -- Next person.
                if ((actor:get_quest_var("megalith_quest:item1") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
                    self:say("Now, return to " .. tostring(mobiles.template(123, 1).name) .. " at the altar and help her finish the call!")
                else
                    -- TODO(parity): nxt is still a legacy 5-digit vnum.
                    -- Translate to (zone, local_id) for catalog lookup.
                    local nxt_zone = math.floor(nxt / 100)
                    local nxt_id = nxt % 100
                    local nxt_template = mobiles.template(nxt_zone, nxt_id)
                    local nxt_name = nxt_template and nxt_template.name or ("the next Keeper")
                    self:say("Now, proceed to " .. tostring(nxt_name) .. " and continue invoking the elements.")
                end
            end
        end
    end
end
return _return_value
