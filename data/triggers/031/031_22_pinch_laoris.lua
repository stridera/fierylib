-- Trigger: pinch_laoris
-- Zone: 31, ID: 22
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3122

-- Converted from DG Script #3122: pinch_laoris
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pinch
if not (cmd == "pinch") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" or cmd == "pi" then
    _return_value = false
    return _return_value
end
if (arg ~= "puppet") and (arg ~= "laoris") and (arg ~= "laoris-puppet") and (arg ~= "toy") and (arg ~= "little") and (arg ~= "colorful") and (arg ~= "hand") and (arg ~= "hand-puppet") then
    _return_value = false
    return _return_value
end
_return_value = true
-- switch on random(1, 9)
if random(1, 9) == 1 then
    local phrase = "Rarr!"
elseif random(1, 9) == 2 then
    local phrase = "Hey want to try my mob's new combat proc?"
elseif random(1, 9) == 3 then
    local phrase = "Teeehehehehehe!"
elseif random(1, 9) == 4 then
    local phrase = "PHASE4"
elseif random(1, 9) == 5 then
    local phrase = "PHRASE5"
elseif random(1, 9) == 6 then
    local phrase = "PHRASE6"
elseif random(1, 9) == 7 then
    local phrase = "PHRASE7"
elseif random(1, 9) == 8 then
    local phrase = "PHRASE8"
elseif random(1, 9) == 9 then
    local phrase = "PHRASE9"
else
    local phrase = "PHRASE0"
end
self.room:send(tostring(actor.name) .. " pinches the Laoris puppet.")
self.room:send("The Laoris puppet says, '" .. tostring(phrase) .. "'")
return _return_value