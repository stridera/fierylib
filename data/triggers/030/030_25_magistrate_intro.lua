-- Trigger: Magistrate_intro
-- Zone: 30, ID: 25
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3025

-- Converted from DG Script #3025: Magistrate_intro
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(5)
    actor:send(tostring(self.name) .. " says to you, 'Greetings, " .. tostring(actor.name) .. ".  It is good to see you.  If you would like, I have some <b:cyan>[quests]</> you could give me a hand with.'")
    wait(1)
    if (actor:get_quest_stage("phase_mace") == 1 or (not actor:get_quest_stage("phase_mace") and (actor:has_equipped("340") or actor:has_item("340")))) and not actor:get_quest_var("phase_mace:greet") then
        actor:send(tostring(self.name) .. " says, 'Oh and you've found quite an unusual mace!  I could probably help you <b:cyan>[upgrade]</> it.'")
    elseif actor:get_quest_stage("phase_mace") == 1 and actor:get_quest_var("phase_mace:greet") then
        actor:send(tostring(self.name) .. " says, 'Have you found what I require?'")
    end
end