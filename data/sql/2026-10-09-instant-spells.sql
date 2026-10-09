-- Legacy spells cast at CAST_SPEED1 (a quarter round) still go through casting_handler, which takes at least 2s
-- (4s without a quick chant: the first handler run is a lead-in, the second completes the spell). The integer
-- Ability.cast_time_rounds column truncates the quarter round to 0, which fierymud-rs treats as instant, so
-- Word of Recall (live: about 4s) landed at once.
-- Legacy (fierymud main): skills.cpp spello() CAST_SPEED1 (casting.hpp:61) for WORD_OF_RECALL (:1320), RECALL (:1122),
-- the ENHANCE_* stat spells (:1336-1351), PROTECT_* (:1354-1364), and the *_BREATH spells (:508, 800, 834, 847, 995, 1254);
-- events.cpp:129 casting_handler (every PULSE_VIOLENCE / 2 = 2s, 2 stars off per run, completes when <= 0).
-- Breath weapons used as the `breathe` skill call call_magic directly (act.offensive.cpp do_breathe, WAIT_STATE one round)
-- and never go through casting, so they keep their own SKILL rows and stay instant.
-- The 'short_cast' tag tells the runtime to wind such a spell up for one star (AbilityDef.short_cast). FRACTURE_SHRAPNEL and
-- PYRE_RECOIL have no spello() in legacy (only called from other spells), so they stay untagged and instant.
-- Source of truth for reimports: data/abilities.json (tests/test_short_cast_spells.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name. Idempotent: the NOT ('short_cast' = ANY(tags)) guard makes a second run update 0 rows.
UPDATE "Ability"
SET tags = array_append(COALESCE(tags, ARRAY[]::text[]), 'short_cast')
WHERE plain_name = ANY(ARRAY[
  'ACID_BREATH',
  'ENHANCE_CHA',
  'ENHANCE_CON',
  'ENHANCE_DEX',
  'ENHANCE_INT',
  'ENHANCE_STR',
  'ENHANCE_WIS',
  'FIRE_BREATH',
  'FROST_BREATH',
  'GAS_BREATH',
  'LIGHTNING_BREATH',
  'PROTECT_ACID',
  'PROTECT_COLD',
  'PROTECT_FIRE',
  'PROTECT_SHOCK',
  'RECALL',
  'VAMPIRIC_BREATH',
  'WORD_OF_RECALL'
])
  AND cast_time_rounds = 0
  AND NOT ('short_cast' = ANY(COALESCE(tags, ARRAY[]::text[])));
