-- Content tables: hard-coded fierymud-rs content moved into the database (data over code).
--
--   "StatusFlagValue"  AI worth of each status flag (mob_ai value_status_flag: what a
--                      monster thinks a piece of gear is worth). Flags without a row score 0.
--   "SystemMessage"    exp_progress (the eleven `%E` prompt lines, indexed by tenth of the
--                      level), insult_lines (the `insult` command), month_names (the sixteen
--                      calendar months), weather_change_<precip> (the line sent when a zone's
--                      precipitation changes; several messages = random pick).
--   "GameConfig"       display.prompt_templates: JSON [[name, template], ...] for `prompt list`.
--   "SpellSyllable"    spell chant gibberish (legacy syllable table); sort_order is match order.
--   "Ability"          prompt_letter: the `%d<letter>` prompt cooldown bar each ability drives.
--
-- Keyed by Ability.plain_name / natural keys, so ids may differ per database. The game logs
-- an ERROR and falls back to empty text when a table or column is missing, so applying this
-- by hand after the deploy is safe.
--
-- Idempotent and builder-safe: tables are created IF NOT EXISTS, rows are inserted only when
-- missing (ON CONFLICT DO NOTHING), prompt_letter is only set where still NULL. A second run
-- changes 0 rows. Keep in sync with the Prisma models StatusFlagValue / SpellSyllable and
-- Ability.promptLetter in muditor/packages/db/prisma/schema.prisma. Generated from
-- data/content_tables.json; a unit test keeps the two in sync.

BEGIN;

CREATE TABLE IF NOT EXISTS "StatusFlagValue" (
    "flag" TEXT NOT NULL,
    "ai_value" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "StatusFlagValue_pkey" PRIMARY KEY ("flag")
);

