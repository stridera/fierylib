-- Trigger: Bounty hunt contract look
-- Zone: 60, ID: 55
-- Type: OBJECT, Flags: LOOK
--
-- Original DG Script: #6055

-- Converted from DG Script #6055: Bounty hunt contract look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
-- Hoisted: branch-scoped `local` would not be visible to the code below.
local stage, victim1, victim2, victim3, go
if self.id == 6050 then
    stage = 1
    victim1 = "the King of the Meer Cats"
    go = "hunt"
elseif self.id == 6051 then
    stage = 2
    victim1 = "the Noble"
    victim2 = "the Abbot"
    go = "hunt"
elseif self.id == 6052 then
    stage = 3
    victim1 = "the O'Connor Chieftain"
    victim2 = "the McLeod Chieftain"
    victim3 = "the Cameron Chieftain"
    go = "hunt"
elseif self.id == 6053 then
    stage = 4
    victim1 = "the Frakati Leader"
    go = "hunt"
elseif self.id == 6054 then
    stage = 5
    victim1 = "Cyrus"
    go = "hunt"
elseif self.id == 6055 then
    stage = 6
    victim1 = "Lord Venth"
    go = "hunt"
elseif self.id == 6056 then
    stage = 7
    victim1 = "the high druid of Anlun Vale"
    go = "hunt"
elseif self.id == 6057 then
    stage = 8
    victim1 = "the Lizard King"
    go = "hunt"
elseif self.id == 6058 then
    stage = 9
    victim1 = "Sorcha"
    go = "hunt"
elseif self.id == 6059 then
    stage = 10
    victim1 = "the Goblin King"
    go = "hunt"
end
_return_value = true
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