-- Trigger: megalith_quest_priestess_receive
-- Zone: 123, ID: 6
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 8676 chars
--
-- Original DG Script: #12306

-- Converted from DG Script #12306: megalith_quest_priestess_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- This trigger serves as the basis for the returning of items to the high priestess and advancing stages 1 and 3.
-- It is heavily copied from the Hot Springs quests.
-- Several of the stages have multiple items the questor could return.
-- Some can result in the quest variables [bad1-3] being placed on the character.
-- Ideally, there will be 0 [bad]
-- If there are 2 [bad] or more at the end, the final step of the quest will fail.
-- If bad4 is on, DISASTER will occur!!
-- There is currently no option to exchange items once they have been delivered
-- 
-- What item is being turned in?
-- 
if actor:get_quest_stage("megalith_quest") == 1 then
    local step = "replace our ritual implements"
    -- 
    -- Set the potential items that could be turned in in Stage 1
    -- 
    -- the expressions set item 2, set item 3, and set item 4 appear multiple times because multiple objects could satisfy the item requirement, but we only want to accept one.
    -- Also create a variable so we can return the cup to the character in stage 3
    -- 
    -- switch on object.id
    -- salt
    if object.id == 23756 then
        local item = 1
        local this = object.shortdesc
        -- hemlock goblet - BAD1
    elseif object.id == 41111 then
        local item = 2
        local goblet_zone, goblet_local = 411, 11
        local this = "a drinking vessel"
        -- rowan goblet
    elseif object.id == 41110 then
        local this = "a drinking vessel"
        local item = 2
        local goblet_zone, goblet_local = 411, 10
        -- chalice
    elseif object.id == 18512 then
        local item = 2
        local goblet_zone, goblet_local = 185, 12
        local this = "a drinking vessel"
        -- censer
    elseif object.id == 8507 then
        local item = 3
        local this = "an incense burner"
        -- thurible
    elseif object.id == 17300 then
        local item = 3
        local this = "an incense burner"
        -- candle
    elseif object.id == 8612 then
        local item = 4
        local this = "spare candles"
        -- candle
    elseif object.id == 58809 then
        local item = 4
        local this = "spare candles"
    else
        return _return_value
    end
elseif actor:get_quest_stage("megalith_quest") == 3 then
    local step = "summon " .. tostring(mobiles.template(123, 0).name)
    -- 
    -- Set the potential items that could be returned in Stage 3
    -- 
    -- switch on object.id
    -- bowl
    if object.id == 23817 then
        local item = 1
        local this = object.shortdesc
        -- goddess skirt - BAD3
    elseif object.id == 4305 then
        local item = 2
        local this = "something from a goddess's regalia"
        -- goddess torch - ALSO BAD3
    elseif object.id == 4318 then
        local item = 2
        local this = "something from a goddess's regalia"
        -- goddess bracelet
    elseif object.id == 58015 then
        local item = 2
        local this = "something from a goddess's regalia"
        -- goddess ring
    elseif object.id == 58018 then
        local item = 2
        local this = "something from a goddess's regalia"
        -- faerie elixir - BAD4 - THE REALLY BAD ONE
    elseif object.id == 58426 then
        local this = "something to serve as Her icon"
        local item = 3
        -- faerie wings
    elseif object.id == 58418 then
        local item = 3
        local this = "something to serve as Her icon"
    else
        return _return_value
    end
end
-- 
-- if you already gave us this item.  The value %item% has been set to appends item here, resulting in item1, item2, item3, and item4.
-- 
if actor:get_quest_var("megalith_quest:item" .. tostring(item)) then
    _return_value = false
    self.room:send(tostring(self.name) .. " says, 'Thank you, but you already brought me " .. tostring(this) .. ".'")
    self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    return _return_value
end
-- 
-- Using the process above, if the thing turned in didn't match item1 item 2 item 3 or item4 we can accept it now and set the quest variable.
-- 
wait(2)
self.room:send(tostring(self.name) .. " says, 'Blessed be!  Just what we need to " .. tostring(step) .. "!'")
actor.name:set_quest_var("megalith_quest", "item" .. tostring(item), 1)
if object.id == 41110 or object.id == 18512 or object.id == 41111 then
    actor.name:set_quest_var("megalith_quest", "goblet_zone", goblet_zone)
    actor.name:set_quest_var("megalith_quest", "goblet_local", goblet_local)
    if object.id == 41111 then
        actor.name:set_quest_var("megalith_quest", "bad1", 1)
    end
