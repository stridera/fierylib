-- Trigger: phase wands bigby research assistant receive
-- Zone: 2, ID: 102
-- Type: MOB, Flags: RECEIVE
--
-- Bigby's research assistant accepts:
--   * a basic wand (legacy vnums 300/310/320/330 = objects 2:100/110/120/130) once both bonding
--     tasks are done, to craft the next-tier wand (301/311/321/331 = 2:101/111/121/131) and award exp,
--   * the matching elemental gem (55574-55577 = objects 555:74-77) to mark wandtask2 complete.
-- The quest vars are reset to 0 after a stage, so every check goes through dg.flag.
-- Anything refused is handed back with `give`, the way legacy `return 0` refused a receive.
local dg = require("dg")

local function give_back()
    dg.give(self, object, actor)
end

local quest_type, wandgem, wand, next_id
if object.zone_id == 2 and object.id == 100 then
    quest_type, wandgem, wand, next_id = "air", 55577, true, 101
elseif object.zone_id == 2 and object.id == 110 then
    quest_type, wandgem, wand, next_id = "fire", 55575, true, 111
elseif object.zone_id == 2 and object.id == 120 then
    quest_type, wandgem, wand, next_id = "ice", 55574, true, 121
elseif object.zone_id == 2 and object.id == 130 then
    quest_type, wandgem, wand, next_id = "acid", 55576, true, 131
elseif object.zone_id == 555 and object.id == 77 then
    quest_type, wandgem = "air", true
elseif object.zone_id == 555 and object.id == 75 then
    quest_type, wandgem = "fire", true
elseif object.zone_id == 555 and object.id == 74 then
    quest_type, wandgem = "ice", true
elseif object.zone_id == 555 and object.id == 76 then
    quest_type, wandgem = "acid", true
end
if not quest_type then
    return true
end

local quest = quest_type .. "_wand"
local times = 50
local stage = actor:get_quest_stage(quest)

if stage == 2 then
    if wand then
        if dg.flag(actor:get_quest_var(quest .. ":wandtask1")) and dg.flag(actor:get_quest_var(quest .. ":wandtask2")) then
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
            dg.give(self, self:spawn_object(2, next_id), actor)
            local expmod = 690
            if actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
                expmod = expmod + math.floor(expmod / 5)
            elseif actor.class == "necromancer" then
                expmod = expmod + math.floor((expmod * 2) / 5)
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
            self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
            self:say("You haven't finished all the tasks to prime the wand yet.")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif wandgem then
        actor:set_quest_var(quest, "wandtask2", 1)
        wait(2)
        world.destroy(object)
        self:say("Yes, this is exactly what I need!")
        wait(1)
        if dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
            self:say("Give me the wand to improve.")
        else
            self:say("Keep practicing with your wand!")
            wait(2)
            self:say("Come back when you've attacked " .. tostring(times) .. " times.")
        end
    end
elseif stage < 2 then
    if wand then
        wait(2)
        if stage == 0 then
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
        self.room:send("- bring me <b:yellow>" .. dg.oname(wandgem) .. "</>")
        wait(2)
        self:say("Do that and I'll be able to improve it.")
        give_back()
    elseif wandgem then
        self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
        self:say("Before you give me anything else, give me the wand you wish to improve.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I've already upgraded your wand as much as I know how.")
    return false  -- legacy return 0: the giver keeps the item
end
return true
