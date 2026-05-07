-- Trigger: Nukreth Spire path1 captive greet
-- Zone: 462, ID: 35
-- Type: MOB, Flags: GREET_ALL
--
-- Original DG Script: #46235

-- Converted from DG Script #46235: Nukreth Spire path1 captive greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.zone_id == 462 and actor.local_id == 25 and globals.task ~= "done" then
    globals.task = "done"
    wait(2)
    self.room:send(tostring(self.name) .. " rushes to her husband.")
    self.room:send("Choking back tears she says, 'I can't believe it!'")
    wait(1)
    self:say("How can I ever thank you?")
    self.room:send("She wraps her arms around her husband in a tight embrace.")
    wait(1)
    self:say("Now, who's leading us out of this hellhole?")
    return true
elseif actor.is_player then
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
        actor:send(tostring(self.name) .. " says, 'Help me kill this thing!'")
    elseif kill == 2 then
        actor:send(tostring(self.name) .. " says, 'Help me kill these things!'")
    elseif job == 1 then
        actor:send(tostring(self.name) .. " says, 'Wait, I can't leave yet!'")
        -- (empty room echo)
        actor:send(tostring(self.name) .. " says, 'Please, help me find my husband.'")
    elseif follow == 1 then
        actor:send(tostring(self.name) .. " says, 'Say 'follow me' and I'll follow you out!'")
    end
end