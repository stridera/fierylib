-- Trigger: Druid receive
-- Zone: 120, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 11647 chars
--
-- Original DG Script: #12003

-- Converted from DG Script #12003: Druid receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("twisted_sorrow") > 1 then
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("No further offerings are necessary.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
elseif actor:get_quest_stage("twisted_sorrow") == 1 then
    if object.type == "LIQCONTAINER" then
        if self.room == 12015 then
            _return_value = false
            self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
            actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
            wait(4)
            self:say("Let us move to one of the mighty Rhells first, friend.")
            wait(4)
            actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
            self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
        else
            if object.val1 == 0 then
                _return_value = false
                self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                wait(4)
                self:emote("peers into " .. tostring(object.shortdesc) .. ".")
                wait(4)
                self:say("This won't do at all!  It's empty.")
                wait(4)
                actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
                self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
            elseif actor.quest_variable[twisted_sorrow:satisfied_tree:self.room] == 1 then
                _return_value = false
                self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                wait(4)
                self:say("This tree is already satisfied, my friend.")
                wait(4)
                actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
                self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
            else
                _return_value = true
                wait(1)
                self:emote("peers into " .. tostring(object.shortdesc) .. ".")
                wait(2)
                self:command("nod")
                wait(2)
                self:command("kneel")
                self:emote("places his hands on the mighty Rhell's roots.")
                wait(5)
                self:emote("continues to kneel, making no sound.")
                wait(7)
                self:command("stand")
                local success = 0
                -- The tree of Luck: tea
                if self.room == 12016 and object.val2 == 11 then
                    local success = 1
                    -- The tree of Reverence: moderate alcohol
                elseif self.room == 12017 and object.val2 > 0 and object.val2 < 5 then
                    local success = 1
                    -- The tree of self-reliance: water
                elseif self.room == 12018 and object.val2 == 0 then
                    local success = 1
                    -- The tree of nimbleness: coffee
                elseif self.room == 12014 and object.val2 == 12 then
                    local success = 1
                    -- The tree of kindness: milk
                elseif self.room == 12046 and object.val2 == 10 then
                    local success = 1
                end
                self.room:send(tostring(self.name) .. " carefully pours out " .. tostring(object.shortdesc) .. " onto the Rhell's roots.")
                wait(1)
                world.destroy(object.name)
                wait(8)
                if success == 1 then
                    local num_trees = 1 + actor:get_quest_var("twisted_sorrow:num_trees")
                    actor.name:set_quest_var("twisted_sorrow", "num_trees", num_trees)
                    actor.name:set_quest_var("twisted_sorrow", "satisfied_tree:%self.room%", 1)
                    self.room:send("A deep throbbing hum is emanating from the ground.")
                    wait(3)
                    self.room:send("The hum gets louder and louder, causing twigs and leaves to dance upon the ground!")
                    self.room:send("It is overwhelming, yet soothing.")
                    wait(5)
                    self.room:send("The hum fades slowly away, and all is quiet again.")
                    wait(3)
                    self:command("smile")
                    wait(2)
                    if num_trees < 4 then
                        self:say("You have done this tree a great service.")
                    elseif num_trees == 4 then
                        self:say("I sense that yet another tree waits in loneliness.")
                        wait(1)
                        self:say("There can be no peace until it, too, is satisfied.")
                    elseif num_trees == 5 then
                        self:say("Excellent, my friend!  The trees are satisfied.")
                        wait(8)
                        self:say("Please take this gift on their behalf.")
                        wait(8)
                        self.room:spawn_object(120, 18)
                        self:command("give sleeves-sorrow " .. tostring(actor.name))
                        self:follow(self.room:find_actor("me"))
                        wait(4)
                        self:emote("walks away quietly.")
                        actor.name:complete_quest("twisted_sorrow")
                        -- 
                        -- Set X to the level of the award - code does not run without it
                        -- 
                        if actor.level < 10 then
                            local expcap = actor.level
                        else
                            local expcap = 10
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
                            local expmod = (expmod + ((expmod * 2) / 15)
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
                            actor:award_exp(expmod)
                            local loop = loop + 1
                        end
                        self:teleport(get_room(120, 15))
                    end
                else
                    self:command("sigh")
                    wait(8)
                    self:say("The tree is not responding.")
                    wait(1)
                    self:say("I fear it has little liking for that drink.")
                end
                -- Here is where the object could be returned, if a way to
                -- empty it could be devised.
            end
        end
    else
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        wait(4)
        self:say("This is not a liquid container.")
        wait(4)
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    end
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("Why do you give me this?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value