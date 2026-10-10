-- Trigger: skillset_skills_H-V
-- Zone: 87, ID: 98
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8798
--
-- Staff skill-granting helper (H-V). Walks a small conversation, with its
-- state kept on the mob (`command`, `skill`, `mortal`):
--   imm says "skillset"          -> the mob asks which skill to set
--   anyone says a skill name     -> the mob remembers it and asks the mortal to say "ready"
--   anyone says "ready"          -> the mob remembers who is ready and asks the imm for "go"
--   an imm (level 101+) says "go" -> the skill is granted; "cancel" starts over
--
-- The legacy script ran the staff `mskillset` command, which the script-origin
-- gate refuses; the grant is now `mortal:set_skill(skill, 1000)` (1000 = the
-- legacy "max proficiency" mskillset gave). The converter's version kept its
-- state in block-scoped locals and passed a literal "%skill%", so it never
-- worked, and it fired on 1% of speech (the DG argument 1 means "match whole
-- words"). Both are fixed here: keywords match whole words, every time.

local KEYWORDS = {
    ["skillset"] = true, ["ready"] = true, ["go"] = true, ["cancel"] = true, ["hide"] = true,
    ["hitall"] = true, ["instant"] = true, ["kick"] = true, ["meditate"] = true,
    ["mount"] = true, ["pick"] = true, ["parry"] = true, ["piercing"] = true, ["quick"] = true,
    ["rescue"] = true, ["retreat"] = true, ["riding"] = true, ["safefall"] = true,
    ["scribe"] = true, ["riposte"] = true, ["shadow"] = true, ["shape"] = true,
    ["slashing"] = true, ["sneak"] = true, ["spell"] = true, ["sphere"] = true,
    ["springleap"] = true, ["steal"] = true, ["stealth"] = true, ["summon"] = true,
    ["switch"] = true, ["tame"] = true, ["throatcut"] = true, ["track"] = true, ["vamp"] = true,
}

local said = string.lower(speech)
local heard = false
for word in string.gmatch(said, "[%w']+") do
    if KEYWORDS[word] then
        heard = true
        break
    end
end
if not heard then
    return true  -- No matching keywords
end
wait(1)

local command = self:getvar("command")
local skill = self:getvar("skill")
local mortal = self:getvar("mortal")

local function start_over()
    self:clearvar("command")
    self:clearvar("skill")
    self:clearvar("mortal")
end

if skill and mortal and command then
    if said == "go" and actor.level >= 101 then
        local target = find_player(mortal)
        if target and target.is_player and target:set_skill(skill, 1000) then
            self:say("Done. Did it work?")
        else
            self:say("I could not set " .. tostring(skill) .. " on " .. tostring(mortal) .. ".")
        end
        start_over()
    elseif said == "cancel" then
        self:say("Ok, lets start over, starting with the command..")
        start_over()
    end
elseif skill and command then
    self:setvar("mortal", actor.name)
    self:say("Ok, imm, if you want to " .. tostring(command) .. " " .. tostring(skill) .. " to " .. tostring(actor.name) .. ", just say go!")
elseif command then
    if said == "ready" or said == "go" or said == "cancel" or said == "skillset" then
        return true  -- Not a skill name
    end
    self:say("Ok, I'll be " .. tostring(command) .. "ing " .. tostring(speech) .. ".")
    self:say("Mortal, if you are ready to get " .. tostring(speech) .. ", say \"ready\".")
    self:setvar("skill", speech)
elseif said == "skillset" then
    self:setvar("command", "mskillset")
    self:say("what skill will I be setting?")
end
return true
