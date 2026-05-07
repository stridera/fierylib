-- Trigger: silania_welcome
-- Zone: 185, ID: 1
-- Type: MOB, Flags: GREET
--
-- Silania greets the player. If they have an in-progress priest/paladin
-- subclass quest, nudges them. Otherwise, for eligible Warriors/Clerics
-- of the right race+level, ponders them as a quest hook. Also handles
-- the wand and mace upgrade quests when those are at this step.

wait(2)

local pp_stage = actor:get_quest_stage("pri_pal_subclass")
if pp_stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You've returned!  Let's talk about your <b:cyan>quest</>.'")
    return
elseif pp_stage == 2 or pp_stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you returned with the bronze chalice the diabolists stole?'")
    return
end

-- TODO(parity): wand/mace upgrade gating uses runtime-set quest stage strings
-- "wandstep"/"macestep" plus globals (wandstep, macestep, weapon) the legacy
-- system stored elsewhere. Confirm with rs design how subclass-step variables
-- are exposed before reactivating this branch.
local classgreet = "no"
local maxlevel = 0
if string.find(actor.class, "Warrior") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 25
    end
elseif string.find(actor.class, "Cleric") then
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
