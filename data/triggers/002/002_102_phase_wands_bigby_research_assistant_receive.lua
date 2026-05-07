-- Trigger: phase wands bigby research assistant receive
-- Zone: 2, ID: 102
-- Type: MOB, Flags: RECEIVE
--
-- Bigby's research assistant accepts:
--   * a basic wand (300/310/320/330) once both bonding tasks are done,
--     to craft the next-tier wand and award exp,
--   * the matching elemental gem (55574-55577) to mark wandtask2 complete.
-- Each wand id is paired with the gem id and the next-tier reward id.
local _return_value = true

local quest_type, wandgem, wand, next_id
if object.id == 300 then
    quest_type, wandgem, wand, next_id = "air", 55577, true, 101
elseif object.id == 310 then
    quest_type, wandgem, wand, next_id = "fire", 55575, true, 111
elseif object.id == 320 then
    quest_type, wandgem, wand, next_id = "ice", 55574, true, 121
elseif object.id == 330 then
    quest_type, wandgem, wand, next_id = "acid", 55576, true, 131
elseif object.id == 55577 then
    quest_type, wandgem = "air", true
elseif object.id == 55575 then
    quest_type, wandgem = "fire", true
elseif object.id == 55574 then
    quest_type, wandgem = "ice", true
elseif object.id == 55576 then
    quest_type, wandgem = "acid", true
end
if not quest_type then
    return _return_value
end

local quest = quest_type .. "_wand"
local times = 50
local stage = actor:get_quest_stage(quest)

if stage == 2 then
    if wand then
        if actor:get_quest_var(quest .. ":wandtask1") and actor:get_quest_var(quest .. ":wandtask2") then
            actor:advance_quest(quest)
            actor:set_quest_var(quest, "greet", 0)
            actor:set_quest_var(quest, "attack_counter", 0)
            for n = 1, 5 do
                actor:set_quest_var(quest, "wandtask" .. tostring(n), 0)
            end
            wait(2)
            self:say("Fantastic work!  This is everything.")
            wait(1)
            self.room:send(tostring(self.name) .. " combines the materials to empower " .. tostring(object.shortdesc) .. "!")
            world.destroy(object)
            wait(2)
            actor:send(tostring(self.name) .. " presents you with a new wand!")
            self.room:spawn_object(2, next_id)
            self:command("give wand " .. tostring(actor.name))
            local expmod = 690
            if actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
                expmod = expmod + (expmod / 5)
            elseif actor.class == "Necromancer" then
                expmod = expmod + ((expmod * 2) / 5)
            end
            actor:send("<b:yellow>You gain experience!</>")
            local setexp = expmod * 10
            for _ = 1, 5 do
                actor:award_exp(setexp)
            end
            wait(2)
            if actor.level < 20 then
                self:say("In time, you'll be able to take another step.  Come back when you've seen some more of the world.")
            else
                self:say("You're ready to take the next step.")
                wait(1)
                if quest_type == "air" then
                    self:say("Speak with the old Abbot in the Abbey of St. George.")
                elseif quest_type == "fire" then
                    self:say("The keeper of the temple to the dark flame out east will know what to do.")
                elseif quest_type == "ice" then
                    self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
                elseif quest_type == "acid" then
                    self:say("First, seek the one who guards the eastern gates of Ickle.")
                end
            end
        else
            self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with suspicion.")
            wait(1)
            self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
            self:say("You haven't finished all the tasks to prime the wand yet.")
        end
    elseif wandgem then
        actor:set_quest_var(quest, "wandtask2", 1)
        wait(2)
        world.destroy(object)
        self:say("Yes, this is exactly what I need!")
        wait(1)
        if actor:get_quest_var(quest .. ":wandtask1") then
            self:say("Give me the wand to improve.")
        else
            self:say("Keep practicing with your wand!")
            wait(2)
            self:say("Come back when you've attacked " .. tostring(times) .. " times.")
        end
    end
elseif (stage or 0) < 2 then
    if wand then
        wait(2)
        if not stage then
            actor:start_quest(quest)
            self:say("I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'This step is relatively simple though.  You can check your <b:cyan>[wand progress]</> with me as well.'")
            wait(1)
        end
        actor:advance_quest(quest)
        self:command("nod")
        self:say("Yes, this is a good match for you.")
        wait(1)
        self:say("To upgrade your wand:")
        self.room:send("- attack <b:yellow>" .. tostring(times) .. "</> times with it")
        self.room:send("- bring me <b:yellow>" .. tostring(objects.template(555, wandgem - 55520).name) .. "</>")
        wait(2)
        self:say("Do that and I'll be able to improve it.")
        self:command("give wand " .. tostring(actor.name))
    elseif wandgem then
        self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self:say("Before you give me anything else, give me the wand you wish to improve.")
    end
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("I've already upgraded your wand as much as I know how.")
end
return _return_value
