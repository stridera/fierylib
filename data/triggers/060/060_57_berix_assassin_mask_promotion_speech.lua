-- Trigger: Berix assassin mask promotion speech
-- Zone: 60, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6057

-- Converted from DG Script #6057: Berix assassin mask promotion speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: promotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "promotion")) then
    return true  -- No matching keywords
end
local maskstage = actor:get_quest_stage("assassin_mask")
local bountystage = actor:get_quest_stage("bounty_hunt")
local job1 = actor:get_quest_var("assassin_mask:masktask1")
local job2 = actor:get_quest_var("assassin_mask:masktask2")
local job3 = actor:get_quest_var("assassin_mask:masktask3")
local job4 = actor:get_quest_var("assassin_mask:masktask4")
wait(2)
if actor.class ~= "Assassin" then
    self.room:send(tostring(self.name) .. " scoffs in disgust.")
    actor:send(tostring(self.name) .. " says, 'You ain't part of the Guild.  Get lost.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You ain't ready for a promotion yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (maskstage * 10) then
    self:say("You ain't ready for another promotion yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("assassin_mask") then
    actor:send(tostring(self.name) .. " says, 'You've already gone as high as you can go!'")
    return _return_value
end
if maskstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta do a <b:cyan>[job]</> for me first though.'")
    return _return_value
elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old mask.'")
    return _return_value
end
-- switch on maskstage
-- Hoisted: branch-scoped `local` here would not be visible to the
-- code below that uses mask/gem/place/hint.
local mask, gem, place, hint
if maskstage == 1 then
    mask = 4500
    gem = 55592
    place = "The Shadowy Lair"
    hint = "in the Misty Caverns."
elseif maskstage == 2 then
    mask = 17809
    gem = 55594
    place = "The Dark Chamber"
    hint = "behind a desert door."
elseif maskstage == 3 then
    mask = 59023
    gem = 55620
    place = "A Dark Tunnel"
    hint = "on the way to a dark, hidden city."
elseif maskstage == 4 then
    mask = 10304
    gem = 55638
    place = "Dark Chamber"
    hint = "hidden below a ghostly fortress."
elseif maskstage == 5 then
    mask = 16200
    gem = 55666
    place = "Darkness......"
    hint = "inside an enchanted closet."
elseif maskstage == 6 then
    mask = 43017
    gem = 55675
    place = "Surrounded by Darkness"
    hint = "in a volcanic shaft."
elseif maskstage == 7 then
    mask = 51075
    gem = 55693
    place = "Dark Indecision"
    hint = "before an altar in a fallen maze."
elseif maskstage == 8 then
    mask = 49062
    gem = 55719
    place = "Heart of Darkness"
    hint = "buried deep in an ancient tomb."
elseif maskstage == 9 then
    mask = 48427
    gem = 55743
    place = "A Dark Room"
    hint = "under the ruins of a shop in an ancient city."
end
local attacks = maskstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'Sure, I can help you climb the ranks.  Each new station you'll earn a new mask.  Do the following:")
actor:send("- Attack &9<blue>" .. tostring(attacks) .. "</> times while wearing your current mask.")
-- TODO(parity): %get.obj_shortdesc[%mask%]% / %get.obj_shortdesc[%gem%]%
-- DG remnants. `mask` and `gem` are legacy global vnums (e.g. 4500, 55592)
-- and need to be split into (zone, local) before calling
-- objects.template(zone, id).name. Showing raw IDs as a placeholder.
actor:send("- Find &9<blue>object id " .. tostring(mask) .. "</> as the base for the new mask.")
actor:send("- Find &9<blue>object id " .. tostring(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your mask and &9<blue>[hide]</> in a secret, dark, shadowy place.")
actor:send("Find \"&9<blue>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[mask progress]</> at any time.'")