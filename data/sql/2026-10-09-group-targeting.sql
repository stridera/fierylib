-- Group targeting (legacy MAG_GROUP) and the outdoors restriction (legacy TAR_OUTDOORS).
--
-- 1. MAG_GROUP. Legacy mag_group (magic.cpp:3451) runs perform_mag_group on every player grouped with the
--    caster who is in the room, caster last. The runtime already does this for Group Heal through
--    Ability.target_scope = ROOM_ALLIES (+ is_area), but the other legacy MAG_GROUP abilities were SINGLE:
--    Invigorate (skills.cpp:969), Divine Essence, Group Armor, Group Recall, Freedom Song, Hearthsong and
--    Heroic Journey. They now take the same ROOM_ALLIES scope. War Cry (also MAG_GROUP) is NOT touched: its
--    row is a violent on-hit damage placeholder, so group targeting would damage the group; it needs its
--    effect rows reworked first (legacy: hitroll and damroll +skill/25+1 on the group).
--
-- 2. TAR_OUTDOORS. Legacy check_spell_target (spell_parser.cpp:1559) refuses the cast while CH_INDOORS(ch)
--    with "This area is too enclosed to cast that spell!". The runtime reads an "outdoors" rule from
--    AbilityRestrictions.requirements (indoors = IndoorRoom flag, underdark or underwater sector, exactly
--    legacy INDOORS()). Nine legacy abilities carry TAR_OUTDOORS: Call Lightning, Detonation, Earthquake,
--    Entangle, Cloak of Gaia (GAIAS_CLOAK), Moonbeam, Natures Embrace, Urban Renewal, Writhing Weeds.
--
-- Source of truth for reimports: data/abilities.json (tests/test_group_targeting.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name (ids differ between dev and prod). Idempotent: each statement only
-- touches a row still in the old shape, so a second run changes 0 rows and builder edits made afterwards
-- (a different scope, a rewritten rule) survive.

-- 1. Group scope: only abilities still on the default SINGLE scope without is_area.
UPDATE "Ability" a
SET target_scope = 'ROOM_ALLIES',
    is_area = true
WHERE a.plain_name IN ('INVIGORATE', 'DIVINE_ESSENCE', 'GROUP_ARMOR', 'GROUP_RECALL',
                       'FREEDOM_SONG', 'HEARTHSONG', 'HEROIC_JOURNEY')
  AND a.target_scope = 'SINGLE'
  AND NOT a.is_area;

UPDATE "Ability" a
SET notes = replace(a.notes,
      'MAG_GROUP (caster plus grouped allies in the room) is not modelled: single target.',
      'MAG_GROUP (mag_group, magic.cpp:3451) is targetScope ROOM_ALLIES: the cast fills the caster plus every grouped player in the room, caster last.')
WHERE a.plain_name = 'INVIGORATE'
  AND a.notes LIKE '%MAG_GROUP (caster plus grouped allies in the room) is not modelled: single target.%';

-- 2. Outdoors restriction: add the rule to an existing restrictions row, or create the row.
UPDATE "AbilityRestrictions" r
SET requirements = r.requirements
      || ARRAY['{"type": "outdoors", "message": "This area is too enclosed to cast that spell!"}'::jsonb]
FROM "Ability" a
WHERE r.ability_id = a.id
  AND a.plain_name IN ('CALL_LIGHTNING', 'DETONATION', 'EARTHQUAKE', 'ENTANGLE', 'GAIAS_CLOAK',
                       'MOONBEAM', 'NATURES_EMBRACE', 'URBAN_RENEWAL', 'WRITHING_WEEDS')
  AND NOT EXISTS (SELECT 1 FROM unnest(r.requirements) AS req WHERE req->>'type' = 'outdoors');

INSERT INTO "AbilityRestrictions" (ability_id, requirements)
SELECT a.id,
       ARRAY['{"type": "outdoors", "message": "This area is too enclosed to cast that spell!"}'::jsonb]
FROM "Ability" a
WHERE a.plain_name IN ('CALL_LIGHTNING', 'DETONATION', 'EARTHQUAKE', 'ENTANGLE', 'GAIAS_CLOAK',
                       'MOONBEAM', 'NATURES_EMBRACE', 'URBAN_RENEWAL', 'WRITHING_WEEDS')
  AND NOT EXISTS (SELECT 1 FROM "AbilityRestrictions" r WHERE r.ability_id = a.id);

UPDATE "Ability" a
SET description = replace(a.description, 'Outdoors only (not enforced yet).', 'Outdoors only.'),
    notes = replace(a.notes,
      'has no restriction type in the runtime yet, so it is not enforced.',
      'is the "outdoors" restriction rule: the cast is refused with that line while the caster''s room is indoors (IndoorRoom flag, underdark or underwater sector).')
WHERE a.plain_name = 'NATURES_EMBRACE'
  AND (a.description LIKE '%Outdoors only (not enforced yet).%'
       OR a.notes LIKE '%has no restriction type in the runtime yet, so it is not enforced.%');
