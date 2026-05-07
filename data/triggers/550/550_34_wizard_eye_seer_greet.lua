-- Trigger: wizard_eye_seer_greet
-- Zone: 550, ID: 34
-- Type: MOB, Flags: GREET
--
-- Seer of Griffin Isle greet handler for the Wizard Eye quest.
-- TODO(parity): legacy script also dispatched on a `wandstep`/`type_wand`
-- crafting branch with level gate `(wandstep - 1) * 10`. Those tokens
-- were DG-script substitutions whose values weren't preserved during
-- conversion, so the wand-quest branch is omitted pending rewrite.
--
-- Original DG Script: #55034

-- Converted from DG Script #55034: wizard_eye_seer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("wizard_eye") == 3 then
    actor:send(tostring(self.name) .. " says, 'I had a feeling you would show up soon.  The shaman from Technitzitlan has sent you to me, yes?'")
elseif actor:get_quest_stage("wizard_eye") == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the herbs?'")
end