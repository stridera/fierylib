-- Legacy XP curve for existing databases (Refs fierymud-rs #9 #23 #34).
--
-- Brings an already-seeded database in line with `fierylib seed levels`
-- without a full reimport:
--   * adds "Class".exp_gain_factor (legacy per-class "exp needed to level"
--     factor, class.cpp `exp_gain_factor`) if the column is missing;
--   * sets that factor per class;
--   * rewrites "LevelDefinition".exp_required with the class-neutral legacy
--     table (utils.cpp `init_exp_table`; row N holds exp_table[N-1]).
--
-- The game multiplies exp_required by the class factor at load time and
-- truncates (legacy `exp_next_level`). Idempotent: rerunning is a no-op.
-- Values come from fierylib.seeders.level_seeder; a unit test keeps this
-- file in sync with the seeder.

BEGIN;

ALTER TABLE "Class"
    ADD COLUMN IF NOT EXISTS exp_gain_factor double precision NOT NULL DEFAULT 1;

UPDATE "Class" AS c
SET exp_gain_factor = v.factor, updated_at = now()
FROM (VALUES
        ('Sorcerer', 1.2),
        ('Cleric', 1.0),
        ('Thief', 1.0),
        ('Warrior', 1.1),
        ('Paladin', 1.15),
        ('Anti-Paladin', 1.15),
        ('Ranger', 1.15),
        ('Druid', 1.0),
        ('Shaman', 1.0),
        ('Assassin', 1.0),
        ('Mercenary', 1.0),
        ('Necromancer', 1.3),
        ('Conjurer', 1.0),
        ('Monk', 1.3),
        ('Berserker', 1.1),
        ('Priest', 1.0),
        ('Diabolist', 1.0),
        ('Mystic', 1.0),
        ('Rogue', 1.0),
        ('Bard', 1.2),
        ('Pyromancer', 1.2),
        ('Cryomancer', 1.2),
        ('Illusionist', 1.2),
        ('Hunter', 1.0)
) AS v(plain_name, factor)
WHERE c.plain_name = v.plain_name
  AND c.exp_gain_factor IS DISTINCT FROM v.factor;

UPDATE "LevelDefinition" AS l
SET exp_required = v.exp, updated_at = now()
FROM (VALUES
        (1, 0),
        (2, 5500),
        (3, 16500),
        (4, 33000),
        (5, 55000),
        (6, 82500),
        (7, 115500),
        (8, 154000),
        (9, 198000),
        (10, 254500),
        (11, 323500),
        (12, 405000),
        (13, 499000),
        (14, 605500),
        (15, 724500),
        (16, 856000),
        (17, 1000000),
        (18, 1161500),
        (19, 1340500),
        (20, 1537000),
        (21, 1751000),
        (22, 1982500),
        (23, 2231500),
        (24, 2498000),
        (25, 2782000),
        (26, 3088500),
        (27, 3417500),
        (28, 3769000),
        (29, 4143000),
        (30, 4539500),
        (31, 4958500),
        (32, 5400000),
        (33, 5864000),
        (34, 6353000),
        (35, 6867000),
        (36, 7406000),
        (37, 7970000),
        (38, 8559000),
        (39, 9173000),
        (40, 9812000),
        (41, 10476000),
        (42, 11165000),
        (43, 11879000),
        (44, 12618000),
        (45, 13382000),
        (46, 14171000),
        (47, 14985000),
        (48, 15824000),
        (49, 16688000),
        (50, 17582000),
        (51, 18506000),
        (52, 19460000),
        (53, 20444000),
        (54, 21458000),
        (55, 22502000),
        (56, 23576000),
        (57, 24680000),
        (58, 25814000),
        (59, 26978000),
        (60, 28172000),
        (61, 29396000),
        (62, 30650000),
        (63, 31934000),
        (64, 33248000),
        (65, 34592000),
        (66, 35966000),
        (67, 37370000),
        (68, 38804000),
        (69, 40268000),
        (70, 41762000),
        (71, 43286000),
        (72, 44840000),
        (73, 46424000),
        (74, 48038000),
        (75, 49682000),
        (76, 51356000),
        (77, 53060000),
        (78, 54794000),
        (79, 56558000),
        (80, 58352000),
        (81, 60176000),
        (82, 62030000),
        (83, 63914000),
        (84, 65828000),
        (85, 67772000),
        (86, 69746000),
        (87, 71750000),
        (88, 73784000),
        (89, 75848000),
        (90, 77942000),
        (91, 80096000),
        (92, 82310000),
        (93, 84594000),
        (94, 86948000),
        (95, 89372000),
        (96, 91876000),
        (97, 94470000),
        (98, 97154000),
        (99, 99938000),
        (100, 105806000),
        (101, 299999999),
        (102, 300000001),
        (103, 300000003),
        (104, 300000005),
        (105, 300000007)
) AS v(level, exp)
WHERE l.level = v.level
  AND l.exp_required IS DISTINCT FROM v.exp;

COMMIT;
