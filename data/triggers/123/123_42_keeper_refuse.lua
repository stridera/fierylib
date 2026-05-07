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

if self.id == 12303 then
    direction = "north"
    part = 4
    need = 55020
elseif self.id == 12304 then
    direction = "south"
    part = 2
    need = 48109
elseif self.id == 12305 then
    direction = "east"
    part = 1
    need = 8301
elseif self.id == 12306 then
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
    wait(2)
    self:say("I'm sorry, I'm quite busy right now.")
elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and actor:get_quest_var("megalith_quest:item" .. tostring(part)) == 1) then
    self:command("shake")
    self:say("I don't need any additional assistance at the moment, thank you.")
    if self.id == 12306 then
        self:command("curtsy " .. tostring(actor.name))
    else
        self:command("bow " .. tostring(actor.name))
    end
elseif actor:get_quest_stage("megalith_quest") == 2 then
    if direction and (actor:get_quest_var("megalith_quest:" .. direction) == 0) and (not actor:get_quest_var("megalith_quest:item" .. tostring(part))) then
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
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            if self.id == 12306 then
                self:say("Unfortunately, I need " .. need_name() .. " filled with water, not this.")
            else
                self:say("Unfortunately, I need " .. need_name() .. ", not this.")
            end
        end
    end
end
return _return_value
