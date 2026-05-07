-- Trigger: Entry prevention: members only
-- Zone: 15, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1501
--
-- Blocks westward entry unless the actor is high-level staff (>99) or
-- wearing the Soul Gem (obj 15:0) WoF clan member token. Returning false
-- cancels the movement.

if direction == "west" then
    if actor.level > 99 or actor:has_equipped(15, 0) then
        return true
    end
    actor:send("You pass through the portal without seeming to go anywhere.")
    self.room:send_except(actor, tostring(actor.name) .. " walks into the portal, but stays among the waves.")
    return false
end
return true
