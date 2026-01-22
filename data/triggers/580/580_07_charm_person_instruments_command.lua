-- Trigger: charm_person_instruments_command
-- Zone: 580, ID: 7
-- Type: OBJECT, Flags: USE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #58007

-- Converted from DG Script #58007: charm_person_instruments_command
-- Original: OBJECT trigger, flags: USE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    _return_value = false
    local room = actor.room
    -- switch on self.id
    if room:get_people("3010") then
        if self.id == 48925 then
            wait(2)
            self.room:send(tostring(mobiles.template(30, 10).name) .. " hums along dreamily.")
            actor.name:set_quest_var("charm_person", "charm1", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(30, 10).name) .. " is charmed by your playing!</>")
        end
        if room:get_people("58017") then
        elseif self.id == 37012 then
            wait(2)
            self.room:send(tostring(mobiles.template(580, 17).name) .. " blushes furiously.")
            actor.name:set_quest_var("charm_person", "charm2", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(580, 17).name) .. " is charmed by your playing!</>")
        end
        if room:get_people("58406") then
        elseif self.id == 41119 then
            wait(2)
            self.room:send(tostring(mobiles.template(584, 6).name) .. " sighs sweetly.")
            actor.name:set_quest_var("charm_person", "charm5", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(584, 6).name) .. " is charmed by your playing!</>")
        end
        if room:get_people("4353") then
        elseif self.id == 16312 then
            wait(2)
            self.room:send(tostring(mobiles.template(43, 53).name) .. " closes her eyes and smiles.")
            actor.name:set_quest_var("charm_person", "charm3", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(43, 53).name) .. " is charmed by your playing!</>")
        end
        if room:get_people("23721") then
        elseif self.id == 58017 then
            wait(2)
            self.room:send(tostring(mobiles.template(237, 21).name) .. " burbles with contentment.")
            actor.name:set_quest_var("charm_person", "charm4", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(237, 21).name) .. " is charmed by your playing!</>")
        end
    end
    if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
        wait(4)
        actor:send("Your skill in charming has greatly improved!")
        actor:send("Hinazuru's training has paid off!")
        actor.name:complete_quest("charm_person")
        actor:send("<b:magenta>You have learned Charm Person!</>")
        skills.set_level(actor.name, "charm person", 100)
    end
end
return _return_value