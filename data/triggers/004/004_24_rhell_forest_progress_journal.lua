-- Trigger: Rhell Forest progress journal
-- Zone: 4, ID: 24
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #424

-- Converted from DG Script #424: Rhell Forest progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "rhell") or string.find(arg, "forest") or string.find(arg, "mystery") or string.find(arg, "ursa_quest") or string.find(arg, "mystery_of_the_rhell_forest") then
    if actor.level >= 35 then
        _return_value = false
        local stage = actor:get_quest_stage("ursa_quest")
        local path = actor:get_quest_var("ursa_quest:choice")
        actor:send("<b:green>&uMystery of the Rhell Forest</>")
        actor:send("Find the sick merchant in the Rhell Forest and help end his distress.")
        actor:send("Recommended Level: 45")
        if actor:get_has_completed("ursa_quest") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ursa_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(625, 6).name))
            actor:send("</>")
            actor:send("The merchant told you:")
            -- switch on stage
            if not path then
                if stage == 1 then
                    actor:send("Please visit one of these powerful people, and ask for a cure:")
                    actor:send("</>")
                    actor:send("- The Emperor, on a nearby island of very refined people")
                    actor:send("- Ruin Wormheart in the Red City")
                    actor:send("- The crazy hermit of the swamps")
                else
                    actor:send("Return with the cure.")
                end
                if path == 1 then
                elseif stage == 2 then
                    actor:send("Please bring me some pepper.  Prices are always cheapest up near Anduin.")
                elseif path == 2 then
                    actor:send("Return to me a particular sceptre of gold that symbolized a king's undying leadership.")
                elseif path == 3 then
                    actor:send("A devourer has a ring with power to heal.  Please bring me this ring.")
                end
                if path == 1 then
                elseif stage == 3 then
                    actor:send("Please bring me a plant, found as \"a bit of bones and plants\" from Blue-Fog Trail.")
                elseif path == 2 then
                    actor:send("Please bring me an emblem of a king's power.  An emblem of the sun.  The one written of in legends of the warring gods in the far north.")
                elseif path == 3 then
                    actor:send("Find the Golhen DrubStatt or whatever that the hermit wrote about from the Highlands, and bring it back to me quickly.")
                end
                if path == 1 then
                elseif stage == 4 then
                    actor:send("I need a particular thorny wood.  Because of it's unpleasant nature there are some unpleasant people that make staves and walking sticks out of it.  Please find one, and bring it back here.")
                elseif path == 2 then
                    actor:send("Please bring be the dagger that radiates glorious light.  The priests of South Caelia know its fierce beauty.")
                elseif path == 3 then
                    actor:send("Bring me milk, in any container.")
                end
                if path == 1 then
                elseif stage == 5 then
                    actor:send("Bring me a pitcher from the hot springs or the Dancing Dolphin Inn.  Either will do.")
                elseif path == 2 then
                    actor:send("I can't do this sober!  Fetch me something to drink, and make it strong!")
                elseif path == 3 then
                    actor:send("Off of the great road is a lumber mill.  Their smith has an anvil that will do our work perfectly.  Please fetch it for me.")
                end
                if path == 2 then
                elseif stage == 6 then
                    actor:send("I need a large container for a sarcophagus, like a body-bag or a large chest.")
                end
            end
        end
    end
end
return _return_value