-- Trigger: Ranger Trophy Pumahl progress
-- Zone: 53, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `_return_value` is referenced but
-- never defined (used in early returns). 1% probability is also low for
-- a status query — verify against DG #5319.
--
-- Original DG Script: #5319

-- Converted from DG Script #5319: Ranger Trophy Pumahl progress
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
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("beast_master") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
local trophy, gem
if actor.class == "warrior" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "mercenary" then
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
        actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
        return _return_value
    end
    -- switch on trophystage
    local place, hint
    do
        local _sw2 = string.lower(tostring(trophystage or ""))
        if tonumber(_sw2) == 1 then
            trophy = 1607
            gem = 55579
            place = "A Coyote's Den"
            hint = "near the Kingdom of the Meer Cats."
        elseif tonumber(_sw2) == 2 then
            trophy = 17806
            gem = 55591
            place = "In the Lions' Den"
            hint = "in the western reaches of Gothra."
        elseif tonumber(_sw2) == 3 then
            trophy = 1805
            gem = 55628
            place = "either of the two Gigantic Roc Nests"
            hint = "in the Wailing Mountains."
        elseif tonumber(_sw2) == 4 then
            trophy = 62513
            gem = 55652
            place = "Chieftain's Lair"
            hint = "in Nukreth Spire in South Caelia."
        elseif tonumber(_sw2) == 5 then
            trophy = 23803
            gem = 55664
            place = "The Heart of the Den"
            hint = "where the oldest unicorn in South Caelia makes its home."
        elseif tonumber(_sw2) == 6 then
            trophy = 43009
            gem = 55685
            place = "Giant Lynx's Lair"
            hint = "far to the north beyond Mt. Frostbite."
        elseif tonumber(_sw2) == 7 then
            trophy = 47008
            gem = 55705
            place = "Giant Griffin's Nest"
            hint = "tucked away in a secluded and well guarded corner of Griffin Island."
        elseif tonumber(_sw2) == 8 then
            trophy = 53323
            gem = 55729
            place = "Witch's Den"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            trophy = 52014
            gem = 55741
            place = "Dargentan's Lair"
            hint = "at the pinnacle of his flying fortress."
        end
    end
    local attack = trophystage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(trophy))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
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
        local remaining = attack - (actor:get_quest_var("ranger_trophy:attack_counter") or 0)
        actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
    end
    if not job2 then
        actor:send("- find <b:green>" .. proto_short(trophy) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:green>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
    end
end