-- Trigger: squeeze_ehlissa
-- Zone: 31, ID: 23
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3123

-- Converted from DG Script #3123: squeeze_ehlissa
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
if (arg ~= "doll") and (arg ~= "ehlissa") and (arg ~= "miniature-ehlissa-doll") and (arg ~= "miniature") and (arg ~= "little") and (arg ~= "little-ehlissa-doll") and (arg ~= "ehlissa-doll") then
    _return_value = false
    return _return_value
end
_return_value = true
self.room:send(tostring(actor.name) .. " squeezes " .. tostring(hisher) .. " doll.")
local i = 99
while i > 0 do
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer on the wall...'")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer...'")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " sings, 'Take one down, pass it around...'")
    wait(3)
    local i = i - 1
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer on the wall!'")
    wait(7)
end
return _return_value