-- Trigger: Fiery_Island_Quest_Grant_rewards
-- Zone: 481, ID: 45
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48145

-- Converted from DG Script #48145: Fiery_Island_Quest_Grant_rewards
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
local person = self.people
while person do
    if person:get_quest_var("fieryisle_quest:reward") == "yes" and not person:get_has_completed("fieryisle_quest") then
        person:send("You notice special glittering gems amongst the chamber's crystals!")
        -- 
        -- Set X to the level of the award - code does not run without it
        -- Fiery Island, X = 55
        if person.level < 55 then
            local expcap = person.level
        else
            local expcap = 55
        end
        local expmod = 0
        if expcap < 9 then
            local expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        -- 
        -- Adjust exp award by class so all classes receive the same proportionate amount
        -- 
        -- switch on person.class
        if person.class == "Warrior" or person.class == "Berserker" then
            -- 
            -- 110% of standard
            -- 
            local expmod = (expmod + (expmod / 10))
        elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
            -- 
            -- 115% of standard
            -- 
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
            -- 
            -- 120% of standard
            -- 
            local expmod = (expmod + (expmod / 5))
        elseif person.class == "Necromancer" or person.class == "Monk" then
            -- 
            -- 130% of standard
            -- 
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        person:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- Fiery Island, xexp = wexp
            person:award_exp(setexp)
            local loop = loop + 1
        end
        local gem = 0
        while gem < 3 do
            local drop = random(1, 11) + 55736
            self.room:spawn_object(vnum_to_zone(drop), vnum_to_local(drop))
            local gem = gem + 1
        end
        person:command("get all.gem")
        person.name:complete_quest("fieryisle_quest")
    end
    local person = person.next_in_room
end