-- Trigger: skillset_questspells
-- Zone: 87, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #8799

-- Converted from DG Script #8799: skillset_questspells
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel banish blur charm creeping plane heavens dragons flood hell hellfire ice major relocate meteorswarm resurrect shift degeneration supernova wall vaporform word wizard aria seed apocalyptic group
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skillset") or string.find(string.lower(speech), "ready") or string.find(string.lower(speech), "go") or string.find(string.lower(speech), "cancel") or string.find(string.lower(speech), "banish") or string.find(string.lower(speech), "blur") or string.find(string.lower(speech), "charm") or string.find(string.lower(speech), "creeping") or string.find(string.lower(speech), "plane") or string.find(string.lower(speech), "heavens") or string.find(string.lower(speech), "dragons") or string.find(string.lower(speech), "flood") or string.find(string.lower(speech), "hell") or string.find(string.lower(speech), "hellfire") or string.find(string.lower(speech), "ice") or string.find(string.lower(speech), "major") or string.find(string.lower(speech), "relocate") or string.find(string.lower(speech), "meteorswarm") or string.find(string.lower(speech), "resurrect") or string.find(string.lower(speech), "shift") or string.find(string.lower(speech), "degeneration") or string.find(string.lower(speech), "supernova") or string.find(string.lower(speech), "wall") or string.find(string.lower(speech), "vaporform") or string.find(string.lower(speech), "word") or string.find(string.lower(speech), "wizard") or string.find(string.lower(speech), "aria") or string.find(string.lower(speech), "seed") or string.find(string.lower(speech), "apocalyptic") or string.find(string.lower(speech), "group")) then
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