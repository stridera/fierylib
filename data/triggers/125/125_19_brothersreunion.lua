-- Trigger: BrothersReunion
-- Zone: 125, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #12519

-- Converted from DG Script #12519: BrothersReunion
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 12502 then
    _return_value = true
    if actor:get_quest_stage("krisenna_quest") == 4 then
        self:destroy_item("warhammer")
        wait(1)
        self:emote("weeps as he realizes that his brother is dead.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Thank you for finding him.  I will take word to my")
        self.room:send("</>family.'")
        wait(1)
        self:say("Please, take this for your efforts.")
        wait(1)
        self:say("It was our great grandfather's.")
        self.room:spawn_object(125, 50)
        self:command("give monocle " .. tostring(actor.name))
        wait(2)
        self:say("And take these as well.")
        local gem = 0
        while gem < 3 do
            local drop = random(1, 11) + 55703
            self.room:spawn_object(vnum_to_zone(drop), vnum_to_local(drop))
            local gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
        actor.name:complete_quest("krisenna_quest")
        -- 
        -- Set X to the level of the award - code does not run without it
        -- 
        if actor.level < 40 then
            local expcap = actor.level
        else
            local expcap = 40
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
        -- Adjust exp award by class so all classes receive the same proprotionate amount
        -- 
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            -- 
            -- 110% of standard
            -- 
            local expmod = (expmod + (expmod / 10))
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            -- 
            -- 115% of standard
            -- 
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            -- 
            -- 120% of standard
            -- 
            local expmod = (expmod + (expmod / 5))
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            -- 
            -- 130% of standard
            -- 
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- 
            actor:award_exp(setexp)
            local loop = loop + 1
        end
        wait(2)
        self.room:send(tostring(self.name) .. " becomes very silent.")
    else
        wait(2)
        self:say("Why yes, this -was- mine, thanks!")
        self:destroy_item("warhammer")
    end
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("I don't want this.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value