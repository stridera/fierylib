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
-- Item ids in the DG globals are legacy vnums (zone * 100 + local id).
-- Mace-quest ids: DG globals set on this mob by the mace LOAD trigger (002_118), if it has one.
local vnum = object.zone_id * 100 + object.id
if vnum == globals.maceitem2 or vnum == globals.maceitem3 or vnum == globals.maceitem4 or vnum == globals.maceitem5 or vnum == globals.mace_id then
    return _return_value
end
-- TODO(parity): 55662 / 2334 are 5-digit legacy vnums. Verify intent
-- (likely (556, 62) ghost crystal and (23, 34) hell trident) and
-- switch to (zone_id, local_id) once confirmed.
if (object.zone_id == 556 and object.id == 62) or (object.zone_id == 23 and object.id == 34) then
    return _return_value
end
-- Phase-armor inputs: stored on the mob by its init (LOAD) trigger, 557:10-39.
local wanted = false
for _, key in ipairs({"hands_armor", "hands_gem", "feet_armor", "feet_gem", "wrist_armor", "wrist_gem", "head_armor", "head_gem", "arms_armor", "arms_gem", "legs_armor", "legs_gem", "body_armor", "body_gem"}) do
    if vnum == self:getvar(key) then
        wanted = true
        break
    end
end
if wanted then
    return _return_value
else
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value