-- Trigger: wizard_eye_status_checker
-- Zone: 550, ID: 42
-- Type: MOB, Flags: SPEECH
--
-- "spell progress" recap for the Wizard Eye quest. Per-stage hint plus
-- (for the three collection stages 4, 7, and 9-10) a checklist of
-- which ingredients/orbs have been turned in and which are still
-- outstanding.
--
-- Original DG Script: #55042

-- Converted from DG Script #55042: wizard_eye_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: spell progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "spell") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end

local stage = actor:get_quest_stage("wizard_eye")
local item1 = actor:get_quest_var("wizard_eye:item1")
local item2 = actor:get_quest_var("wizard_eye:item2")
local item3 = actor:get_quest_var("wizard_eye:item3")
local item4 = actor:get_quest_var("wizard_eye:item4")
wait(2)
if actor:get_has_completed("wizard_eye") then
    actor:send(tostring(self.name) .. " says, 'You already have the sight of the Great Snow Leopard.'")
    return true
end

local who, visit, thing1, thing2, thing3, thing4

if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You are trying to find the <b:cyan>gypsy witch in South Caelia Highlands.  Ask her about Wizard Eye.</>'")
    return true
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'The gypsy witch says to find <b:yellow>marigold poultice</> from a healer on the beachhead.'")
    return true
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Go visit the <b:cyan>Seer of Griffin Isle</> to see what you need to do next.  <b:cyan>Ask her about Wizard Eye</>.'")
    return true
elseif stage == 4 then
    who = "her"
    visit = "have the Seer make you an herbal sachet"
    thing1 = objects.template(23, 29).name
    thing2 = objects.template(237, 53).name
    thing3 = objects.template(480, 5).name
elseif stage == 5 then
    actor:send(tostring(self.name) .. " says, 'Give me the sachet.'")
    return true
elseif stage == 6 then
    actor:send(tostring(self.name) .. " says, 'You are looking for <b:cyan>the apothecary in Anduin</>.'")
    return true
elseif stage == 7 then
    who = "her"
    visit = "get The Green Woman to make you incense"
    thing1 = objects.template(237, 54).name
    thing2 = objects.template(30, 298).name
    thing3 = objects.template(238, 47).name
    thing4 = objects.template(180, 1).name
elseif stage == 8 then
    actor:send(tostring(self.name) .. " says, 'Give me the incense.'")
    return true
elseif stage == 9 or stage == 10 then
    who = "him"
    visit = "see the Oracle of Justice"
    thing1 = objects.template(30, 218).name
    thing2 = objects.template(534, 24).name
    thing3 = objects.template(430, 21).name
    thing4 = objects.template(40, 3).name
elseif stage == 11 then
    actor:send(tostring(self.name) .. " says, 'Give me the crystal ball.'")
    return true
elseif stage == 12 then
    actor:send(tostring(self.name) .. " says, 'All you need to do now is lay back and go to <b:cyan>sleep</>.'")
    return true
else
    actor:send(tostring(self.name) .. " says, 'Progress on what spell?  I am not guiding you.'")
    return true
end

actor:send(tostring(self.name) .. " says, 'You need to " .. visit .. ".'")
if item1 or item2 or item3 or item4 then
    actor:send(tostring(self.name) .. " says, 'You have already given " .. who .. ":'")
    if item1 then
        actor:send("- " .. tostring(thing1))
    end
    if item2 then
        actor:send("- " .. tostring(thing2))
    end
    if item3 then
        actor:send("- " .. tostring(thing3))
    end
    if item4 and thing4 then
        actor:send("- " .. tostring(thing4))
    end
end
actor:send(tostring(self.name) .. " says, 'You still need to bring " .. who .. ":'")
if not item1 then
    actor:send("- <b:yellow>" .. tostring(thing1) .. "</>")
end
if not item2 then
    actor:send("- <b:yellow>" .. tostring(thing2) .. "</>")
end
if not item3 then
    actor:send("- <b:yellow>" .. tostring(thing3) .. "</>")
end
if stage ~= 4 and not item4 and thing4 then
    actor:send("- <b:yellow>" .. tostring(thing4) .. "</>")
end
return true
