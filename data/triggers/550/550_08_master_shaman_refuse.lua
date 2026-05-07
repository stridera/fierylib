-- Trigger: Master Shaman refuse
-- Zone: 550, ID: 8
-- Type: MOB, Flags: RECEIVE
--
-- Default refusal handler: when the Master Shaman is given an item that
-- doesn't match the current Wizard Eye stage's expected ingredient, she
-- refuses it with a stage-appropriate quip.
--
-- TODO(parity): the legacy script also short-circuited for the wand-quest
-- items (`%wandgem%`, `%wand_id%`, `%wandtask3%`). Those identifiers were
-- DG-script substitutions whose runtime values were never captured during
-- conversion, so the wand-specific allow-through is omitted; this trigger
-- only handles the wizard_eye refusal text now.
--
-- Original DG Script: #55008

-- Converted from DG Script #55008: Master Shaman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local stage = actor:get_quest_stage("wizard_eye")
local desc = tostring(object.shortdesc)
local response
if stage == 2 then
    response = "Is " .. desc .. " really what she sent you to find?"
elseif stage == 5 or stage == 8 then
    response = "Is " .. desc .. " really what she suggested you use?"
elseif stage == 11 then
    response = "What?  " .. desc .. "?  This can't be right."
else
    response = "What is this?"
end
self:command("eye " .. tostring(actor.name))
actor:send(tostring(self.name) .. " says, '" .. response .. "'")
self.room:send(tostring(self.name) .. " refuses " .. desc .. ".")
return true