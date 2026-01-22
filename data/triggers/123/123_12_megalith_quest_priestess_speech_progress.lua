-- Trigger: megalith_quest_priestess_speech_progress
-- Zone: 123, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 7019 chars
--
-- Original DG Script: #12312

-- Converted from DG Script #12312: megalith_quest_priestess_speech_progress
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- make sure you're on the quest
if actor:get_quest_stage("megalith_quest") < 1 then
    _return_value = false
    return _return_value
end
if actor:get_has_completed("megalith_quest") then
    self:say("We give thanks for your help in completing our summoning ritual.")
    wait(2)
    self:say("Blessed be!")
    return _return_value
end
if actor:get_has_failed("megalith_quest") then
    self:say("Sadly we failed in our efforts to invoke " .. tostring(mobiles.template(123, 0).name) .. "...")
    wait(2)
    self:say("Would you like to try again?")
    return _return_value
end
-- clear variables
local item1 = 0
local item2 = 0
local item3 = 0
local item4 = 0
local receive1 = 0
local receive2 = 0
local receive3 = 0
local receive4 = 0
local receive5 = 0
local stage = actor:get_quest_stage("megalith_quest")
-- switch on stage
if stage == 1 then
    local step = "replacing the sacred prophetic implements"
    -- salt 23756
    local item1 = "salt"
    -- Goblet or chalice 41110 or 41111 or 18512
    local item2 = "a goblet or chalice"
    -- censer 8507 or 17300
    local item3 = "a censer"
    -- candles 8612 or 58809
    local item4 = "candles"
    -- give to the priestess
    local receive5 = 12301
    actor:send(tostring(self.name) .. " says, 'I need your help " .. tostring(step) .. ".'")
elseif stage == 2 then
    -- 
    -- Must be done East South West North
    -- 
    local step = "call the elements"
    -- thin sheet of cloud to Keeper of the East
    local receive1 = mobiles.template(123, 5).name
    local item1 = objects.template(83, 1).name
    -- the fiery eye to Keeper of the South
    local receive2 = mobiles.template(123, 4).name
    local item2 = objects.template(481, 9).name
    -- granite ring to Keeper of the North
    local receive3 = mobiles.template(123, 3).name
    local item3 = objects.template(550, 20).name
    -- water from room 12463 to Keeper of the West
    local receive4 = mobiles.template(123, 6).name
    local item4 = water from objects.template(123, 52).name
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We're trying to " .. tostring(step) .. ".'")
    if (actor:get_quest_var("megalith_quest:item1")) and (actor:get_quest_var("megalith_quest:item2")) and (actor:get_quest_var("megalith_quest:item3")) and (actor:get_quest_var("megalith_quest:item4")) then
        self.room:send(tostring(self.name) .. " says, 'We're ready to finish calling the elements!")
        self.room:send("</>If you wish to proceed, repeat after me:'")
        self.room:send("<b:white>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this")
        self.room:send("</>hallowed ground!</>")
        return _return_value
    end
elseif stage == 3 then
    local step = "locate three reliquaries"
    local receive5 = 12301
    local item1 = "a holy prayer bowl"
    local item2 = "a piece of a goddess's regalia"
    local item3 = "a faerie relic from the land of the Reverie made manifest"
    actor:send(tostring(self.name) .. " says, 'We need to <b:yellow>" .. tostring(step) .. "</>.'")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'I've been awaiting your return!  Let us")
    self.room:send("</>perform the Great Rite of Invocation! Repeat after me:'")
    self.room:send("<b:white>Great Lady of the Stars, hear our prayer!</>")
    return _return_value
else
    _return_value = false
    return _return_value
end
-- list items already given
if actor:get_quest_var("megalith_quest:item1") /= 1 or actor:get_quest_var("megalith_quest:item2") /= 1 or actor:get_quest_var("megalith_quest:item3") /= 1 or actor:get_quest_var("megalith_quest:item4") /= 1 then
    -- (empty send to actor)
    actor:send("You have already retrieved:")
end
if actor:get_quest_var("megalith_quest:item1") /= 1 then
    actor:send("- <b:white>" .. tostring(item1) .. "</>")
end
if actor:get_quest_var("megalith_quest:item2") /= 1 then
    actor:send("- <b:white>" .. tostring(item2) .. "</>")
end
if actor:get_quest_var("megalith_quest:item3") /= 1 then
    actor:send("- <b:white>" .. tostring(item3) .. "</>")
end
if actor:get_quest_var("megalith_quest:item4") ~= 0 then
    actor:send("- <b:white>" .. tostring(item4) .. "</>")
end
-- list items to be returned
-- (empty send to actor)
if stage ~= 4 then
    actor:send("We still need:")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item1") /= 0 then
    actor:send("to assist <b:white>" .. tostring(receive1) .. "</>.")
    if actor:get_quest_var("megalith_quest:east") /= 1 then
        actor:send("She needs " .. tostring(item1))
    else
        actor:send("Please check with her to see what she needs.")
    end
    -- (empty send to actor)
elseif actor:get_quest_var("megalith_quest:item1") /= 0 then
    actor:send("<b:white>" .. tostring(item1) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item2") /= 0 then
    actor:send("to assist <b:red>" .. tostring(receive2) .. "</>.")
    if actor:get_quest_var("megalith_quest:south") /= 1 then
        actor:send("She needs " .. tostring(item2))
    else
        actor:send("Please check with her to see what she needs.")
    end
    -- (empty send to actor)
elseif actor:get_quest_var("megalith_quest:item2") /= 0 then
    actor:send("<b:white>" .. tostring(item2) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item3") /= 0 then
    actor:send("to assist <b:green>" .. tostring(receive3) .. "</>.")
    if actor:get_quest_var("megalith_quest:north") /= 1 then
        actor:send("She needs " .. tostring(item3))
    else
        actor:send("Please check with her to see what she needs.")
    end
    -- (empty send to actor)
elseif actor:get_quest_var("megalith_quest:item3") /= 0 then
    actor:send("<b:white>" .. tostring(item3) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item4") /= 0 then
    actor:send("to assist <b:cyan>" .. tostring(receive4) .. "</>.")
    if actor:get_quest_var("megalith_quest:west") /= 1 then
        actor:send("She needs " .. tostring(item4))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif stage == 1 and actor:get_quest_var("megalith_quest:item4") == 0 then
    actor:send("<b:white>" .. tostring(item4) .. "</>")
end
-- (empty send to actor)
if receive5 then
    actor:send(tostring(self.name) .. " says, 'Please bring these to me.'")
end
return _return_value