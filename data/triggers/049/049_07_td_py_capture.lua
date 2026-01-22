-- Trigger: TD PY Capture
-- Zone: 49, ID: 7
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #4907

-- Converted from DG Script #4907: TD PY Capture
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: xcapture
if not (cmd == "xcapture") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Team Domination Pylon Capture (Command) Trigger
if not arg then
    _return_value = false
    return _return_value
end
local i = 0
while i < teams do
    if string.find(arg, "T" .. i .. "T") then
        if candidate == "i" then
            local seconds = timeout * 12
            actor:send("Your team will capture this " .. tostring(pylonname) .. " in " .. tostring(seconds) .. " seconds!")
        elseif owner == "i" then
            if candidate then
                actor:send("You touch the " .. tostring(pylonname) .. ", canceling team " .. tostring(candidate) .. "'s attempt to capture your " .. tostring(pylonname) .. "!")
                self.room:send_except(actor, tostring(actor.name) .. " touches the " .. tostring(pylonname) .. ", disrupting its pulsing.")
                self.room:find_actor("teamdominationmc"):say("TDCommand Cancel T" .. tostring(i) .. "T P" .. tostring(pylon) .. "P")
                candidate = nil
            else
                actor:send("But your team already controls this " .. tostring(pylonname) .. "!")
            end
        else
            local timeout = 4
            globals.timeout = globals.timeout or true
            local candidate = i
            globals.candidate = globals.candidate or true
            local seconds = timeout * 12
            actor:send("You touch the " .. tostring(pylonname) .. ", and it starts pulsating.")
            actor:send("Your team will capture this " .. tostring(pylonname) .. " in " .. tostring(seconds) .. " seconds!")
            self.room:send_except(actor, tostring(actor.name) .. " touches the " .. tostring(pylonname) .. ", and it starts pulsating.")
            self.room:find_actor("teamdominationmc"):say("TDCommand Countdown T" .. tostring(candidate) .. "T P" .. tostring(pylon) .. "P")
        end
        _return_value = true
        return _return_value
    end
    local i = i + 1
end
_return_value = false
return _return_value