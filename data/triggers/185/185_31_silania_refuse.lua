-- Trigger: Silania refuse
-- Zone: 185, ID: 31
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: msend %actor
--
-- Original DG Script: #18531

-- Converted from DG Script #18531: Silania refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%maceitem2%" or object.id == "%maceitem3%" or object.id == "%maceitem4%" or object.id == "%maceitem5%" or object.id == "%wandgem%" or object.id == "%wandvnum%" or object.id == "%macevnum%" then
    return _return_value
else
    local response = "What is this for?"
end
if response then
    _return_value = false
    actor:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    -- UNCONVERTED: msend %actor
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value