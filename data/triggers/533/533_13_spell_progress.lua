-- Trigger: spell progress
-- Zone: 533, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53313
--
-- Player asks for "status" or "progress" -- sculptor reports how many
-- blocks of living ice the player has delivered toward the wall_ice
-- quest, or notes the quest is finished, or invites them to help.
--
-- Original DG had probability 0% (synthetic gate); removed because
-- speech triggers fire on keyword match, not random roll.

-- Speech keywords: status, progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end

local stage = actor:get_quest_stage("wall_ice")
if stage == 1 then
    local have = tonumber(actor:get_quest_var("wall_ice:blocks")) or 0
    local need = 20 - have
    wait(2)
    self:say("Let me see...")
    self.room:send(tostring(self.name) .. " counts the number of blocks.")
    wait(2)
    self:say("You have brought me <b:cyan>" .. tostring(have) .. " blocks of living ice.</>")
    self:say("I still need <b:cyan>" .. tostring(need) .. "</> more.")
    self.room:send(tostring(self.name) .. " says, 'If you need a new copy of the spell of living ice, say \"<b:cyan>please replace the spell</>\".'")
elseif actor:get_has_completed("wall_ice") then
    self:say("We've already completed the repairs here.  Good work!")
else
    self:say("Did you want to help me work?")
end