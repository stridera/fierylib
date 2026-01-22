-- Trigger: squeeze_zzur
-- Zone: 31, ID: 18
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3118

-- Converted from DG Script #3118: squeeze_zzur
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: squeeze
if not (cmd == "squeeze") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if (arg ~= "plushie") and (arg ~= "zzur-plushie") and (arg ~= "zzur") and (arg ~= "toy") and (arg ~= "little-plushie") and (arg ~= "little") then
    _return_value = false
    return _return_value
end
_return_value = true
-- switch on random(1, 9)
if random(1, 9) == 1 then
    local phrase = "Done yet?"
elseif random(1, 9) == 2 then
    local phrase = "Be nice to the newbies."
elseif random(1, 9) == 3 then
    local phrase = "AFK."
elseif random(1, 9) == 4 then
    local phrase = "Uh huh."
elseif random(1, 9) == 5 then
    local phrase = "Thoughts? Suggestions?"
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
self.room:send(tostring(actor.name) .. " squeezes the Zzur plushie's belly.")
self.room:send("The Zzur plushie says, '" .. tostring(phrase) .. "'")
return _return_value