-- Trigger: TD PY Countdown
-- Zone: 49, ID: 8
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4908

-- Converted from DG Script #4908: TD PY Countdown
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
-- Team Domination Pylon Countdown (Random) Trigger
if timeout then
    local timeout = timeout - 1
    globals.timeout = globals.timeout or true
    if timeout < 1 then
        self.room:send("The " .. tostring(pylonname) .. " glows brightly, erupting in light!")
        self.room:find_actor("teamdominationmc"):say("TDCommand Capture T" .. tostring(candidate) .. "T P" .. tostring(pylon) .. "P")
        local owner = candidate
        globals.owner = globals.owner or true
        candidate = nil
        timeout = nil
    end
end