CREATE TABLE IF NOT EXISTS "SpellSyllable" (
    "id" SERIAL NOT NULL,
    "sort_order" INTEGER NOT NULL,
    "syllable" TEXT NOT NULL,
    "replacement" TEXT NOT NULL,

    CONSTRAINT "SpellSyllable_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "SpellSyllable_syllable_key" ON "SpellSyllable"("syllable");

CREATE INDEX IF NOT EXISTS "SpellSyllable_sort_order_idx" ON "SpellSyllable"("sort_order");

ALTER TABLE "Ability" ADD COLUMN IF NOT EXISTS "prompt_letter" VARCHAR(1);

INSERT INTO "StatusFlagValue" ("flag", "ai_value") VALUES
  ('major_paralysis', -50),
  ('blind', -40),
  ('blindness', -40),
  ('silence', -30),
  ('insanity', -30),
  ('hurt_throat', -30),
  ('poison', -20),
  ('poisoned', -20),
  ('sleep', -20),
  ('minor_paralysis', -20),
  ('on_fire', -20),
  ('disease', -20),
  ('animated', -20),
  ('exposed', -20),
  ('charm', -10),
  ('tamed', -10),
  ('fear', -10),
  ('vitality', -5),
  ('curse', 3),
  ('enlarge', 10),
  ('reduce', 10),
  ('bless', 10),
  ('tongues', 15),
  ('feather_fall', 15),
  ('camouflaged', 15),
  ('ray_of_enfeeblement', 15),
  ('farsee', 20),
  ('detect_align', 20),
  ('detect_poison', 20),
  ('detect_magic', 20),
  ('waterbreath', 20),
  ('minor_globe', 20),
  ('shadowing', 20),
  ('waterwalk', 25),
  ('invisible', 25),
  ('notrack', 25),
  ('light', 25),
  ('sneak', 35),
  ('sense_life', 35),
  ('detect_life', 35),
  ('infravision', 35),
  ('detect_invis', 40),
  ('protect_evil', 50),
  ('protect_good', 50),
  ('fly', 50),
  ('soulshield', 50),
  ('prot_fire', 50),
  ('prot_cold', 50),
  ('prot_air', 50),
  ('prot_earth', 50),
  ('fireshield', 50),
  ('coldshield', 50),
  ('ultravision', 50),
  ('aware', 50),
  ('vamp_touch', 50),
  ('haste', 60),
  ('displacement', 60),
  ('nimble', 60),
  ('acid_weapon', 60),
  ('fire_weapon', 60),
  ('ice_weapon', 60),
  ('radiant_weapon', 60),
  ('poison_weapon', 60),
  ('shock_weapon', 60),
  ('major_globe', 70),
  ('harness', 70),
  ('negate_heat', 70),
  ('negate_cold', 70),
  ('negate_air', 70),
  ('negate_earth', 70),
  ('greater_displacement', 70),
  ('blur', 80),
  ('sanctuary', 90),
  ('stone_skin', 100),
  ('stoneskin', 100)
ON CONFLICT ("flag") DO NOTHING;

INSERT INTO "SpellSyllable" ("sort_order", "syllable", "replacement") VALUES
  (1, ' ', ' '),
  (2, 'ar', 'abra'),
  (3, 'ate', 'i'),
  (4, 'cau', 'kada'),
  (5, 'blind', 'nose'),
  (6, 'bur', 'mosa'),
  (7, 'cu', 'judi'),
  (8, 'de', 'oculo'),
  (9, 'dis', 'mar'),
  (10, 'ect', 'kamina'),
  (11, 'en', 'uns'),
  (12, 'gro', 'cra'),
  (13, 'light', 'dies'),
  (14, 'lo', 'hi'),
  (15, 'magi', 'kari'),
  (16, 'mon', 'bar'),
  (17, 'mor', 'zak'),
  (18, 'move', 'sido'),
  (19, 'ness', 'lacri'),
  (20, 'ning', 'illa'),
  (21, 'per', 'duda'),
  (22, 'ra', 'gru'),
  (23, 're', 'candus'),
  (24, 'son', 'sabru'),
  (25, 'tect', 'infra'),
  (26, 'tri', 'cula'),
  (27, 'ven', 'nofo'),
  (28, 'word of', 'inset'),
  (29, 'a', 'i'),
  (30, 'b', 'v'),
  (31, 'c', 'q'),
  (32, 'd', 'm'),
  (33, 'e', 'o'),
  (34, 'f', 'y'),
  (35, 'g', 't'),
  (36, 'h', 'p'),
  (37, 'i', 'u'),
  (38, 'j', 'y'),
  (39, 'k', 't'),
  (40, 'l', 'r'),
  (41, 'm', 'w'),
  (42, 'n', 'b'),
  (43, 'o', 'a'),
  (44, 'p', 's'),
  (45, 'q', 'd'),
  (46, 'r', 'f'),
  (47, 's', 'g'),
  (48, 't', 'h'),
  (49, 'u', 'e'),
  (50, 'v', 'z'),
  (51, 'w', 'x'),
  (52, 'x', 'n'),
  (53, 'y', 'l'),
  (54, 'z', 'k')
ON CONFLICT ("syllable") DO NOTHING;

INSERT INTO "SystemMessage" ("key", "category", "messages", "updated_at") VALUES
  ('exp_progress', 'prompt', ARRAY['<blue>You still have a very long way to go to your next level.</>', '<blue>You have gained some progress towards your next level.</>', '<cyan>You are about one-quarter of the way to your next level.</>', '<blue>You are about a third of the way to your next level.</>', '<blue>You are almost half-way to your next level.</>', '<cyan>You are just past the half-way point to your next level.</>', '<blue>You are well on your way to your next level.</>', '<blue>You are about three-quarters of the way to your next level.</>', '<cyan>You are almost ready to attain your next level.</>', '<blue>You should level anytime now!</>', '<blue>You are SO close to the next level.</>']::text[], CURRENT_TIMESTAMP),
  ('insult_lines', 'social', ARRAY['You smell like a troll''s armpit!', 'Your mother was a bugbear!', 'You fight like a dairy farmer!', 'I''ve seen better-looking rust monsters!', 'Even a gelatinous cube has more personality!', 'Your sword is dull and your wits are duller!', 'I''ve met kobolds with sharper tongues!', 'Your aim is as bad as your cooking!']::text[], CURRENT_TIMESTAMP),
  ('month_names', 'calendar', ARRAY['the Month of Deepwinter', 'the Month of the Claw', 'the Month of the Grand Struggle', 'the Month of the Running', 'the Month of the Planting', 'the Month of the Long Day', 'the Month of the Time of Famine', 'the Month of the High Sun', 'the Month of the Ripening', 'the Month of the Lowering', 'the Month of the Fade', 'the Month of the Dying', 'the Month of the Shadows', 'the Month of the Great Frost', 'the Month of the Drawing', 'the Month of the Long Night']::text[], CURRENT_TIMESTAMP),
  ('weather_change_clear', 'weather', ARRAY['<b:yellow>The clouds part</>; the sky brightens.']::text[], CURRENT_TIMESTAMP),
  ('weather_change_cloudy', 'weather', ARRAY['<dim>Clouds gather overhead.</>']::text[], CURRENT_TIMESTAMP),
  ('weather_change_drizzle', 'weather', ARRAY['<cyan>A light drizzle</> begins to fall.']::text[], CURRENT_TIMESTAMP),
  ('weather_change_rain', 'weather', ARRAY['The <cyan>rain</> picks up — a steady <cyan>downpour</>.']::text[], CURRENT_TIMESTAMP),
  ('weather_change_storm', 'weather', ARRAY['<dim>The wind howls</>; <dim>thunder</> rumbles in the distance.']::text[], CURRENT_TIMESTAMP),
  ('weather_change_snow', 'weather', ARRAY['<b:white>Snowflakes</> begin to fall.']::text[], CURRENT_TIMESTAMP),
  ('weather_change_blizzard', 'weather', ARRAY['The snow thickens into a blinding <b:white>blizzard</>.']::text[], CURRENT_TIMESTAMP)
ON CONFLICT ("key") DO NOTHING;

INSERT INTO "GameConfig" ("category", "key", "value", "value_type", "description", "updated_at") VALUES
  ('display', 'prompt_templates', '[["classic", "<%h/%H hp %v/%V mv> "], ["compact", "[%h/%H %v/%V] "], ["bars", "%B %M "], ["vitals", "<red>%h</>/%H hp <green>%v</>/%V mv "], ["verbose", "<%n %h/%H hp %v/%V mv %w @ %R> "], ["location", "[%R] <%h/%H hp> "], ["worldclock", "<%h/%H %v/%V — %s %y %Y> "], ["combat", "<%h/%H hp %v/%V mv | %O %K> "], ["minimal", "> "]]', 'JSON'::"ConfigValueType", 'Named prompt presets for the prompt command: [[name, template], ...] in menu order', CURRENT_TIMESTAMP)
ON CONFLICT ("category", "key") DO NOTHING;

UPDATE "Ability" a
SET "prompt_letter" = v.letter
FROM (VALUES
  ('a', 'INN_ASCEN'),
  ('b', 'BREATHE_ACID'),
  ('b', 'BREATHE_FIRE'),
  ('b', 'BREATHE_FROST'),
  ('b', 'BREATHE_GAS'),
  ('b', 'BREATHE_LIGHTNING'),
  ('c', 'INN_BRILL'),
  ('g', 'DARKNESS'),
  ('h', 'DISARM'),
  ('i', 'FIRST_AID'),
  ('j', 'INSTANT_KILL'),
  ('k', 'INVISIBLE'),
  ('l', 'LAY_HANDS'),
  ('m', 'FEATHER_FALL'),
  ('n', 'SHAPECHANGE'),
  ('o', 'SUMMON_MOUNT'),
  ('r', 'THROATCUT'),
  ('t', 'BLINDING_BEAUTY'),
  ('u', 'ILLUMINATION'),
  ('w', 'STATUE'),
  ('x', 'BARKSKIN')
) AS v(letter, plain_name)
WHERE a.plain_name = v.plain_name AND a."prompt_letter" IS NULL;

COMMIT;
