-- Trigger: thief_subclass_farmer_greeting
-- Zone: 88, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8800

-- Converted from DG Script #8800: thief_subclass_farmer_greeting
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        if actor.can_be_seen and actor.hiddenness < 1 then
            actor:send(tostring(self.name) .. " notices you skulking about!")
            actor:send(tostring(self.name) .. " says, 'Who are you?!  You weren't invited here!'")
            actor:send(tostring(self.name) .. " shoos you off the farm!")
            actor:teleport(get_room(80, 6))
            wait(1)
            -- actor looks around
            actor:fail_quest("merc_ass_thi_subclass")
            actor:send("<b:yellow>You have failed your quest!</>")
            actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
        end
    end
end