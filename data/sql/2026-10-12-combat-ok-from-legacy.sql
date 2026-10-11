-- fierymud-rs #111: "Major Globe can be cast in combat" - Coldshield, Ice Armor, Invisibility (and ~130 more)
-- could still be cast mid-fight. Legacy skills.cpp passes ok_fighting as the seventh spello() argument (enforced in
-- spell_parser.cpp: `!SINFO.fighting_ok && GET_STANCE(ch) == STANCE_FIGHTING` -> "Impossible! You can't
-- concentrate enough!"), and the import never wrote it: Ability.combat_ok kept its column default (true) for
-- everything except the globe pair patched in 2026-10-10-spell-fixes.sql.
-- This clears combat_ok for every spell / chant / song that legacy marks ok_fighting = false (data/abilities.json
-- now carries `combatOk` for all of them; src/fierylib/parsers/legacy_spell_data.py reads skills.cpp).
-- Only the safe direction is patched: a row legacy marks castable in combat that someone cleared later keeps
-- the builder's choice. Keyed by Ability.plain_name; matches only rows still castable, so a second run changes 0 rows.
UPDATE "Ability"
SET combat_ok = false
WHERE combat_ok
  AND "abilityType" IN ('SPELL', 'CHANT', 'SONG')
  AND plain_name IN (
  'ANIMATE_DEAD', 'ARMOR_OF_GAIA', 'BATTLE_HYMN', 'BLESS',
  'BONE_ARMOR', 'CHARM', 'CIRCLE_OF_FIRE', 'CIRCLE_OF_LIGHT',
  'CLARITY', 'CLONE', 'COLDSHIELD', 'CONCEALMENT',
  'CONTROL_WEATHER', 'CREATE_FOOD', 'CREATE_SPRING', 'CREATE_WATER',
  'DARKNESS', 'DARK_FEAST', 'DARK_PRESENCE', 'DEMONIC_MUTATION',
  'DETECT_ALIGN', 'DETECT_INVIS', 'DETECT_MAGIC', 'DETECT_POISON',
  'DIMENSION_DOOR', 'DIVINE_ESSENCE', 'DRAGONS_HEALTH', 'EARTH_BLESSING',
  'ELEMENTAL_WARDING', 'ENCHANT_WEAPON', 'ENDURANCE', 'ENHANCE_ABILITY',
  'ENHANCE_CHA', 'ENHANCE_CON', 'ENHANCE_DEX', 'ENHANCE_INT',
  'ENHANCE_STR', 'ENHANCE_WIS', 'ENLARGE', 'ENLIGHTENMENT',
  'ENRAPTURE', 'FAMILIARITY', 'FARSEE', 'FEATHER_FALL',
  'FIRESHIELD', 'FLAME_BLADE', 'FLY', 'GAIAS_CLOAK',
  'GLORY', 'GREATER_ENDURANCE', 'GREATER_VITALITY', 'GROUP_ARMOR',
  'HEARTHSONG', 'HEAVENS_GATE', 'HELLS_GATE', 'ICE_ARMOR',
  'ICE_DAGGER', 'IDENTIFY', 'ILLUMINATION', 'ILLUSORY_WALL',
  'INFRAVISION', 'INN_ASCEN', 'INN_BRILL', 'INN_SYLL',
  'INN_TASS', 'INN_TREN', 'INVIGORATE', 'INVISIBLE',
  'ISOLATION', 'LESSER_ENDURANCE', 'LOCATE_OBJECT', 'MAJOR_GLOBE',
  'MAJOR_PARALYSIS', 'MASS_INVIS', 'MESMERIZE', 'MINOR_CREATION',
  'MINOR_GLOBE', 'MISDIRECTION', 'MOONWELL', 'NATURES_EMBRACE',
  'NEGATE_COLD', 'NEGATE_HEAT', 'NOURISHMENT', 'PHANTASM',
  'PLANE_SHIFT', 'PRAYER', 'PRESERVE', 'PROTECT_ACID',
  'PROTECT_COLD', 'PROTECT_FIRE', 'PROTECT_SHOCK', 'PROT_FROM_EVIL',
  'PROT_FROM_GOOD', 'RAIN', 'REDUCE', 'REGENERATION',
  'RELOCATE', 'REMOVE_CURSE', 'REMOVE_PARALYSIS', 'RESURRECT',
  'REVEAL_HIDDEN', 'SANCTUARY', 'SANE_MIND', 'SENSE_LIFE',
  'SHIFT_CORPSE', 'SIMULACRUM', 'SLEEP', 'SONG_OF_REST',
  'SOULSHIELD', 'SPEAK_IN_TONGUES', 'STATUE', 'SUMMON',
  'SUMMON_CORPSE', 'SUMMON_DEMON', 'SUMMON_DRACOLICH', 'SUMMON_ELEMENTAL',
  'SUMMON_GREATER_DEMON', 'URBAN_RENEWAL', 'VAPORFORM', 'VENTRILOQUATE',
  'VIGORIZE_CRITIC', 'VIGORIZE_LIGHT', 'VIGORIZE_SERIOUS', 'VITALITY',
  'WALL_OF_FOG', 'WALL_OF_ICE', 'WALL_OF_STONE', 'WANDERING_WOODS',
  'WAR_CRY', 'WATERFORM', 'WATERWALK', 'WINGS_OF_HEAVEN',
  'WINGS_OF_HELL', 'WIZARD_EYE', 'WORD_OF_COMMAND'
  );
