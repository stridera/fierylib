-- Trigger: academy_torch_remove
-- Zone: 519, ID: 10
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #51910

-- Converted from DG Script #51910: academy_torch_remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
if actor:get_quest_var("school:gear") == 6 then
    actor:set_quest_var("school", "gear", 7)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Good, save that light!'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'During your adventures, you can pick up stuff using the <b:cyan>(G)ET</> command.'")
    wait(2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):command("drop all.stick")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Pick up one of those sticks by typing <b:green>get stick</>.'")
end