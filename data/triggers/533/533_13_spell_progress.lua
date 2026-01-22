-- Trigger: spell progress
-- Zone: 533, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53313

-- Converted from DG Script #53313: spell progress
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("wall_ice") == 1 then
    local have = actor:get_quest_var("wall_ice:blocks")
    local need = (20 - have)
    wait(2)
    self:say("Let me see...")
    self.room:send(tostring(self.name) .. " counts the number of blocks.")
    wait(2)
    self:say("You have brought me <b:cyan>" .. tostring(have) .. " blocks of living ice.</>")
    -- (empty room echo)
    self:say("I still need <b:cyan>" .. tostring(need) .. "</> more.")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you need a new copy of the spell of living ice, say \"<b:cyan>please replace the spell</>\".'")
elseif actor:get_has_completed("wall_ice") then
    self:say("We've already completed the repairs here.  Good work!")
elseif not actor:get_quest_stage("wall_ice") then
    self:say("Did you want to help me work?")
end