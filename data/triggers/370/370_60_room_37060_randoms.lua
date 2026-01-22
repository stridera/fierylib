-- Trigger: room_37060_randoms
-- Zone: 370, ID: 60
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #37060

-- Converted from DG Script #37060: room_37060_randoms
-- Original: WORLD trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send("The flashing lights dance rhythmically across your vision, slowly hypnotizing you into a trance.")
wait(4)
self.room:send("A loud bang explodes in the center of the circle, snapping you out of your trance!")
self.room:send("The glowing circle drawn on the floor intensifies, nearly blinding you with its brightness.")
wait(3)
self.room:spawn_mobile(370, 60)
self.room:send("As you look on, a small black portal opens in the center of the circle.")
self.room:send("Suddenly, a black phantasmic shape flies up out of the portal.")
self.room:send("The portal subsides to nothingness behind the phantom.")
wait(3)
self.room:send("The phantasmic shape melts through the ceiling above you.")
world.destroy(self.room:find_actor("phantasmic-phantom"))