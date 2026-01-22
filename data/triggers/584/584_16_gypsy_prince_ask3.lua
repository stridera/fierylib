-- Trigger: gypsy_prince_ask3
-- Zone: 584, ID: 16
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58416

-- Converted from DG Script #58416: gypsy_prince_ask3
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if actor:get_quest_stage("major_spell_quest") == 3 then
    wait(2)
    self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
    actor:send(tostring(self.name) .. " says to you, 'Excellent!  That rogue of a guard, a monstrous bronze statue'")
    actor:send(tostring(self.name) .. " says to you, 'that now guards the entrance of that accursed village was to'")
    actor:send(tostring(self.name) .. " says to you, 'search the Underdark for an item for me.  Go to him and demand'")
    actor:send(tostring(self.name) .. " says to you, 'it in the name of the Gypsy Prince of Calia and I shall reward you.'")
    actor.name:advance_quest("major_spell_quest")
    -- This sets the player to level 4 in the quest
else
end