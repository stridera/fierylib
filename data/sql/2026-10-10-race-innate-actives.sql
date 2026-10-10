-- RaceAbilities: the racial active abilities behind `innate <ability>` (fierymud-rs #14).
--
-- Legacy source (fierymud main, src/act.informative.cpp do_innate ~3962): each active innate is gated on
-- GET_RACE and calls call_magic with the matching spell, then sets a CD_INNATE_* cooldown.
--   race             innate (legacy arg)        ability plain_name   legacy effect / cooldown
--   ELF              syll                       INN_SYLL             +DEX (APPLY_DEX), 7h
--   ELF, FAERIE_*    harness                    HARNESS              10h
--   GNOME, SVERFN.   brill                      INN_BRILL            +INT (APPLY_INT), 7h
--   GNOME            create                     MINOR_CREATION       (spell minor creation)
--   GNOME, SVERFN.   statue                     STATUE               10h
--   ORC              chaz                       INN_STRENGTH         +STR (APPLY_STR), 7h
--   DWARF, DUERGAR   tass                       INN_TASS             +WIS (APPLY_WIS), 7h
--   DUERGAR          invisible                  INVISIBLE            9h
--   DROW             darkness                   DARKNESS             7h
--   DROW             feather fall               FEATHER_FALL         9h
--   FAERIE_UNSEELIE  darkness                   DARKNESS             7h
--   FAERIE_SEELIE    illumination               ILLUMINATION         7h
--   FAERIE_*         faerie step                DIMENSION_DOOR       7h (no FAERIE_STEP ability exists)
--   NYMPH            ascen                      INN_ASCEN            +CHA (APPLY_CHA), 7h
--   NYMPH            blinding beauty            BLINDING_BEAUTY      10h
--   ARBOREAN         barkskin                   BARKSKIN             (20 - CON bonus)h
-- `tren` (INN_TREN, +CON) is commented out in do_innate, so no race gets it. RaceAbilities has no
-- min-level column (legacy has no level gate either). Display names of the INN_* abilities are NOT
-- touched here.
--
-- Cooldowns (legacy SET_COOLDOWN(ch, CD_INNATE_*, n MUD_HR), 1 MUD_HR = 75 real seconds): added as
-- RaceAbilities.cooldown_hours / cooldown_stat / cooldown_phrase (nullable) because Ability.cooldown_ms
-- would also gate the normal spell. cooldown_stat names a stat whose legacy stat_bonus[x].skill_small
-- is subtracted from the hours (barkskin: 20 - CON). cooldown_phrase completes the refusal line
-- "You can <phrase> again in N seconds." (legacy: feather fall omitted the "in"; fixed). `create` is
-- the legacy `create` command (CD_INNATE_CREATE, 1h), run here as MINOR_CREATION.
-- Source of truth for reimports: data/races.json "skills" (tests/test_race_innate_actives.py keeps
-- them in sync).
--
-- Keyed by Races.race (enum) and Ability.plain_name only, no numeric ids. Idempotent: only missing
-- rows are inserted, so builder edits survive and a second run changes 0 rows.

INSERT INTO "RaceAbilities" (race, ability_id, category, bonus, proficiency_cap)
SELECT v.race::"Race", a.id, 'PRIMARY', 0, 100
FROM (VALUES
    ('ARBOREAN', 'BARKSKIN'),
    ('DROW', 'DARKNESS'),
    ('DROW', 'FEATHER_FALL'),
    ('DUERGAR', 'INN_TASS'),
    ('DUERGAR', 'INVISIBLE'),
    ('DWARF', 'INN_TASS'),
    ('ELF', 'HARNESS'),
    ('ELF', 'INN_SYLL'),
    ('FAERIE_SEELIE', 'DIMENSION_DOOR'),
    ('FAERIE_SEELIE', 'HARNESS'),
    ('FAERIE_SEELIE', 'ILLUMINATION'),
    ('FAERIE_UNSEELIE', 'DARKNESS'),
    ('FAERIE_UNSEELIE', 'DIMENSION_DOOR'),
    ('FAERIE_UNSEELIE', 'HARNESS'),
    ('GNOME', 'INN_BRILL'),
    ('GNOME', 'MINOR_CREATION'),
    ('GNOME', 'STATUE'),
    ('NYMPH', 'BLINDING_BEAUTY'),
    ('NYMPH', 'INN_ASCEN'),
    ('ORC', 'INN_STRENGTH'),
    ('SVERFNEBLIN', 'INN_BRILL'),
    ('SVERFNEBLIN', 'STATUE')
) AS v(race, ability)
JOIN "Ability" a ON a.plain_name = v.ability
ON CONFLICT (race, ability_id) DO NOTHING;

-- Cooldowns. Idempotent: only rows without a cooldown get one, so builder edits survive and a second
-- run changes 0 rows.
ALTER TABLE "RaceAbilities" ADD COLUMN IF NOT EXISTS cooldown_hours INTEGER;
ALTER TABLE "RaceAbilities" ADD COLUMN IF NOT EXISTS cooldown_stat TEXT;
ALTER TABLE "RaceAbilities" ADD COLUMN IF NOT EXISTS cooldown_phrase TEXT;

UPDATE "RaceAbilities" ra
SET cooldown_hours = v.hours,
    cooldown_stat = v.stat,
    cooldown_phrase = v.phrase
FROM (VALUES
    ('ARBOREAN', 'BARKSKIN', 20, 'CON', 'armor yourself'),
    ('DROW', 'DARKNESS', 7, NULL, 'create darkness'),
    ('DROW', 'FEATHER_FALL', 9, NULL, 'fall lightly'),
    ('DUERGAR', 'INN_TASS', 7, NULL, 'seek wisdom'),
    ('DUERGAR', 'INVISIBLE', 9, NULL, 'turn invisible'),
    ('DWARF', 'INN_TASS', 7, NULL, 'seek wisdom'),
    ('ELF', 'HARNESS', 10, NULL, 'boost your magical abilities'),
    ('ELF', 'INN_SYLL', 7, NULL, 'improve your grace'),
    ('FAERIE_SEELIE', 'DIMENSION_DOOR', 7, NULL, 'traverse the Reverie'),
    ('FAERIE_SEELIE', 'HARNESS', 10, NULL, 'boost your magical abilities'),
    ('FAERIE_SEELIE', 'ILLUMINATION', 7, NULL, 'create light'),
    ('FAERIE_UNSEELIE', 'DARKNESS', 7, NULL, 'create darkness'),
    ('FAERIE_UNSEELIE', 'DIMENSION_DOOR', 7, NULL, 'traverse the Reverie'),
    ('FAERIE_UNSEELIE', 'HARNESS', 10, NULL, 'boost your magical abilities'),
    ('GNOME', 'INN_BRILL', 7, NULL, 'boost your intelligence'),
    ('GNOME', 'MINOR_CREATION', 1, NULL, 'create'),
    ('GNOME', 'STATUE', 10, NULL, 'disguise yourself'),
    ('NYMPH', 'BLINDING_BEAUTY', 10, NULL, 'blind with your beauty'),
    ('NYMPH', 'INN_ASCEN', 7, NULL, 'enliven your charming nature'),
    ('ORC', 'INN_STRENGTH', 7, NULL, 'bolster your strength'),
    ('SVERFNEBLIN', 'INN_BRILL', 7, NULL, 'boost your intelligence'),
    ('SVERFNEBLIN', 'STATUE', 10, NULL, 'disguise yourself')
) AS v(race, ability, hours, stat, phrase), "Ability" a
WHERE a.plain_name = v.ability
  AND ra.ability_id = a.id
  AND ra.race = v.race::"Race"
  AND ra.cooldown_hours IS NULL;
