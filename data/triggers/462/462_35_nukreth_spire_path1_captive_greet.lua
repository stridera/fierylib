-- Trigger: Nukreth Spire path1 captive greet
-- Zone: 462, ID: 35
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #46235

-- Converted from DG Script #46235: Nukreth Spire path1 captive greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == 46225 and task ~= "done" then
    local task = "done"
    globals.task = globals.task or true
    wait(2)
    self.room:send(tostring(self.name) .. " rushes to her husband.")
    self.room:send("Choking back tears she says, 'I can't believe it!'")
    wait(1)
    self:say("How can I ever thank you?")
    self.room:send("She wraps her arms around her husband in a tight embrace.")
    wait(1)
    self:say("Now, who's leading us out of this hellhole?")
    return _return_value
elseif actor.id == -1 then
    if actor:get_quest_stage("nukreth_spire") then
        if not actor.quest_variable[nukreth_spire:pathnumber] then
            if self.room == 46278 then
                -- the spiritbreaker is still alive
                if world.count_mobiles("46224") > 0 then
                    local kill = 1
                else
                    -- the spiritbreaker is not alive, but they need to find something first
                    if not task then
                        local job = 1
                    else
                        -- the spiritbreaker is not alive, and they have found the thing they need
                        local follow = 1
                    end
                end
            elseif self.room == 46265 or self.room == 46220 or self.room == 46205 then
                if world.count_mobiles("46201") > 0 then
                    -- the gnoll trackers are alive
                    local kill = 2
                else
                    if not task then
                        -- the trackers are dead, but they need to find something first
                        local job = 1
                    else
                        -- the trackers are dead, and they have found the thing they need
                        local follow = 1
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