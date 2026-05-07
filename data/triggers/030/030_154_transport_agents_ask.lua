-- Trigger: Transport agents ask
-- Zone: 30, ID: 154
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
local myname = "elf"
local dest_room = 3016
local dsname = "Mielikki"
if self.id == 3151 or self.id == 30075 then
    -- barbarian, sends to Ickle
    myname = "barbarian"
    dest_room = 10046
    dsname = "Ickle"
elseif self.id == 3152 then
    -- dwarf, sends to Anduin
    myname = "dwarf"
    dest_room = 6015
    dsname = "Anduin"
elseif self.id == 30074 then
    myname = "drow"
    dest_room = 6015
    dsname = "Anduin"
elseif self.id == 30076 then
    myname = "human"
    dest_room = 3016
    dsname = "Mielikki"
elseif self.id == 30077 then
    myname = "orc"
    dest_room = 30115
    dsname = "Ogakh"
elseif self.id == 3150 then
    -- legacy: questmaster 3150 had no agent record; bail
    return true
end
wait(4)
-- **************************
-- * Check for eligibility **
-- **************************
if actor.level > 99 then
    self:command("eyebrow " .. tostring(actor.name))
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Just goto " .. tostring(dest_room) .. ".'")
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
local dcolor
if self.room == 3016 then
    -- Mielikki - GREEN
    dcolor = "&2green&0"
elseif self.room == 6015 then
    -- Anduin - RED
    dcolor = "&1red&0"
elseif self.room == 30115 then
    -- Ogakh - GRAY
    dcolor = "&9&bgray&0"
else
    -- Ickle - BLUE
    dcolor = "&4blue&0"
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
actor:teleport(get_room(math.floor(dest_room / 100), dest_room % 100))
get_room(math.floor(dest_room / 100), dest_room % 100):at(function()
    self.room:send_except(actor, tostring(actor.name) .. " arrives in a cloud of " .. tostring(dcolor) .. " smoke.")
end)
-- actor looks around