-- Trigger: academy_recruiter_speech_resume
-- Zone: 519, ID: 80
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #51980

-- Converted from DG Script #51980: academy_recruiter_speech_resume
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: resume
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "resume")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("school") or not actor:get_quest_stage("school") then
    return _return_value
else
    -- switch on actor:get_quest_stage("school")
    if actor:get_quest_stage("school") == 1 then
        local lesson = "&3&bCOMMUNICATION&0, &3&bGEAR&0, and &3&bEXPLORATION&0"
        local holding = 51900
        local direction = "east"
        self:command("unlock gates")
        self:command("open gates")
    elseif actor:get_quest_stage("school") == 2 then
        local lesson = "&3&bHIT POINTS&0 and &3&bSCORE&0"
        local holding = 51909
        local direction = "east"
        if actor:get_quest_stage("school") == 3 then
        elseif actor:get_quest_stage("school") == 3 or actor:get_quest_stage("school") == 4 then
            local lesson = "&3&bCOMBAT&0"
        elseif actor:get_quest_stage("school") == 4 then
            local lesson = "&3&bLOOT&0 and &3&bTOGGLES&0"
        end
        -- switch on actor.class
        if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
            local direction = "down"
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
            local direction = "south"
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
            local direction = "east"
        elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
            local direction = "north"
        else
            actor:send(tostring(self.name) .. " tells you, 'I don't know how you got to this point.  Please find a god!'")
            return _return_value
        end
        local holding = 51908
        local lesson = "&3&bRESTING&0 and &3&bMONEY&0"
        local holding = 51910
        local direction = "east"
        local lesson = "&3&bLEVELING&0"
        local holding = 51910
        local direction = "east"
        actor:send(tostring(self.name) .. " tells you, 'You are taking lessons on " .. tostring(lesson) .. ".")
        actor:send("Tutorial commands will appear <b:green>in green text</>.")
        actor:send("Type those phrases <b:green>exactly</> as they appear to advance.")
        actor:send("Remember, <b:green>spelling matters!!!</>.'")
        actor:send(tostring(self.name) .. " escorts you into the Academy.")
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'You can say <magenta>EXIT</> at any time to leave.'")
        -- holding values: 51900, 51908, 51909, 51910 => zone 519, local ids 0, 8, 9, 10
        local holding_zone = 519
        local holding_local = holding % 100
        actor:teleport(get_room(holding_zone, holding_local))
        get_room(holding_zone, holding_local):at(function()
            actor:command("%direction%")
        end)
        if actor:get_quest_stage("school") == 1 then
            self:command("close gates")
            self:command("lock gates")
        end
    end
end  -- auto-close block