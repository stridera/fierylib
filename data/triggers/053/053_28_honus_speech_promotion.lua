-- Trigger: Honus speech promotion
-- Zone: 53, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `cloak`, `gem`, `place`, `hint` are branch-scoped
-- through the cloakstage if/elseif (48-93) but referenced at 98-103.
-- Output uses literal `%get.obj_shortdesc[%cloak%]%` DG remnants —
-- replace with `objects.template(zone, id).name`. Legacy 5-digit ids.
-- `_return_value` referenced but never defined. Full rewrite from DG
-- #5328.
--
-- Original DG Script: #5328

-- Converted from DG Script #5328: Honus speech promotion
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: promotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "promotion")) then
    return true  -- No matching keywords
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
local huntstage = actor:get_quest_stage("treasure_hunter")
local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
wait(0.2)
if actor.class ~= "rogue" and actor.class ~= "bard" and actor.class ~= "thief" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'We only promote within the cloak and dagger guilds.  Sorry.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for a promotion yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (cloakstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("rogue_cloak") then
    actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
    return _return_value
end
if cloakstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
    return _return_value
elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old cloak.'")
    return _return_value
end
-- switch on cloakstage
local place, hint
do
    local _sw1 = string.lower(tostring(cloakstage or ""))
    if tonumber(_sw1) == 1 then
        local cloak = 58801
        local gem = 55585
        place = "A Storage Room"
        hint = "in the house on the hill."
    elseif tonumber(_sw1) == 2 then
        local cloak = 17307
        local gem = 55593
        place = "A Small Alcove"
        hint = "in the holy library."
    elseif tonumber(_sw1) == 3 then
        local cloak = 10308
        local gem = 55619
        place = "either Treasure Room"
        hint = "in the paladin fortress."
    elseif tonumber(_sw1) == 4 then
        local cloak = 12325
        local gem = 55659
        place = "The Treasure Room"
        hint = "beyond the Tower in the Wastes."
    elseif tonumber(_sw1) == 5 then
        local cloak = 43022
        local gem = 55663
        place = "Treasury"
        hint = "in the ghostly fortress."
    elseif tonumber(_sw1) == 6 then
        local cloak = 23810
        local gem = 55674
        place = "either Treasure Room with a chest"
        hint = "lost in the sands."
    elseif tonumber(_sw1) == 7 then
        local cloak = 51013
        local gem = 55714
        place = "Mesmeriz's Secret Treasure Room"
        hint = "hidden deep underground."
    elseif tonumber(_sw1) == 8 then
        local cloak = 58410
        local gem = 55740
        place = "Treasure Room"
        hint = "sunken in the swamp."
    elseif tonumber(_sw1) == 9 then
        local cloak = 52009
        local gem = 55741
        place = "Treasure Room"
        hint = "buried with an ancient king."
    end
end
local attacks = cloakstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each promotion you'll earn a new cloak to signify your new station.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current cloak.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</> as the base for the new cloak.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your cloak and <b:yellow>[search]</> in various treasure rooms.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")