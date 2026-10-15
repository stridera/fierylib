-- Trigger: Paladin pendant Isilynor speech
-- Zone: 30, ID: 87
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3087

-- Converted from DG Script #3087: Paladin pendant Isilynor speech
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
for _, w in ipairs({"devotion"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
local huntstage = actor:get_quest_stage("dragon_slayer")
local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
wait(0.2)
if actor.class ~= "paladin" and actor.class ~= "anti-paladin" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Such acts are only for warriors of Justice or Destruction.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (pendantstage * 10) then
    self:say("You aren't ready for another devotional act yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("paladin_pendant") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
    return _return_value
end
if pendantstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a dragon first though.'")
    return _return_value
elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old necklace.'")
    return _return_value
end
-- switch on pendantstage
local place, hint
local necklace, gem
do
    local _sw1 = string.lower(tostring(pendantstage or ""))
    if tonumber(_sw1) == 1 then
        necklace = 12003
        gem = 55582
        place = "The Mist Temple Altar"
        hint = "in the Misty Caverns."
    elseif tonumber(_sw1) == 2 then
        necklace = 23708
        gem = 55590
        place = "Chamber of Chaos"
        hint = "in the Temple of Chaos."
    elseif tonumber(_sw1) == 3 then
        necklace = 58005
        gem = 55622
        place = "Altar of Borgan"
        hint = "in the lost city of Nymrill."
    elseif tonumber(_sw1) == 4 then
        necklace = 48123
        gem = 55654
        place = "A Hidden Altar Room"
        hint = "in a cave in South Caelia's Wailing Mountains."
    elseif tonumber(_sw1) == 5 then
        necklace = 12336
        gem = 55662
        place = "The Altar of the Snow Leopard Order"
        hint = "buried deep in Mt. Frostbite"
    elseif tonumber(_sw1) == 6 then
        necklace = 43019
        gem = 55677
        place = "Chapel Altar"
        hint = "deep underground in a lost castle."
    elseif tonumber(_sw1) == 7 then
        necklace = 37015
        gem = 55709
        place = "A Cliffside Altar"
        hint = "tucked away in the land of Dreams."
    elseif tonumber(_sw1) == 8 then
        necklace = 58429
        gem = 55738
        place = "Dark Altar"
        hint = "entombed with an ancient evil king."
    elseif tonumber(_sw1) == 9 then
        necklace = 52010
        gem = 55739
        place = "An Altar"
        hint = "far away in the Plane of Air."
    end
end
local attacks = pendantstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act of devotion you'll earn a new necklace.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current necklace.")
actor:send("- Find <b:yellow>" .. proto_short(necklace) .. "</> as the base for the new necklace.")
actor:send("- Find <b:yellow>" .. proto_short(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your necklace and <b:yellow>[pray]</> in a sanctified space.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")