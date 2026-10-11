-- Trigger: Ranger Trophy assignment examine
-- Zone: 53, ID: 16
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
-- TODO(parity): same problems as 053_15: `victim1`/`stage` are
-- branch-scoped; `== "stage"` is a string compare; legacy 5-digit ids
-- need split. Full rewrite from DG #5316.
--
-- Original DG Script: #5316

-- Converted from DG Script #5316: Ranger Trophy assignment examine
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: examine
if not (cmd == "examine") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local victim1
if arg == "assignment" then
    -- switch on self.id
    if (self.zone_id == 53 and self.id == 0) then
        victim1 = "an abominable slime creature"
        local stage = 1
    elseif (self.zone_id == 53 and self.id == 1) then
        victim1 = "a large buck"
        local stage = 2
    elseif (self.zone_id == 53 and self.id == 2) then
        victim1 = "the giant scorpion"
        local stage = 3
    elseif (self.zone_id == 53 and self.id == 3) then
        victim1 = "a monstrous canopy spider"
        local stage = 4
    elseif (self.zone_id == 53 and self.id == 4) then
        victim1 = "the chimera"
        local stage = 5
    elseif (self.zone_id == 53 and self.id == 5) then
        victim1 = "the drider king"
        local stage = 6
    elseif (self.zone_id == 53 and self.id == 6) then
        victim1 = "a beholder"
        local stage = 7
    elseif (self.zone_id == 53 and self.id == 7) then
        victim1 = "the Banshee"
        local stage = 8
    elseif (self.zone_id == 53 and self.id == 8) then
        victim1 = "Baba Yaga"
        local stage = 9
    elseif (self.zone_id == 53 and self.id == 9) then
        victim1 = "the medusa"
        local stage = 10
    end
else
    _return_value = true
    return _return_value
end
actor:send("This is a notice to slay " .. tostring(victim1) .. ".")
if actor:get_quest_var("beast_master:hunt") == "dead" and actor:get_quest_stage("beast_master") == "stage" then
    actor:send("You have completed the hunt.")
    actor:send("Return your assignment to Pumahl for your reward!")
end
return _return_value