-- Trigger: Illusionist Subclass progress journal
-- Zone: 4, ID: 66
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #466

-- Converted from DG Script #466: Illusionist Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local illusionraces = "none"
    if string.find(arg, "Illusionist") and string.find(actor.class, "Sorcerer") and actor.level <= 45 and not (string.find(illusionraces, "actor.race")) then
        _return_value = false
        actor:send("<b:magenta>Illusionist</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(172, 0).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("illusionist_subclass") then
            actor:send(tostring(mobiles.template(172, 0).name) .. " said to you:")
            -- switch on actor:get_quest_stage("illusionist_subclass")
            if actor:get_quest_stage("illusionist_subclass") == 1 then
                actor:send("This is what I need you to do...")
                actor:send("That ruffian in the smuggler's hideout once stole a woman from me, on the very eve of our betrothal announcement.")
                actor:send("Or my pride, perhaps.")
                actor:send("It appears that she was his from the very beginning._")
                actor:send("She has departed, she is lost, my dear Cestia...")
                actor:send("She boarded a ship for the southern seas and never returned.")
                actor:send("I fear she is dead.")
                actor:send("But she may have survived, and on that fact this plan hinges._")
                actor:send("I gave her a valuable onyx choker as a betrothal gift.")
                actor:send("She took it in her deceit._")
                actor:send("The smuggler leader took the choker, and keeps it as a prize.")
                actor:send("To humiliate me, perhaps.")
                actor:send("And now he has raised defenses that even I cannot penetrate._")
                actor:send("He knows my fatal weakness: hay fever._")
                actor:send("So he has placed flowers, to reveal me should I enter his home in disguise._")
                actor:send("This is where you come in._")
                actor:send("I would like you to enter the hideout in disguise and take back the choker.")
                actor:send("But beware: it is well hidden._")
                actor:send("Somehow that brutish fool has engaged the services of an illusionist...")
                actor:send("I would like to know who helped him... but no matter._")
                actor:send("'I will enchant you to resemble dear Cestia when the smugglers look upon you.")
                actor:send("Their leader will no doubt welcome you with open arms._")
                actor:send("'But we must ensure that he will reveal its hiding place to you.")
                actor:send("For that, we will make it appear as if the guards of Mielikki have discovered their hideout._")
                actor:send("It is my hope that the leader will hide you - Cestia - for safekeeping, in his most secure location._")
                actor:send("There, perhaps, you will find the choker._")
                actor:send("'I will give you a vial of disturbance.")
                actor:send("Drop it and once you find their leader Gannigan sounds of shouting and fighting will resonate throughout the area.")
                actor:send("It will convince the smugglers that they are under attack._")
                actor:send("You must take care to drop it out of sight of any smugglers, or they may become suspicious.")
                actor:send("Then go immediately to the leader, and stall him until you hear the sounds of invasion._")
                actor:send("Come back and ask for <b:cyan>help</> if you get stuck!")
            elseif actor:get_quest_stage("illusionist_subclass") == 2 then
                actor:send("Did you meet with the leader?")
                actor:send("I hope the disguise was sufficient._")
                actor:send("Perhaps it would be worthwhile to try again.")
                actor:send("The smuggler leader should be searching high and low for Cestia, now._")
                actor:send("If you are willing, I will refresh your disguise for another attempt.")
                actor:send("Say <b:white>'begin'</> when you are ready.")
            else
                actor:send("Do you have the choker?  Did you lose it?_")
                actor:send("If you want to try again, say <b:white>'restart'</> and I will refresh your magical disguise.")
            end
        end
    end
end
return _return_value