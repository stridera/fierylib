-- Trigger: mccabe_receive
-- Zone: 482, ID: 58
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48258

-- Converted from DG Script #48258: mccabe_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("meteorswarm")
local earth = actor:get_quest_var("meteorswarm:earth")
local air = actor:get_quest_var("meteorswarm:air")
if object.id == 48251 then
    _return_value = false
    self:command("shake")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Go <b:cyan>use</> this new treasure; don't give it back to me!'")
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    _return_value = false
    self.room:send(tostring(self.name) .. " accepts the meteorite.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Good, this will work.'")
    self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Go, resume your studies.'")
    actor:set_quest_var("meteorswarm", "new", 0)
else
    -- switch on stage
    if stage == 1 then
        _return_value = false
        self:command("eye")
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'No, go find Jemnon first.'")
    elseif stage == 2 then
        _return_value = false
        self:command("eye")
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'No, go find the rock demon first.'")
        if earth == 0 then
        elseif stage == 3 then
            _return_value = false
            actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
            actor:send(tostring(self.name) .. " tells you, 'Such wonderfully powerful stone.  This will do perfectly.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'Next, you need to demonstrate mastery over fire.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'The northern cult of fire provides an excellent opportunity to do so.'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'Take the meteor, <b:cyan>slay the high priest, and find the secret lava well</>.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'The charge from such energy will be ideal for conjuring.'")
            wait(2)
            actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
            actor.name:set_quest_var("meteorswarm", "earth", 1)
        else
            _return_value = false
            actor:send(tostring(self.name) .. " tells you, 'Yes yes, you have already proven it's a lovely focus.'")
        end
    elseif stage == 4 then
        _return_value = false
        self:command("eye")
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'No, go find Dargentan first.'")
        if air == 0 then
        elseif stage == 5 then
            self:destroy_item("meteorite")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'This meteorite, representing the force of earth, has been imbued with the spirits of fire and air.  It will serve as the perfect focus for casting meteorswarm.'")
            wait(4)
            actor:send(tostring(self.name) .. " tells you, 'You are ready.'")
            wait(3)
            self.room:spawn_object(482, 51)
            self:command("give meteorite " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'Go somewhere safe, and <b:cyan>use it</> to unlock its potential.'")
            actor.name:set_quest_var("meteorswarm", "air", 1)
        else
            _return_value = false
            actor:send(tostring(self.name) .. " tells you, 'Where did you find a second one of these?  You don't need it.'")
        end
    else
        _return_value = false
        wait(1)
        self:command("eye")
        actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
    end
end
return _return_value