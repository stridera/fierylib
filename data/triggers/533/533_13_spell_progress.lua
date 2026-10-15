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

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

local stage = actor:get_quest_stage("wall_ice")
if stage == 1 then
    local have = tonumber(actor:get_quest_var("wall_ice:blocks")) or 0
    local need = 20 - have
    wait(0.2)
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