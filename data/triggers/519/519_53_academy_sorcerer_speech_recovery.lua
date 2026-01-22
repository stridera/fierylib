-- Trigger: academy_sorcerer_speech_recovery
-- Zone: 519, ID: 53
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51953

-- Converted from DG Script #51953: academy_sorcerer_speech_recovery
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: recovery
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "recovery")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
if actor:get_quest_var("school:fight") == 8 then
    actor:set_quest_var("school", "fight", 9)
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