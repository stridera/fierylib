-- Trigger: Assassin mask progress checker
-- Zone: 60, ID: 59
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 8214 chars
--
-- Original DG Script: #6059

-- Converted from DG Script #6059: Assassin mask progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: status progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("<b:green>Contract Killers</>")
if actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
elseif not actor:get_quest_stage("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current contract.'")
elseif actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if actor:get_quest_var("bounty_hunt:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
    else
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Best get on killing that cat-king or whatever first.'")
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the Noble and the Abbot  sheltering him at the Abbey of St. George.'")
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the three Chieftains in the southwestern Highlands.'")
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Find the Frakati Leader and kill him.'")
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Infiltrate the Sacred Haven and take out the number two in command, Cyrus.'")
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Disappear Lord Venth down south.'")
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Send the high druid on a permanent pilgrimage.'")
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Kill the Lizard King.  If you can even find him...'")
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the leader of the Ice Cult up north before they get wind of it.'")
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  End the reign of the Goblin King.  We'll all probably dream a little more soundly then.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'All my other jobs are too risky for someone without moreexperience.  Come back when you've seen a little more.'")
end
if actor.class == "Assassin" then
    actor:send("</>")
    actor:send("<b:green>Deadly Promotion</>")
    local bountystage = actor:get_quest_stage("bounty_hunt")
    local maskstage = actor:get_quest_stage("assassin_mask")
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
        actor:send(tostring(self.name) .. " says, 'You ain't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("assassin_mask") then
        actor:send(tostring(self.name) .. " says, 'You've already gone as high as you can go!'")
        return _return_value
    end
    if maskstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Sure.  You gotta do a <b:cyan>[job]</> for me first though.'")
        return _return_value
    elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs and then we can talk.'")
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
    local attack = maskstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%mask%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- hidden in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old mask.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("assassin_mask:attack_counter")
        actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your mask.")
    end
    if not job2 then
        actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%mask%]%</>")
    end
    if not job3 then
        actor:send("- find &9<blue>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- &9<blue>hide in a place called \"&9<blue>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's &9<blue>" .. tostring(hint) .. "</>")
    end
end