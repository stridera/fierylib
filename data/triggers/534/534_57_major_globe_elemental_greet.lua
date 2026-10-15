-- Trigger: major_globe_elemental_greet
-- Zone: 534, ID: 57
-- Type: MOB, Flags: GLOBAL, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #53457

-- Converted from DG Script #53457: major_globe_elemental_greet
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
--
-- When a questor with major_globe_spell stage 8 (or the relevant elemental
-- wand quest) approaches an elemental of the matching type, there's a 1-in-4
-- chance to spawn an elemental ward. After a non-load roll, lock out further
-- rolls for 2 minutes via globals.last_enter.

-- TODO(parity): mob ids below were legacy 5-digit vnums in the original DG
-- (e.g. 2328 = vnum 2328 plant elemental). Confirm they map to the same
-- composite (zone_id, local_id) values once mob proto migration finishes;
-- self.id alone may be ambiguous across zones.
local load_ward
local wand
if (self.zone_id == 23 and self.id == 28) then
    -- plant elemental
    load_ward = 53
    wand = actor:get_quest_stage("acid_wand")
elseif (self.zone_id == 28 and self.id == 6) or (self.zone_id == 28 and self.id == 7) then
    -- mist elemental
    load_ward = 54
    wand = actor:get_quest_stage("air_wand")
elseif (self.zone_id == 28 and self.id == 8) or (self.zone_id == 28 and self.id == 9) or (self.zone_id == 484 and self.id == 231) then
    -- water elemental
    load_ward = 55
elseif (self.zone_id == 52 and self.id == 12) or (self.zone_id == 125 and self.id == 23) or (self.zone_id == 484 and self.id == 100) or (self.zone_id == 484 and self.id == 111) or (self.zone_id == 484 and self.id == 112) then
    -- flame elemental
    load_ward = 56
    wand = actor:get_quest_stage("fire_wand")
elseif (self.zone_id == 533 and self.id == 12) or (self.zone_id == 533 and self.id == 13) or (self.zone_id == 484 and self.id == 230) or (self.zone_id == 484 and self.id == 232) then
    -- ice elemental
    load_ward = 57
    wand = actor:get_quest_stage("ice_wand")
end
if actor:get_quest_stage("major_globe_spell") == 8 or wand == 8 then
    local now = timestamp()
    -- Roll only if first encounter or 2+ game hours since last non-load roll.
    local do_load = 0
    if globals.last_enter then
        if now - globals.last_enter >= 2 then
            do_load = random(1, 4)
        end
    else
        do_load = random(1, 4)
    end
    if do_load == 1 then
        if load_ward then
            self.room:spawn_object(534, load_ward)
            if actor:get_quest_stage("major_globe_spell") == 8 then
                actor:set_quest_var("major_globe_spell", "ward_" .. tostring(load_ward), 1)
            end
            wait(0.1)
            actor:send("<blue>" .. tostring(self.name) .. " flares briefly as you approach.</>")
            self.room:send_except(actor, "<blue>" .. tostring(self.name) .. " flares briefly as " .. tostring(actor.name) .. " approaches.</>")
        end
    else
        -- Save time stamp so questor must wait 2 minutes for next roll.
        globals.last_enter = now
    end
end