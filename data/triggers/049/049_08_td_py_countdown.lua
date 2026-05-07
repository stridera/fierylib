-- Trigger: TD PY Countdown
-- Zone: 49, ID: 8
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4908
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
--
-- Ticks down a pending pylon capture. When the timer hits zero the pylon
-- changes ownership and notifies the war-room mob, which fires 049_02.

self.state = self.state or {}
if not self.state.timeout then
    return true
end

self.state.timeout = self.state.timeout - 1

if self.state.timeout < 1 then
    local pylonname = self.state.pylonname or "Caelian Pylon"
    local pylon = self.state.pylon or 0
    local candidate = self.state.candidate

    self.room:send("The " .. pylonname .. " glows brightly, erupting in light!")

    if candidate then
        local mc = self.room:find_actor("teamdominationmc")
        if mc then
            mc:command("say TDCommand Capture T" .. tostring(candidate)
                       .. "T P" .. pylon .. "P")
        end
        self.state.owner = candidate
    end

    self.state.candidate = nil
    self.state.timeout = nil
end

return true
