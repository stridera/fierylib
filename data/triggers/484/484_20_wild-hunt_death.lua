-- Trigger: wild-hunt death
-- Zone: 484, ID: 20
-- Type: MOB, Flags: GLOBAL, DEATH
-- Status: CLEAN
--
-- Original DG Script: #48420

-- Converted from DG Script #48420: wild-hunt death
-- Original: MOB trigger, flags: GLOBAL, DEATH, probability: 100%
-- The 55214 branch (a normal deer) puts two more deer in random rooms of zone 552 through
-- get_room(552, 11..92) + room:at (legacy `at 55211..55292`).
local _return_value = true  -- Default: allow action
-- If this deer is the white hart, load the spirit of the white
-- hart who runs away from the questor.
-- If this deer is normal, load two more deer.
-- If this deer is the spirit of the white hart, load the antlers.
if (self.zone_id == 552 and self.id == 44) then
    if actor:get_quest_stage("doom_entrance") == 1 then
        _return_value = true
        self.room:send("The spirit of the white hart breaks from the body and scampers off!")
        self.room:spawn_mobile(552, 45)
    end
elseif (self.zone_id == 552 and self.id == 14) then
    if actor:get_quest_stage("doom_entrance") == 1 then
        -- Two more deer, each in a random room of 552:11-92 (legacy rooms 55211-55292).
        for _ = 1, 2 do
            local room = get_room(552, random(11, 92))
            if room then
                room:at(function()
                    self.room:spawn_mobile(552, 14)
                end)
            end
        end
    end
elseif (self.zone_id == 552 and self.id == 45) then
    local i = actor.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    local load_obj
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("doom_entrance") == 1 then
                person:advance_quest("doom_entrance")
                person:send("<b:white>You have advanced the quest!</>")
                load_obj = "yes"
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
    if load_obj == "yes" then
        self.room:spawn_object(484, 29)
    end
end
return _return_value