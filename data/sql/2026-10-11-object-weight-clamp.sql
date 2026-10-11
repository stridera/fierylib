-- Clamp absurd object weights to 100000 (importer: object_importer.MAX_OBJECT_WEIGHT).
--
-- Legacy 30.obj stores 2147483648.00 (i32 overflow, "look fountain" printed
-- "It weighs about 2147483648.0 lbs") on 30:137 (#3137), 30:296 and 30:299; a handful of
-- others use 100005 .. 1000000000 as an "immovable" marker. 100000 is still unliftable.
-- A second run changes 0 rows.
UPDATE "Objects" SET weight = 100000 WHERE weight > 100000;
