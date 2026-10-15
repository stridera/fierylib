-- Library: dg
-- Description: DG-script helpers for converted triggers: legacy vnum to (zone, id) keys, DG truthiness, wand/mace quest items.
--
-- Usage from a trigger:
--   local dg = require("dg")
--   local name = dg.oname(55577)              -- name of legacy object 55577
--   if dg.is_obj(object, wandgem) then ... end -- the received object is that vnum
--   if dg.flag(actor:get_quest_var("air_wand:wandtask1")) then ... end
--   dg.give(self, self:spawn_object(2, 101), actor)   -- hand a spawned item to the player
--
-- Legacy vnums were zone * 100 + id, but the importer keys every entity by the zone FILE it came
-- from (id = vnum - zone * 100), and some files hold more than 100 entries: zone 2 holds object
-- vnums 200-399 (the phase wands and maces, 301 = (2, 101)), zone 4 holds 400-599, zone 117 holds
-- 11700-11840, and so on. Splitting such a vnum as zone = vnum / 100 lands in the wrong zone. The
-- tables below list the files that run past 99 entries (the range is the span of the file's
-- vnums); any other vnum splits the old way. Zone 0 is stored as zone 1000.
-- Kinds are separate because a zone's mob file can be shorter or longer than its object file.

local M = {}

-- {first vnum, last vnum, zone}
local OBJ = {
    {200, 399, 2}, {400, 599, 4}, {2300, 2408, 23}, {3000, 3306, 30}, {11700, 11812, 117},
    {12000, 12158, 120}, {12300, 12499, 123}, {30000, 30128, 300}, {32400, 32573, 324},
    {48100, 48252, 481}, {48400, 48503, 484}, {50000, 50106, 500}, {53400, 53506, 534},
    {58000, 58299, 580},
}
local MOB = {
    {3000, 3499, 30}, {7300, 7475, 73}, {11700, 11813, 117}, {48100, 48251, 481},
    {48400, 48636, 484}, {53400, 53508, 534}, {58000, 58150, 580},
}
local ROOM = {
    {2300, 2786, 23}, {2800, 2910, 28}, {3000, 3499, 30}, {3500, 3601, 35}, {4100, 4238, 41},
    {4500, 4685, 45}, {7300, 7457, 73}, {8000, 8227, 80}, {8300, 8423, 83}, {11700, 11840, 117},
    {12000, 12220, 120}, {12300, 12482, 123}, {12700, 12850, 127}, {30000, 30123, 300},
    {32400, 32589, 324}, {35000, 35199, 350}, {39000, 39189, 390}, {41100, 41243, 411},
    {43000, 43252, 430}, {47000, 47128, 470}, {47200, 47404, 472}, {48100, 48256, 481},
    {48400, 48612, 484}, {49000, 49190, 490}, {53000, 53219, 530}, {53400, 53578, 534},
    {58000, 58215, 580}, {58400, 58543, 584}, {58800, 58918, 588},
}

local function split(ranges, vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    vnum = math.floor(vnum)
    for _, r in ipairs(ranges) do
        if vnum >= r[1] and vnum <= r[2] then
            return r[3], vnum - r[3] * 100
        end
    end
    local zone = vnum // 100
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end

-- Legacy object vnum -> zone, id.
function M.obj(vnum) return split(OBJ, vnum) end
-- Legacy mob vnum -> zone, id.
function M.mob(vnum) return split(MOB, vnum) end
-- Legacy room vnum -> zone, id.
function M.room(vnum) return split(ROOM, vnum) end

-- (zone, id) -> legacy vnum (the same for objects, mobs and rooms).
function M.to_vnum(zone, id)
    if zone == 1000 then return id end
    return zone * 100 + id
end

local function named(proto, kind, vnum, zone, id)
    local name = zone and proto.template(zone, id).name
    if not name or name == "" then
        return "[no description for " .. kind .. " " .. tostring(vnum) .. "]"
    end
    return name
end

-- Name of the legacy object / mob / room vnum (DG %get.obj_shortdesc[N]% and friends).
function M.oname(vnum)
    local zone, id = M.obj(vnum)
    return named(objects, "object", vnum, zone, id)
end
function M.mname(vnum)
    local zone, id = M.mob(vnum)
    return named(mobiles, "mobile", vnum, zone, id)
end
function M.rname(vnum)
    local zone, id = M.room(vnum)
    local room = zone and get_room(zone, id)
    return room and room.name or ""
end

-- True when `obj` (a handle or template with zone_id / id) is the legacy object `vnum`.
function M.is_obj(obj, vnum)
    if type(vnum) ~= "number" or not obj then return false end
    local zone, id = M.obj(vnum)
    return obj.zone_id == zone and obj.id == id
end

-- DG truthiness of a quest variable: unset, "", and 0 are false (0 is truthy in Lua).
function M.flag(v)
    return v ~= nil and v ~= 0 and v ~= "" and v ~= false
end

-- True when the received `obj` is no longer there: an earlier RECEIVE trigger on the same mob
-- (002_108, 002_126, ...) took it, and a handle to a despawned item reads as nothing.
function M.gone(obj)
    return obj == nil or obj.name == nil or obj.name == ""
end

-- True when `obj` is one of the items a wand or mace crafter exports through `globals`:
-- wandgem, wandtask3, wandtask4, wand_id (002_111) and maceitem2..6, mace_id (002_118). The DG
-- refuse triggers let those through to the receive trigger and turned everything else away.
local KEYS = {
    "wandgem", "wandtask3", "wandtask4", "wand_id",
    "maceitem2", "maceitem3", "maceitem4", "maceitem5", "maceitem6", "mace_id",
}
function M.quest_item(obj, g)
    if not obj or not g then return false end
    for _, key in ipairs(KEYS) do
        if M.is_obj(obj, g[key]) then return true end
    end
    return false
end

-- Hand `item` (the handle spawn_object returned, or a received `object`) from the mob `giver` to
-- the player `to`. The give command takes a single word for the item (more words need "to") and
-- has no "give all", so the item goes by its first keyword; the newest matching item leaves first.
function M.give(giver, item, to)
    if not giver or not item or not to then return end
    giver:command("give " .. item.alias .. " " .. to.name)
end

return M
