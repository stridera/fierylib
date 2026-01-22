-- Trigger: TD WR Countdown
-- Zone: 49, ID: 9
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #4909

-- Converted from DG Script #4909: TD WR Countdown
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: TDCommand Countdown
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tdcommand") or string.find(string.lower(speech), "countdown")) then
    return true  -- No matching keywords
end
-- Team Domination War Room Countdown (Speech) Trigger
local i = 0
while i < pylons do
    if string.find(speech, "P" .. i .. "P") then
        local j = 0
        while j < teams do
            if string.find(speech, "T" .. j .. "T") then
                pylon[i] = j
                globals["pylon" .. i] = globals["pylon" .. i] or true
                -- switch on j
                if j == 0 then
                    local team = team0
                elseif j == 1 then
                    local team = team1
                elseif j == 2 then
                    local team = team2
                elseif j == 3 then
                    local team = team3
                end
                local num = i + 1
                -- switch on num
                if num == 1 then
                    local suffix = "st"
                elseif num == 2 then
                    local suffix = "nd"
                elseif num == 3 then
                    local suffix = "rd"
                else
                    local suffix = "th"
                end
                self.room:find_actor("teamdominationmc"):command("gossip " .. team .. " infiltrates the " .. num .. suffix .. " " .. pylonname .. "!  1 minute to capture!")
                self.room:send("Team Domination countdown started for pylon " .. tostring(i) .. "'s capture by team " .. tostring(j) .. ".")
                return _return_value
            end
            local j = j + 1
            if j >= teams then
                trigger_log("TD Error: Bad team identifier to WR Countdown trigger")
            end
            return _return_value
        end
        local i = i + 1
        if i >= pylons then
            trigger_log("TD Error: Bad pylon identifier to WR Countdown trigger")
        end
    end  -- auto-close block
end  -- auto-close block