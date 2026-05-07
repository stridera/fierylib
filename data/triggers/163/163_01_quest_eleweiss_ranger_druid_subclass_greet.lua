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
-- TODO(parity): the type_wand branch reads multiple DG-side globals
-- (`wandstep`, `weapon`, `type_wand:greet`, `type_wand:wandtask{1,2,3}`)
-- whose schemas aren't yet defined for the Lua runtime. The greeting strings
-- are preserved but the per-task lookups need a real schema before this is
-- wired up.

wait(2)

local wandstep = actor:get_quest_stage("type_wand")
if wandstep then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("type_wand:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif actor:get_quest_var("type_wand:wandtask1")
            and actor:get_quest_var("type_wand:wandtask2")
            and actor:get_quest_var("type_wand:wandtask3") then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            -- TODO(parity): `weapon` was a DG global naming the in-progress weapon.
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
        end
    end
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before the class check below.

if (string.find(actor.class, "Warrior") and (actor.level >= 10 and actor.level <= 25))
    or (string.find(actor.class, "Cleric") and (actor.level >= 10 and actor.level <= 35)) then
    if not actor:get_quest_stage("ran_dru_subclass") then
        self:emote("grins casually.")
        actor:send(tostring(self.name) .. " says, 'Some know the ways of the woods, others are ignorant.  Do you know the <b:cyan>ways</> or not?'")
        self:emote("puts a more serious look on his face.")
    elseif actor:get_quest_stage("ran_dru_subclass") == 4 and not actor:get_has_completed("ran_dru_subclass") then
        actor:send(tostring(self.name) .. " says, 'Have you the jewel of the heart?'")
    end
end
