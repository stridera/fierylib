-- Trigger: group_heal_injured_give
-- Zone: 185, ID: 23
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #18523

-- Converted from DG Script #18523: group_heal_injured_give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("group_heal") == 6 then
    local healed = actor:get_quest_var("group_heal:total")
    if victim.id == -1 then
        return _return_value
    else
        _return_value = false
        if actor.quest_variable[group_heal:victim.vnum] then
            actor:send("you have already helped " .. tostring(victim.name))
        elseif victim.id == 18506 or victim.id == 43020 or victim.id == 12513 or victim.id == 58803 or victim.id == 30054 or victim.id == 46414 or victim.id == 36103 then
            actor.name:set_quest_var("group_heal", "%victim.vnum%", 1)
            local heal = healed + 1
            actor.name:set_quest_var("group_heal", "total", heal)
            actor:send("You give " .. tostring(self.shortdesc) .. " to " .. tostring(victim.name) .. " and apply the medicine to " .. tostring(victim.himher) .. ".")
            wait(1)
            self.room:send(tostring(victim.name) .. "'s wounds begin to heal as they consume the magical feast.")
            wait(2)
            if victim.id == 18506 or victim.id == 43020 or victim.id == 12513 or victim.id == 58803 or victim.id == 30054 or  then
                self.room:send(tostring(victim.name) .. " says, 'Thank you so much for coming to my aid!'")
                wait(1)
                self.room:send(tostring(victim.name) .. " bows and departs.")
            elseif victim.id == 46414 or victim.id == 36103 then
                victim:command("nuzzle %actor.name%")
                wait(1)
                self.room:send(tostring(victim.name) .. " turns and departs.")
            end
            if heal >= 5 then
                victim:command("mskillset %actor% group heal")
                world.destroy(victim)
                wait(1)
                actor:send("The miraculous power of St. George washes over you!")
                actor:send("The appropriate prayers to beseech the gods for group heal well up in your soul.")
                actor.name:complete_quest("group_heal")
                actor:send("<b:white>You have learned Group Heal</>!")
            else
                world.destroy(victim)
            end
            world.destroy(self.room:find_object("self"))
        elseif victim.id == 62506 or victim.id == 53450 then
            wait(1)
            actor:send("It is not possible to help " .. tostring(victim.name) .. ".")
        else
            wait(1)
            actor:send(tostring(victim.name) .. " does not appear to be hurt.")
        end
    end
end
return _return_value