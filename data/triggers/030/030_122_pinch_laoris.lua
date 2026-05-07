-- Trigger: pinch_laoris
-- Zone: 30, ID: 122
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
    _return_value = true
    return _return_value
end
if (arg ~= "puppet") and (arg ~= "laoris") and (arg ~= "laoris-puppet") and (arg ~= "toy") and (arg ~= "little") and (arg ~= "colorful") and (arg ~= "hand") and (arg ~= "hand-puppet") then
    _return_value = true
    return _return_value
end
_return_value = false
-- legacy "switch on random(1, 9)": single roll, then table-lookup phrase
local roll = random(1, 9)
local phrases = {
    "Rarr!",
    "Hey want to try my mob's new combat proc?",
    "Teeehehehehehe!",
    "PHASE4",
    "PHRASE5",
    "PHRASE6",
    "PHRASE7",
    "PHRASE8",
    "PHRASE9",
}
local phrase = phrases[roll] or "PHRASE0"
self.room:send(tostring(actor.name) .. " pinches the Laoris puppet.")
self.room:send("The Laoris puppet says, '" .. tostring(phrase) .. "'")
return _return_value