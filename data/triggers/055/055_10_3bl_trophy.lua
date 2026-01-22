-- Trigger: 3bl_trophy
-- Zone: 55, ID: 10
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #5510

-- Converted from DG Script #5510: 3bl_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: trophy trophies
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trophy") or string.find(string.lower(speech), "trophies")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local vnum_trophy1 = 5504
local vnum_trophy2 = 5506
local vnum_trophy3 = 5508
local vnum_trophy4 = 5510
local vnum_trophy5 = 5512
local vnum_trophy6 = 5514
local vnum_trophy7 = 5516
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Eldorian Guard you")
    actor:send("</>will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy1%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy2%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy3%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy4%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy5%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy6%]%")
    actor:send("- " .. "%get.obj_shortdesc[%vnum_trophy7%]%")
end