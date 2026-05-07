-- Trigger: Dragon Slayer notice look
-- Zone: 30, ID: 85
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #3085

-- Converted from DG Script #3085: Dragon Slayer notice look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
local stage
local victim1
local go
if self.id == 3080 then
    stage = 1
    victim1 = "a dragon hedge"
    go = "hunt"
elseif self.id == 3081 then
    stage = 2
    victim1 = "the green wyrmling"
    go = "hunt"
elseif self.id == 3082 then
    stage = 3
    victim1 = "Wug the Fiery Drakling"
    go = "hunt"
elseif self.id == 3083 then
    stage = 4
    victim1 = "the young blue dragon"
    go = "hunt"
elseif self.id == 3084 then
    stage = 5
    victim1 = "a faerie dragon"
    go = "hunt"
elseif self.id == 3085 then
    stage = 6
    victim1 = "the wyvern"
    go = "hunt"
elseif self.id == 3086 then
    stage = 7
    victim1 = "an ice lizard"
    go = "hunt"
elseif self.id == 3087 then
    stage = 8
    victim1 = "the Beast of Borgan"
    go = "hunt"
elseif self.id == 3088 then
    stage = 9
    victim1 = "Tri-Aszp"
    go = "hunt"
elseif self.id == 3089 then
    stage = 10
    victim1 = "the Hydra"
    go = "hunt"
else
    return true
end
_return_value = true
actor:send("This is a notice to slay " .. tostring(victim1) .. ".")
-- TODO(parity): legacy DG had `stage` template-replaced; comparing against
-- literal "stage" never matches. Should be `actor:get_quest_stage("dragon_slayer") == stage`.
if actor:get_quest_var("dragon_slayer:hunt") == "dead" and actor:get_quest_stage("dragon_slayer") == stage then
    actor:send("You have completed the hunt.")
    actor:send("Return the notice to Isilynor for your reward!")
end
return _return_value