-- Trigger: Master Shaman refuse
-- Zone: 550, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <Master Shaman refuse>:13: 'end' expected (to close 'if' at line 11) near 'if'
--   Complex nesting: 8 if statements
--
-- Original DG Script: #55008

-- Converted from DG Script #55008: Master Shaman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("wizard_eye")
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wand_id%" or object.id == "%wandtask3%" then
    -- The converter generated a dead-code `if stage == N then
    -- elseif object.id == ... then return` block per stage after
    -- this early-return — unreachable, and the converter left
    -- the `if X then` branches with empty bodies. TODO(parity):
    -- restore the per-stage refusal text from the legacy DG
    -- script.
    return _return_value
end
if stage == 2 then
    local response = "Is object.shortdesc really what she sent you to find?"
elseif stage == 5 or stage == 8 then
    local response = "Is object.shortdesc really what she suggested you use?"
elseif stage == 11 then
    local response = "What?  object.shortdesc?  This can't be right."
else
    local response = "What is this?"
end
if response then
    _return_value = true
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value