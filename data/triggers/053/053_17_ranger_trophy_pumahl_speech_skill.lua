-- Trigger: Ranger Trophy Pumahl speech skill
-- Zone: 53, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `local trophy`, `local gem`, `local place`, `local hint`
-- are branch-scoped through the trophystage if/elseif (lines 49-93) but
-- referenced at lines 98-103. Output uses literal `%get.obj_shortdesc[
-- %trophy%]%` template strings (DG remnants) — must be replaced with
-- `objects.template(zone, id).name` lookups. Legacy 5-digit object ids.
-- `_return_value` is referenced at lines 27/29/32/35 but never defined.
-- Full rewrite from DG #5317.
--
-- Original DG Script: #5317

-- Converted from DG Script #5317: Ranger Trophy Pumahl speech skill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
do
    local _sw1 = string.lower(tostring(trophystage or ""))
    if tonumber(_sw1) == 1 then
        local trophy = 1607
        local gem = 55579
        place = "A Coyote's Den"
        hint = "near the Kingdom of the Meer Cats."
    elseif tonumber(_sw1) == 2 then
        local trophy = 17806
        local gem = 55591
        place = "In the Lions' Den"
        hint = "in the western reaches of Gothra."
    elseif tonumber(_sw1) == 3 then
        local trophy = 1805
        local gem = 55628
        place = "either of the two Gigantic Roc Nests"
        hint = "in the Wailing Mountains."
    elseif tonumber(_sw1) == 4 then
        local trophy = 62513
        local gem = 55652
        place = "Chieftain's Lair"
        hint = "in Nukreth Spire in South Caelia."
    elseif tonumber(_sw1) == 5 then
        local trophy = 23803
        local gem = 55664
        place = "The Heart of the Den"
        hint = "where the oldest unicorn in South Caelia makes its home."
    elseif tonumber(_sw1) == 6 then
        local trophy = 43009
        local gem = 55685
        place = "Giant Lynx's Lair"
        hint = "far to the north beyond Mt. Frostbite."
    elseif tonumber(_sw1) == 7 then
        local trophy = 47008
        local gem = 55705
        place = "Giant Griffin's Nest"
        hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif tonumber(_sw1) == 8 then
        local trophy = 53323
        local gem = 55729
        place = "Witch's Den"
        hint = "entombed with an ancient evil king."
    elseif tonumber(_sw1) == 9 then
        local trophy = 52014
        local gem = 55741
        place = "Dargentan's Lair"
        hint = "at the pinnacle of his flying fortress."
    end
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