-- Trigger: phase wands bigby research assistant receive
-- Zone: 3, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--   Complex nesting: 11 if statements
--   Large script: 6900 chars
--
-- Original DG Script: #302

-- Converted from DG Script #302: phase wands bigby research assistant receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 300 then
    local type = "air"
    local wandgem = 55577
    local wand = "yes"
    local next_zone, next_local = 3, 1
elseif object.id == 310 then
    local type = "fire"
    local wandgem = 55575
    local wand = "yes"
    local next_zone, next_local = 3, 11
elseif object.id == 320 then
    local type = "ice"
    local wandgem = 55574
    local wand = "yes"
    local next_zone, next_local = 3, 21
elseif object.id == 330 then
    local type = "acid"
    local wandgem = 55576
    local wand = "yes"
    local next_zone, next_local = 3, 31
elseif object.id == 55577 then
    local type = "air"
    local wandgem = "yes"
elseif object.id == 55575 then
    local type = "fire"
    local wandgem = "yes"
elseif object.id == 55574 then
    local type = "ice"
    local wandgem = "yes"
elseif object.id == 55576 then
    local type = "acid"
    local wandgem = "yes"
end
local times = 50
-- Is this a wand or gem?
if wand == "yes" or wandgem == "yes" then
    -- Are we on the crafting stage?
    if actor:get_quest_stage(type .. "_wand") == 2 then
        if wand == "yes" then
            if actor:get_quest_var(type .. "_wand", "wandtask1") and actor:get_quest_var(type .. "_wand", "wandtask2") then
                actor:advance_quest("%type%_wand")
                actor:set_quest_var("%type%_wand", "greet", 0)
                actor:set_quest_var("%type%_wand", "attack_counter", 0)
                local num = 1
                while num <= 5 do
                    actor:set_quest_var("%type%_wand", "wandtask%num%", 0)
                    local num = num + 1
                end
                wait(2)
                self:say("Fantastic work!  This is everything.")
                wait(1)
                self.room:send(tostring(self.name) .. " combines the materials to empower " .. tostring(object.shortdesc) .. "!")
                world.destroy(object)
                wait(2)
                actor:send(tostring(self.name) .. " presents you with a new wand!")
                self.room:spawn_object(next_zone, next_local)
                self:command("give wand " .. tostring(actor))
                local expcap = 10
                local expmod = 690
                -- Adjust exp award by class so all classes receive the same proportionate amount
                -- switch on actor.class
                if actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
                    -- 120% of standard
                    local expmod = (expmod + (expmod / 5))
                elseif actor.class == "Necromancer" then
                    -- 130% of standard
                    local expmod = (expmod + (expmod * 2) / 5)
                else
                    local expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 5 do
                    actor:award_exp(setexp)
                    local loop = loop + 1
                end
                wait(2)
                if actor.level < 20 then
                    self:say("In time, you'll be able to take another step.  Come back when you've seen some more of the world.")
                else
                    self:say("You're ready to take the next step.")
                    wait(1)
                    if type == "air" then
                        self:say("Speak with the old Abbot in the Abbey of St. George.")
                    elseif type == "fire" then
                        self:say("The keeper of the temple to the dark flame out east will know what to do.")
                    elseif type == "ice" then
                        self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
                    elseif type == "acid" then
                        self:say("First, seek the one who guards the eastern gates of Ickle.")
                    end
                end
            else
                _return_value = false
                self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with suspicion.")
                wait(1)
                self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
                self:say("You haven't finished all the tasks to prime the wand yet.")
            end
        elseif wandgem == "yes" then
            actor:set_quest_var("%type%_wand", "wandtask2", 1)
            wait(2)
            world.destroy(object)
            self:say("Yes, this is exactly what I need!")
            wait(1)
            if actor:get_quest_var(type .. "_wand", "wandtask1") then
                self:say("Give me the wand to improve.")
            else
                self:say("Keep practicing with your wand!")
                wait(2)
                self:say("Come back when you've attacked " .. tostring(times) .. " times.")
            end
        end
    elseif actor:get_quest_stage(type .. "_wand") < 2 then
        if wand then
            wait(2)
            if not actor:get_quest_stage(type .. "_wand") then
                actor:start_quest("%type%_wand")
                self:say("I can upgrade your " .. tostring(type) .. " wand!  But what I will do is just the first step in a life-long journey.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'This step is relatively simple though.  You can check your <b:cyan>[wand progress]</> with me as well.'")
                wait(1)
            end
            actor:advance_quest("%type%_wand")
            self:command("nod")
            self:say("Yes, this is a good match for you.")
            wait(1)
            self:say("To upgrade your wand:")
            self.room:send("- attack <b:yellow>" .. tostring(times) .. "</> times with it")
            self.room:send("- bring me <b:yellow>" .. "%get.obj_shortdesc[%wandgem%]%</>")
            wait(2)
            self:say("Do that and I'll be able to improve it.")
            self:command("give wand " .. tostring(actor))
        elseif wandgem then
            _return_value = false
            self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("Before you give me anything else, give me the wand you wish to improve.")
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("I've already upgraded your wand as much as I know how.")
    end
end
return _return_value