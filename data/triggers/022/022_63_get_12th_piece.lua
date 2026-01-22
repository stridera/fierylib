-- Trigger: Get_12th_piece
-- Zone: 22, ID: 63
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #2263

-- Converted from DG Script #2263: Get_12th_piece
-- Original: OBJECT trigger, flags: GET, probability: 100%
wait(2)
self.room:spawn_mobile(22, 2)
find_player("tsaeldin"):teleport(get_room(30, 2))
self.room:find_actor("tsaeldin"):command("goss At last!  The lost artifacts have been recovered!")
wait(10)
self.room:find_actor("tsaeldin"):command("goss You MUST come see me at once.  I shall await your arrival in Mielikki.")