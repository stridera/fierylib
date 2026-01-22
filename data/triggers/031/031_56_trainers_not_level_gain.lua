-- Trigger: trainers not level gain
-- Zone: 31, ID: 56
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #3156

-- Converted from DG Script #3156: trainers not level gain
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: level
if not (cmd == "level") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "l" or cmd == "le" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'Sorry, I'm not a guild master.'")
wait(2)
local warriors = "warrior paladin ranger monk berserker anti-paladin"
local clerics = "cleric druid priest diabolist"
local rogues = "rogue bard mercenary assassin thief"
local sorcerers = "sorcerer cryomancer pyromancer illusionist necromancer"
if self.id == 3165 then
    -- Calken
    if string.find(warriors, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go west and north.'")
    elseif string.find(clerics, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(rogues, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.  But don't go to Julk's training grounds!'")
    elseif string.find(sorcerers, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
elseif self.id == 3170 then
    -- Fecil
    if string.find(warriors, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(clerics, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(rogues, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Rogue Guild is known to be somewhere near the jewelry shop in the south-west corner of Town Center.'")
    elseif string.find(sorcerers, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'You guild master is just around the corner!  Go north and east.'")
    end
elseif self.id == 3160 then
    -- Julk
    if string.find(warriors, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Warrior Guild is located behind Santiago's Weapon Shop just east of Town Center.  But don't go to Calken in the training grounds!'")
    elseif string.find(clerics, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild Masters are north of Town Center by the Temple to Mielikki.'")
    elseif string.find(rogues, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'Your guild master is right around the corner!  Go north and down.'")
    elseif string.find(sorcerers, "actor.class") then
        actor:send(tostring(self.name) .. " says, 'The Sorcerer Guild Masters are located near Bigby's Magic Shope just west and south of Town Center.  But don't go to Fecil's study hall!'")
    end
end
return _return_value