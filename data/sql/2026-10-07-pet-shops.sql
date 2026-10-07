-- Pet / mount shops (Refs fierymud-rs#43 "Shops not populated").
--
-- The importer's pet-shop phase was disabled when ShopRooms was dropped, so
-- every stable/pet shop shipped with a keeper and NO ShopMobs rows: the
-- shopkeepers had nothing to sell and no mount could be hired.
--
-- Legacy pet_shop spec_proc (spec_assign.cpp): a shop ROOM sells the mobs
-- standing in the backroom (room id + 1). Rooms: 3030 Kayla, 3091 Jorhan,
-- 6228 Shula, 10056 Faric, 30012 Arandidor, 30031 Myrzistan.
--
-- For each room this links every distinct mob reset into the backroom to the
-- Shops row of the keeper reset into the shop room (if the keeper owns several
-- Shops rows the highest id wins, matching the runtime keeper lookup), with
-- unlimited stock and price 0 (runtime default = mob level * 100).
--
-- Idempotent: ON CONFLICT DO NOTHING, so builder edits to price/amount made in
-- Muditor survive a re-run. Requires MobResets to be imported (prod has them).
-- After applying, restart fieryNT so the shop catalog reloads.

BEGIN;

WITH pet_rooms(zone_id, room_id) AS (
  VALUES (30, 30), (30, 91), (62, 28), (100, 56), (300, 12), (300, 31)
),
shop_for_room AS (
  SELECT DISTINCT ON (pr.zone_id, pr.room_id)
         pr.zone_id AS room_zone_id, pr.room_id, s.zone_id AS shop_zone_id, s.id AS shop_id
  FROM pet_rooms pr
  JOIN "MobResets" kr ON kr.room_zone_id = pr.zone_id AND kr.room_id = pr.room_id
  JOIN "Shops" s ON s.keeper_zone_id = kr.mob_zone_id AND s.keeper_id = kr.mob_id
  ORDER BY pr.zone_id, pr.room_id, s.zone_id DESC, s.id DESC
),
pets AS (
  SELECT DISTINCT sr.shop_zone_id, sr.shop_id, br.mob_zone_id, br.mob_id
  FROM shop_for_room sr
  JOIN "MobResets" br ON br.room_zone_id = sr.room_zone_id AND br.room_id = sr.room_id + 1
)
INSERT INTO "ShopMobs" (amount, price, shop_zone_id, shop_id, mob_zone_id, mob_id)
SELECT -1, 0, shop_zone_id, shop_id, mob_zone_id, mob_id FROM pets
ON CONFLICT (shop_zone_id, shop_id, mob_zone_id, mob_id) DO NOTHING;

COMMIT;

-- Report: expect 6 shops with pets (Kayla 6, Jorhan 3, Shula 3, Faric 3,
-- Arandidor 4, Myrzistan 5 on the dev dump).
SELECT shop_zone_id, shop_id, count(*) AS pets FROM "ShopMobs" GROUP BY 1, 2 ORDER BY 1, 2;
