-- Command triggers follow legacy script_driver (fierymud-rs trigger dispatch).
--
-- 1. Default verdict. Legacy script_driver starts with ret_val = 1, which BLOCKS the typed
--    command; only an explicit `return 0` lets it through. The converter emitted
--    `local _return_value = true  -- Default: allow action` on every COMMAND script, so a run
--    that never set the value let the command continue. COMMAND scripts now default to false.
--    Only that default line changes, and only on COMMAND-flagged triggers (other trigger types
--    share the line and keep it); an explicit `_return_value = true` later in the script is left
--    alone, so `return 0` paths still allow.
-- 2. Bogus percent gate. For a COMMAND trigger the DG numeric argument is not a probability:
--    on an OBJECT it is the OCMD_* location mask (1 worn, 2 carried, 4 on the floor), on a mob
--    or room it is unused. The converter turned it into `if not percent_chance(N)`, so e.g. the
--    academy torch (519_09, N=3) ran 3% of the time. OBJECT gates become a `location` guard
--    (the dispatcher binds location = equip / inventory / room); mob and room gates are removed.
--
-- Keyed by Triggers (zone_id, id). Idempotent: each statement only matches text still in the old
-- shape (position(old in commands) > 0), so a second run changes 0 rows and builder edits to other
-- parts of a script survive. Source of truth for reimports: data/triggers/*.lua
-- (tests/test_command_trigger_default.py keeps them in sync). After applying, reload the catalog:
-- `treload` in game or POST /api/admin/triggers/reload.
--
-- ORDER: apply AFTER 2026-10-10-trigger-api-fixes.sql. That patch overwrites whole script bodies
-- (including 188_91, which this one also touches) with the file text it was generated from, so
-- running it second would put the old default line back on 188_91. This patch only replaces the
-- exact old text, so it is safe on a row either patch has already rewritten.

-- 1. default verdict (245 COMMAND scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$local _return_value = true  -- Default: allow action$old$, $new$local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (1, 17),
    (1, 18),
    (1, 29),
    (1, 30),
    (1, 31),
    (1, 32),
    (23, 48),
    (23, 49),
    (23, 50),
    (30, 4),
    (30, 20),
    (30, 54),
    (30, 55),
    (30, 56),
    (30, 75),
    (30, 86),
    (30, 88),
    (30, 109),
    (30, 112),
    (30, 113),
    (30, 117),
    (30, 118),
    (30, 119),
    (30, 120),
    (30, 121),
    (30, 122),
    (30, 123),
    (30, 124),
    (30, 125),
    (30, 153),
    (30, 155),
    (30, 156),
    (30, 157),
    (30, 158),
    (30, 159),
    (30, 296),
    (43, 43),
    (43, 57),
    (43, 58),
    (53, 16),
    (53, 18),
    (53, 29),
    (53, 42),
    (53, 47),
    (53, 48),
    (53, 49),
    (53, 50),
    (53, 51),
    (53, 52),
    (53, 53),
    (60, 29),
    (60, 30),
    (60, 56),
    (60, 58),
    (60, 61),
    (60, 62),
    (60, 63),
    (60, 64),
    (60, 65),
    (60, 66),
    (60, 67),
    (60, 68),
    (60, 69),
    (60, 70),
    (60, 71),
    (60, 72),
    (60, 75),
    (60, 76),
    (60, 77),
    (60, 78),
    (60, 79),
    (60, 80),
    (60, 81),
    (60, 83),
    (70, 75),
    (73, 175),
    (85, 21),
    (85, 22),
    (85, 23),
    (120, 19),
    (123, 16),
    (123, 23),
    (123, 98),
    (125, 1),
    (125, 13),
    (125, 14),
    (125, 25),
    (125, 34),
    (188, 1),
    (188, 20),
    (188, 21),
    (188, 23),
    (188, 24),
    (188, 25),
    (188, 40),
    (188, 41),
    (188, 85),
    (188, 86),
    (188, 90),
    (188, 91),
    (188, 93),
    (188, 94),
    (188, 96),
    (188, 97),
    (188, 98),
    (188, 99),
    (200, 38),
    (300, 2),
    (300, 4),
    (300, 11),
    (430, 57),
    (462, 21),
    (462, 23),
    (481, 162),
    (484, 16),
    (484, 17),
    (484, 19),
    (484, 21),
    (484, 130),
    (484, 131),
    (484, 132),
    (484, 133),
    (484, 134),
    (484, 135),
    (484, 136),
    (484, 137),
    (484, 138),
    (484, 139),
    (484, 140),
    (484, 141),
    (484, 142),
    (484, 143),
    (484, 144),
    (484, 145),
    (484, 146),
    (484, 147),
    (484, 148),
    (484, 149),
    (484, 151),
    (484, 152),
    (484, 153),
    (484, 154),
    (484, 155),
    (484, 156),
    (484, 157),
    (484, 158),
    (484, 159),
    (484, 160),
    (484, 161),
    (484, 162),
    (484, 163),
    (484, 164),
    (490, 3),
    (490, 24),
    (490, 101),
    (519, 6),
    (519, 7),
    (519, 8),
    (519, 9),
    (519, 11),
    (519, 13),
    (519, 17),
    (519, 18),
    (519, 20),
    (519, 21),
    (519, 24),
    (519, 25),
    (519, 27),
    (519, 28),
    (519, 29),
    (519, 31),
    (519, 32),
    (519, 33),
    (519, 35),
    (519, 37),
    (519, 38),
    (519, 40),
    (519, 41),
    (519, 42),
    (519, 43),
    (519, 44),
    (519, 46),
    (519, 47),
    (519, 48),
    (519, 50),
    (519, 51),
    (519, 52),
    (519, 54),
    (519, 56),
    (519, 57),
    (519, 59),
    (519, 60),
    (519, 61),
    (519, 62),
    (519, 63),
    (519, 64),
    (519, 65),
    (519, 66),
    (519, 72),
    (519, 74),
    (519, 76),
    (519, 94),
    (521, 30),
    (521, 31),
    (521, 32),
    (521, 33),
    (534, 17),
    (534, 56),
    (534, 105),
    (580, 9),
    (580, 10),
    (580, 11),
    (580, 107),
    (590, 2),
    (590, 4),
    (590, 13),
    (590, 15),
    (590, 17),
    (590, 18),
    (590, 19),
    (590, 20),
    (590, 21),
    (590, 31),
    (590, 32),
    (590, 33),
    (590, 34),
    (590, 35),
    (590, 41),
    (590, 47),
    (590, 49),
    (615, 0),
    (615, 15),
    (615, 20),
    (615, 21),
    (615, 25),
    (615, 31),
    (615, 38),
    (615, 39),
    (615, 40),
    (615, 41),
    (615, 45),
    (615, 95),
    (615, 98),
    (615, 99),
    (625, 10))
  AND position($old$local _return_value = true  -- Default: allow action$old$ in commands) > 0;

-- 2.1 percent gate -> OBJECT location guard (30 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

$old$, $new$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (12, 60),
    (12, 61),
    (12, 70),
    (14, 2),
    (30, 109),
    (30, 112),
    (30, 113),
    (30, 117),
    (30, 118),
    (30, 119),
    (30, 120),
    (30, 121),
    (30, 122),
    (30, 123),
    (30, 124),
    (30, 125),
    (188, 1),
    (188, 40),
    (188, 41),
    (188, 80),
    (188, 82),
    (188, 85),
    (188, 86),
    (188, 99),
    (521, 30),
    (521, 31),
    (521, 32),
    (521, 33),
    (534, 104),
    (534, 105))
  AND position($old$-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

$old$ in commands) > 0;

-- 2.2 percent gate -> OBJECT location guard (16 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

$old$, $new$-- Command location mask 2: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "inventory") then
    return true  -- Not in a location this trigger watches
end

$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (12, 46),
    (12, 69),
    (22, 50),
    (22, 51),
    (22, 52),
    (22, 53),
    (22, 54),
    (22, 55),
    (22, 56),
    (22, 57),
    (22, 58),
    (22, 59),
    (22, 60),
    (63, 90),
    (188, 98),
    (238, 41))
  AND position($old$-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

$old$ in commands) > 0;

-- 2.3 percent gate -> OBJECT location guard (34 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

$old$, $new$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (12, 98),
    (30, 86),
    (30, 88),
    (53, 16),
    (53, 18),
    (53, 29),
    (53, 42),
    (53, 47),
    (53, 48),
    (53, 49),
    (53, 50),
    (53, 51),
    (53, 52),
    (53, 53),
    (60, 56),
    (60, 58),
    (123, 16),
    (188, 20),
    (188, 21),
    (188, 23),
    (188, 24),
    (188, 25),
    (188, 90),
    (188, 91),
    (188, 93),
    (188, 94),
    (188, 96),
    (188, 97),
    (492, 99),
    (519, 9),
    (534, 15),
    (580, 9),
    (590, 47),
    (615, 45))
  AND position($old$-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

$old$ in commands) > 0;

-- 2.4 percent gate -> OBJECT location guard (21 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

$old$, $new$-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (60, 61),
    (60, 62),
    (60, 63),
    (60, 64),
    (60, 65),
    (60, 66),
    (60, 67),
    (60, 68),
    (60, 69),
    (60, 70),
    (60, 71),
    (60, 72),
    (60, 75),
    (60, 76),
    (60, 77),
    (60, 78),
    (60, 79),
    (60, 80),
    (60, 81),
    (60, 83),
    (87, 2))
  AND position($old$-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

$old$ in commands) > 0;

-- 2.5 percent gate -> gate removed (narg is unused for this trigger) (1 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

$old$, $new$$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (550, 27))
  AND position($old$-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

$old$ in commands) > 0;

-- 2.6 percent gate -> gate removed (narg is unused for this trigger) (1 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

$old$, $new$$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (590, 13))
  AND position($old$-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

$old$ in commands) > 0;

-- 2.7 percent gate -> gate removed (narg is unused for this trigger) (2 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 7% chance to trigger
if not percent_chance(7) then
    return true
end

$old$, $new$$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (519, 94),
    (615, 99))
  AND position($old$-- 7% chance to trigger
if not percent_chance(7) then
    return true
end

$old$ in commands) > 0;

-- 2.8 percent gate -> gate removed (narg is unused for this trigger) (1 scripts)
UPDATE "Triggers"
SET commands = replace(commands, $old$-- 75% chance to trigger
if not percent_chance(75) then
    return true
end

$old$, $new$$new$),
    updated_at = NOW()
WHERE (zone_id, id) IN (VALUES
    (533, 6))
  AND position($old$-- 75% chance to trigger
if not percent_chance(75) then
    return true
end

$old$ in commands) > 0;
