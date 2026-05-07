-- Trigger: megalith_quest_act_fill
-- Zone: 123, ID: 16
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12316

-- Converted from DG Script #12316: megalith_quest_act_fill
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: fill
if not (cmd == "fill") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Questor should fill a vessel from room 12401
-- Doing so will set item5 if the questor is on stage 2
-- 
-- switch on cmd
if cmd == "f" or cmd == "fi" then
    _return_value = true
    return _return_value
end
if (actor:get_quest_stage("megalith_quest") == 2) and (actor.room.zone_id == 124 and actor.room.local_id == 1) and (actor:get_quest_var("megalith_quest:goblet") == self.id) then
    -- TODO(parity): legacy room 12401 likely splits to (124, 1) but the
    -- trigger zone is 123 and 12401 was stored as a 5-digit vnum. Verify
    -- the canonical zone for the hidden spring before relying on this.
    actor:command("fill " .. tostring(arg))
    actor:set_quest_var("megalith_quest", "item5", 1)
end
return _return_value