-- Trigger: create_door_18547_to_18566
-- Zone: 185, ID: 7
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #18507

-- Converted from DG Script #18507: create_door_18547_to_18566
-- Original: WORLD trigger, flags: PREENTRY, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
-- only run from silanias trigger 18506
wait(2)
self.room:send("The walls seem to flow away from an opening.")
get_room(185, 47):exit("east"):set_state({hidden = false})
get_room(185, 66):exit("west"):set_state({hidden = false})