-- Trigger: wizard_eye_status_checker
-- Zone: 550, ID: 42
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 14 if statements
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
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "progress")) then
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
    return _return_value
end
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You are trying to find the <b:cyan>gypsy witch in South Caelia Highlands.  Ask her about Wizard Eye.</>'")
    return _return_value
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'The gypsy witch says to find <b:yellow>marigold poultice</> from a healer on the beachhead.'")
    return _return_value
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Go visit the <b:cyan>Seer of Griffin Isle</> to see what you need to do next.  <b:cyan>Ask her about Wizard Eye</>.'")
    return _return_value
elseif stage == 4 then
    local who = "her"
    local visit = "have the Seer make you an herbal sachet"
    local thing1 = objects.template(23, 29).name
    local thing2 = objects.template(237, 53).name
    local thing3 = objects.template(480, 5).name
elseif stage == 5 then
    actor:send(tostring(self.name) .. " says, 'Give me the sachet.'")
    return _return_value
elseif stage == 6 then
    actor:send(tostring(self.name) .. " says, 'You are looking for <b:cyan>the apothecary in Anduin</>.'")
    return _return_value
elseif stage == 7 then
    local who = "her"
    local visit = "get The Green Woman to make you incense"
    local thing1 = objects.template(237, 54).name
    local thing2 = objects.template(32, 98).name
    local thing3 = objects.template(238, 47).name
    local thing4 = objects.template(180, 1).name
elseif stage == 8 then
    actor:send(tostring(self.name) .. " says, 'Give me the incense.'")
    return _return_value
elseif stage == 9 or stage == 10 then
    local who = "him"
    local thing1 = objects.template(32, 18).name
    local thing2 = objects.template(534, 24).name
    local thing3 = objects.template(430, 21).name
    local thing4 = objects.template(40, 3).name
    local visit = "see the Oracle of Justice"
elseif stage == 11 then
    actor:send(tostring(self.name) .. " says, 'Give me the crystal ball.'")
    return _return_value
elseif stage == 12 then
    actor:send(tostring(self.name) .. " says, 'All you need to do now is lay back and go to <b:cyan>sleep</>.'")
    return _return_value
else
    actor:send(tostring(self.name) .. " says, 'Progress on what spell?  I am not guiding you.'")
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'You need to " .. tostring(visit) .. ".")
if item1 or item2 or item3 or item4 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " says, 'You have already given " .. tostring(who) .. ":")
    if item1 then
        actor:send("- " .. tostring(thing1))
    end
    if item2 then
        actor:send("- " .. tostring(thing2))
    end
    if item3 then
        actor:send("- " .. tostring(thing3))
    end
    if item4 then
        actor:send("- " .. tostring(thing4))
    end
end
-- (empty send to actor)
actor:send(tostring(self.name) .. " says, 'You still need to bring " .. tostring(who) .. ":")
if not item1 then
    actor:send("- <b:yellow>" .. tostring(thing1) .. "</>")
end
if not item2 then
    actor:send("- <b:yellow>" .. tostring(thing2) .. "</>")
end
if not item3 then
    actor:send("- <b:yellow>" .. tostring(thing3) .. "</>")
end
if stage ~= 4 then
    if not item4 then
        actor:send("- <b:yellow>" .. tostring(thing4) .. "</>")
    end
end