elseif object.id == 4318 or object.id == 4305 then
    actor.name:set_quest_var("megalith_quest", "bad3", 1)
elseif object.id == 58426 then
    actor.name:set_quest_var("megalith_quest", "bad4", 1)
end
world.destroy(object.name)
-- 
-- See if we've turned in everything for this step
-- 
local item = 1
while item <= 4 do
    item[item] = 0
    local item = item + 1
end
if actor:get_quest_var("megalith_quest:item1") then
    local item1 = 1
end
if actor:get_quest_var("megalith_quest:item2") then
    local item2 = 1
end
if actor:get_quest_var("megalith_quest:item3") then
    local item3 = 1
end
if (actor:get_quest_stage("megalith_quest") ~= 1) or actor:get_quest_var("megalith_quest:item4") then
    local item4 = 1
end
-- 
-- If all the items have been turned in
-- 
if item1 and item2 and item3 and item4 then
    wait(2)
    actor.name:advance_quest("megalith_quest")
    local item = 1
    -- 
    -- Reset item variables with a while-loop
    -- This quest uses 5 item variables, but only 4 are ever checked in this receive trigger.  Clear all 5 here just to be safe.
    -- 
    while item <= 5 do
        actor.name:set_quest_var("megalith_quest", "item" .. tostring(item), 0)
        local item = item + 1
    end
    wait(1)
    self:say("I believe we're ready to proceed!")
    wait(1)
    -- 
    -- If turning everything in starts stage 2
    -- 
    if actor:get_quest_stage("megalith_quest") == 2 then
        self:emote("carefully places each tool in its proper position on the altar.")
        wait(2)
        self.room:send(tostring(self.name) .. " proclaims, 'Rejoice!  The Great Work begins!'")
        self:emote("lights the candle.")
        self.room:send(tostring(self.name) .. " lifts her arms and turns her face skyward.")
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("'O spirits of the ancient deep,")
        self.room:send("</>protect us as we undertake our magical working.'")
        wait(6)
        actor:send(tostring(self.name) .. " slowly fixes her gaze on you.")
        self.room:send_except(actor, tostring(self.name) .. " slowly fixes her gaze on " .. tostring(actor.name) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Next you'll work with the <b:white>Keepers</> to call the elements to protect us and awaken the sleeping land.  You can find them preparing the four enormous menhirs in the forest.  Please check in with them to see what resources they need.'")
        wait(2)
        self:say("Oh wait, I almost forgot!")
        wait(2)
        --
        -- Return the same drinking vessel from Stage 1
        --
        local goblet_zone = actor:get_quest_var("megalith_quest:goblet_zone")
        local goblet_local = actor:get_quest_var("megalith_quest:goblet_local")
        self.room:spawn_object(goblet_zone, goblet_local)
        self.room:send("The coven high priestess takes " .. "%get.obj_shortdesc[%goblet%]% from the altar.")
        -- (empty room echo)
        self:command("pour goblet out")
        self:command("give goblet " .. tostring(actor.name))
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'You'll need this vessel again.  I've consecrated it for use in the Great Rite.'")
        wait(3)
        self:say("Now, go seek out the Keepers!")
        -- 
        -- If turning everything in starts stage 4
        -- 
    elseif actor:get_quest_stage("megalith_quest") == 4 then
        actor.name:set_quest_var("megalith_quest", "reliquary", 1)
        self:emote("reverentially places each of the reliquaries on the altar.")
        wait(2)
        self:emote("whispers,")
        self.room:send("'By the power of three times three,")
        self.room:send("</>As I will it, so shall it be.'")
        wait(4)
        self:emote("breathes deeply and flexes her hands.")
        wait(3)
        self:say("It's time.")
        wait(2)
        self:emote("says in a hushed but excited tone, 'Are you ready?'")
    end
    -- 
    -- If we need more stuff
    -- 
else
    wait(2)
    self:say("If you have the other necessaries, please give them to me.")
end
return _return_value