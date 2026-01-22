-- Trigger: Nukreth Spire path2 3 4 captive greet
-- Zone: 462, ID: 5
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #46205

-- Converted from DG Script #46205: Nukreth Spire path2 3 4 captive greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("nukreth_spire") then
    if not actor:get_quest_var("nukreth_spire:pathnumber") then
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
    if self.id == 46220 then
        self:say("Help me kill this thing!")
    elseif self.id == 46221 then
        self:say("Save me from this monster!!")
    elseif self.id == 46222 then
        self:say("WE TAKE REVENGE!!!")
    elseif self.id == 46223 then
        self:say("Get this beast off me!!")
    end
elseif kill == 2 then
    if self.id == 46220 then
        self:say("Help me kill these things!")
    elseif self.id == 46221 then
        self:say("Save me from these monsters!!")
    elseif self.id == 46222 then
        self:say("WE TAKE REVENGE!!!")
    elseif self.id == 46223 then
        self:say("Get these beasts off me!!")
    end
elseif job == 1 then
    self:say("Wait, I can't leave yet!")
    -- (empty room echo)
    if self.id == 46220 then
        self:say("Please, help me find my husband.")
    elseif self.id == 46221 then
        self:say("Please, help me save my baby!")
    elseif self.id == 46222 then
        self:say("Bring me my axe!")
    elseif self.id == 46223 then
        self:say("Help me find my treasure!")
    end
elseif follow == 1 then
    self:say("Say 'follow me' and I'll follow you out!")
end