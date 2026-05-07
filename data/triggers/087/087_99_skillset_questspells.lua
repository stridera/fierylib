-- Trigger: skillset_questspells
-- Zone: 87, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8799
--
-- TODO(parity): same broken state machine as #8797/#8798 -- block-scoped `local`,
-- `globals.X = globals.X or true` storing booleans, and literal "%skill%"
-- being passed to skills.set_level. Full rewrite needed; body left as
-- converted output for traceability.

-- Converted from DG Script #8799: skillset_questspells
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel banish blur charm creeping plane heavens dragons flood hell hellfire ice major relocate meteorswarm resurrect shift degeneration supernova wall vaporform word wizard aria seed apocalyptic group
local speech_lower = string.lower(speech)
if not (string.find(speech_lower,"skillset") or string.find(speech_lower,"ready") or string.find(speech_lower,"go") or string.find(speech_lower,"cancel") or string.find(speech_lower,"banish") or string.find(speech_lower,"blur") or string.find(speech_lower,"charm") or string.find(speech_lower,"creeping") or string.find(speech_lower,"plane") or string.find(speech_lower,"heavens") or string.find(speech_lower,"dragons") or string.find(speech_lower,"flood") or string.find(speech_lower,"hell") or string.find(speech_lower,"hellfire") or string.find(speech_lower,"ice") or string.find(speech_lower,"major") or string.find(speech_lower,"relocate") or string.find(speech_lower,"meteorswarm") or string.find(speech_lower,"resurrect") or string.find(speech_lower,"shift") or string.find(speech_lower,"degeneration") or string.find(speech_lower,"supernova") or string.find(speech_lower,"wall") or string.find(speech_lower,"vaporform") or string.find(speech_lower,"word") or string.find(speech_lower,"wizard") or string.find(speech_lower,"aria") or string.find(speech_lower,"seed") or string.find(speech_lower,"apocalyptic") or string.find(speech_lower,"group")) then
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