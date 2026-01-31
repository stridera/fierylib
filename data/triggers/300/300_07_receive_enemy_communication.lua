-- Trigger: receive enemy communication
-- Zone: 300, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #30007

-- Converted from DG Script #30007: receive enemy communication
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 30212 then
    _return_value = true
    wait(4)
    self:destroy_item("scroll")
    self:say("Why thank you... good spy.  I'll have my warlocks extract this message,")
    self:say("and find out what those self-righteous paladins are up to.")
    wait(2)
    self:say("Here is something for your trouble.")
    self.room:spawn_object(555, random(1, 8) + 81)
    self.room:spawn_object(555, random(1, 8) + 81)
    self:command("give all.gem " .. tostring(actor.name))
elseif object.id == 30208 then
    _return_value = true
    wait(3)
    self:destroy_item("parchment")
    self:command("growl")
    wait(2)
    self:say("What are you doing with this!  You spy!  Paladin!  GUARDS!")
    wait(1)
    self:command("open door")
    wait(4)
    local damage = actor.level * 2 + 5
    local damage_dealt = actor:damage(damage)  -- type: crush
    if damage_dealt == 0 then
        self.room:send_except(actor, tostring(self.name) .. " tries to kick " .. tostring(actor.name) .. ", but is having trouble with " .. tostring(self.possessive) .. " foot!")
        actor:send(tostring(self.name) .. " tries to kick you, but is having trouble with " .. tostring(self.possessive) .. " foot!")
    else
        self.room:send_except(actor, tostring(self.name) .. " kicks " .. tostring(actor.name) .. " solidly in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
        actor:send(tostring(self.name) .. " kicks you solidly in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is sent reeling through the doorway!")
        actor:send("You topple through the door into the next room!")
        wait(3)
        actor:teleport(get_room(300, 38))
        -- actor looks around
    end
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
    wait(1)
    self:say("I don't need your rubbish!  Show some respect, dog!")
end
return _return_value