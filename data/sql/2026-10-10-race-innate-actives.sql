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
-- cooldown or min-level column (legacy has no level gate either), so rows only; the legacy cooldowns
-- are listed above for the runtime. Display names of the INN_* abilities are NOT touched here.
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
