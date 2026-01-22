-- Trigger: Elemental Chaos Hakujo progress checker
-- Zone: 53, ID: 43
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 11858 chars
--
-- Original DG Script: #5343

-- Converted from DG Script #5343: Elemental Chaos Hakujo progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("<b:green>Elemental Chaos</>")
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
elseif not actor:get_quest_stage("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'You aren't walking the Way with me.'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
elseif actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("elemental_chaos")
        if actor:get_quest_stage("elemental_chaos") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
        elseif actor:get_quest_stage("elemental_chaos") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
        elseif actor:get_quest_stage("elemental_chaos") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshiping it!'")
        elseif actor:get_quest_stage("elemental_chaos") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
        elseif actor:get_quest_stage("elemental_chaos") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
        elseif actor:get_quest_stage("elemental_chaos") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
        elseif actor:get_quest_stage("elemental_chaos") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("elemental_chaos") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
        elseif actor:get_quest_stage("elemental_chaos") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
        elseif actor:get_quest_stage("elemental_chaos") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
end
if string.find(actor.class, "Monk") then
    actor:send("</>")
    actor:send("</>")
    actor:send("<b:green>Enlightenment</>")
    local missionstage = actor:get_quest_stage("elemental_chaos")
    local visionstage = actor:get_quest_stage("monk_vision")
    local job1 = actor:get_quest_var("monk_vision:visiontask1")
    local job2 = actor:get_quest_var("monk_vision:visiontask2")
    local job3 = actor:get_quest_var("monk_vision:visiontask3")
    local job4 = actor:get_quest_var("monk_vision:visiontask4")
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
        if visionstage == 1 then
            local book = 59006
            local gem = 55582
            local room = get_room("4328")
            local place = room.name
            local hint = "in a place to perform."
        elseif visionstage == 2 then
            local book = 18505
            local gem = 55591
            local room = get_room("58707")
            local place = room.name
            local hint = "near a sandy beach."
        elseif visionstage == 3 then
            local book = 8501
            local gem = 55623
            local room = get_room("18597")
            local place = room.name
            local hint = "in a cloistered library."
        elseif visionstage == 4 then
            local book = 12532
            local gem = 55655
            local room = get_room("58102")
            local place = room.name
            local hint = "on my home island."
        elseif visionstage == 5 then
            local book = 16209
            local gem = 55665
            local room = get_room("16057")
            local place = room.name
            local hint = "in the ghostly fortress."
        elseif visionstage == 6 then
            local book = 43013
            local gem = 55678
            local room = get_room("59054")
            local place = room.name
            local hint = "in the fortress of the zealous."
        elseif visionstage == 7 then
            local book = 53009
            local gem = 55710
            local room = get_room("49079")
            local place = room.name
            local hint = "off-shore of the island of great beasts."
        elseif visionstage == 8 then
            local book = 58415
            local gem = 55722
            local room = get_room("11820")
            local place = room.name
            local hint = "beyond the Blue-Fog Trail."
        elseif visionstage == 9 then
            local book = 58412
            local gem = 55741
            local room = get_room("52075")
            local place = room.name
            local hint = "in the shattered citadel of Templace."
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
                actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
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
    if actor:get_quest_stage("monk_chants") then
        local chantstage = actor:get_quest_stage("monk_chants")
        -- switch on chantstage
        if chantstage == 1 then
            local chant = "Tremors of Saint Augustine"
            local level = 30
            local item = "a book surrounded by trees and shadows"
            local place = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful"
        elseif chantstage == 2 then
            local chant = "Tempest of Saint Augustine"
            local level = 40
            local item = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity"
            local place = "at the marker on a southern mountain range."
        elseif chantstage == 3 then
            local chant = "Blizzards of Saint Augustine"
            local level = 50
            local item = "a book held by a master who in turn is a servant of a beast of winter"
            local place = "in a temple shrouded in mists"
        elseif chantstage == 4 then
            local chant = "Aria of Dissonance"
            local level = 60
            local item = "a book on war, held by a banished war god"
            local place = "in a dark cave before a blasphemous book, near an unholy fire"
        elseif chantstage == 5 then
            local chant = "Apocalyptic Anthem"
            local level = 75
            local item = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape"
            local place = "in a chapel of the walking dead"
        elseif chantstage == 6 then
            local chant = "Fires of Saint Augustine"
            local level = 80
            local item = "a scroll of curses, carried by children of air in a floating fortress"
            local place = "at an altar dedicated to fire's destructive forces"
        elseif chantstage == 7 then
            local chant = "Seed of Destruction"
            local level = 99
            local item = "the eye of one caught in an eternal feud"
            local place = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied"
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