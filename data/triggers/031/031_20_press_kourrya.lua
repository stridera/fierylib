-- Trigger: press_kourrya
-- Zone: 31, ID: 20
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3120

-- Converted from DG Script #3120: press_kourrya
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: press
if not (cmd == "press") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" or cmd == "pr" then
    _return_value = false
    return _return_value
end
if (arg ~= "button") and (arg ~= "figurine") and (arg ~= "kourrya-figurine") and (arg ~= "figurine") and (arg ~= "toy") and (arg ~= "tiny") and (arg ~= "figure") and (arg ~= "robed") and (arg ~= "woman") then
    _return_value = false
    return _return_value
end
_return_value = true
-- switch on random(1, 9)
if random(1, 9) == 1 then
    local phrase = "Find it yourself."
elseif random(1, 9) == 2 then
    local phrase = "Finish your existing quest first."
elseif random(1, 9) == 3 then
    local phrase = "Your soul belongs to me!"
elseif random(1, 9) == 4 then
    local phrase = "PHRASE4"
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
self.room:send(tostring(actor.name) .. " presses the button in the Kourrya figurine's back.")
self.room:send("The Kourrya figurine says, '" .. tostring(phrase) .. "'")
return _return_value