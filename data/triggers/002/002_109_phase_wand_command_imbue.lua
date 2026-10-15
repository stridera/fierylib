-- Trigger: phase wand command imbue
-- Zone: 2, ID: 109
-- Type: OBJECT, Flags: COMMAND
--
-- The `imbue` command on the phase wands and staves that need it (legacy vnums 303/313/323/333,
-- 306/316/326/336 and 308/318/328/338 = objects 2:103, 2:106, 2:108 and their +10/+20/+30
-- siblings). Run by the wielder or carrier (command location mask 3: worn or carried).
--
--  * wand 303/313/323/333 (stage 5): in the element's area (rooms 55001-55003 / 5200-5299 /
--    39001-39189 / 7300-7457), and once a crafter has put the player on the step (greet == 1),
--    the wand is imbued: wandtask4.
--  * staff 306/316/326/336 (stage 8): at the element's place, once the weapon is bonded
--    (wandtask1) and primed by the crafter (wandtask5) and the player carries the elemental
--    ward, the ward is consumed and the staff becomes the next staff (+1), advancing the quest.
--  * staff 308/318/328/338 (stage 10): in the plane room, once primed (wandtask4), the quest is
--    completed and the staff becomes the final one (+1).
-- Rooms are compared by their legacy number (zone * 100 + id) the way the DG script did.
-- The result is the next staff in the player's pack, a level-band experience award (x10, five
-- times, scaled by class), and the old staff gone.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end
local dg = require("dg")

-- `imbue`, abbreviated to at least "imb" (the DG script let "i" and "im" through).
local typed = string.lower(cmd or "")
if #typed < 3 or string.sub("imbue", 1, #typed) ~= typed then
    return true
end

local vnum = dg.to_vnum(self.zone_id, self.id)

local element, area, place, ward_vnum, ward_name, crafter, color
if vnum == 303 then
    element, area = "air", "howling winds"
elseif vnum == 313 then
    element, area = "fire", "sweltering tunnels"
elseif vnum == 323 then
    element, area = "ice", "vast ocean"
elseif vnum == 333 then
    element, area = "acid", "murky swamp"
elseif vnum == 306 then
    element, place, ward_vnum, ward_name, crafter = "air", 49007, 53454, "ward-mist", 8515
elseif vnum == 316 then
    element, place, ward_vnum, ward_name, crafter = "fire", 5272, 53456, "ward-flames", 48250
elseif vnum == 326 then
    element, place, ward_vnum, ward_name, crafter = "ice", 55105, 53457, "ward-ice", 10300
elseif vnum == 336 then
    element, place, ward_vnum, ward_name, crafter = "acid", 16355, 53453, "ward-plants", 48029
elseif vnum == 308 then
    element, place, color = "air", 48862, "<b:yellow>"
elseif vnum == 318 then
    element, place, color = "fire", 47800, "<b:red>"
elseif vnum == 328 then
    element, place, color = "ice", 47708, "<b:cyan>"
elseif vnum == 338 then
    element, place, color = "acid", 47672, "<b:green>"
else
    return true
end

local is_staff = (vnum == 306 or vnum == 308 or vnum == 316 or vnum == 318
    or vnum == 326 or vnum == 328 or vnum == 336 or vnum == 338)
local weapon = is_staff and "staff" or "wand"
local quest = element .. "_wand"
local room = actor.room
local here = room and dg.to_vnum(room.zone_id, room.id)

local imbued, reward
if place and here == place then
    if not dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
        local remaining = ((actor:get_quest_stage(quest) - 1) * 50) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
        actor:send("You need to attack " .. tostring(remaining) .. " more times to fully bond with your " .. weapon .. "!")
        return false
    end
    if ward_vnum then
        if not dg.flag(actor:get_quest_var(quest .. ":wandtask5")) then
            actor:send("<b:blue>" .. tostring(self.shortdesc) .. " must be primed by " .. dg.mname(crafter) .. " before you can imbue it!</>")
            return false
        end
        local ward_zone, ward_id = dg.obj(ward_vnum)
        if not actor:has_item(ward_zone, ward_id) then
            actor:send("You don't have " .. dg.oname(ward_vnum) .. " with you!")
            return false
        end
        actor:send("You raise " .. tostring(self.shortdesc) .. " and " .. dg.oname(ward_vnum) .. " above your head.")
        wait(1)
        actor:send("The energies of this place start to flow through you!")
        wait(3)
        actor:destroy_item(ward_name)
        actor:send(dg.oname(ward_vnum) .. " floats into the air and unravels into wispy tendrils of elemental energy!")
        wait(2)
        actor:send("The energies wrap around " .. tostring(self.shortdesc) .. ".")
        wait(3)
        actor:send(tostring(self.shortdesc) .. " is transformed!")
        reward = true
        actor:advance_quest(quest)
        actor:set_quest_var(quest, "greet", 0)
        actor:set_quest_var(quest, "attack_counter", 0)
        for number = 1, 5 do
            actor:set_quest_var(quest, "wandtask" .. number, 0)
        end
    else
        if not dg.flag(actor:get_quest_var(quest .. ":wandtask4")) then
            return true  -- not primed yet: DG let the command fall through
        end
        actor:send("You close your eyes and hold " .. tostring(self.shortdesc) .. " before you.")
        wait(2)
        actor:send("You feel the wheel of the cosmos rotating around you here in this place.")
        wait(3)
        actor:send("You begin to draw from the vast elemental energies of the plane...")
        wait(3)
        actor:send("Drawing all the raw primordial power you can muster, you suffuse the very essence of the realm into your staff!")
        actor:send(color .. "You have perfected your staff!</>")
        actor:complete_quest(quest)
        reward = true
    end
elseif area then
    -- The wands: only in the element's area, and only for a player a crafter has put on the step.
    local ranges = {
        [303] = {55001, 55003}, [313] = {5200, 5299}, [323] = {39001, 39189}, [333] = {7300, 7457},
    }
    local r = ranges[vnum]
    if here and here >= r[1] and here <= r[2] and (actor:get_quest_var(quest .. ":greet") or 0) == 1 then
        imbued = true
    else
        return true
    end
else
    return true
end

if imbued then
    actor:send("You imbue your wand with the energy of the " .. area .. "!")
    actor:set_quest_var(quest, "wandtask4", 1)
elseif reward then
    local next_zone, next_id = dg.obj(vnum + 1)
    actor:spawn_object(next_zone, next_id)

    -- Experience: a level-band curve on the staff's level, scaled by class so every class
    -- receives the same proportion of a level.
    local expcap = self.level
    local expmod = 0
    if expcap < 9 then
        expmod = math.floor(((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    local class = actor.class
    if class == "warrior" or class == "berserker" then
        expmod = expmod + math.floor(expmod / 10)
    elseif class == "paladin" or class == "anti-paladin" or class == "ranger" then
        expmod = expmod + math.floor((expmod * 2) / 15)
    elseif class == "sorcerer" or class == "pyromancer" or class == "cryomancer" or class == "illusionist" or class == "bard" then
        expmod = expmod + math.floor(expmod / 5)
    elseif class == "necromancer" or class == "monk" then
        expmod = expmod + math.floor((expmod * 2) / 5)
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 5 do
        actor:award_exp(setexp)
    end
    world.destroy(self)
end
return false
