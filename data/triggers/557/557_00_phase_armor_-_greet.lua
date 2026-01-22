-- Trigger: Phase Armor - Greet
-- Zone: 557, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 24 if statements
--   Large script: 7045 chars
--
-- Original DG Script: #55700

-- Converted from DG Script #55700: Phase Armor - Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
local _return_value = true  -- Default: allow action
wait(2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    _return_value = false
else
    if actor.level <= (20 * (phase - 1)) then
        _return_value = false
    elseif not (string.find(classes, "actor.class")) or (classes == "anti" and actor.class == "Paladin") then
        _return_value = false
    elseif actor:get_quest_stage("phase_armor") == (phase - 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Welcome, would you like to do some armor quests?  If so, just ask me about them.'")
    end
end
if string.find(self.class, "necromancer") then
    if actor:get_quest_stage("shift_corpse") then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'May Death guide your hunt for Lokari.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you need a new crystal, msend " .. tostring(actor) .. " " .. tostring(self.name) .. " says, &9<blue>\"I need a new crystal\"</>.'")
    end
elseif string.find(self.class, "pyromancer") then
    if actor:get_quest_stage("supernova") == 2 and (actor:has_item("48917") or actor:has_equipped("48917")) then
        actor.name:advance_quest("supernova")
        local rnd1 = random(1, 3)
        -- switch on rnd1
        if rnd1 == 1 then
            local step3 = 4318
        elseif rnd1 == 2 then
            local step3 = 10316
        elseif rnd1 == 3 then
            local step3 = 58062
        end
        actor.name:set_quest_var("supernova", "step3", step3)
        local rnd2 = random(1, 3)
        -- switch on rnd2
        if rnd2 == 1 then
            local step4 = 18577
        elseif rnd2 == 2 then
            local step4 = 17277
        elseif rnd2 == 3 then
            local step4 = 8561
        end
        actor.name:set_quest_var("supernova", "step4", step4)
        local rnd3 = random(1, 3)
        -- switch on rnd3
        if rnd3 == 1 then
            local step5 = 53219
        elseif rnd3 == 2 then
            local step5 = 47343
        elseif rnd3 == 3 then
            local step5 = 16278
        end
        actor.name:set_quest_var("supernova", "step5", step5)
        local rnd4 = random(1, 3)
        -- switch on rnd4
        if rnd4 == 1 then
            local step6 = 58657
        elseif rnd4 == 2 then
            local step6 = 35119
        elseif rnd4 == 3 then
            local step6 = 55422
        end
        actor.name:set_quest_var("supernova", "step6", step6)
        local step7 = random(1, 3)
        actor.name:set_quest_var("supernova", "step7", step7)
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ah I see you found one of Phayla's lamps!'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage in her favorite leisure activities.'")
        wait(2)
        local clue = actor:get_quest_var("supernova:step3")
        -- switch on clue
        if clue == 4318 then
            actor:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a show from the best seat in the house.'")
        elseif clue == 10316 then
            actor:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at the popular resort up north.'")
        elseif clue == 58062 then
            actor:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.'")
        end
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts there.'")
    end
elseif (self.class == "cleric" or self.class == "priest" or self.class == "Diabolist") and macestep then
    if actor:get_quest_stage("phase_mace") == "macestep" then
        local minlevel = macestep * 10
        if actor.level >= minlevel then
            wait(2)
            if actor:get_quest_var("phase_mace:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the mace?'")
            end
        end
    end
end
if actor:get_quest_stage("ursa_quest") and self.vnum == 6007 then
    wait(1)
    actor:send(tostring(self.name) .. " notices the concerned look on your face.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'So, the merchant has gotten himself in quite a bit of trouble.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'I know what he must do, but he won't like it.'")
    self:command("chuckle")
    wait(1)
    actor:send(tostring(self.name) .. " dips his quill in a well of blood and scratches out a sinister letter.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Quickly, take this to him!  Perhaps the Darkness still finds him...  amusing.'")
    self.room:spawn_object(625, 10)
    self:command("give letter " .. tostring(actor))
end
if actor:get_quest_stage("hell_trident") == 1 and self.id == 6032 then
    if actor.level >= 65 then
        wait(2)
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("banish") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hellfire_brimstone") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask6") then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        if actor:get_quest_var("hell_trident:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'Hmmm, is that a demon's trident I sense on you?  Perhaps you would like some help with <b:cyan>[upgrades]</>.'")
        else
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'You return with victory in your eyes.  Hand me your trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Have you met Hell's demands?'")
            end
        end
    end
end
return _return_value