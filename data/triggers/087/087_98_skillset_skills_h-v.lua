-- Trigger: skillset_skills_H-V
-- Zone: 87, ID: 98
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8798
--
-- TODO(parity): same broken state machine as #8797 -- block-scoped `local`,
-- `globals.X = globals.X or true` storing booleans, and literal "%skill%"
-- being passed to skills.set_level. Full rewrite needed; body left as
-- converted output for traceability.

-- Converted from DG Script #8798: skillset_skills_H-V
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel hide hitall instant kick meditate  mount  pick parry piercing quick rescue  retreat riding safefall  scribe riposte shadow shape slashing sneak spell sphere springleap steal stealth summon switch tame throatcut track vamp
local speech_lower = string.lower(speech)
if not (string.find(speech_lower,"skillset") or string.find(speech_lower,"ready") or string.find(speech_lower,"go") or string.find(speech_lower,"cancel") or string.find(speech_lower,"hide") or string.find(speech_lower,"hitall") or string.find(speech_lower,"instant") or string.find(speech_lower,"kick") or string.find(speech_lower,"meditate") or string.find(speech_lower,"mount") or string.find(speech_lower,"pick") or string.find(speech_lower,"parry") or string.find(speech_lower,"piercing") or string.find(speech_lower,"quick") or string.find(speech_lower,"rescue") or string.find(speech_lower,"retreat") or string.find(speech_lower,"riding") or string.find(speech_lower,"safefall") or string.find(speech_lower,"scribe") or string.find(speech_lower,"riposte") or string.find(speech_lower,"shadow") or string.find(speech_lower,"shape") or string.find(speech_lower,"slashing") or string.find(speech_lower,"sneak") or string.find(speech_lower,"spell") or string.find(speech_lower,"sphere") or string.find(speech_lower,"springleap") or string.find(speech_lower,"steal") or string.find(speech_lower,"stealth") or string.find(speech_lower,"summon") or string.find(speech_lower,"switch") or string.find(speech_lower,"tame") or string.find(speech_lower,"throatcut") or string.find(speech_lower,"track") or string.find(speech_lower,"vamp")) then
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