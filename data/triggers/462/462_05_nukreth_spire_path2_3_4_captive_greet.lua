-- Trigger: Nukreth Spire path2 3 4 captive greet
-- Zone: 462, ID: 5
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #46205

-- Converted from DG Script #46205: Nukreth Spire path2 3 4 captive greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local kill, job, follow
local task = globals.task
local in_breaker_room = self.room.zone_id == 462 and self.room.local_id == 78
local in_tracker_rooms = self.room.zone_id == 462
    and (self.room.local_id == 65 or self.room.local_id == 20 or self.room.local_id == 5)
if actor:get_quest_stage("nukreth_spire") then
    if not actor:get_quest_var("nukreth_spire:pathnumber") then
        if in_breaker_room then
            -- the spiritbreaker is still alive
            if world.count_mobiles(462, 24) > 0 then
                kill = 1
            else
                -- the spiritbreaker is not alive, but they need to find something first
                if not task then
                    job = 1
                else
                    -- the spiritbreaker is not alive, and they have found the thing they need
                    follow = 1
                end
            end
        elseif in_tracker_rooms then
            if world.count_mobiles(462, 1) > 0 then
                -- the gnoll trackers are alive
                kill = 2
            else
                if not task then
                    -- the trackers are dead, but they need to find something first
                    job = 1
                else
                    -- the trackers are dead, and they have found the thing they need
                    follow = 1
                end
            end
        end
    end
end
if kill == 1 then
    if self.local_id == 20 then
        self:say("Help me kill this thing!")
    elseif self.local_id == 21 then
        self:say("Save me from this monster!!")
    elseif self.local_id == 22 then
        self:say("WE TAKE REVENGE!!!")
    elseif self.local_id == 23 then
        self:say("Get this beast off me!!")
    end
elseif kill == 2 then
    if self.local_id == 20 then
        self:say("Help me kill these things!")
    elseif self.local_id == 21 then
        self:say("Save me from these monsters!!")
    elseif self.local_id == 22 then
        self:say("WE TAKE REVENGE!!!")
    elseif self.local_id == 23 then
        self:say("Get these beasts off me!!")
    end
elseif job == 1 then
    self:say("Wait, I can't leave yet!")
    -- (empty room echo)
    if self.local_id == 20 then
        self:say("Please, help me find my husband.")
    elseif self.local_id == 21 then
        self:say("Please, help me save my baby!")
    elseif self.local_id == 22 then
        self:say("Bring me my axe!")
    elseif self.local_id == 23 then
        self:say("Help me find my treasure!")
    end
elseif follow == 1 then
    self:say("Say 'follow me' and I'll follow you out!")
end