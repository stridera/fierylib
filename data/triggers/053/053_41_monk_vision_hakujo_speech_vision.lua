-- Trigger: Monk Vision Hakujo speech vision
-- Zone: 53, ID: 41
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `get_room("4328")` is called with a 5-digit string
-- vnum — the API requires `(zone, id)`. `_return_value` referenced
-- but never defined. Full rewrite from DG #5341.
--
-- Original DG Script: #5341

-- Converted from DG Script #5341: Monk Vision Hakujo speech vision
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"vision", "enlightenment"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local visionstage = actor:get_quest_stage("monk_vision")
local missionstage = actor:get_quest_stage("elemental_chaos")
local job1 = actor:get_quest_var("monk_vision:visiontask1")
local job2 = actor:get_quest_var("monk_vision:visiontask2")
local job3 = actor:get_quest_var("monk_vision:visiontask3")
local job4 = actor:get_quest_var("monk_vision:visiontask4")
wait(0.2)
if actor.class ~= "monk" then
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
local place, hint
local gem, book
do
    local _sw1 = string.lower(tostring(visionstage or ""))
    if tonumber(_sw1) == 1 then
        book = 59006
        gem = 55582
        local room = get_room("4328")
        place = room.name
        hint = "in a place to perform."
    elseif tonumber(_sw1) == 2 then
        book = 18505
        gem = 55591
        local room = get_room("58707")
        place = room.name
        hint = "near a sandy beach."
    elseif tonumber(_sw1) == 3 then
        book = 8501
        gem = 55623
        local room = get_room("18597")
        place = room.name
        hint = "in a cloistered library."
    elseif tonumber(_sw1) == 4 then
        book = 12532
        gem = 55655
        local room = get_room("58102")
        place = room.name
        hint = "on my home island."
    elseif tonumber(_sw1) == 5 then
        book = 16209
        gem = 55665
        local room = get_room("16057")
        place = room.name
        hint = "in the ghostly fortress."
    elseif tonumber(_sw1) == 6 then
        book = 43013
        gem = 55678
        local room = get_room("59054")
        place = room.name
        hint = "in the fortress of the zealous."
    elseif tonumber(_sw1) == 7 then
        book = 53009
        gem = 55710
        local room = get_room("49079")
        place = room.name
        hint = "off-shore of the island of great beasts."
    elseif tonumber(_sw1) == 8 then
        book = 58415
        gem = 55722
        local room = get_room("11820")
        place = room.name
        hint = "beyond the Blue-Fog Trail."
    elseif tonumber(_sw1) == 9 then
        book = 58412
        gem = 55741
        local room = get_room("52075")
        place = room.name
        hint = "in the shattered citadel of Templace."
    end
end
local attacks = visionstage * 100
self:command("nod")
if visionstage == 1 then
    actor:send(tostring(self.name) .. " says, 'You will undertake a series of vision quests, gathering esoteric works of philosophy, history, and magic.  With each vision quest you'll earn a new marking to signify your path toward Enlightenment.'")
    actor:send("</>")
end
actor:send(tostring(self.name) .. " says, 'For your vision quest do the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current vision marking.")
actor:send("- Find <b:yellow>" .. proto_short(gem) .. "</> to awaken your Third Eye charka and <b:yellow>" .. proto_short(book) .. "</>.")
actor:send("- While donning your vision marking, take gem and text to a place of deep reflection and <b:yellow>[read]</> the text to broaden your awareness.")
actor:send("</>  Go to \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("Once you have, bring the gem, text, and your vision marking back to me.")
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")