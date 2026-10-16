-- Trigger: Monk Vision command read
-- Zone: 53, ID: 42
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5342

-- Rewritten from DG Script #5342: Monk Vision command read
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%
--
-- Each of the nine Sight items is bound to one place (a room), a quest
-- stage, a gem the monk must carry and the previous Sight, which must be
-- worn. Reading the item in its place, at its stage, takes four rounds of
-- reading; leaving or fighting breaks the focus.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2
-- (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: read
if not (cmd == "read") then
    return true  -- Not our command
end

local dg = require("dg")

-- This item (zone, id) -> place (legacy room number), quest stage, the
-- gem (zone, id) carried, the previous Sight (zone, id) worn.
local VISIONS = {
    ["590:6"]   = { 4328,  1, 555, 82, 2, 190 },
    ["185:5"]   = { 58707, 2, 555, 91, 2, 191 },
    ["85:1"]    = { 18597, 3, 556, 23, 2, 192 },
    ["125:32"]  = { 58102, 4, 556, 55, 2, 193 },
    ["162:9"]   = { 16057, 5, 556, 65, 2, 194 },
    ["430:13"]  = { 59054, 6, 556, 78, 2, 195 },
    ["530:9"]   = { 49079, 7, 557, 10, 2, 196 },
    ["584:15"]  = { 11820, 8, 557, 22, 2, 197 },
    ["584:12"]  = { 52075, 9, 557, 41, 2, 198 },
}

local vision = VISIONS[self.zone_id .. ":" .. self.id]
if not vision then
    return true  -- Not one of the Sight items
end
local place_zone, place_id = dg.room(vision[1])
local stage = vision[2]
local hasgem = actor:has_item(vision[3], vision[4])
local hasvision = actor:has_equipped(vision[5], vision[6])

-- True while the reader stands in this Sight's place.
local function in_place()
    local room = actor.room
    return room.zone_id == place_zone and room.local_id == place_id
end

-- Everything the monk reads here is magenta.
local function tell(msg)
    actor:send("<magenta>" .. msg .. "</>")
end

local visionstage = actor:get_quest_stage("monk_vision")
if not (in_place() and visionstage == stage and hasvision and hasgem) then
    return true  -- Not ready: the command carries on to the normal handler
end

if dg.flag(actor:get_quest_var("monk_vision:visiontask4")) then
    tell("You have already expanded your mind to its "
         .. "current limits.")
    return false
end

if actor.is_fighting then
    tell("You cannot properly focus while fighting!")
    return false
end

tell("You begin to read " .. tostring(self.shortdesc) .. "...")
wait(4)
if actor.is_fighting then
    tell("You cannot properly focus while fighting!")
    return false
end
if not in_place() then
    tell("You must be in the proper place to keep reading!")
    return false
end

for _ = 1, 3 do
    tell("You continue to read...")
    wait(4)
    if actor.is_fighting then
        tell("You cannot properly focus while fighting!")
        return false
    end
    if not in_place() then
        tell("You must be in the proper place to keep reading!")
        return false
    end
end

actor:send("<b:magenta>You feel your awareness broadening!</>")
actor:set_quest_var("monk_vision", "visiontask4", 1)
return false
