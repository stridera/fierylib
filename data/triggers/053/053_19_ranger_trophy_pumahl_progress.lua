-- Trigger: Ranger Trophy Pumahl progress
-- Zone: 53, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 7914 chars
--
-- Original DG Script: #5319

-- Converted from DG Script #5319: Ranger Trophy Pumahl progress
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
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        if actor:get_quest_stage("beast_master") == 1 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 2 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 3 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
        elseif actor:get_quest_stage("beast_master") == 4 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
        elseif actor:get_quest_stage("beast_master") == 5 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
        elseif actor:get_quest_stage("beast_master") == 6 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
        elseif actor:get_quest_stage("beast_master") == 7 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
        elseif actor:get_quest_stage("beast_master") == 8 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
        elseif actor:get_quest_stage("beast_master") == 9 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
        elseif actor:get_quest_stage("beast_master") == 10 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
if actor.class == "Warrior" or actor.class == "Ranger" or actor.class == "Berserker" or actor.class == "Mercenary" then
    actor:send("</>")
    actor:send("<b:green>Eye of the Tiger</>")
    local huntstage = actor:get_quest_stage("beast_master")
    local trophystage = actor:get_quest_stage("ranger_trophy")
    local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
    local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
    local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
    local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (trophystage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
        return _return_value
    end
    if trophystage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.'")
        return _return_value
    elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first and then we can talk.'")
        return _return_value
    end
    -- switch on trophystage
    if trophystage == 1 then
        local trophy = 1607
        local gem = 55579
        local place = "A Coyote's Den"
        local hint = "near the Kingdom of the Meer Cats."
    elseif trophystage == 2 then
        local trophy = 17806
        local gem = 55591
        local place = "In the Lions' Den"
        local hint = "in the western reaches of Gothra."
    elseif trophystage == 3 then
        local trophy = 1805
        local gem = 55628
        local place = "either of the two Gigantic Roc Nests"
        local hint = "in the Wailing Mountains."
    elseif trophystage == 4 then
        local trophy = 62513
        local gem = 55652
        local place = "Chieftain's Lair"
        local hint = "in Nukreth Spire in South Caelia."
    elseif trophystage == 5 then
        local trophy = 23803
        local gem = 55664
        local place = "The Heart of the Den"
        local hint = "where the oldest unicorn in South Caelia makes its home."
    elseif trophystage == 6 then
        local trophy = 43009
        local gem = 55685
        local place = "Giant Lynx's Lair"
        local hint = "far to the north beyond Mt. Frostbite."
    elseif trophystage == 7 then
        local trophy = 47008
        local gem = 55705
        local place = "Giant Griffin's Nest"
        local hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif trophystage == 8 then
        local trophy = 53323
        local gem = 55729
        local place = "Witch's Den"
        local hint = "entombed with an ancient evil king."
    elseif trophystage == 9 then
        local trophy = 52014
        local gem = 55741
        local place = "Dargentan's Lair"
        local hint = "at the pinnacle of his flying fortress."
    end
    local attack = trophystage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%trophy%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- foraged in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old trophy.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("ranger_trophy:attack_counter")
        actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
    end
    if not job2 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</>")
    end
    if not job3 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
    end
end