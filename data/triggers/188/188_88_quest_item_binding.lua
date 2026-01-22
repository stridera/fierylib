-- Trigger: quest_item_binding
-- Zone: 188, ID: 88
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #18888

-- Converted from DG Script #18888: quest_item_binding
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
-- This trigger checks if a player is "registered" to wear certain quest eq.
-- In order to be registered, a player must have the quest_items quest and a
-- quest variable whose name is the vnum of the object this trigger is on
-- and whose value is true (a simple 1 or yes will suffice).
-- 
-- To register a player for equipment, first check to see if they already have
-- the quest_item quest by typing "quest stage quest_items <player>" in their
-- presence.  If they do not have it or it is failed, it will say failed.  In
-- this case, attempt to start or restart quest_items on the player ("quest
-- start quest_items <player>" and "quest restart quest_items <player>").  If
-- the 'quest stage' command said anything besides failed, the player is ready!
-- 
-- Once a player has the quest_items quest active, add a quest variable for
-- the object.  For instance, if I wanted to allow Laoris to wear a golden
-- dragonhelm, I would type:
-- 
-- quest variable quest_items laoris 18890 1
-- 
-- If I no longer want Laoris to be able to wear the helm, I would type:
-- 
-- quest variable quest_items laoris 18890 0
-- 
if actor.quest_variable["quest_items"][self.vnum] then
    _return_value = true
else
    _return_value = false
    if self.type == "WEAPON" then
        actor:send("You do not feel worthy enough to wield " .. tostring(self.shortdesc) .. "!")
    else
        actor:send("You do not feel worthy enough to wear " .. tostring(self.shortdesc) .. "!")
    end
end
return _return_value