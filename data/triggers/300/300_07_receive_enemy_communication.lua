-- Trigger: receive enemy communication
-- Zone: 300, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #30007

-- Converted from DG Script #30007: receive enemy communication
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Branch on the (zone_id, local_id) of the offered item.
-- 302:12 = enemy/orc message scroll (player is acting as a spy for the orcs)
-- 302:8  = paladin message parchment (player is foolishly handing in evidence
--          against themselves; general attacks and kicks them through a door)
if object.zone_id == 302 and object.local_id == 12 then
    wait(4)
    self:destroy_item("scroll")
    self:say("Why thank you... good spy.  I'll have my warlocks extract this message,")
    self:say("and find out what those self-righteous paladins are up to.")
    wait(2)
    self:say("Here is something for your trouble.")
    -- Reward: two random gems from the 555:81-555:89 range
    self.room:spawn_object(555, 81 + random(1, 8))
    self.room:spawn_object(555, 81 + random(1, 8))
    self:command("give all.gem " .. tostring(actor.name))
    return false
elseif object.zone_id == 302 and object.local_id == 8 then
    wait(3)
    self:destroy_item("parchment")
    self:command("growl")
    wait(2)
    self:say("What are you doing with this!  You spy!  Paladin!  GUARDS!")
    wait(1)
    self:command("open door")
    wait(4)
    local damage = actor.level * 2 + 5
    local damage_dealt = actor:damage(damage)  -- crush
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
    end
    return false
else
    self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
    wait(1)
    self:say("I don't need your rubbish!  Show some respect, dog!")
    return true
end