-- Trigger: Elemental Chaos Hakujo progress checker
-- Zone: 53, ID: 43
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped vision/chant locals; `get_room("4328")`
-- bad arg shape; `%get.obj_shortdesc[%gem%]%` and `%place%` literal DG
-- remnants in output strings. Full rewrite from DG #5343.
--
-- Original DG Script: #5343

-- Converted from DG Script #5343: Elemental Chaos Hakujo progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Elemental Chaos</>")
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
elseif actor:get_quest_stage("elemental_chaos") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't walking the Way with me.'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
elseif actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("elemental_chaos")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("elemental_chaos") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshiping it!'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
end
if string.find(actor.class, "monk") then
    actor:send("</>")
    actor:send("</>")
    actor:send("<b:green>Enlightenment</>")
    local missionstage = actor:get_quest_stage("elemental_chaos")
    local visionstage = actor:get_quest_stage("monk_vision")
    local job1 = actor:get_quest_var("monk_vision:visiontask1")
    local job2 = actor:get_quest_var("monk_vision:visiontask2")
    local job3 = actor:get_quest_var("monk_vision:visiontask3")
    local job4 = actor:get_quest_var("monk_vision:visiontask4")
    local place
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for a vision yet.  Come back when you've grown a bit.'")
    elseif actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    elseif actor.level < (visionstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    elseif visionstage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    else
        -- switch on visionstage
        local hint
        do
            local _sw2 = string.lower(tostring(visionstage or ""))
            if tonumber(_sw2) == 1 then
                local book = 59006
                local gem = 55582
                local room = get_room("4328")
                place = room.name
                hint = "in a place to perform."
            elseif tonumber(_sw2) == 2 then
                local book = 18505
                local gem = 55591
                local room = get_room("58707")
                place = room.name
                hint = "near a sandy beach."
            elseif tonumber(_sw2) == 3 then
                local book = 8501
                local gem = 55623
                local room = get_room("18597")
                place = room.name
                hint = "in a cloistered library."
            elseif tonumber(_sw2) == 4 then
                local book = 12532
                local gem = 55655
                local room = get_room("58102")
                place = room.name
                hint = "on my home island."
            elseif tonumber(_sw2) == 5 then
                local book = 16209
                local gem = 55665
                local room = get_room("16057")
                place = room.name
                hint = "in the ghostly fortress."
            elseif tonumber(_sw2) == 6 then
                local book = 43013
                local gem = 55678
                local room = get_room("59054")
                place = room.name
                hint = "in the fortress of the zealous."
            elseif tonumber(_sw2) == 7 then
                local book = 53009
                local gem = 55710
                local room = get_room("49079")
                place = room.name
                hint = "off-shore of the island of great beasts."
            elseif tonumber(_sw2) == 8 then
                local book = 58415
                local gem = 55722
                local room = get_room("11820")
                place = room.name
                hint = "beyond the Blue-Fog Trail."
            elseif tonumber(_sw2) == 9 then
                local book = 58412
                local gem = 55741
                local room = get_room("52075")
                place = room.name
                hint = "in the shattered citadel of Templace."
            end
        end
        local attack = visionstage * 100
        if job1 or job2 or job3 or job4 then
            actor:send("You've done the following:")
            if job1 then
                actor:send("- attacked " .. tostring(attack) .. " times")
            end
            if job2 then
                actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
            end
            if job3 then
                actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
            end
            if job4 then
                actor:send("- read in " .. tostring(place))
            end
            actor:send("</>")
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 then
            actor:send("Just give me your current vision mark.")
        else
            if not job1 then
                local remaining = attack - actor:get_quest_var("monk_vision:attack_counter")
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- take <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
    if actor:get_quest_stage("monk_chants") > 0 then
        local chantstage = actor:get_quest_stage("monk_chants")
        -- switch on chantstage
        local chant, level, item, place
        do
            local _sw3 = string.lower(tostring(chantstage or ""))
            if tonumber(_sw3) == 1 then
                chant = "Tremors of Saint Augustine"
                level = 30
                item = "a book surrounded by trees and shadows"
                place = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful"
            elseif tonumber(_sw3) == 2 then
                chant = "Tempest of Saint Augustine"
                level = 40
                item = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity"
                place = "at the marker on a southern mountain range."
            elseif tonumber(_sw3) == 3 then
                chant = "Blizzards of Saint Augustine"
                level = 50
                item = "a book held by a master who in turn is a servant of a beast of winter"
                place = "in a temple shrouded in mists"
            elseif tonumber(_sw3) == 4 then
                chant = "Aria of Dissonance"
                level = 60
                item = "a book on war, held by a banished war god"
                place = "in a dark cave before a blasphemous book, near an unholy fire"
            elseif tonumber(_sw3) == 5 then
                chant = "Apocalyptic Anthem"
                level = 75
                item = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape"
                place = "in a chapel of the walking dead"
            elseif tonumber(_sw3) == 6 then
                chant = "Fires of Saint Augustine"
                level = 80
                item = "a scroll of curses, carried by children of air in a floating fortress"
                place = "at an altar dedicated to fire's destructive forces"
            elseif tonumber(_sw3) == 7 then
                chant = "Seed of Destruction"
                level = 99
                item = "the eye of one caught in an eternal feud"
                place = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied"
            end
        end
        actor:send("</>")
        actor:send("</>")
        actor:send("<b:green>Esoteric Chants</>")
        if actor.level >= level then
            if chantstage < (visionstage - 2) then
                actor:send(tostring(self.name) .. " says, 'You are seeking the chant " .. tostring(chant) .. ".'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " says, 'You are looking for " .. tostring(item) .. ".")
                actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(place) .. ".'")
            else
                actor:send(tostring(self.name) .. " says, 'You must first take another step towards <b:cyan>[enlightenment]</> before you can grasp more esoteric knowledge.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't ready to learn the next chant yet.'")
        end
    end
end