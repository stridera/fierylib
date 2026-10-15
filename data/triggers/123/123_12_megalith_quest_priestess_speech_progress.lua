-- Trigger: megalith_quest_priestess_speech_progress
-- Zone: 123, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12312

-- Converted from DG Script #12312: megalith_quest_priestess_speech_progress
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "status?", "progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
-- The mob's short description starts lowercase ("the witch priestess"); a line that begins with it
-- needs a capital.
local self_name = self.name:sub(1, 1):upper() .. self.name:sub(2)
wait(0.2)
-- Make sure you're on the quest.
if actor:get_quest_stage("megalith_quest") < 1 then
    return _return_value
end
if actor:get_has_completed("megalith_quest") then
    self:say("We give thanks for your help in completing our summoning ritual.")
    wait(0.2)
    self:say("Blessed be!")
    return _return_value
end
if actor:get_has_failed("megalith_quest") then
    self:say("Sadly we failed in our efforts to invoke " .. tostring(mobiles.template(123, 0).name) .. "...")
    wait(0.2)
    self:say("Would you like to try again?")
    return _return_value
end
-- Hoisted locals (branch-scoped in the converter output, used after the
-- if/elseif chain).
local step
local item1, item2, item3, item4
local receive1, receive2, receive3, receive4, receive5
local stage = actor:get_quest_stage("megalith_quest")
do
    local _sw1 = string.lower(tostring(stage or ""))
    local _run1 = false
    repeat
        if _run1 or tonumber(_sw1) == 1 then
            _run1 = true
            step = "replacing the sacred prophetic implements"
            -- salt 23756
            item1 = "salt"
            -- Goblet or chalice 41110 or 41111 or 18512
            item2 = "a goblet or chalice"
            -- censer 8507 or 17300
            item3 = "a censer"
            -- candles 8612 or 58809
            item4 = "candles"
            -- give to the priestess
            receive5 = 12301
            actor:send(self_name .. " says, 'I need your help " .. tostring(step) .. ".'")
            break
        end
        if _run1 or tonumber(_sw1) == 2 then
            _run1 = true
            -- Must be done East South West North.
            step = "call the elements"
            -- thin sheet of cloud to Keeper of the East
            receive1 = mobiles.template(123, 5).name
            item1 = objects.template(83, 1).name
            -- the fiery eye to Keeper of the South
            receive2 = mobiles.template(123, 4).name
            item2 = objects.template(481, 9).name
            -- granite ring to Keeper of the North
            receive3 = mobiles.template(123, 3).name
            item3 = objects.template(550, 20).name
            -- water from room 12463 to Keeper of the West
            receive4 = mobiles.template(123, 6).name
            item4 = "water from " .. tostring(objects.template(123, 52).name)
            wait(0.2)
            actor:send(self_name .. " says, 'We're trying to " .. tostring(step) .. ".'")
            if (actor:get_quest_var("megalith_quest:item1") == 1) and (actor:get_quest_var("megalith_quest:item2") == 1) and (actor:get_quest_var("megalith_quest:item3") == 1) and (actor:get_quest_var("megalith_quest:item4") == 1) then
                self.room:send(self_name .. " says, 'We're ready to finish calling the elements!")
                self.room:send("</>If you wish to proceed, repeat after me:'")
                self.room:send("<b:white>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this")
                self.room:send("</>hallowed ground!</>")
                return _return_value
            end
            break
        end
        if _run1 or tonumber(_sw1) == 3 then
            _run1 = true
            step = "locate three reliquaries"
            receive5 = 12301
            item1 = "a holy prayer bowl"
            item2 = "a piece of a goddess's regalia"
            item3 = "a faerie relic from the land of the Reverie made manifest"
            actor:send(self_name .. " says, 'We need to <b:yellow>" .. tostring(step) .. "</>.'")
            break
        end
        if _run1 or tonumber(_sw1) == 4 then
            _run1 = true
            self.room:send(self_name .. " says, 'I've been awaiting your return!  Let us")
            self.room:send("</>perform the Great Rite of Invocation! Repeat after me:'")
            self.room:send("<b:white>Great Lady of the Stars, hear our prayer!</>")
            return _return_value
        end
        do  -- default
            _run1 = true
            return _return_value
        end
    until true
end
-- Quest vars item1..item4 are 1 once that item has been handed over; unset or 0 means still needed.
local function have(n)
    return actor:get_quest_var("megalith_quest:item" .. n) == 1
end
-- list items already given
if have(1) or have(2) or have(3) or have(4) then
    actor:send("You have already retrieved:")
end
if item1 and have(1) then
    actor:send("- <b:white>" .. tostring(item1) .. "</>")
end
if item2 and have(2) then
    actor:send("- <b:white>" .. tostring(item2) .. "</>")
end
if item3 and have(3) then
    actor:send("- <b:white>" .. tostring(item3) .. "</>")
end
if item4 and have(4) then
    actor:send("- <b:white>" .. tostring(item4) .. "</>")
end
-- list items to be returned
if stage ~= 4 then
    actor:send("We still need:")
end
if stage == 2 and not have(1) then
    actor:send("to assist <b:white>" .. tostring(receive1) .. "</>.")
    if actor:get_quest_var("megalith_quest:east") ~= 1 then
        actor:send("She needs " .. tostring(item1))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item1 and not have(1) then
    actor:send("<b:white>" .. tostring(item1) .. "</>")
end
if stage == 2 and not have(2) then
    actor:send("to assist <b:red>" .. tostring(receive2) .. "</>.")
    if actor:get_quest_var("megalith_quest:south") ~= 1 then
        actor:send("She needs " .. tostring(item2))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item2 and not have(2) then
    actor:send("<b:white>" .. tostring(item2) .. "</>")
end
if stage == 2 and not have(3) then
    actor:send("to assist <b:green>" .. tostring(receive3) .. "</>.")
    if actor:get_quest_var("megalith_quest:north") ~= 1 then
        actor:send("She needs " .. tostring(item3))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item3 and not have(3) then
    actor:send("<b:white>" .. tostring(item3) .. "</>")
end
if stage == 2 and not have(4) then
    actor:send("to assist <b:cyan>" .. tostring(receive4) .. "</>.")
    if actor:get_quest_var("megalith_quest:west") ~= 1 then
        actor:send("She needs " .. tostring(item4))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif stage == 1 and item4 and not have(4) then
    actor:send("<b:white>" .. tostring(item4) .. "</>")
end
if receive5 then
    actor:send(self_name .. " says, 'Please bring these to me.'")
end
return _return_value
