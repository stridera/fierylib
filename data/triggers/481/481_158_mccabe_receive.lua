-- Trigger: mccabe_receive
-- Zone: 481, ID: 158
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48258
--
-- TODO(parity): the legacy DG `if earth == 0 then ... elseif stage == 3
-- then ...` chains in the stage-2 and stage-4 branches mix two different
-- discriminants and were converted near-verbatim. The nested `elseif`
-- arms below are unreachable in the current shape and need a structural
-- rewrite once the quest semantics are confirmed against the C++ server.

-- Converted from DG Script #48258: mccabe_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (48252 48251): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 481 and object.id == 152) or
    (object.zone_id == 481 and object.id == 151)
) then
    return true
end

local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("meteorswarm")
local earth = actor:get_quest_var("meteorswarm:earth")
local air = actor:get_quest_var("meteorswarm:air")
if object.zone_id == 481 and object.local_id == 151 then
    self:command("shake")
    actor:send(tostring(self.name) .. " tells you, 'Go <b:cyan>use</> this new treasure; don't give it back to me!'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    self.room:send(tostring(self.name) .. " accepts the meteorite.")
    actor:send(tostring(self.name) .. " tells you, 'Good, this will work.'")
    self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'Go, resume your studies.'")
    actor:set_quest_var("meteorswarm", "new", 0)
    return false  -- legacy return 0: the giver keeps the item
else
    -- switch on stage
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find Jemnon first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 2 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find the rock demon first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 3 then
            if (earth or 0) == 0 then
                actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                actor:send(tostring(self.name) .. " tells you, 'Such wonderfully powerful stone.  This will do perfectly.'")
                actor:send(tostring(self.name) .. " tells you, 'Next, you need to demonstrate mastery over fire.'")
                actor:send(tostring(self.name) .. " tells you, 'The northern cult of fire provides an excellent opportunity to do so.'")
                actor:send(tostring(self.name) .. " tells you, 'Take the meteor, <b:cyan>slay the high priest, and find the secret lava well</>.'")
                actor:send(tostring(self.name) .. " tells you, 'The charge from such energy will be ideal for conjuring.'")
                actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
                actor:set_quest_var("meteorswarm", "earth", 1)
                return false  -- legacy return 0: the giver keeps the item
            else
                actor:send(tostring(self.name) .. " tells you, 'Yes yes, you have already proven it's a lovely focus.'")
                return false  -- legacy return 0: the giver keeps the item
            end
        elseif tonumber(_sw1) == 4 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find Dargentan first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 5 then
            if (air or 0) == 0 then
                self:destroy_item("meteorite")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'This meteorite, representing the force of earth, has been imbued with the spirits of fire and air.  It will serve as the perfect focus for casting meteorswarm.'")
                wait(4)
                actor:send(tostring(self.name) .. " tells you, 'You are ready.'")
                wait(3)
                self.room:spawn_object(481, 151)
                self:command("give meteorite " .. tostring(actor.name))
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Go somewhere safe, and <b:cyan>use it</> to unlock its potential.'")
                actor:set_quest_var("meteorswarm", "air", 1)
            else
                actor:send(tostring(self.name) .. " tells you, 'Where did you find a second one of these?  You don't need it.'")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value