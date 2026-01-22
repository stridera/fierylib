-- Trigger: Monk Vision Hakujo speech vision
-- Zone: 53, ID: 41
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5341

-- Converted from DG Script #5341: Monk Vision Hakujo speech vision
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: vision enlightenment
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "vision") or string.find(string.lower(speech), "enlightenment")) then
    return true  -- No matching keywords
end
local visionstage = actor:get_quest_stage("monk_vision")
local missionstage = actor:get_quest_stage("elemental_chaos")
local job1 = actor:get_quest_var("monk_vision:visiontask1")
local job2 = actor:get_quest_var("monk_vision:visiontask2")
local job3 = actor:get_quest_var("monk_vision:visiontask3")
local job4 = actor:get_quest_var("monk_vision:visiontask4")
wait(2)
if actor.class ~= "Monk" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only monks have the mental fortitude to seek Enlightenment.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (visionstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another vision yet.  Come back when you've gained more experience.'")
    return _return_value
elseif actor:get_has_completed("monk_vision") then
    actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    return _return_value
end
if visionstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    return _return_value
elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'Just give me your current vision mark.'")
    return _return_value
end
-- switch on visionstage
if visionstage == 1 then
    local book = 59006
    local gem = 55582
    local room = get_room("4328")
    local place = room.name
    local hint = "in a place to perform."
elseif visionstage == 2 then
    local book = 18505
    local gem = 55591
    local room = get_room("58707")
    local place = room.name
    local hint = "near a sandy beach."
elseif visionstage == 3 then
    local book = 8501
    local gem = 55623
    local room = get_room("18597")
    local place = room.name
    local hint = "in a cloistered library."
elseif visionstage == 4 then
    local book = 12532
    local gem = 55655
    local room = get_room("58102")
    local place = room.name
    local hint = "on my home island."
elseif visionstage == 5 then
    local book = 16209
    local gem = 55665
    local room = get_room("16057")
    local place = room.name
    local hint = "in the ghostly fortress."
elseif visionstage == 6 then
    local book = 43013
    local gem = 55678
    local room = get_room("59054")
    local place = room.name
    local hint = "in the fortress of the zealous."
elseif visionstage == 7 then
    local book = 53009
    local gem = 55710
    local room = get_room("49079")
    local place = room.name
    local hint = "off-shore of the island of great beasts."
elseif visionstage == 8 then
    local book = 58415
    local gem = 55722
    local room = get_room("11820")
    local place = room.name
    local hint = "beyond the Blue-Fog Trail."
elseif visionstage == 9 then
    local book = 58412
    local gem = 55741
    local room = get_room("52075")
    local place = room.name
    local hint = "in the shattered citadel of Templace."
end
local attacks = visionstage * 100
self:command("nod")
if visionstage == 1 then
    actor:send(tostring(self.name) .. " says, 'You will undertake a series of vision quests, gathering esoteric works of philosophy, history, and magic.  With each vision quest you'll earn a new marking to signify your path toward Enlightenment.'")
    actor:send("</>")
end
actor:send(tostring(self.name) .. " says, 'For your vision quest do the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current vision marking.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> to awaken your Third Eye charka and <b:yellow>%get.obj_shortdesc[%book%]%</>.")
actor:send("- While donning your vision marking, take gem and text to a place of deep reflection and <b:yellow>[read]</> the text to broaden your awareness.")
actor:send("</>  Go to \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("Once you have, bring the gem, text, and your vision marking back to me.")
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")