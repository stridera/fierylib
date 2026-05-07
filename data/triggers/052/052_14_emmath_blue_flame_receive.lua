-- Trigger: Emmath blue flame receive
-- Zone: 52, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   TODO: the second half ("phase wand") references undefined globals
--         (`step`, `type`, `weapon`) and DG-style `%type%_wand` quest keys.
--         The crafting quest needs a real schema (step number, weapon
--         kind, element type) before this branch can be implemented.
--         Branch is left in place as a comment block for porting.
--
-- Original DG Script: #5214
--
-- Receive handler dedicated to the renegade blue flame (238:22). Stage 2
-- rejects it (still gathering basics); stage 3 destroys it, completes the
-- emmath_flameball quest, and gives the actor object 52:10.

get_room(238, 90):at(function()
    run_room_trigger(238, 14)
end)
-- flameball
if actor:get_quest_stage("emmath_flameball") == 2 and actor:get_quest_stage("type_wand") ~= "step" then
    wait(2)
    self:destroy_item("blue-flame")
    self:command("eye")
    actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.'")
    actor:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    wait(2)
    self:destroy_item("blue-flame")
    actor:send(tostring(self.name) .. " says, 'Ah yes... the blue flame.'")
    self:command("smile self")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Such a pity to destroy such an artifact as this.'")
    self:emote("pauses momentarily.")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'But it must be done.'")
    wait(1)
    self:emote("crushes the blue flame in his hand, its essence evaporating into the air.")
    wait(2)
    self:command("lick")
    wait(2)
    self:command("look " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I.  You seem ready for the power.'")
    actor:erase_quest("emmath_flameball")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
    self.room:spawn_object(52, 10)
    self:command("give ball " .. tostring(actor.name))
end
-- TODO: phase-wand branch elided pending crafting-quest schema rewrite.
-- The legacy DG required globals `step`, `type`, `weapon` and used
-- `%type%_wand` percent-substituted quest names; none of those exist in
-- the Lua runtime. Re-introduce after the type_wand quest is redesigned.
return true