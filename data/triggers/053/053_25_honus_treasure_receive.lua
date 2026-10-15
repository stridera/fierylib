-- Trigger: Honus treasure receive
-- Zone: 53, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): `accept`/`refuse` are declared `local` inside elseif
-- arms but used at lines 90/95 outside the loop — they read nil. The
-- inner refuse-decision tree references `accept` before it's set
-- (line 60). Group iteration `local a` is branch-scoped. `==
-- "stage"` is a string compare. Legacy 5-digit ids. Full rewrite from
-- DG #5325.
--
-- Original DG Script: #5325

-- Converted from DG Script #5325: Honus treasure receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
local stage
if (object.zone_id == 615 and object.id == 14) then
    -- singing chain
    stage = 1
elseif (object.zone_id == 43 and object.id == 19) then
    -- fire ring
    stage = 2
elseif (object.zone_id == 161 and object.id == 3) then
    -- sandstone ring
    stage = 3
elseif (object.zone_id == 502 and object.id == 15) then
    -- electrum hoop
    stage = 4
elseif (object.zone_id == 481 and object.id == 1) then
    -- rainbow shell
    stage = 5
elseif (object.zone_id == 160 and object.id == 9) then
    -- stormshield
    stage = 6
elseif (object.zone_id == 550 and object.id == 8) then
    -- snow leopard cloak
    stage = 7
elseif (object.zone_id == 490 and object.id == 41) then
    -- rope ladder
    stage = 8
elseif (object.zone_id == 584 and object.id == 1) then
    -- phoenix feather
    stage = 9
elseif (object.zone_id == 534 and object.id == 100) or (object.zone_id == 534 and object.id == 101) or (object.zone_id == 534 and object.id == 105) or (object.zone_id == 534 and object.id == 106) then
    -- sleet armor
    stage = 10
end
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" then
            if person:get_quest_var("treasure_hunter:hunt") == "found" then
                person:set_quest_var("treasure_hunter", "hunt", "returned")
                local accept = 1
                local refuse = 0
            elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
                if accept then
                    local refuse = 0
                else
                    local refuse = 1
                end
            elseif actor:get_quest_var("treasure_hunter:hunt") == "returned" then
                if accept then
                    local refuse = 0
                else
                    local refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") > stage then
                if accept then
                    local refuse = 0
                else
                    local refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") < stage then
                if accept then
                    local refuse = 0
                else
                    local refuse = 3
                end
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if accept == 1 then
    wait(0.2)
    world.destroy(object)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Excellent!  Now just give me the order paperwork and I can pay you.'")
elseif refuse then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    if refuse == 1 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Nah nah nah, you gotta put in at least a little effort toward finding this yourself, come on.'")
    elseif refuse == 2 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    elseif refuse == 3 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'I'm not looking for that...  Yet.'")
    end
end
return _return_value