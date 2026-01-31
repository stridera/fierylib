-- Trigger: 3bl_trophy
-- Zone: 41, ID: 10
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #4110

-- Converted from DG Script #4110: 3bl_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: trophy trophies
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trophy") or string.find(string.lower(speech), "trophies")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- Trophy vnums are all in zone 55
local trophy1_zone, trophy1_local = 55, 4
local trophy2_zone, trophy2_local = 55, 6
local trophy3_zone, trophy3_local = 55, 8
local trophy4_zone, trophy4_local = 55, 10
local trophy5_zone, trophy5_local = 55, 12
local trophy6_zone, trophy6_local = 55, 14
local trophy7_zone, trophy7_local = 55, 16
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of Eldorian Guard")
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