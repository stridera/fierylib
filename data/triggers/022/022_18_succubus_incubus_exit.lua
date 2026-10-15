-- Trigger: Succubus_Incubus_Exit
-- Zone: 22, ID: 18
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2218

-- Converted from DG Script #2218: Succubus_Incubus_Exit
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<red>The <blue>unbearable <yellow>heat</> <b:red>suddenly burns away the carpeting,</><red> revealing a trapdoor.</>")
get_room(22, 11):exit("down"):set_state({hidden = false})
get_room(22, 11):exit("down"):set_state({description = "<red>A red </><b:red>hot </><b:yellow>iron</><b:red> staircase</><red> leads downwards.</>"})