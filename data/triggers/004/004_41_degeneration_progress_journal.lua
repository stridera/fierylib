-- Trigger: Degeneration progress journal
-- Zone: 4, ID: 41
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #441

-- Converted from DG Script #441: Degeneration progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "degeneration") then
    if string.find(actor.class, "Necromancer") and actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("degeneration")
        actor:send("<b:green>&uDegeneration</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("degeneration") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage and not actor:get_has_completed("degeneration") then
            actor:send("Quest Master: " .. tostring(mobiles.template(55, 26).name))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("Find Yajiro in Odaishyozen and bring back his book.")
            elseif stage == 2 then
                actor:send("Find Mesmeriz in the Minithawkin Mines and bring back his necklace.")
            elseif stage == 3 then
                actor:send("Find Luchiaans in Nordus and bring back his mask.")
            elseif stage == 4 then
                actor:send("Find Voliangloch in Demise Keep and bring back his rod.")
            elseif stage == 5 then
                actor:send("Find Kryzanthor in the Graveyard and bring back his robe.")
            elseif stage == 6 then
                actor:send("Find Ureal the Lich in the Barrow and bring back his statuette.")
            elseif stage == 7 or stage == 8 then
                actor:send("Find Norisent in the Cathedral of Betrayal and bring back his book.")
            elseif stage == 9 then
                actor:send("Find the enormous ruby hidden under a stairway.")
            end
        end
    end
end
return _return_value