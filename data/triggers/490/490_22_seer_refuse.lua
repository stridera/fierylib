-- Trigger: Seer refuse
-- Zone: 490, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49022

-- Converted from DG Script #49022: Seer refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- The wand-quest items (wandgem, wandtask3, wandtask4, wand_id, exported through `globals` by
-- 002_111) fall through to 002_108. The wizard_eye ingredients (2329, 23753, 48005 = 23:29,
-- 237:53, 480:5) are accepted at stage 4. A turned-away item is handed back.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
if actor:get_quest_stage("wizard_eye") == 4 and (
        (object.zone_id == 23 and object.id == 29) or (object.zone_id == 237 and object.id == 53)
        or (object.zone_id == 480 and object.id == 5)) then
    return true
end
local _return_value = true  -- Default: allow action
local response, action
if actor:get_quest_stage("wizard_eye") == 4 then
    response = "This isn't a dress, bay, or thyme!  I don't have thyme for this!"
    action = "cackle"
else
    response = "This isn't sunscreen, what use do I have for it?"
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    if action then
        self:command(action)
    end
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value