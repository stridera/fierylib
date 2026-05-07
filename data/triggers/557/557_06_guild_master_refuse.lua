-- Trigger: Guild Master refuse
-- Zone: 557, ID: 6
-- Type: MOB, Flags: RECEIVE
--
-- Catch-all RECEIVE handler: accepts items the guildmaster knows how
-- to use (mace upgrades, the legacy id 55662 ghost crystal, the 2334
-- demon trident, the per-slot phase_armor inputs). Anything else is
-- handed back with an "I am not interested" message.
--
-- Original DG Script: #55706

-- Converted from DG Script #55706: Guild Master refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- TODO(parity): mace-quest item ids (`%maceitem2%`..`%mace_id%`) are
-- unresolved DG placeholders; replace with the integer ids set by
-- whichever LOAD trigger seeds the mace quest globals.
if object.id == maceitem2 or object.id == maceitem3 or object.id == maceitem4 or object.id == maceitem5 or object.id == mace_id then
    return _return_value
end
-- TODO(parity): 55662 / 2334 are 5-digit legacy vnums. Verify intent
-- (likely (556, 62) ghost crystal and (23, 34) hell trident) and
-- switch to (zone_id, local_id) once confirmed.
if object.id == 55662 or object.id == 2334 then
    return _return_value
end
if object.id == hands_armor or object.id == hands_gem or object.id == feet_armor or object.id == feet_gem or object.id == wrist_armor or object.id == wrist_gem or object.id == head_armor or object.id == head_gem or object.id == arms_armor or object.id == arms_gem or object.id == legs_armor or object.id == legs_gem or object.id == body_armor or object.id == body_gem then
    return _return_value
else
    _return_value = true
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value