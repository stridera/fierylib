-- Trigger: Paladin Pendant progress tracker
-- Zone: 30, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3089

-- Converted from DG Script #3089: Paladin Pendant progress tracker
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Dragon Slayer</>")
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif actor:get_quest_stage("dragon_slayer") == 0 and actor.level > 4 then
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
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("dragon_slayer") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
end
local anti = "Anti-Paladin"
local necklace, gem
if actor.class == "paladin" or actor.class == "anti-paladin" then
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
        actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
        return _return_value
    end
    -- switch on pendantstage
    local place, hint
    do
        local _sw2 = string.lower(tostring(pendantstage or ""))
        if tonumber(_sw2) == 1 then
            necklace = 12003
            gem = 55582
            place = "The Mist Temple Altar"
            hint = "in the Misty Caverns."
        elseif tonumber(_sw2) == 2 then
            necklace = 23708
            gem = 55590
            place = "Chamber of Chaos"
            hint = "in the Temple of Chaos."
        elseif tonumber(_sw2) == 3 then
            necklace = 58005
            gem = 55622
            place = "Altar of Borgan"
            hint = "in the lost city of Nymrill."
        elseif tonumber(_sw2) == 4 then
            necklace = 48123
            gem = 55654
            place = "A Hidden Altar Room"
            hint = "in a cave in South Caelia's Wailing Mountains."
        elseif tonumber(_sw2) == 5 then
            necklace = 12336
            gem = 55662
            place = "The Altar of the Snow Leopard Order"
            hint = "buried deep in Mt. Frostbite"
        elseif tonumber(_sw2) == 6 then
            necklace = 43019
            gem = 55677
            place = "Chapel Altar"
            hint = "deep underground in a lost castle."
        elseif tonumber(_sw2) == 7 then
            necklace = 37015
            gem = 55709
            place = "A Cliffside Altar"
            hint = "tucked away in the land of Dreams."
        elseif tonumber(_sw2) == 8 then
            necklace = 58429
            gem = 55738
            place = "Dark Altar"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            necklace = 52010
            gem = 55739
            place = "An Altar"
            hint = "far away in the Plane of Air."
        end
    end
    local attack = pendantstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(necklace))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
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
        local remaining = attack - (actor:get_quest_var("paladin_pendant:attack_counter") or 0)
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. proto_short(necklace) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end