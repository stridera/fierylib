-- Trigger: Cryomancer Subclass progress journal
-- Zone: 4, ID: 69
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #469

-- Converted from DG Script #469: Cryomancer Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local cryoraces = "arborean dragonborn_fire"
    if string.find(arg, "Cryomancer") and string.find(actor.class, "Sorcerer") and actor.level <= 45 and not (string.find(cryoraces, "actor.race")) then
        _return_value = false
        actor:send("<b:blue>Cryomancer</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(550, 20).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("cryomancer_subclass") then
            actor:send(tostring(mobiles.template(550, 20).name) .. " said to you:")
            -- switch on actor:get_quest_stage("cryomancer_subclass")
            if actor:get_quest_stage("cryomancer_subclass") == 1 then
                actor:send("It will take a great mage with a dedication to the cold arts to complete the quest I lay before you.")
                actor:send("Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 2 then
                actor:send("My counterpart, the great Emmath Firehand, long ago battled with me once._")
                actor:send("It was not serious by any means, but it did end in a stalemate.")
                actor:send("The catch however..._")
                actor:send("Is that what we battled over may still be suffering.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
                actor:send("It is a shame really, that poor shrub, it really was an innocent in all of that._")
                actor:send("I do feel bad about it.")
                actor:send("The poor thing tried to flee us and sought the shaman who created him._")
                actor:send("I do not know if that will help you end his suffering or not, but I hope it does._")
                actor:send("And the reward will be great if you do._")
                actor:send("The shrub muttered something about a place with rushing water and some odd warriors being his safety._")
                actor:send("Oh!  One last thing.")
                actor:send("When you return to claim your reward, be sure to say to me <b:white>\"The shrub suffers no longer\"</>, and the prize will be yours.")
            elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
                actor:send("Say <b:white>\"The shrub suffers no longer\"</>, and the prize will be yours.")
            end
        end
    end
end
return _return_value