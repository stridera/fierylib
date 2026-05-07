-- Trigger: font_load_holy_water
-- Zone: 185, ID: 50
-- Type: OBJECT, Flags: LOAD
--
-- When the font (this object) loads, spawn a holy water (185, 28) in
-- the same room.
self.room:spawn_object(185, 28)