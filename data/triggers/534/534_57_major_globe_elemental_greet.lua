-- Trigger: major_globe_elemental_greet
-- Zone: 534, ID: 57
-- Type: MOB, Flags: GLOBAL, GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #53457

-- Converted from DG Script #53457: major_globe_elemental_greet
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
-- switch on self.id
-- plant elemental
if self.id == 2328 then
    local load_ward = 53453
    local wand = actor:get_quest_stage("acid_wand")
    -- Mist elemental
elseif self.id == 2806 or self.id == 2807 then
    local load_ward = 53454
    local wand = actor:get_quest_stage("air_wand")
    -- Water elemental
elseif self.id == 2808 or self.id == 2809 or self.id == 48631 then
    local load_ward = 53455
    -- flame elemental
elseif self.id == 5212 or self.id == 12523 or self.id == 48500 or self.id == 48511 or self.id == 48512 then
    local load_ward = 53456
    local wand = actor:get_quest_stage("fire_wand")
    -- ice elemental
elseif self.id == 53312 or self.id == 53313 or self.id == 48630 or self.id == 48632 then
    local load_ward = 53457
    local wand = actor:get_quest_stage("ice_wand")
end
-- If random is 1
if actor:get_quest_stage("major_globe_spell") == 8 or wand == 8 then
    local now = time.stamp
    -- If there was a previous time stamp, check against it
    if last_enter then
        -- If 2 minutes have passed, roll for chance to load again
        if now - last_enter >= 2 then
            local do_load = random(1, 4)
        end
        -- If first time entering, roll for chance to load
    else
        local do_load = random(1, 4)
    end
    -- If rolled 1, load
    if do_load == 1 then
        if load_ward then
            -- load_ward values: 53453, 53454, 53455, 53456, 53457 => zone 534, local ids 53-57
            local load_ward_zone = 534
            local load_ward_local = load_ward % 100
            self.room:spawn_object(load_ward_zone, load_ward_local)
            if actor:get_quest_stage("major_globe_spell") == 8 then
                actor.name:set_quest_var("major_globe_spell", "ward_%load_ward%", 1)
            end
            wait(1)
            actor:send("<blue>" .. tostring(self.name) .. " flares briefly as you approach.</>")
            self.room:send_except(actor, "<blue>" .. tostring(self.name) .. " flares briefly as " .. tostring(actor.name) .. " approaches.</>")
        end
        -- If didn't roll 1, save time stamp so questor must wait 2 minutes
    else
        -- Save time stamp
        local last_enter = now
        globals.last_enter = globals.last_enter or true
    end
end