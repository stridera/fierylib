-- Trigger: calian_slayer
-- Zone: 12, ID: 12
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #1212

-- Converted from DG Script #1212: calian_slayer
-- Original: OBJECT trigger, flags: GET, WEAR, probability: 100%
if actor:get_quest_var("quest_items:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
    -- Worthy: deny pickup/wear with concealment flavor
    self.room:send_except(actor, "A &9<blue>black <white>haze </>surrounds " .. tostring(actor.name) .. ", obscuring " .. tostring(actor.object) .. " from view.")
    actor:send("A &9<blue>black <white>haze </>surrounds you, momentarily obscuring your view.")
    return false
end
-- Not worthy: allow action with rejection message
actor:send("You do not feel worthy enough to wield " .. tostring(self.shortdesc) .. "!")
return true