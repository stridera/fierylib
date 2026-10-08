-- EffectAura: look-at-actor aura flavor sentences, moved out of the hard-coded
-- AURAS table in fierymud-rs commands/look_auras.rs (data over code).
--
-- `keys` are lowercase, space-separated labels matched against the originating
-- ability's name and the effect's flag name. Rows sharing `exclusive_group` show
-- only the first match by sort_order (Dragon's Health supersedes plain endurance,
-- as in legacy). min/max_alignment (inclusive) gate on the bearer's alignment:
-- Sanctuary reads black <= -350, white >= 350, blue in between.
--
-- Idempotent and builder-safe: the table is created IF NOT EXISTS and rows are
-- inserted ON CONFLICT (slug) DO NOTHING, so edits made in Muditor survive a
-- re-run and a second run changes nothing. Keep in sync with the Prisma model
-- EffectAura in muditor/packages/db/prisma/schema.prisma.

BEGIN;

CREATE TABLE IF NOT EXISTS "EffectAura" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "keys" TEXT[],
    "text" TEXT NOT NULL,
    "needs_detect_magic" BOOLEAN NOT NULL DEFAULT false,
    "exclusive_group" TEXT,
    "min_alignment" INTEGER,
    "max_alignment" INTEGER,
    "sort_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "EffectAura_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "EffectAura_slug_key" ON "EffectAura"("slug");

INSERT INTO "EffectAura"
    (slug, keys, text, needs_detect_magic, exclusive_group, min_alignment, max_alignment, sort_order)
VALUES
    ('armor', ARRAY['armor', 'group armor'], 'A <b:white>translucent shimmering aura</> surrounds {M}.', true, NULL, NULL, NULL, 10),
    ('bless', ARRAY['bless'], 'The shimmering telltales of a <b:yellow>magical blessing</> flutter about {S} head.', true, NULL, NULL, NULL, 20),
    ('demonic_aspect', ARRAY['demonic aspect'], 'A <red>demonic tinge</> circulates in {S} <red>blood</>.', true, NULL, NULL, NULL, 30),
    ('demonic_mutation', ARRAY['demonic mutation'], 'Two <red>large red horns</> sprout from {S} head.', true, NULL, NULL, NULL, 40),
    ('dark_presence', ARRAY['dark presence'], 'You sense a <dim>dark presence</> within {M}.', true, NULL, NULL, NULL, 50),
    ('dragons_health', ARRAY['dragons health', 'dragon''s health'], 'The power of <magenta>dragon''s blood</> fills {M}!', true, 'health_boost', NULL, NULL, 60),
    ('lesser_endurance', ARRAY['lesser endurance', 'endurance', 'greater endurance', 'vitality', 'greater vitality'], '{^S} health appears to be bolstered by magical power.', true, 'health_boost', NULL, NULL, 70),
    ('chill_touch', ARRAY['chill touch'], 'A <cyan>weakening chill</> circulates in {S} veins.', true, NULL, NULL, NULL, 80),
    ('clarity', ARRAY['clarity'], 'A <b:yellow>clarity</> of mind surrounds {M}.', true, NULL, NULL, NULL, 90),
    ('minor_globe', ARRAY['minor globe'], '<red>{^S} body is encased in a shimmering globe!</>', true, NULL, NULL, NULL, 100),
    ('stone_skin', ARRAY['stone skin', 'stoneskin'], '<dim>{^S} body seems to be made of stone!</>', false, NULL, NULL, NULL, 110),
    ('barkskin', ARRAY['barkskin'], '<yellow>{^S} skin is thick, brown, and wrinkly.</>', false, NULL, NULL, NULL, 120),
    ('bone_armor', ARRAY['bone armor'], '<white>Heavy bony plates cover {S} body.</>', false, NULL, NULL, NULL, 130),
    ('demonskin', ARRAY['demonskin'], '<red>{^S} skin is shiny, smooth, and <b:red>very red</>.</>', false, NULL, NULL, NULL, 140),
    ('gaias_cloak', ARRAY['gaias cloak', 'gaia''s cloak'], '<green>A whirlwind of leaves and <yellow>sticks</> whips around {S} body.</>', false, NULL, NULL, NULL, 150),
    ('ice_armor', ARRAY['ice armor'], 'A layer of <blue>solid ice</> covers {M} entirely.', false, NULL, NULL, NULL, 160),
    ('mirage', ARRAY['mirage'], '<white>{^S} image <red>wavers</> and <dim>shimmers</> and is somewhat indistinct.</>', false, NULL, NULL, NULL, 170),
    ('blind', ARRAY['blind', 'blindness'], '{^S} <dim>dull</> eyes suggest {E} is blind!', false, NULL, NULL, NULL, 180),
    ('fireshield', ARRAY['fireshield'], '<b:red>{^S} body is encased in fire!</>', false, NULL, NULL, NULL, 190),
    ('coldshield', ARRAY['coldshield'], '<b:blue>{^S} body is encased in jagged ice!</>', false, NULL, NULL, NULL, 200),
    ('major_globe', ARRAY['major globe'], '<b:red>{^S} body is encased in shimmering globe of force!</>', false, NULL, NULL, NULL, 210),
    ('entangle', ARRAY['entangle'], '<green>{^E} is entwined by a tangled mass of vines.</>', false, NULL, NULL, NULL, 220),
    ('paralyzed', ARRAY['paralyzed', 'minor paralysis', 'major paralysis'], '<cyan>{^E} is completely still, and shows no awareness of {S} surroundings.</>', false, NULL, NULL, NULL, 230),
    ('web', ARRAY['web'], '<green>{^E} is tangled in glowing <b:yellow>webs</>!</>', false, NULL, NULL, NULL, 240),
    ('wings_of_hell', ARRAY['wings of hell'], '<b:red>Huge leathery <dim>bat-like</> wings sprout from {S} back.</>', false, NULL, NULL, NULL, 250),
    ('wings_of_heaven', ARRAY['wings of heaven'], '<b:white>{^E} has a pair of beautiful bright white wings.</>', false, NULL, NULL, NULL, 260),
    ('magic_torch', ARRAY['magic torch'], '{^E} is being followed by a <red>bright glowing light</>.', false, NULL, NULL, NULL, 270),
    ('circle_of_light', ARRAY['circle of light'], '<b:white>A circle of light floats over {S} head.</>', false, NULL, NULL, NULL, 280),
    ('on_fire', ARRAY['on fire', 'burning'], '<b:red>{^E} is on FIRE!</>', false, NULL, NULL, NULL, 290),
    ('sanctuary_evil', ARRAY['sanctuary'], '<dim>{^S} body is surrounded by a black aura!</>', false, NULL, NULL, -350, 300),
    ('sanctuary_neutral', ARRAY['sanctuary'], '<b:blue>{^S} body is surrounded by a blue aura!</>', false, NULL, -349, 349, 310),
    ('sanctuary_good', ARRAY['sanctuary'], '<b:white>{^S} body is surrounded by a white aura!</>', false, NULL, 350, NULL, 320)
ON CONFLICT (slug) DO NOTHING;

COMMIT;
