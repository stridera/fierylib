-- Trigger: Transport agents ask
-- Zone: 30, ID: 154
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3154

-- Converted from DG Script #3154: Transport agents ask
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"transport"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

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
if (self.zone_id == 30 and self.id == 151) or (self.zone_id == 300 and self.id == 75) then
    -- barbarian, sends to Ickle
    myname = "barbarian"
    dest_room = 10046
    dsname = "Ickle"
elseif (self.zone_id == 30 and self.id == 152) then
    -- dwarf, sends to Anduin
    myname = "dwarf"
    dest_room = 6015
    dsname = "Anduin"
elseif (self.zone_id == 300 and self.id == 74) then
    myname = "drow"
    dest_room = 6015
    dsname = "Anduin"
elseif (self.zone_id == 300 and self.id == 76) then
    myname = "human"
    dest_room = 3016
    dsname = "Mielikki"
elseif (self.zone_id == 300 and self.id == 77) then
    myname = "orc"
    dest_room = 30115
    dsname = "Ogakh"
elseif (self.zone_id == 30 and self.id == 150) then
    -- legacy: questmaster 3150 had no agent record; bail
    return true
end
wait(0.4)
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
if (self.room.zone_id == 30 and self.room.local_id == 16) then
    -- Mielikki - GREEN
    dcolor = "<green>green</>"
elseif (self.room.zone_id == 60 and self.room.local_id == 15) then
    -- Anduin - RED
    dcolor = "<red>red</>"
elseif (self.room.zone_id == 300 and self.room.local_id == 115) then
    -- Ogakh - GRAY
    dcolor = "<b:black>gray</>"
else
    -- Ickle - BLUE
    dcolor = "<blue>blue</>"
end
-- **********************
-- * Perform transport **
-- **********************
self.room:send_except(actor, tostring(self.name) .. " nods briefly to " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " nods briefly to you.")
wait(0.4)
self.room:send_except(actor, tostring(self.name) .. " makes a magical gesture at " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " makes a magical gesture at you.")
self.room:send_except(actor, tostring(actor.name) .. " disappears in a cloud of gray smoke.")
actor:teleport(get_room(math.floor(dest_room / 100), dest_room % 100))
get_room(math.floor(dest_room / 100), dest_room % 100):at(function()
    self.room:send_except(actor, tostring(actor.name) .. " arrives in a cloud of " .. tostring(dcolor) .. " smoke.")
end)
-- actor looks around