-- Trigger: 3eg_trophy
-- Zone: 41, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #4109

-- Converted from DG Script #4109: 3eg_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: trophy trophies
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trophy") or string.find(string.lower(speech), "trophies")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- Trophy vnums are all in zone 55
local trophy1_zone, trophy1_local = 55, 3
local trophy2_zone, trophy2_local = 55, 5
local trophy3_zone, trophy3_local = 55, 7
local trophy4_zone, trophy4_local = 55, 9
local trophy5_zone, trophy5_local = 55, 11
local trophy6_zone, trophy6_local = 55, 13
local trophy7_zone, trophy7_local = 55, 15
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of the Black Legion")
    actor:send("</>you will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. objects.template_name(trophy1_zone, trophy1_local))
    actor:send("- " .. objects.template_name(trophy2_zone, trophy2_local))
    actor:send("- " .. objects.template_name(trophy3_zone, trophy3_local))
    actor:send("- " .. objects.template_name(trophy4_zone, trophy4_local))
    actor:send("- " .. objects.template_name(trophy5_zone, trophy5_local))
    actor:send("- " .. objects.template_name(trophy6_zone, trophy6_local))
    actor:send("- " .. objects.template_name(trophy7_zone, trophy7_local))
end