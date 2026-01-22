-- Trigger: skillset_skills_H-V
-- Zone: 87, ID: 98
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #8798

-- Converted from DG Script #8798: skillset_skills_H-V
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel hide hitall instant kick meditate  mount  pick parry piercing quick rescue  retreat riding safefall  scribe riposte shadow shape slashing sneak spell sphere springleap steal stealth summon switch tame throatcut track vamp
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skillset") or string.find(string.lower(speech), "ready") or string.find(string.lower(speech), "go") or string.find(string.lower(speech), "cancel") or string.find(string.lower(speech), "hide") or string.find(string.lower(speech), "hitall") or string.find(string.lower(speech), "instant") or string.find(string.lower(speech), "kick") or string.find(string.lower(speech), "meditate") or string.find(string.lower(speech), "mount") or string.find(string.lower(speech), "pick") or string.find(string.lower(speech), "parry") or string.find(string.lower(speech), "piercing") or string.find(string.lower(speech), "quick") or string.find(string.lower(speech), "rescue") or string.find(string.lower(speech), "retreat") or string.find(string.lower(speech), "riding") or string.find(string.lower(speech), "safefall") or string.find(string.lower(speech), "scribe") or string.find(string.lower(speech), "riposte") or string.find(string.lower(speech), "shadow") or string.find(string.lower(speech), "shape") or string.find(string.lower(speech), "slashing") or string.find(string.lower(speech), "sneak") or string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "sphere") or string.find(string.lower(speech), "springleap") or string.find(string.lower(speech), "steal") or string.find(string.lower(speech), "stealth") or string.find(string.lower(speech), "summon") or string.find(string.lower(speech), "switch") or string.find(string.lower(speech), "tame") or string.find(string.lower(speech), "throatcut") or string.find(string.lower(speech), "track") or string.find(string.lower(speech), "vamp")) then
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