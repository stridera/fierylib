-- Weather flavour lines (data-over-code).
--
-- The `weather` command of fierymud-rs kept one flavour line per zone climate and time of day in
-- a Rust match. They now live in "WeatherText" (climate, daypart, text), editable in Muditor.
-- daypart is dawn / day / midday / evening / night / any. The game tries the exact hour band,
-- then its group (day = day+midday; night = night+evening+dawn), then "any"; a key with no row
-- (or NULL text) falls back to the same built-in line, so behaviour is identical either way.
--
-- This patch:
--   * creates "WeatherText" if missing (DDL matches what Prisma's `db push` creates);
--   * seeds the current lines, filling only missing rows and NULL texts (a line edited in
--     Muditor wins).
--
-- Idempotent: rerunning changes nothing.

BEGIN;

CREATE TABLE IF NOT EXISTS "WeatherText" (
    "climate" "Climate" NOT NULL,
    "daypart" TEXT NOT NULL,
    "text" TEXT,

    CONSTRAINT "WeatherText_pkey" PRIMARY KEY ("climate","daypart")
);

INSERT INTO "WeatherText" ("climate", "daypart", "text")
VALUES
    ('ARID', 'day', 'Heat shimmers off the parched ground; the air is dry as bone.'),
    ('ARID', 'night', 'The desert chill cuts through cloaks; stars wheel sharply overhead.'),
    ('SEMIARID', 'day', 'Dust dances on a warm wind; the sun bears down without mercy.'),
    ('SEMIARID', 'night', 'The scrub cools rapidly; far-off coyotes call.'),
    ('TROPICAL', 'day', 'Humid air clings to your skin; a green-tinted sun hangs heavy.'),
    ('TROPICAL', 'night', 'Frogs and night-birds compete in the dripping dark.'),
    ('SUBTROPICAL', 'day', 'Warm gusts carry distant rain; cumulus clouds tower in lazy stacks.'),
    ('SUBTROPICAL', 'night', 'Crickets thicken the air; warm mist drifts through the night.'),
    ('TEMPERATE', 'dawn', 'A cool breeze rustles the leaves; dew glistens on every blade.'),
    ('TEMPERATE', 'day', 'Mild sun and a clean breeze; pleasant traveling weather.'),
    ('TEMPERATE', 'night', 'Stars glitter through clear, cool air.'),
    ('OCEANIC', 'day', 'Salt spray rides a steady wind; gulls wheel and complain.'),
    ('OCEANIC', 'night', 'Distant surf and sea-mist mute the night.'),
    ('SUBARCTIC', 'day', 'Pale sun glints off stubborn frost; your breath fogs the air.'),
    ('SUBARCTIC', 'night', 'Bitter cold seeps through every seam; aurora flickers overhead.'),
    ('ARCTIC', 'day', 'Wind-driven snow blurs the horizon; the sun is a pale disc.'),
    ('ARCTIC', 'night', 'The cold is absolute; ice creaks in the dark.'),
    ('ALPINE', 'day', 'Thin, sharp air bites at your lungs; the sun is fierce off the snow.'),
    ('ALPINE', 'night', 'The wind howls down the slopes; stars are knife-bright at altitude.'),
    ('NONE', 'any', 'The air is still and unremarkable.')
ON CONFLICT ("climate", "daypart") DO UPDATE
SET "text" = EXCLUDED."text"
WHERE "WeatherText"."text" IS NULL;

COMMIT;
