-- Trigger: wild-hunt death
-- Zone: 484, ID: 20
-- Type: MOB, Flags: GLOBAL, DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48420

-- Converted from DG Script #48420: wild-hunt death
-- Original: MOB trigger, flags: GLOBAL, DEATH, probability: 100%
local _return_value = true  -- Default: allow action
-- If this deer is the white hart, load the spirit of the white
-- hart who runs away from the questor.
-- If this deer is normal, load two more deer.
-- If this deer is the spirit of the white hart, load the antlers.
-- self.id is now local_id; these mobs are in zone 552
if self.id == 44 then  -- was 55244
    if actor:get_quest_stage("doom_entrance") == 1 then
        _return_value = false
        self.room:send("The spirit of the white hart breaks from the body and scampers off!")
        self.room:spawn_mobile(552, 45)
    end
elseif self.id == 14 then  -- was 55214
    if actor:get_quest_stage("doom_entrance") == 1 then
        -- room was 55211-55292, which is zone 552, locals 11-92
        local room_local = 10 + random(1, 82)
        get_room(552, room_local):at(function()
            self.room:spawn_mobile(552, 14)
        end)
        room_local = 10 + random(1, 82)
        get_room(552, room_local):at(function()
            self.room:spawn_mobile(552, 14)
        end)
    end
elseif self.id == 45 then  -- was 55245
    local i = actor.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("doom_entrance") == 1 then
                person.name:advance_quest("doom_entrance")
                person:send("<b:white>You have advanced the quest!</>")
                local load = "yes"
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    if load == "yes" then
        self.room:spawn_object(484, 29)
    end
end
return _return_value