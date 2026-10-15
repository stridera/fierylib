-- Trigger: Ranger Trophy Pumahl speech skill
-- Zone: 53, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `_return_value` is referenced in the early returns but never defined.
-- Full rewrite from DG #5317.
--
-- Original DG Script: #5317

-- Converted from DG Script #5317: Ranger Trophy Pumahl speech skill
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
for _, w in ipairs({"skill"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local trophystage = actor:get_quest_stage("ranger_trophy")
local huntstage = actor:get_quest_stage("beast_master")
local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
wait(0.2)
if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "berserker" and actor.class ~= "mercenary" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only warriors, rangers, berserkers, and mercenaries possess the skills required for this.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (trophystage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("ranger_trophy") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
    return _return_value
end
if trophystage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a great beast first though.'")
    return _return_value
elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old trophy.'")
    return _return_value
end
-- switch on trophystage
local place, hint
local trophy, gem
do
    local _sw1 = string.lower(tostring(trophystage or ""))
    if tonumber(_sw1) == 1 then
        trophy = 1607
        gem = 55579
        place = "A Coyote's Den"
        hint = "near the Kingdom of the Meer Cats."
    elseif tonumber(_sw1) == 2 then
        trophy = 17806
        gem = 55591
        place = "In the Lions' Den"
        hint = "in the western reaches of Gothra."
    elseif tonumber(_sw1) == 3 then
        trophy = 1805
        gem = 55628
        place = "either of the two Gigantic Roc Nests"
        hint = "in the Wailing Mountains."
    elseif tonumber(_sw1) == 4 then
        trophy = 62513
        gem = 55652
        place = "Chieftain's Lair"
        hint = "in Nukreth Spire in South Caelia."
    elseif tonumber(_sw1) == 5 then
        trophy = 23803
        gem = 55664
        place = "The Heart of the Den"
        hint = "where the oldest unicorn in South Caelia makes its home."
    elseif tonumber(_sw1) == 6 then
        trophy = 43009
        gem = 55685
        place = "Giant Lynx's Lair"
        hint = "far to the north beyond Mt. Frostbite."
    elseif tonumber(_sw1) == 7 then
        trophy = 47008
        gem = 55705
        place = "Giant Griffin's Nest"
        hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif tonumber(_sw1) == 8 then
        trophy = 53323
        gem = 55729
        place = "Witch's Den"
        hint = "entombed with an ancient evil king."
    elseif tonumber(_sw1) == 9 then
        trophy = 52014
        gem = 55741
        place = "Dargentan's Lair"
        hint = "at the pinnacle of his flying fortress."
    end
end
local attacks = trophystage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act mission you'll earn a new trophy.  Undertake the following:")
actor:send("- Attack <b:green>" .. tostring(attacks) .. "</> times while wearing your current trophy.")
actor:send("- Find <b:green>" .. proto_short(trophy) .. "</> as another demonstration of mastery over the beasts of the wild.")
actor:send("- Find <b:green>" .. proto_short(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your trophy and <b:green>[forage]</> in a great beast's home.")
actor:send("Find \"<b:green>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")