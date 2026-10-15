-- Trigger: trainers not level gain
-- Zone: 30, ID: 156
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3156

-- Converted from DG Script #3156: trainers not level gain
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: level
if not (cmd == "level") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "l" or _sw1 == "le" then
        _return_value = true
        return _return_value
    end
end
actor:send(tostring(self.name) .. " says, 'Sorry, I'm not a guild master.'")
wait(0.2)
local warriors = "warrior paladin ranger monk berserker anti-paladin"
local clerics = "cleric druid priest diabolist"
local rogues = "rogue bard mercenary assassin thief"
local sorcerers = "sorcerer cryomancer pyromancer illusionist necromancer"
if (self.zone_id == 30 and self.id == 165) then
    -- Calken
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go west and north.'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.  But don't go to Julk's training grounds!'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
elseif (self.zone_id == 30 and self.id == 170) then
    -- Fecil
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'You guild master is just around the corner!  Go north and east.'")
    end
elseif (self.zone_id == 30 and self.id == 160) then
    -- Julk
    if string.find(string.lower(warriors), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(string.lower(clerics), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(string.lower(rogues), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go north down.'")
    elseif string.find(string.lower(sorcerers), actor.class, 1, true) then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
end
return _return_value