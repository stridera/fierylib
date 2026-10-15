-- Trigger: quest_eleweiss_ranger_druid_subclass_greet
-- Zone: 163, ID: 1
-- Type: MOB, Flags: GREET_ALL
--
-- Original DG Script: #16301
--
-- Eleweiss greets visitors. Behavior depends on which quest the actor is on:
--   * type_wand quest (wand-crafting):  prompt about upgrades / current task
--   * ran_dru_subclass quest:            class/level gate, opens dialog
--
-- The wand branch reads the step, element and weapon the questmaster's LOAD trigger (002_111)
-- stores in `globals`.
local dg = require("dg")
wait(0.2)

local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep
if wandstep and actor:get_quest_stage(wand_quest) == wandstep then
    local minlevel = (wandstep - 1) * 10
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

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before the class check below.

if (string.find(actor.class, "warrior") and (actor.level >= 10 and actor.level <= 25))
    or (string.find(actor.class, "cleric") and (actor.level >= 10 and actor.level <= 35)) then
    if actor:get_quest_stage("ran_dru_subclass") == 0 then
        self:emote("grins casually.")
        actor:send(tostring(self.name) .. " says, 'Some know the ways of the woods, others are ignorant.  Do you know the <b:cyan>ways</> or not?'")
        self:emote("puts a more serious look on his face.")
    elseif actor:get_quest_stage("ran_dru_subclass") == 4 and not actor:get_has_completed("ran_dru_subclass") then
        actor:send(tostring(self.name) .. " says, 'Have you the jewel of the heart?'")
    end
end
