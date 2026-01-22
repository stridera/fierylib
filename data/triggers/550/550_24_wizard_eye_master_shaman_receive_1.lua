-- Trigger: Wizard Eye Master Shaman receive 1
-- Zone: 550, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55024

-- Converted from DG Script #55024: Wizard Eye Master Shaman receive 1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("wizard_eye")
if stage == 2 then
    wait(2)
    world.destroy(object)
    actor.name:advance_quest("wizard_eye")
    actor:send(tostring(self.name) .. " says, 'Ah, marigold for clairvoyance.  That makes sense.  I will store it while you seek the advice of the next sage.'")
    actor:send(tostring(self.name) .. " tucks the marigold poultice away in her chamber.")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'There are a handful of true visionaries in Ethilien, but one stands out among the rest.  The <b:cyan>Seer of Griffin Isle</> always receives the most cryptic of visions.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Whatever a \"sun screen\" is I have no idea, but she speaks of it often.'")
    self:command("ponder")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Often I am forced to question her sanity...'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Regardless of her mental state, she is a truly master diviner.  <b:cyan>Visit her</> and see what she recommends you do to attune to your future crystal ball.'")
end