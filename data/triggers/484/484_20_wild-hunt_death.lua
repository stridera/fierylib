-- Trigger: wild-hunt death
-- Zone: 484, ID: 20
-- Type: MOB, Flags: GLOBAL, DEATH
-- Status: CLEAN
--
-- Original DG Script: #48420

-- Converted from DG Script #48420: wild-hunt death
-- Original: MOB trigger, flags: GLOBAL, DEATH, probability: 100%
-- TODO(parity): self.id checks compare numeric legacy vnums (55244 etc.)
--   against the new (zone_id, local_id) keying — the equality will never
--   match. The 55214 branch also calls `room:at(...)` on a numeric `room`,
--   which will runtime-error. Needs full rewrite once zone 552 is mapped.
local _return_value = true  -- Default: allow action
-- If this deer is the white hart, load the spirit of the white
-- hart who runs away from the questor.
-- If this deer is normal, load two more deer.
-- If this deer is the spirit of the white hart, load the antlers.
if self.id == 55244 then
    if actor:get_quest_stage("doom_entrance") == 1 then
        _return_value = true
        self.room:send("The spirit of the white hart breaks from the body and scampers off!")
        self.room:spawn_mobile(552, 45)
    end
elseif self.id == 55214 then
    if actor:get_quest_stage("doom_entrance") == 1 then
        local room = 55210 + random(1, 82)
        room:at(function()
            self.room:spawn_mobile(552, 14)
        end)
        local room = 55210 + random(1, 82)
        room:at(function()
            self.room:spawn_mobile(552, 14)
        end)
    end
elseif self.id == 55245 then
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