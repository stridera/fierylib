-- Trigger: Word of Command progress journal
-- Zone: 4, ID: 32
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #432

-- Converted from DG Script #432: Word of Command progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "word") or string.find(arg, "command") or string.find(arg, "word_of_command") or string.find(arg, "word_command") then
    if actor.level >= 65 then
        if string.find(actor.class, "diabolist") or string.find(actor.class, "Priest") then
            _return_value = false
            local stage = actor:get_quest_stage("word_command")
            actor:send("<b:green>&uWord of Command</>")
            if actor:get_has_completed("word_command") then
                local status = "Completed!"
            elseif stage then
                local status = "In Progress"
            else
                local status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
        if stage > 0 and not actor:get_has_completed("word_command") then
            actor:send("Quest Master: " .. tostring(mobiles.template(430, 21).name))
            actor:send("</>")
            actor:send("Help " .. tostring(mobiles.template(430, 21).name) .. " escape from Demise Keep!")
            actor:send("%get.mob_shortdesc[43017]% and its minions will stop at nothing to keep %get.mob_shortdesc[43021]% trapped in its clutches!")
        end
    end
end
return _return_value