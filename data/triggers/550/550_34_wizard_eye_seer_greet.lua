-- Trigger: wizard_eye_seer_greet
-- Zone: 550, ID: 34
-- Type: MOB, Flags: GREET
--
-- Seer of Griffin Isle greet handler: the Wizard Eye quest lines, plus the wand branch for the air
-- wand's step 7 (the step, element and weapon come from the LOAD trigger 002_111 through `globals`).
--
-- Original DG Script: #55034

-- Converted from DG Script #55034: wizard_eye_seer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep
local minlevel = ((wandstep or 1) - 1) * 10
local on_wand = wandstep ~= nil and actor:get_quest_stage(wand_quest) == wandstep and actor.level >= minlevel
local greeted = (actor:get_quest_var(wand_quest .. ":greet") or 0) ~= 0
if actor:get_quest_stage("wizard_eye") == 3 then
    actor:send(tostring(self.name) .. " says, 'I had a feeling you would show up soon.  The shaman from Technitzitlan has sent you to me, yes?'")
    if on_wand then
        wait(1)
        if not greeted then
            actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
        end
    end
elseif actor:get_quest_stage("wizard_eye") == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the herbs?'")
    if on_wand then
        wait(1)
        if not greeted then
            actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
        else
            actor:send(tostring(self.name) .. " says, 'And do you have what I need for the staff?'")
        end
    end
elseif on_wand then
    if not greeted then
        actor:send(tostring(self.name) .. " says, 'I've been expecting you!  Tell me, what brings you to me?'")
    else
        actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
    end
end
