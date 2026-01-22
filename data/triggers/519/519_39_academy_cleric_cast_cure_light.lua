-- Trigger: academy_cleric_cast_cure_light
-- Zone: 519, ID: 39
-- Type: MOB, Flags: CAST
-- Status: CLEAN
--
-- Original DG Script: #51939

-- Converted from DG Script #51939: academy_cleric_cast_cure_light
-- Original: MOB trigger, flags: CAST, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:fight") == 2 and spell == "cure light" then
    actor:set_quest_var("school", "fight", 3)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You're a natural healer!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Once you cast a spell, the spell slot it used will automatically begin to <b:cyan>RECOVER</>.")
    actor:send("The amount of time a spell slot takes to recover depends on the Circle of spell slot, your <b:cyan>FOCUS</> score, and whether or not you <b:cyan>MEDITATE</>.")
    actor:send("Spell slots recover <b:yellow>in the order they were used</>.")
    actor:send("</>")
    actor:send("<b:cyan>FOCUS</> is a bonus gained from equipment and your Intelligence and Wisdom stats.")
    actor:send("You can see your <b:cyan>FOCUS</> score using the <b:cyan>SCORE</> command.")
    actor:send("</>")
    actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
    actor:send("<b:magenta>1. How many spell slots you have")
    actor:send("2. Which spell slots you've used")
    actor:send("3. How long each slot will take to recover</>")
    actor:send("</>")
    actor:send("Check your current recovery status by typing <b:green>study</> now.'")
end
_return_value = false
return _return_value