-- Ability display names: one casing rule (playtest 2026-10-11 #16).
--
-- The legacy names mixed "Armor Of Gaia" with "Cloak of Gaia", dropped apostrophes
-- ("Bigbys Clenched Fist" next to "Hell's Gate") and spelled "Cure Critic" next to
-- "Cause Critical". Rule: title case, minor words (of, the, and, a, an, in, on, to, from)
-- lowercase unless first; possessives get their apostrophe; the cure/vigorize ladder says
-- "Critical" like cause critical. 33 rows. Same names as data/abilities.json
-- (fierylib.converters.ability_names), checked by tests/test_ability_names.py.
--
-- Only Ability.name (display text) changes. plain_name is the key and is not touched; the
-- runtime matches abilities by plain_name or case-insensitively, apostrophes ignored, so
-- 'cast armor of gaia', 'cast "bigbys clenched fist"' and 'cast cure critic' all still resolve.
--
-- Idempotent and builder-safe: each row is guarded on the old name, so a name edited in
-- Muditor is left alone and a second run changes 0 rows.
UPDATE "Ability" a
   SET name = v.new_name, updated_at = now()
  FROM (VALUES
  ('ARIA_OF_DISSONANCE', 'Aria Of Dissonance', 'Aria of Dissonance'),
  ('ARMOR_OF_GAIA', 'Armor Of Gaia', 'Armor of Gaia'),
  ('BALLAD_OF_TEARS', 'Ballad Of Tears', 'Ballad of Tears'),
  ('BIGBYS_CLENCHED_FIST', 'Bigbys Clenched Fist', 'Bigby''s Clenched Fist'),
  ('BLIZZARDS_OF_SAINT_AUGUSTINE', 'Blizzards Of Saint Augustine', 'Blizzards of Saint Augustine'),
  ('CIRCLE_OF_DEATH', 'Circle Of Death', 'Circle of Death'),
  ('CIRCLE_OF_FIRE', 'Circle Of Fire', 'Circle of Fire'),
  ('CIRCLE_OF_LIGHT', 'Circle Of Light', 'Circle of Light'),
  ('CLOUD_OF_DAGGERS', 'Cloud Of Daggers', 'Cloud of Daggers'),
  ('CONE_OF_COLD', 'Cone Of Cold', 'Cone of Cold'),
  ('CROWN_OF_MADNESS', 'Crown Of Madness', 'Crown of Madness'),
  ('CURE_CRITIC', 'Cure Critic', 'Cure Critical'),
  ('DRAGONS_HEALTH', 'Dragons Health', 'Dragon''s Health'),
  ('FIRES_OF_SAINT_AUGUSTINE', 'Fires Of Saint Augustine', 'Fires of Saint Augustine'),
  ('HEAVENS_GATE', 'Heavens Gate', 'Heaven''s Gate'),
  ('HYMN_OF_SAINT_AUGUSTINE', 'Hymn Of Saint Augustine', 'Hymn of Saint Augustine'),
  ('NATURES_EMBRACE', 'Natures Embrace', 'Nature''s Embrace'),
  ('NATURES_GUIDANCE', 'Natures Guidance', 'Nature''s Guidance'),
  ('SEED_OF_DESTRUCTION', 'Seed Of Destruction', 'Seed of Destruction'),
  ('SHADOWS_SORROW_SONG', 'Shadows Sorrow Song', 'Shadow''s Sorrow Song'),
  ('SONATA_OF_MALAISE', 'Sonata Of Malaise', 'Sonata of Malaise'),
  ('SONG_OF_REST', 'Song Of Rest', 'Song of Rest'),
  ('SPEAK_IN_TONGUES', 'Speak In Tongues', 'Speak in Tongues'),
  ('TEMPEST_OF_SAINT_AUGUSTINE', 'Tempest Of Saint Augustine', 'Tempest of Saint Augustine'),
  ('TREMORS_OF_SAINT_AUGUSTINE', 'Tremors Of Saint Augustine', 'Tremors of Saint Augustine'),
  ('VIGORIZE_CRITIC', 'Vigorize Critic', 'Vigorize Critical'),
  ('WALL_OF_FOG', 'Wall Of Fog', 'Wall of Fog'),
  ('WALL_OF_ICE', 'Wall Of Ice', 'Wall of Ice'),
  ('WALL_OF_STONE', 'Wall Of Stone', 'Wall of Stone'),
  ('WINGS_OF_HEAVEN', 'Wings Of Heaven', 'Wings of Heaven'),
  ('WINGS_OF_HELL', 'Wings Of Hell', 'Wings of Hell'),
  ('WORD_OF_COMMAND', 'Word Of Command', 'Word of Command'),
  ('WORD_OF_RECALL', 'Word Of Recall', 'Word of Recall')
  ) AS v(plain_name, old_name, new_name)
 WHERE a.plain_name = v.plain_name
   AND a.name = v.old_name
   AND a.name <> v.new_name;
