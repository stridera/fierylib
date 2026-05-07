-- Trigger: glazed-stiletto-wield
-- Zone: 237, ID: 81
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #23781

-- Converted from DG Script #23781: glazed-stiletto-wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
-- Only the player who completed the quest_items entry for this stiletto can
-- wield it; everyone else gets the flavor refusal and is blocked from wielding.
if actor:get_quest_var("quest_items:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
    actor:send("You flip out the blade of " .. tostring(self.shortdesc) .. ".")
    self.room:send_except(actor, tostring(actor.name) .. " flips the blade out of " .. tostring(self.shortdesc) .. ".")
    return true  -- Allow wear
end
actor:send("You try to wield " .. tostring(self.shortdesc) .. ", but can't figure out how to open it.")
return false  -- Block wear