-- Misdirection and Ventriloquate restored to their legacy behaviour (fierymud-rs, ops/notes/ability-flag-gaps-2026-10-12.md).
-- Both used to apply the `hidden` status (a free Stealth marker). The engine now has the real mechanics:
--
--   MISDIRECTION   legacy SPELL_MISDIRECTION sets EFF_MISDIRECTION for 2 + skill / 4 hours. The `misdirection` status flag
--                  installs the Misdirection marker: `<dir> <fake-dir>` / `stay <dir>` / `<dir> stay` show the room a
--                  false direction (legacy act.movement.cpp do_move / do_misdirected_move), and a mob carrying the flag
--                  does it when it wanders (mobact.cpp).
--   VENTRILOQUATE  legacy is a MAG_MANUAL spell (spells.cpp spell_ventriloquate) that applies nothing to the caster: the
--                  room hears the target say the words after its name, with bystander saving rolls. The ability's single
--                  effect becomes an `alter_object` row in mode `speak_as`, the engine's marker for a manual handler
--                  (Preserve is `corpse_timer` on the same effect).
--
-- Keyed ONLY by Ability.plain_name and guarded on the exact old override_params, so a second run changes 0 rows and builder
-- edits survive. Source of truth for reimports: data/abilities.json (tests/test_misdirection_ventriloquate.py keeps the two in
-- sync). Compatibility: a binary without the new code treats `misdirection` as a plain named effect (no marker, nothing
-- happens) and an `alter_object` row with an unknown mode as a no-op; a new binary on unpatched data keeps the old
-- `hidden` behaviour for both.
BEGIN;

UPDATE "AbilityEffect" ae
SET override_params = '{"flag": "misdirection", "duration": "2 + (skill / 4)", "durationUnit": "hours"}'::jsonb
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = 'MISDIRECTION'
  AND ae."order" = 0
  AND ae.override_params = '{"flag": "hidden", "amount": 20, "duration": "skill", "durationUnit": "hours"}'::jsonb;

WITH removed AS (
  DELETE FROM "AbilityEffect" ae
  USING "Ability" a
  WHERE a.id = ae.ability_id
    AND a.plain_name = 'VENTRILOQUATE'
    AND ae."order" = 0
    AND ae.override_params = '{"flag": "hidden", "amount": 20, "duration": "skill", "durationUnit": "hours"}'::jsonb
  RETURNING ae.ability_id
)
INSERT INTO "AbilityEffect" (ability_id, effect_id, override_params, "order", trigger)
SELECT r.ability_id, e.id, '{"mode": "speak_as"}'::jsonb, 0, 'on_cast'
FROM removed r, "Effect" e
WHERE e.name = 'alter_object'
ON CONFLICT (ability_id, effect_id, "order") DO NOTHING;

UPDATE "Effect"
SET description = description || ' The speak_as mode (Ventriloquate) is a manual spell on a person: the room hears the target say the words typed after its name; listeners may see through it, and nothing is applied to the caster.'
WHERE name = 'alter_object' AND description NOT LIKE '%speak_as%';

-- `stay` is a command now (legacy CMD_HIDE: it does not give a hiding character away). The command-help patch
-- seeds its row; keep it hidden-safe like the other movement commands (only while the row still carries the seed text).
UPDATE "Command"
SET keeps_hidden = true, updated_at = now()
WHERE name = 'stay'
  AND keeps_hidden = false
  AND help_text LIKE '%acts out leaving that way%';

-- Help: Misdirection already documents the `<dir> <fake-dir>` form; add the riding rule and who is not fooled.
-- Ventriloquate gets a worked example and how the trick is seen through.
UPDATE "HelpEntry"
SET content = replace(
      content,
      'See also: VENTRILOQUATE',
      E'The spell does not work while riding or being ridden. Immortals of your level or\nhigher see through it.\n\nSee also: VENTRILOQUATE'),
    updated_at = now()
WHERE 'misdirection' = ANY(keywords)
  AND content LIKE '%See also: VENTRILOQUATE%'
  AND content NOT LIKE '%does not work while riding%';

UPDATE "HelpEntry"
SET content = replace(
      content,
      'See also: MISDIRECTION',
      E'The words go after the target''s name:\n\n> cast ''ventriloquate'' bob Who left the gate open?\n\nEveryone else in the room hears Bob say it, and nobody hears you chant. Wise and\nexperienced listeners may see through the trick, and the keenest may even tell who\ndid it. A trick played on another player is always seen through, so it only truly\nfools anyone when the target is a mob.\n\nSee also: MISDIRECTION'),
    updated_at = now()
WHERE 'ventriloquate' = ANY(keywords)
  AND content LIKE '%See also: MISDIRECTION%'
  AND content NOT LIKE '%Everyone else in the room hears%';

COMMIT;
