-- Trigger: flood_south_gate
-- Zone: 390, ID: 12
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39012

-- Converted from DG Script #39012: flood_south_gate
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local room = get_room(391, 87)
if room then
    local exit = room:exit("south")
    if exit then
        exit:set_state({hidden = true, description = "A sturdy gate holds back the sea."})
    end
end