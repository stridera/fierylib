-- Trigger: Emmath receive decline
-- Zone: 52, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5216

-- Converted from DG Script #5216: Emmath receive decline
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
    local response = I asked you to bring me the actor:get_quest_var("pyromancer_subclass:part") flame, not this nonsense.
elseif actor.quest_stage[type_wand] == "step" then
    local response = "I can't craft with this!"
elseif %actor.quest_stage[emmath_flameball] > 1 then
    local response = "You're supposed to be out collecting flames, not whatever this is."
else
    local response = "Why are you bringing me this trash?"
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value