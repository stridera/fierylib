-- fierymud-rs #125 (class spell lists): the `*` quest-spell marker in `help spell_<class>` comes from
-- Ability.quest_only, which the import never wrote (every row was false). Legacy skills.cpp marks quest spells with the
-- `quest` argument of spello()/chanto()/songo() (42 abilities); data/abilities.json now carries `questOnly`
-- for them. quest_only is informational (nothing in the runtime reads it), so this does not change who can learn what.
-- Keyed by Ability.plain_name; matches only rows still false, so a second run changes 0 rows.
UPDATE "Ability"
SET quest_only = true
WHERE NOT quest_only
  AND plain_name IN (
  'APOCALYPTIC_ANTHEM', 'ARIA_OF_DISSONANCE', 'BANISH', 'BLIZZARDS_OF_SAINT_AUGUSTINE',
  'BLUR', 'CHARM', 'CREEPING_DOOM', 'CROWN_OF_MADNESS',
  'DEGENERATION', 'DRAGONS_HEALTH', 'ENRAPTURE', 'FIRES_OF_SAINT_AUGUSTINE',
  'FLOOD', 'GREATER_DISPLACEMENT', 'GROUP_ARMOR', 'GROUP_HEAL',
  'GROUP_RECALL', 'HEARTHSONG', 'HEAVENS_GATE', 'HELLFIRE_BRIMSTONE',
  'HELLS_GATE', 'HYMN_OF_SAINT_AUGUSTINE', 'ICE_SHARDS', 'ILLUSORY_WALL',
  'MAJOR_GLOBE', 'MAJOR_PARALYSIS', 'METEORSWARM', 'MOONWELL',
  'PLANE_SHIFT', 'RELOCATE', 'RESURRECT', 'SEED_OF_DESTRUCTION',
  'SHIFT_CORPSE', 'SUMMON_DRACOLICH', 'SUPERNOVA', 'TEMPEST_OF_SAINT_AUGUSTINE',
  'TREMORS_OF_SAINT_AUGUSTINE', 'VAPORFORM', 'WALL_OF_ICE', 'WATERFORM',
  'WIZARD_EYE', 'WORD_OF_COMMAND'
  );
