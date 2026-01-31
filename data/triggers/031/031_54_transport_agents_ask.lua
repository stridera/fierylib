-- Trigger: Transport agents ask
-- Zone: 31, ID: 54
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3154

-- Converted from DG Script #3154: Transport agents ask
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- This is the ask trigger for intercity transport questmasters.
-- It allows level 1-15 people to get transport by asking to
-- Anduin, Ickle, or Mielikki.
-- Much of this trigger is a copy of 3152.
-- ******************
-- * GENERAL SETUP **
-- ******************
local minlevel = 1
local maxlevel = 15
-- switch on self.id
-- This is the barbarian, who sends people to Ickle.
if self.id == 3151 or self.id == 30075 then
    local myname = "barbarian"
    local dest_zone, dest_local = 100, 46
    local dsname = "Ickle"
elseif self.id == 3152 then
    -- This is the dwarf, who sends people to Anduin.
    local myname = "dwarf"
    local dest_zone, dest_local = 60, 15
    local dsname = "Anduin"
elseif self.id == 30074 then
    local myname = "drow"
    local dest_zone, dest_local = 60, 15
    local dsname = "Anduin"
elseif self.id == 30076 then
    local myname = "human"
    local dest_zone, dest_local = 30, 16
    local dsname = "Mielikki"
elseif self.id == 30077 then
    local myname = "orc"
    local dest_zone, dest_local = 301, 15
    local dsname = "Ogakh"
elseif self.id == 3150 then
else
    -- This is the elf, who sends people to Mielikki.
    local myname = "elf"
    local dest_zone, dest_local = 30, 16
    local dsname = "Mielikki"
end
wait(4)
-- **************************
-- * Check for eligibility **
-- **************************
if actor.level > 99 then
    self:command("eyebrow " .. tostring(actor.name))
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Just goto " .. tostring(dvnum) .. ".'")
    return _return_value
elseif minlevel > actor.level then
    self:command("shake")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'You are not experienced enough to go to " .. tostring(dsname) .. ".'</>")
    return _return_value
elseif actor.level > maxlevel then
    self:command("eyebrow " .. tostring(actor.name))
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'You are too powerful for me to transport.'</>")
    return _return_value
end
-- **************************
-- * Set origination color **
-- **************************
-- The color says where they came from.
-- It is seen by anyone standing at the destination.
if self.room == 3016 then
    -- Mielikki - GREEN
    local dcolor = "&2green&0"
elseif self.room == 6015 then
    -- Anduin - RED
    local dcolor = "&1red&0"
elseif self.room == 30115 then
    -- Ogakh - GRAY
    local dcolor = "&9&bgray&0"
else
    -- Ickle - BLUE
    local dcolor = "&4blue&0"
end
-- **********************
-- * Perform transport **
-- **********************
self.room:send_except(actor, tostring(self.name) .. " nods briefly to " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " nods briefly to you.")
wait(4)
self.room:send_except(actor, tostring(self.name) .. " makes a magical gesture at " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " makes a magical gesture at you.")
self.room:send_except(actor, tostring(actor.name) .. " disappears in a cloud of gray smoke.")
actor:teleport(get_room(dest_zone, dest_local))
get_room(dest_zone, dest_local):at(function()
    self.room:send_except(actor, tostring(actor.name) .. " arrives in a cloud of " .. tostring(dcolor) .. " smoke.")
end)
-- actor looks around