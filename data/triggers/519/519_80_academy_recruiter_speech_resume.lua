-- Trigger: academy_recruiter_speech_resume
-- Zone: 519, ID: 80
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51980

-- Converted from DG Script #51980: academy_recruiter_speech_resume
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"resume"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
local stage = actor:get_quest_stage("school")
if actor:get_has_completed("school") or stage == 0 then
    return true
end
-- Declared up front: the DG `set` variables are read after the switch below.
local lesson
local holding
local direction
-- switch on actor:get_quest_stage("school")
if stage == 1 then
    lesson = "<b:yellow>COMMUNICATION</>, <b:yellow>GEAR</>, and <b:yellow>EXPLORATION</>"
    holding = 0
    direction = "east"
    self:command("unlock gates")
    self:command("open gates")
elseif stage == 2 then
    lesson = "<b:yellow>HIT POINTS</> and <b:yellow>SCORE</>"
    holding = 9
    direction = "east"
elseif stage == 3 or stage == 4 then
    if stage == 3 then
        lesson = "<b:yellow>COMBAT</>"
    elseif stage == 4 then
        lesson = "<b:yellow>LOOT</> and <b:yellow>TOGGLES</>"
    end
    -- switch on actor.class
    local class_lower = string.lower(tostring(actor.class or ""))
    if class_lower == "rogue" or class_lower == "thief" or class_lower == "assassin" or class_lower == "mercenary" or class_lower == "bard" then
        direction = "down"
    elseif class_lower == "sorcerer" or class_lower == "cryomancer" or class_lower == "pyromancer" or class_lower == "necromancer" or class_lower == "illusionist" then
        direction = "south"
    elseif class_lower == "cleric" or class_lower == "priest" or class_lower == "diabolist" or class_lower == "druid" then
        direction = "east"
    elseif class_lower == "warrior" or class_lower == "paladin" or class_lower == "anti-paladin" or class_lower == "ranger" or class_lower == "monk" or class_lower == "berserker" then
        direction = "north"
    else
        actor:send(tostring(self.name) .. " tells you, 'I don't know how you got to this point.  Please find a god!'")
        return true
    end
    holding = 8
elseif stage == 5 then
    lesson = "<b:yellow>RESTING</> and <b:yellow>MONEY</>"
    holding = 10
    direction = "east"
elseif stage == 6 then
    lesson = "<b:yellow>LEVELING</>"
    holding = 10
    direction = "east"
end
actor:send(tostring(self.name) .. " tells you, 'You are taking lessons on " .. tostring(lesson) .. ".")
actor:send("Tutorial commands will appear <b:green>in green text</>.")
actor:send("Type those phrases <b:green>exactly</> as they appear to advance.")
actor:send("Remember, <b:green>spelling matters!!!</>.'")
actor:send(tostring(self.name) .. " escorts you into the Academy.")
actor:send("</>")
actor:send(tostring(self.name) .. " tells you, 'You can say <magenta>EXIT</> at any time to leave.'")
actor:teleport(get_room(519, holding))
get_room(519, holding):at(function()
    actor:command(direction)
end)
if stage == 1 then
    self:command("close gates")
    self:command("lock gates")
end
