-- Trigger: McCabe refuse
-- Zone: 481, ID: 149
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48249
--
-- TODO(parity): the original DG `if object.id == %wandgem% or ...` referenced
-- DG quest globals (`%wandgem%`, `%wandtask3%`, `%wandtask4%`, `%wand_id%`)
-- belonging to the cross-zone `type_wand` craft quest. Those globals don't
-- exist in the Lua runtime; the canonical wand-quest item ids must be wired
-- in once the type_wand quest is ported.

-- Converted from DG Script #48249: McCabe refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
local wand_ids = {
    -- (zone, local_id) pairs for type_wand craft items; populate when ported.
}
local function is_wand_item(obj)
    if not obj then return false end
    for _, pair in ipairs(wand_ids) do
        if obj.zone_id == pair[1] and obj.local_id == pair[2] then
            return true
        end
    end
    return false
end
if is_wand_item(object) then
    return _return_value
else
    _return_value = true
    self:command("eye")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
end
return _return_value