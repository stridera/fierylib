-- Trigger: academy_instructor_command_inventory
-- Zone: 519, ID: 6
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51906

-- Converted from DG Script #51906: academy_instructor_command_inventory
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: inventory
if not (cmd == "inventory") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:gear") == 1 then
    actor:command("inventory")
    actor:set_quest_var("school", "gear", 2)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Good!  Now you can see everything you have.")
    actor:send("In order to gain benefits from items, you have to equip them.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are three commands to equip items:")
    actor:send("<b:cyan>(WEA)R</>, <b:cyan>(WI)ELD</>, and <b:cyan>(HO)LD</>.'</>")
    -- (empty send to actor)
    actor:send("<b:cyan>WEAR</> will equip something from your inventory.")
    actor:send("You can equip most objects by typing <b:cyan>WEAR [object]</>.")
    actor:send("Weapons can be equipped with either <b:cyan>WEAR</> or <b:cyan>WIELD</>.")
    actor:send("<b:cyan>WEAR ALL</> will equip everything in your inventory at once.")
    -- (empty send to actor)
    actor:send("Some items can only be equipped with the <b:cyan>HOLD</> command.")
    actor:send("That includes instruments, wands, staves, magic orbs, etc.")
    actor:send("They will not be equipped with the <b:cyan>wear all</> command.")
    actor:send("Once you are holding them they can be activated with the <b:cyan>USE</> command.")
    wait(7)
    actor:send(tostring(self.name) .. " tells you, 'Go ahead and type <b:green>wear all</> and see what happens.'")
end
_return_value = false
return _return_value