-- Trigger: Keeper refuse
-- Zone: 123, ID: 42
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12342

-- Converted from DG Script #12342: Keeper refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
--
-- TODO(parity): self.id checks use legacy 5-digit vnums (12303..12306).
-- After the (zone, local_id) split they should become self.local_id 3..6
-- in zone 123. The `need` IDs (55020, 48109, 8301) are also legacy.
-- TODO(parity): the original DG had a guard `if object.id == %wandgem%
-- or %wandtask3% or %wandtask4% or %wand_id%` that referenced globals
-- from the wand-crafting quest. Those globals are not exposed in the
-- new runtime, so the guard now skips that pass-through. Restore once
-- the wand quest's exported IDs are available, otherwise the Keepers
-- will refuse wand components when they should have ignored them.

-- Hoisted from branch-scoped locals in the converter output.
local direction
local part
local need

if (self.zone_id == 123 and self.id == 3) then
    direction = "north"
    part = 4
    need = 55020
elseif (self.zone_id == 123 and self.id == 4) then
    direction = "south"
    part = 2
    need = 48109
elseif (self.zone_id == 123 and self.id == 5) then
    direction = "east"
    part = 1
    need = 8301
elseif (self.zone_id == 123 and self.id == 6) then
    direction = "west"
    part = 3
    need = actor:get_quest_var("megalith_quest:goblet")
end

local function need_name()
    -- TODO(parity): need is still a legacy 5-digit vnum.
    if not need then return "the offering" end
    local nz = math.floor(need / 100)
    local nid = need % 100
    local tmpl = objects.template(nz, nid)
    return tmpl and tmpl.name or "the offering"
end

if actor:get_quest_stage("megalith_quest") < 2 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("I'm sorry, I'm quite busy right now.")
elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and (actor:get_quest_var("megalith_quest:item" .. tostring(part)) or 0) == 1) then
    self:command("shake")
    self:say("I don't need any additional assistance at the moment, thank you.")
    if (self.zone_id == 123 and self.id == 6) then
        self:command("curtsy " .. tostring(actor.name))
    else
        self:command("bow " .. tostring(actor.name))
    end
elseif actor:get_quest_stage("megalith_quest") == 2 then
    if direction and ((actor:get_quest_var("megalith_quest:" .. direction) or 0) == 0) and (not actor:get_quest_var("megalith_quest:item" .. tostring(part))) then
        if (self.zone_id == 123 and self.id == 3) then
            self:command("eye " .. tostring(actor.name))
            self:say("I haven't yet told you what I need.")
        elseif (self.zone_id == 123 and self.id == 4) then
            self:command("sigh")
            self:say("You have yet to receive instructions.  A little patience, please!")
        elseif (self.zone_id == 123 and self.id == 5) then
            self:emote("yelps in surprise.")
            self:say("Did Umberto tell you what I need already?!")
        elseif (self.zone_id == 123 and self.id == 6) then
            self:emote("looks confused.")
            self:say("I have yet to tell you what I need.")
        end
    else
        if ((self.zone_id == 123 and self.id == 3) and (object.zone_id == 550 and object.id == 20)) or ((self.zone_id == 123 and self.id == 4) and (object.zone_id == 481 and object.id == 9)) or ((self.zone_id == 123 and self.id == 5) and (object.zone_id == 83 and object.id == 1)) or ((self.zone_id == 123 and self.id == 6) and ((object.zone_id == 411 and object.id == 10) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 185 and object.id == 12))) then
            return _return_value
        else
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(0.2)
            if (self.zone_id == 123 and self.id == 6) then
                self:say("Unfortunately, I need " .. need_name() .. " filled with water, not this.")
            else
                self:say("Unfortunately, I need " .. need_name() .. ", not this.")
            end
        end
    end
end
return _return_value
