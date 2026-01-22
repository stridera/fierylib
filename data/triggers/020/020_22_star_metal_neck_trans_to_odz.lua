-- Trigger: star_metal_neck_trans_to_odz
-- Zone: 20, ID: 22
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2022

-- Converted from DG Script #2022: star_metal_neck_trans_to_odz
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor.id == -1 then
    wait(2)
    self.room:send_except(actor, "A strange little glow appears around " .. tostring(actor.name) .. ", making you light-headed.")
    actor:send("A strange glow appears around you and you feel light headed.")
    wait(2)
    actor:teleport(get_room(580, 2))
    actor:send("You blink and realize you are not where you started.")
    actor:send("You hear the crash of waves to the south.")
    wait(2)
    actor:command("look")
end