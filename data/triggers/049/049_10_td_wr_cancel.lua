-- Trigger: TD WR Cancel
-- Zone: 49, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #4910

-- Converted from DG Script #4910: TD WR Cancel
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: TDCommand Cancel
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tdcommand") or string.find(string.lower(speech), "cancel")) then
    return true  -- No matching keywords
end
-- Team Domination War Room Cancel (Speech) Trigger
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
                self.room:find_actor("teamdominationmc"):command("gossip " .. team .. " disrupts the countdown for " .. pylonname .. " " .. num .. "'s capture!")
                self.room:send("Team Domination countdown cancelled for pylon " .. tostring(i) .. "'s capture.")
                return _return_value
            end
            local j = j + 1
        end
        if j >= teams then
            trigger_log("TD Error: Bad team identifier to WR Cancel trigger")
        end
        return _return_value
    end
    local i = i + 1
    if i >= pylons then
        trigger_log("TD Error: Bad pylon identifier to WR Cancel trigger")
    end
end  -- auto-close block