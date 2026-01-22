-- Trigger: Ranger Trophy Pumahl speech skill
-- Zone: 53, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5317

-- Converted from DG Script #5317: Ranger Trophy Pumahl speech skill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skill
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skill")) then
    return true  -- No matching keywords
end
local trophystage = actor:get_quest_stage("ranger_trophy")
local huntstage = actor:get_quest_stage("beast_master")
local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
wait(2)
if actor.class ~= "Warrior" and actor.class ~= "Ranger" and actor.class ~= "Berserker" and actor.class ~= "Mercenary" then
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
    actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first and then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old trophy.'")
    return _return_value
end
-- switch on trophystage
if trophystage == 1 then
    local trophy = 1607
    local gem = 55579
    local place = "A Coyote's Den"
    local hint = "near the Kingdom of the Meer Cats."
elseif trophystage == 2 then
    local trophy = 17806
    local gem = 55591
    local place = "In the Lions' Den"
    local hint = "in the western reaches of Gothra."
elseif trophystage == 3 then
    local trophy = 1805
    local gem = 55628
    local place = "either of the two Gigantic Roc Nests"
    local hint = "in the Wailing Mountains."
elseif trophystage == 4 then
    local trophy = 62513
    local gem = 55652
    local place = "Chieftain's Lair"
    local hint = "in Nukreth Spire in South Caelia."
elseif trophystage == 5 then
    local trophy = 23803
    local gem = 55664
    local place = "The Heart of the Den"
    local hint = "where the oldest unicorn in South Caelia makes its home."
elseif trophystage == 6 then
    local trophy = 43009
    local gem = 55685
    local place = "Giant Lynx's Lair"
    local hint = "far to the north beyond Mt. Frostbite."
elseif trophystage == 7 then
    local trophy = 47008
    local gem = 55705
    local place = "Giant Griffin's Nest"
    local hint = "tucked away in a secluded and well guarded corner of Griffin Island."
elseif trophystage == 8 then
    local trophy = 53323
    local gem = 55729
    local place = "Witch's Den"
    local hint = "entombed with an ancient evil king."
elseif trophystage == 9 then
    local trophy = 52014
    local gem = 55741
    local place = "Dargentan's Lair"
    local hint = "at the pinnacle of his flying fortress."
end
local attacks = trophystage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act mission you'll earn a new trophy.  Undertake the following:")
actor:send("- Attack <b:green>" .. tostring(attacks) .. "</> times while wearing your current trophy.")
actor:send("- Find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</> as another demonstration of mastery over the beasts of the wild.")
actor:send("- Find <b:green>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your trophy and <b:green>[forage]</> in a great beast's home.")
actor:send("Find \"<b:green>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")