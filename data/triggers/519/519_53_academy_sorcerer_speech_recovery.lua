-- Trigger: academy_sorcerer_speech_recovery
-- Zone: 519, ID: 53
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51953

-- Converted from DG Script #51953: academy_sorcerer_speech_recovery
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"recovery"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
if (actor:get_quest_var("school:fight") or 0) == 8 then
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
_return_value = true
return _return_value