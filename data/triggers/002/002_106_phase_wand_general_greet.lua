-- Trigger: phase wand general greet
-- Zone: 2, ID: 106
-- Type: MOB, Flags: GREET_ALL
--
-- Generic greet handler shared by every wand questmaster mob loaded by
-- 002_111. If the player is at this mob's wandstep and meets the level
-- requirement, the mob either offers help (first time) or asks if they
-- have what they need (subsequent visits, gated by the per-quest "greet"
-- var).
wait(2)
local wandstep = globals.wandstep
if not wandstep then return end
local minlevel = (wandstep - 1) * 10
local quest = (globals.type or "type") .. "_wand"
if actor:get_quest_stage(quest) == wandstep and actor.level >= minlevel then
    if (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
    else
        self:say("Do you have what I need?")
    end
end
