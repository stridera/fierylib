-- fierymud-rs: data-over-code binding of engine features to ability rows.
-- The runtime (mud-world CoreAbilities) resolves the nine core abilities by a stable `core:<role>`
-- tag in Ability.tags instead of by display name, so renaming one in Muditor no longer silently
-- disables the feature. Rows are keyed here by their CURRENT plain_name (the one-time bridge); after
-- this patch the tag, not the name, is the binding. An untagged database still works (the loader
-- falls back to the name and logs a WARN).
-- Idempotent: a row that already carries its tag is left alone; a NULL tags column counts as empty.
BEGIN;

UPDATE "Ability" a
SET tags = array_append(coalesce(a.tags, '{}'), m.tag)
FROM (VALUES
  ('DODGE',        'core:dodge'),
  ('PARRY',        'core:parry'),
  ('SAFEFALL',     'core:safefall'),
  ('PICK_LOCK',    'core:pick_lock'),
  ('SWITCH',       'core:switch'),
  ('STEAL',        'core:steal'),
  ('CLAW',         'core:claw'),
  ('ELECTRIFY',    'core:electrify'),
  ('SUMMON_MOUNT', 'core:summon_mount')
) AS m(plain_name, tag)
WHERE a.plain_name = m.plain_name
  AND NOT (m.tag = ANY (coalesce(a.tags, '{}')));

COMMIT;
