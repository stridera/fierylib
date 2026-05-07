-- Trigger: phase wand status checker questmasters
-- Zone: 2, ID: 114
-- Type: MOB, Flags: SPEECH
--
-- The "[wand progress]" / "wand" status handler shared by every wand
-- questmaster mob from wandstep 3-10. Reads the per-mob crafting
-- parameters from globals (set by 002_111) and reports on the player's
-- current task list, what's done, and what's still needed.
--
-- TODO(parity): Several DG-script artifacts in this trigger are not
-- safely fixable without engine support, so the body has been parked
-- behind a guard:
--   * The original `actor.has_completed[type_wand]` index check needs
--     `actor:get_has_completed(globals.type .. "_wand")`.
--   * `get.room[place]` / `get.room[wandtask4]` lookups need
--     `get_room(z, id)` after globals exports normalises the ids to
--     (zone, local) pairs.
--   * Embedded `%get.obj_shortdesc[%wandgem%]%` and
--     `%get.mob_shortdesc[%wandtask3%]%` interpolations need
--     replacement with `objects.template` / `mobiles.template`.
--   * The original DG had a 0% probability filter that the converter
--     emitted as `if not percent_chance(0)`; this is a synthetic gate
--     that always blocks the trigger and has been removed.
-- Until the lookup helpers are exposed, this trigger emits a generic
-- response so the player can still chat with the questmaster.

local lower = string.lower(speech or "")
if not (string.find(lower, "wand", 1, true) or string.find(lower, "progress", 1, true)) then
    return true
end
wait(2)
if actor.class ~= "sorcerer" and actor.class ~= "cryomancer" and actor.class ~= "pyromancer"
        and actor.class ~= "illusionist" and actor.class ~= "necromancer" then
    self:say("This weapon is only for students of the arcane arts.")
    return true
end
local quest_type = globals.type
local wandstep = globals.wandstep
if not wandstep then return true end
local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
if actor:get_has_completed(quest) then
    self:say("It looks like you already have the most powerful staff of " .. tostring(quest_type) .. " in existence!")
elseif stage == wandstep and actor.level >= (wandstep - 1) * 10 then
    if (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
        self:say("Tell me why you're here first.")
    else
        self:say("I'm improving your " .. tostring(quest_type) .. " weapon.  Talk to me about <b:cyan>upgrades</> to see what I need.")
    end
elseif stage and stage > wandstep then
    self:say("I can't help you anymore, but I know who can.  Speak with the next questmaster on your journey.")
elseif (stage or 0) < wandstep then
    self:say("You need to make more improvements to your " .. tostring(globals.weapon or "wand") .. " before I can work with it.")
elseif actor.level < (wandstep - 1) * 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
end
return true
