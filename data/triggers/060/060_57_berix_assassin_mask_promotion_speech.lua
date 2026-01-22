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
    actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs and then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old mask.'")
    return _return_value
end
-- switch on maskstage
if maskstage == 1 then
    local mask = 4500
    local gem = 55592
    local place = "The Shadowy Lair"
    local hint = "in the Misty Caverns."
elseif maskstage == 2 then
    local mask = 17809
    local gem = 55594
    local place = "The Dark Chamber"
    local hint = "behind a desert door."
elseif maskstage == 3 then
    local mask = 59023
    local gem = 55620
    local place = "A Dark Tunnel"
    local hint = "on the way to a dark, hidden city."
elseif maskstage == 4 then
    local mask = 10304
    local gem = 55638
    local place = "Dark Chamber"
    local hint = "hidden below a ghostly fortress."
elseif maskstage == 5 then
    local mask = 16200
    local gem = 55666
    local place = "Darkness......"
    local hint = "inside an enchanted closet."
elseif maskstage == 6 then
    local mask = 43017
    local gem = 55675
    local place = "Surrounded by Darkness"
    local hint = "in a volcanic shaft."
elseif maskstage == 7 then
    local mask = 51075
    local gem = 55693
    local place = "Dark Indecision"
    local hint = "before an altar in a fallen maze."
elseif maskstage == 8 then
    local mask = 49062
    local gem = 55719
    local place = "Heart of Darkness"
    local hint = "buried deep in an ancient tomb."
elseif maskstage == 9 then
    local mask = 48427
    local gem = 55743
    local place = "A Dark Room"
    local hint = "under the ruins of a shop in an ancient city."
end
local attacks = maskstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'Sure, I can help you climb the ranks.  Each new station you'll earn a new mask.  Do the following:")
actor:send("- Attack &9<blue>" .. tostring(attacks) .. "</> times while wearing your current mask.")
actor:send("- Find &9<blue>" .. "%get.obj_shortdesc[%mask%]%</> as the base for the new mask.")
actor:send("- Find &9<blue>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your mask and &9<blue>[hide]</> in a secret, dark, shadowy place.")
actor:send("Find \"&9<blue>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[mask progress]</> at any time.'")