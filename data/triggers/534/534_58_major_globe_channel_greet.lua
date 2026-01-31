-- Trigger: major_globe_channel_greet
-- Zone: 534, ID: 58
-- Type: MOB, Flags: GLOBAL, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #53458

-- Converted from DG Script #53458: major_globe_channel_greet
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
if actor:get_quest_stage("major_globe_spell") == 9 then
    -- switch on self.id
    if self.id == 2322 then
        local load_channel = 53458
    elseif self.id == 58008 then
        local load_channel = 53459
    elseif self.id == 16003 then
        local load_channel = 53460
    elseif self.id == 23711 then
    end
    if load_channel then
        self:destroy_item("majorglobe-channel")
        self.room:spawn_object(534, 61)
        wait(1)
        actor:send("<blue>" .. tostring(self.name) .. "'s eyes flash briefly as you approach.</>")
        self.room:send_except(actor, "<blue>" .. tostring(self.name) .. "'s eyes flash briefly as " .. tostring(actor.name) .. " approaches.</>")
    end
end