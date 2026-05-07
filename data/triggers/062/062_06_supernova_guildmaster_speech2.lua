-- Trigger: supernova_guildmaster_speech2
-- Zone: 62, ID: 6
-- Type: MOB, Flags: SPEECH
--
-- Pyromancer guildmaster, second pass: when a stage-2 supernova questor
-- returns with one of Phayla's lamps (489, 17), roll the random clue chain
-- (step3..step7), advance to stage 3, and read off the first clue.
--
-- The legacy step* values are room vnums (zone*100+id) the player must visit;
-- they are persisted as quest_vars so that the clue scrolls and other triggers
-- read the same values on subsequent looks.
--
-- Original DG Script: #6206

if not (string.find(string.lower(speech), "phalya")
        or string.find(string.lower(speech), "phayla")
        or string.find(string.lower(speech), "lamp")
        or string.find(string.lower(speech), "help")
        or string.find(string.lower(speech), "information")
        or string.find(string.lower(speech), "clue")) then
    return true
end
if actor:get_quest_stage("supernova") == 2 and (actor:has_item(489, 17) or actor:has_equipped(489, 17)) then
    actor:advance_quest("supernova")

    -- Roll the random clue chain. Hoist locals out of branches so they are
    -- visible after the conditional.
    local step3
    local rnd1 = random(1, 3)
    if rnd1 == 1 then step3 = 4318
    elseif rnd1 == 2 then step3 = 10316
    else step3 = 58062
    end
    actor:set_quest_var("supernova", "step3", step3)

    local step4
    local rnd2 = random(1, 3)
    if rnd2 == 1 then step4 = 18577
    elseif rnd2 == 2 then step4 = 17277
    else step4 = 8561
    end
    actor:set_quest_var("supernova", "step4", step4)

    local step5
    local rnd3 = random(1, 3)
    if rnd3 == 1 then step5 = 53219
    elseif rnd3 == 2 then step5 = 47343
    else step5 = 16278
    end
    actor:set_quest_var("supernova", "step5", step5)

    local step6
    local rnd4 = random(1, 3)
    if rnd4 == 1 then step6 = 58657
    elseif rnd4 == 2 then step6 = 35119
    else step6 = 55422
    end
    actor:set_quest_var("supernova", "step6", step6)

    actor:set_quest_var("supernova", "step7", random(1, 3))

    self:say("Ah I see you found one of Phayla's lamps!")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage")
    self.room:send("</>in her favorite leisure activities.'")
    wait(2)
    if step3 == 4318 then
        self.room:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a")
        self.room:send("</>show from the best seat in the house.'")
    elseif step3 == 10316 then
        self.room:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at")
        self.room:send("</>the popular resort up north.'")
    elseif step3 == 58062 then
        self.room:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island")
        self.room:send("</>theatre, where she enjoys meditating in their reflecting room.'")
    end
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts")
    self.room:send("</>there.'")
elseif actor:get_quest_stage("supernova") == 1 then
    self.room:send(tostring(self.name) .. " says, 'If you return here with one of Phayla's lamps, I")
    self.room:send("</>may be able to give you some more insight as to her whereabouts.'")
end
return true