-- Trigger: submit_command_trigger
-- Zone: 18, ID: 11
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1811

-- Converted from DG Script #1811: submit_command_trigger
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: submit
if not (cmd == "submit") then
    return true  -- Not our command
end
self:command("blink")
actor:command("forget all")
actor:send("You feel drained.")
local rm = random(1, 10)
-- switch on rm
do
    local _sw1 = string.lower(tostring(rm or ""))
    if tonumber(_sw1) == 1 then
        actor:teleport(get_room(520, 70))
    elseif tonumber(_sw1) == 2 then
        actor:teleport(get_room(480, 80))
    elseif tonumber(_sw1) == 3 then
        actor:teleport(get_room(117, 134))
    elseif tonumber(_sw1) == 4 then
        actor:teleport(get_room(117, 135))
    elseif tonumber(_sw1) == 5 then
        actor:teleport(get_room(430, 144 + random(1, 13)))
    elseif tonumber(_sw1) == 6 then
        actor:teleport(get_room(101, 0))
    elseif tonumber(_sw1) == 7 then
        actor:teleport(get_room(551, 5))
    elseif tonumber(_sw1) == 8 then
        actor:teleport(get_room(324, 189))
    elseif tonumber(_sw1) == 9 then
        actor:teleport(get_room(127, 1))
    end
end