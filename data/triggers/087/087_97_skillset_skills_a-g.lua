-- Trigger: skillset_skills_A-G
-- Zone: 87, ID: 97
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8797
--
-- TODO(parity): converter produced a broken state machine. Issues:
--   (1) `local skill = speech` / `local mortal = actor.name` / `local command = "mskillset"`
--       are block-scoped so the branches that "save" state never persist past the
--       end of this script invocation. They should write to `globals.*`.
--   (2) `globals.skill = globals.skill or true` saves boolean true instead of
--       the speech value. Should be `globals.skill = speech` etc.
--   (3) `skills.set_level(mortal, "%skill%", 100)` passes the literal string
--       "%skill%" instead of the saved skill name.
--   (4) Branch reads of `skill`, `mortal`, `command` are bare globals not
--       routed through the `globals` table.
-- Full rewrite needed. Body left as converted output for traceability.

-- Converted from DG Script #8797: skillset_skills_A-G
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: skillset ready go cancel 2H backstab bandage barehand bash bludgeoning bodyslam chant conceal corner  disarm dodge doorbash double douse dual eye first group guard
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "skillset") or string.find(speech_lower, "ready") or string.find(speech_lower, "go") or string.find(speech_lower, "cancel") or string.find(speech_lower, "2h") or string.find(speech_lower, "backstab") or string.find(speech_lower, "bandage") or string.find(speech_lower, "barehand") or string.find(speech_lower, "bash") or string.find(speech_lower, "bludgeoning") or string.find(speech_lower, "bodyslam") or string.find(speech_lower, "chant") or string.find(speech_lower, "conceal") or string.find(speech_lower, "corner") or string.find(speech_lower, "disarm") or string.find(speech_lower, "dodge") or string.find(speech_lower, "doorbash") or string.find(speech_lower, "double") or string.find(speech_lower, "douse") or string.find(speech_lower, "dual") or string.find(speech_lower, "eye") or string.find(speech_lower, "first") or string.find(speech_lower, "group") or string.find(speech_lower, "guard")) then
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
