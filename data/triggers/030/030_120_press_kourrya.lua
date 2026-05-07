-- Trigger: press_kourrya
-- Zone: 30, ID: 120
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
    _return_value = true
    return _return_value
end
if (arg ~= "button") and (arg ~= "figurine") and (arg ~= "kourrya-figurine") and (arg ~= "figurine") and (arg ~= "toy") and (arg ~= "tiny") and (arg ~= "figure") and (arg ~= "robed") and (arg ~= "woman") then
    _return_value = true
    return _return_value
end
_return_value = false
-- legacy "switch on random(1, 9)": single roll, then table-lookup phrase
local roll = random(1, 9)
local phrases = {
    "Find it yourself.",
    "Finish your existing quest first.",
    "Your soul belongs to me!",
    "PHRASE4",
    "PHRASE5",
    "PHRASE6",
    "PHRASE7",
    "PHRASE8",
    "PHRASE9",
}
local phrase = phrases[roll] or "PHRASE0"
self.room:send(tostring(actor.name) .. " presses the button in the Kourrya figurine's back.")
self.room:send("The Kourrya figurine says, '" .. tostring(phrase) .. "'")
return _return_value