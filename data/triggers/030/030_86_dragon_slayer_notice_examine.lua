-- Trigger: Dragon Slayer notice examine
-- Zone: 30, ID: 86
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3086

-- Converted from DG Script #3086: Dragon Slayer notice examine
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: examine
if not (cmd == "examine") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
local stage
local victim1
local go
if arg == "notice" then
    -- switch on self.id
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
    end
else
    _return_value = true
    return _return_value
end
actor:send("This is a notice to slay " .. tostring(victim1) .. ".")
-- TODO(parity): legacy DG had `stage` template-replaced; comparing against
-- literal "stage" never matches. Should be `actor:get_quest_stage("dragon_slayer") == stage`.
if actor:get_quest_var("dragon_slayer:hunt") == "dead" and actor:get_quest_stage("dragon_slayer") == stage then
    actor:send("You have completed the hunt.")
    actor:send("Return the notice to Isilynor for your reward!")
end
return _return_value