-- Flame Blade (10:43) never dissipated (fierymud-rs playtest r16, U5). Its help: "Once removed the FLAME BLADE
-- will dissipate. Dissipation will also occur after a period of use."
--
-- The blade already carries DECOMPOSING (legacy ITEM_DECOMP), which makes it rot once it lies on the floor, as in
-- legacy (limits.cpp start_decomposing: level + 11 mud hours). But a held or wielded item never rots that way, and
-- legacy removal drops it straight back into the pack (obj_to_char -> stop_decomposing), so a blade that is never
-- dropped lived forever. A real object timer (`Objects.timer`, mud hours; 1 mud hour = 75 s) burns it out after
-- a period of use whether it is wielded, carried or dropped: 24 mud hours = 30 real minutes.
--
-- Armor of Gaia (10:40/41/42): no change. Legacy objects 1040-1042 carry no DECOMP flag and no timer either, so
-- the plates are ordinary armor in legacy and the DB matches.
--
-- Keyed by (zone_id, id); idempotent (a re-run changes 0 rows).
UPDATE "Objects"
SET timer = 24
WHERE zone_id = 10
  AND id = 43
  AND timer IS DISTINCT FROM 24;
