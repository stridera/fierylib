-- Trigger: Nukreth Spire fangs greet rescuer
-- Zone: 462, ID: 17
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #46217

-- Converted from DG Script #46217: Nukreth Spire fangs greet rescuer
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
wait(2)
if actor:get_quest_var("nukreth_spire:rescue") then
    self.room:send("The Fangs of Yeenoghu look up and cackle with delight!")
    self.room:send("They cry, 'Fresh meat for Yeenoghu!'")
    wait(1)
    self.room:send("A weak man laying at the feet of the statue raises his hand in desperation.")
    self.room:send("He whispers, 'Help me...!'")
    actor:set_quest_var("nukreth_spire", "rescue", 0)
end