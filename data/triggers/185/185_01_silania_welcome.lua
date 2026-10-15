-- Trigger: silania_welcome
-- Zone: 185, ID: 1
-- Type: MOB, Flags: GREET
--
-- Silania greets the player. If they have an in-progress priest/paladin
-- subclass quest, nudges them. Otherwise, for eligible Warriors/Clerics
-- of the right race+level, ponders them as a quest hook. Also handles
-- the wand and mace upgrade quests when those are at this step (the step, element, weapon come
-- from the LOAD triggers 002_111 / 002_118 through `globals`; Silania is the air wand's step 10
-- crafter and the mace's step 6 priest).
local dg = require("dg")

wait(2)

local pp_stage = actor:get_quest_stage("pri_pal_subclass")
if pp_stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You've returned!  Let's talk about your <b:cyan>quest</>.'")
elseif pp_stage == 2 or pp_stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you returned with the bronze chalice the diabolists stole?'")
end

local classgreet = "no"
local maxlevel = 0
if pp_stage >= 1 and pp_stage <= 3 then
    -- already on the subclass quest: no recruiting patter
elseif string.find(actor.class, "warrior") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 25
    end
elseif string.find(actor.class, "cleric") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 35
    end
end

if classgreet == "yes" and actor.level >= 10 and actor.level <= maxlevel then
    actor:send(tostring(self.name) .. " says, 'Some know not of their <b:cyan>destinies</>, others simply choose to ignore them.  Which of the two are you?'")
    wait(2)
    self:command("ponder " .. tostring(actor.name))
end

local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
if globals.macestep and actor:get_quest_stage("phase_mace") == globals.macestep then
    local minlevel = globals.macestep * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end
