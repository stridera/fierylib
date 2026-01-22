-- Trigger: Paladin Pendant progress tracker
-- Zone: 30, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 8426 chars
--
-- Original DG Script: #3089

-- Converted from DG Script #3089: Paladin Pendant progress tracker
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
actor:send("<b:green>Dragon Slayer</>")
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif not actor:get_quest_stage("dragon_slayer") and actor.level > 4 then
    actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
elseif actor.level < 5 then
    actor:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
elseif actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_var("dragon_slayer:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_stage("dragon_slayer") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
        elseif actor:get_quest_stage("dragon_slayer") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
        elseif actor:get_quest_stage("dragon_slayer") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
        elseif actor:get_quest_stage("dragon_slayer") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
        elseif actor:get_quest_stage("dragon_slayer") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
        elseif actor:get_quest_stage("dragon_slayer") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
        elseif actor:get_quest_stage("dragon_slayer") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
        elseif actor:get_quest_stage("dragon_slayer") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
        elseif actor:get_quest_stage("dragon_slayer") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
        elseif actor:get_quest_stage("dragon_slayer") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
end
local anti = "Anti-Paladin"
if actor.class == "paladin" or actor.class == "anti" then
    actor:send("</>")
    actor:send("<b:green>Divine Devotion</>")
    local huntstage = actor:get_quest_stage("dragon_slayer")
    local pendantstage = actor:get_quest_stage("paladin_pendant")
    local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
    local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
    local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
    local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (pendantstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another devotional act yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
        return _return_value
    end
    if pendantstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.'")
        return _return_value
    elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Slay a few more dragons and then we can talk.'")
        return _return_value
    end
    -- switch on pendantstage
    if pendantstage == 1 then
        local necklace = 12003
        local gem = 55582
        local place = "The Mist Temple Altar"
        local hint = "in the Misty Caverns."
    elseif pendantstage == 2 then
        local necklace = 23708
        local gem = 55590
        local place = "Chamber of Chaos"
        local hint = "in the Temple of Chaos."
    elseif pendantstage == 3 then
        local necklace = 58005
        local gem = 55622
        local place = "Altar of Borgan"
        local hint = "in the lost city of Nymrill."
    elseif pendantstage == 4 then
        local necklace = 48123
        local gem = 55654
        local place = "A Hidden Altar Room"
        local hint = "in a cave in South Caelia's Wailing Mountains."
    elseif pendantstage == 5 then
        local necklace = 12336
        local gem = 55662
        local place = "The Altar of the Snow Leopard Order"
        local hint = "buried deep in Mt. Frostbite"
    elseif pendantstage == 6 then
        local necklace = 43019
        local gem = 55677
        local place = "Chapel Altar"
        local hint = "deep underground in a lost castle."
    elseif pendantstage == 7 then
        local necklace = 37015
        local gem = 55709
        local place = "A Cliffside Altar"
        local hint = "tucked away in the land of Dreams."
    elseif pendantstage == 8 then
        local necklace = 58429
        local gem = 55738
        local place = "Dark Altar"
        local hint = "entombed with an ancient evil king."
    elseif pendantstage == 9 then
        local necklace = 52010
        local gem = 55739
        local place = "An Altar"
        local hint = "far away in the Plane of Air."
    end
    local attack = pendantstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%necklace%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- prayed in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old necklace.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("paladin_pendant:attack_counter")
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end