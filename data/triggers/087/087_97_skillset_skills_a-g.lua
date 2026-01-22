-- Trigger: skillset_skills_A-G
-- Zone: 87, ID: 97
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #8797

-- Converted from DG Script #8797: skillset_skills_A-G
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel 2H backstab bandage barehand bash bludgeoning bodyslam chant conceal corner  disarm dodge doorbash double douse dual eye first group guard
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skillset") or string.find(string.lower(speech), "ready") or string.find(string.lower(speech), "go") or string.find(string.lower(speech), "cancel") or string.find(string.lower(speech), "2h") or string.find(string.lower(speech), "backstab") or string.find(string.lower(speech), "bandage") or string.find(string.lower(speech), "barehand") or string.find(string.lower(speech), "bash") or string.find(string.lower(speech), "bludgeoning") or string.find(string.lower(speech), "bodyslam") or string.find(string.lower(speech), "chant") or string.find(string.lower(speech), "conceal") or string.find(string.lower(speech), "corner") or string.find(string.lower(speech), "disarm") or string.find(string.lower(speech), "dodge") or string.find(string.lower(speech), "doorbash") or string.find(string.lower(speech), "double") or string.find(string.lower(speech), "douse") or string.find(string.lower(speech), "dual") or string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "first") or string.find(string.lower(speech), "group") or string.find(string.lower(speech), "guard")) then
    return true  -- No matching keywords
end
wait(1)
if skill and mortal and command then
    if speech == "go" and actor.level >= 101 then
        skills.set_level(mortal, "%skill%", 100)
        self:say("Done. Did it work?")
    elseif speech == "cancel" then
        self:say("Ok, lets start over, starting with the command..")
    end
    command = nil
    mortal = nil
    skill = nil
elseif skill and command then
    local mortal = actor.name
    globals.mortal = globals.mortal or true
    self:say("Ok, imm, if you want to " .. tostring(command) .. " " .. tostring(skill) .. " to " .. tostring(mortal) .. ", just say go!")
elseif command then
    self:say("Ok, I'll be " .. tostring(command) .. "ing " .. tostring(speech) .. ".")
    self:say("Mortal, if you are ready to get " .. tostring(speech) .. ", say \"ready\".")
    local skill = speech
    globals.skill = globals.skill or true
elseif speech == "skillset" then
    local command = "mskillset"
    globals.command = globals.command or true
    self:say("what skill will I be setting?")
end