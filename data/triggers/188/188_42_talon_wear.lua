-- Trigger: talon_wear
-- Zone: 188, ID: 42
-- Type: OBJECT, Flags: GLOBAL, WEAR
-- Status: CLEAN
--
-- Original DG Script: #18842

-- Converted from DG Script #18842: talon_wear
-- Original: OBJECT trigger, flags: GLOBAL, WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.quest_variable[quest_items:self.vnum] then
    if not (actor:get_worn("wield")) and not (actor:get_worn("wield2")) and not (actor:get_worn("2hwield")) then
        _return_value = true
    else
        _return_value = false
        actor:send("You cannot wield another weapon with " .. tostring(self.shortdesc) .. "!")
    end
else
    _return_value = false
    actor:send("You do not feel worthy enough to wield " .. tostring(self.shortdesc) .. "!")
end
return _return_value