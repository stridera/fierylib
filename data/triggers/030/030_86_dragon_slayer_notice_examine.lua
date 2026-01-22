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
if arg == "notice" then
    -- switch on self.id
    if self.id == 3080 then
        local stage = 1
        local victim1 = "a dragon hedge"
        local go = "hunt"
    elseif self.id == 3081 then
        local stage = 2
        local victim1 = "the green wyrmling"
        local go = "hunt"
    elseif self.id == 3082 then
        local stage = 3
        local victim1 = "Wug the Fiery Drakling"
        local go = "hunt"
    elseif self.id == 3083 then
        local stage = 4
        local victim1 = "the young blue dragon"
        local go = "hunt"
    elseif self.id == 3084 then
        local stage = 5
        local victim1 = "a faerie dragon"
        local go = "hunt"
    elseif self.id == 3085 then
        local stage = 6
        local victim1 = "the wyvern"
        local go = "hunt"
    elseif self.id == 3086 then
        local stage = 7
        local victim1 = "an ice lizard"
        local go = "hunt"
    elseif self.id == 3087 then
        local stage = 8
        local victim1 = "the Beast of Borgan"
        local go = "hunt"
    elseif self.id == 3088 then
        local stage = 9
        local victim1 = "Tri-Aszp"
        local go = "hunt"
    elseif self.id == 3089 then
        local stage = 10
        local victim1 = "the Hydra"
        local go = "hunt"
    end
else
    _return_value = false
    return _return_value
end
actor:send("This is a notice to slay " .. tostring(victim1) .. ".")
if actor:get_quest_var("dragon_slayer:hunt") == "dead" and actor:get_quest_stage("dragon_slayer") == "stage" then
    actor:send("You have completed the hunt.")
    actor:send("Return the notice to Isilynor for your reward!")
end
return _return_value