-- Trigger: Bounty hunt contract look
-- Zone: 60, ID: 55
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #6055

-- Converted from DG Script #6055: Bounty hunt contract look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
if self.id == 6050 then
    local stage = 1
    local victim1 = "the King of the Meer Cats"
    local go = "hunt"
elseif self.id == 6051 then
    local stage = 2
    local victim1 = "the Noble"
    local victim2 = "the Abbot"
    local go = "hunt"
elseif self.id == 6052 then
    local stage = 3
    local victim1 = "the O'Connor Chieftain"
    local victim2 = "the McLeod Chieftain"
    local victim3 = "the Cameron Chieftain"
    local go = "hunt"
elseif self.id == 6053 then
    local stage = 4
    local victim1 = "the Frakati Leader"
    local go = "hunt"
elseif self.id == 6054 then
    local stage = 5
    local victim1 = "Cyrus"
    local go = "hunt"
elseif self.id == 6055 then
    local stage = 6
    local victim1 = "Lord Venth"
    local go = "hunt"
elseif self.id == 6056 then
    local stage = 7
    local victim1 = "the high druid of Anlun Vale"
    local go = "hunt"
elseif self.id == 6057 then
    local stage = 8
    local victim1 = "the Lizard King"
    local go = "hunt"
elseif self.id == 6058 then
    local stage = 9
    local victim1 = "Sorcha"
    local go = "hunt"
elseif self.id == 6059 then
    local stage = 10
    local victim1 = "the Goblin King"
    local go = "hunt"
end
_return_value = false
if stage ~= 2 and stage ~= 3 then
    actor:send("This is a contract for the death of " .. tostring(victim1) .. ".")
elseif stage == 2 then
    actor:send("This is a contract for the death of " .. tostring(victim1) .. " and " .. tostring(victim2) .. ".")
elseif stage == 3 then
    actor:send("This is a contract for the death of " .. tostring(victim1) .. ", " .. tostring(victim2) .. ", and " .. tostring(victim3) .. ".")
end
if actor:get_quest_var("bounty_hunt:bounty") == "dead" then
    actor:send("You have completed the contract.")
    actor:send("Return it to Berix for your payment!")
elseif stage == 2 then
    if actor:get_quest_var("bounty_hunt:target1") then
        actor:send("You have scratched " .. tostring(victim1) .. " off the list.")
    end
    if actor:get_quest_var("bounty_hunt:target2") then
        actor:send("You have scratched " .. tostring(victim2) .. " off the list.")
    end
elseif stage == 3 then
    if actor:get_quest_var("bounty_hunt:target1") then
        actor:send("You have scratched " .. tostring(victim1) .. " off the list.")
    end
    if actor:get_quest_var("bounty_hunt:target2") then
        actor:send("You have scratched " .. tostring(victim2) .. " off the list.")
    end
    if actor:get_quest_var("bounty_hunt:target3") then
        actor:send("You have scratched " .. tostring(victim3) .. " off the list.")
    end
end
return _return_value