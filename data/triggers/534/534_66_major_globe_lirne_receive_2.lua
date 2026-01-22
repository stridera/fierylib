-- Trigger: Major Globe Lirne receive 2
-- Zone: 534, ID: 66
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53466

-- Converted from DG Script #53466: Major Globe Lirne receive 2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 7 then
    actor.name:advance_quest("major_globe_spell")
    wait(1)
    self:destroy_item("majorglobe-spellbook")
    self:command("gasp")
    actor:send(tostring(self.name) .. " says, 'This is fantastic!  I knew you would find it.'")
    self:emote("opens the spellbook and begins leafing through it.")
    wait(3)
    self:emote("begins to look very excited.")
    actor:send(tostring(self.name) .. " says, 'Ah ha!  Here it is...  The spell to protect against powerful magic.  We'll need some <b:yellow>elemental wards</> to power it, though.'")
    self:command("snap")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You must banish some elementals and return their energies to me.  I think five should do it: mist, water, ice, flame, or plant.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Yes... go and <b:cyan>banish five unique elementals</> and bring back their energies!'")
elseif stage < 7 then
    _return_value = false
    self:command("eyebrow")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'How could you have found this?  Do the quest in order!'")
elseif stage > 7 then
    wait(1)
    self:destroy_item("majorglobe-spellbook")
    actor:send(tostring(self.name) .. " says, 'You've already brought me this!")
end
return _return_value