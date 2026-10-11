-- Legacy mag_affect (magic.cpp:3320): a spell with `refresh = false` fails ("Nothing seems to happen.", still charged)
-- when the victim already has it. Every other spell refreshes in place. These are the legacy spells that set
-- `refresh = false` (DISPLACEMENT shares the GREATER_DISPLACEMENT case label). fierymud-rs reads `"refresh": false` from
-- AbilityEffect.override_params (commands.rs, "Nothing seems to happen." gate before the effect loop).
-- Keyed ONLY by Ability.plain_name. Idempotent: rows that already carry a `refresh` key are left alone.
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb) || '{"refresh": false}'::jsonb
FROM "Ability" a
WHERE a.id = ae.ability_id
  AND a.plain_name = ANY(ARRAY[
    'COLDSHIELD',
    'CONFUSION',
    'DISPLACEMENT',
    'ENTANGLE',
    'FIRESHIELD',
    'GREATER_DISPLACEMENT',
    'HARNESS',
    'MAJOR_GLOBE',
    'MINOR_GLOBE',
    'MINOR_PARALYSIS',
    'SLEEP',
    'SOULSHIELD',
    'SPINECHILLER',
    'STONE_SKIN',
    'VAPORFORM',
    'WATERFORM',
    'WEB'
  ])
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'refresh');
