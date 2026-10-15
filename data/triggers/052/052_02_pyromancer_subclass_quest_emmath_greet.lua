-- Trigger: pyromancer_subclass_quest_emmath_greet
-- Zone: 52, ID: 2
-- Type: MOB, Flags: GREET_ALL
--
-- Original DG Script: #5202
--
-- Greet for Emmath Firehand. Three behaviors stacked here:
--   1. crafting-quest hint if the player is mid-staff-upgrade (the step, element and weapon come
--      from the LOAD trigger 002_111 through `globals`).
--   2. Pyromancer subclass progress reminders by stage.
--   3. First-contact recruitment patter for eligible Sorcerers.
wait(0.2)
local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
local stage = actor:get_quest_stage("pyromancer_subclass")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Come back to try again have you?  Only the best and most motivated of mages will complete the quest I lay before you.'")
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this <b:red>quest</> and become a pyromancer.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Are you ready to finish listening now?  I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and <b:black>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif stage == 3 or stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame?  Give it here!'")
else
    if string.find(actor.class, "sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            return true
        else
            if actor.level >= 10 and actor.level <= 45 then
                self.room:send("Emmath Firehand's glowing eyes flash brightly for a moment.")
                actor:send(tostring(self.name) .. " says, 'Some love the life of <b:red>flame</>.  Do you?'")
                self:emote("flicks a grin around the room.")
            elseif string.find(actor.class, "sorcerer") and actor.level < 10 then
                self:emote("stares in amazement at " .. tostring(actor.name) .. ".")
                actor:send(tostring(self.name) .. " says, 'I have no idea how you found me but you are far too inexperienced to be in these tunnels in the first place, and even less to ask for my guidance.'")
            end
        end
    end
end