-- Trigger: thief_subclass_farmer_death
-- Zone: 60, ID: 28
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #6028

-- Converted from DG Script #6028: thief_subclass_farmer_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        if self.id == 8804 then
            self.room:send("The farmer's wife comes running!")
            self.room:send("The farmer's wife cries out, 'Sweet Mielikki, what have you done?!'")
            self.room:send_except(actor, "The farmer's wife chases " .. tostring(actor.name) .. " off the farm!")
            -- (empty send to actor)
            actor:send("The farmer's wife throws herself at you!")
            actor:send("The farmer's wife screams, 'Get out!  Get out!' while chasing you off the farm!")
            actor:teleport(get_room(80, 6))
            get_room(80, 6):at(function()
                -- actor looks around
            end)
        else
            self.room:send("The farmer comes running!")
            self.room:send("The farmer cries out, 'Sweet Mielikki, what have you done?!'")
            self.room:send_except(actor, "The farmer chases " .. tostring(actor.name) .. " off the farm!")
            -- (empty send to actor)
            actor:send("The farmer throws himself at you!")
            actor:send("The farmer hollers, 'Get out!  Get out!' while chasing you off the farm!")
            actor:teleport(get_room(80, 6))
            -- actor looks around
        end
        actor:fail_quest("merc_ass_thi_subclass")
        actor:send("<b:yellow>You have failed your quest!</>")
        actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
    end
end