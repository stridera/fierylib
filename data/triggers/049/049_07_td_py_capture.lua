-- Trigger: TD PY Capture
-- Zone: 49, ID: 7
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4907
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%
--
-- Receives "xcapture T<team>T" relayed from the armband (049_04). Three
-- cases:
--   * candidate == team    : already counting down for this team
--   * owner     == team    : already owned by this team -- reject
--   * neither              : start a new countdown, notify the war room
-- A foreign team touching during another team's countdown cancels it.

if not percent_chance(4) then
    return true
end

if cmd ~= "xcapture" then
    return true
end

if not arg or arg == "" then
    return true
end

self.state = self.state or {}
local pylonname = self.state.pylonname or "Caelian Pylon"
local pylon = self.state.pylon or 0
local teams = self.state.teams or (globals.teams or 4)

-- Parse "T<team>T" out of arg.
local team_idx = tonumber(string.match(arg, "T(%d+)T"))
if not team_idx or team_idx < 0 or team_idx >= teams then
    return true
end

local candidate = self.state.candidate
local owner = self.state.owner

if candidate == team_idx then
    -- Same team is already counting down; remind them.
    local timeout = self.state.timeout or 0
    local seconds = timeout * 12
    actor:send("Your team will capture this " .. pylonname
               .. " in " .. seconds .. " seconds!")
elseif owner == team_idx then
    if candidate then
        -- Owner returns mid-attempt and disrupts the rival capture.
        actor:send("You touch the " .. pylonname
                   .. ", canceling team " .. tostring(candidate)
                   .. "'s attempt to capture your " .. pylonname .. "!")
        self.room:send_except(actor, tostring(actor.name)
                              .. " touches the " .. pylonname
                              .. ", disrupting its pulsing.")
        local mc = self.room:find_actor("teamdominationmc")
        if mc then
            mc:command("say TDCommand Cancel T" .. team_idx
                       .. "T P" .. pylon .. "P")
        end
        self.state.candidate = nil
    else
        actor:send("But your team already controls this " .. pylonname .. "!")
    end
else
    -- New countdown.
    local timeout = 4
    self.state.timeout = timeout
    self.state.candidate = team_idx
    local seconds = timeout * 12
    actor:send("You touch the " .. pylonname .. ", and it starts pulsating.")
    actor:send("Your team will capture this " .. pylonname
               .. " in " .. seconds .. " seconds!")
    self.room:send_except(actor, tostring(actor.name)
                          .. " touches the " .. pylonname
                          .. ", and it starts pulsating.")
    local mc = self.room:find_actor("teamdominationmc")
    if mc then
        mc:command("say TDCommand Countdown T" .. team_idx
                   .. "T P" .. pylon .. "P")
    end
end

return false  -- consume the relayed command
