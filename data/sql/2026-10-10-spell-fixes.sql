-- Spell fixes from player reports (fierymud-rs #111, #106, #109). Keyed ONLY by Ability.plain_name (ids differ
-- between dev and prod). Idempotent: each statement only touches a row still in the old shape, so a second run
-- changes 0 rows and builder edits made afterwards survive.
-- Source of truth for reimports: data/abilities.json (tests/test_spell_fixes.py keeps them in sync).

-- #111: Major Globe (and its sibling Minor Globe) cannot be cast in combat. Legacy fierymud main, skills.cpp
-- spello(SPELL_MAJOR_GLOBE ... POS_STANDING, false, ...) and spello(SPELL_MINOR_GLOBE ...): the seventh argument
-- is fighting_ok = false, enforced in spell_parser.cpp (`!SINFO.fighting_ok && GET_STANCE(ch) == STANCE_FIGHTING`).
-- The import never wrote Ability.combat_ok (the column default is true), so every legacy no-fighting spell could
-- be cast mid-fight. Only the globe pair is corrected here; the other ~110 legacy no-fighting spells (buffs,
-- summons, detects...) are a balance call and wait for approval.
UPDATE "Ability"
SET combat_ok = false
WHERE plain_name IN ('MAJOR_GLOBE', 'MINOR_GLOBE')
  AND combat_ok;

-- #106: Dispel Magic is a violent spell (legacy skills.cpp spello(SPELL_DISPEL_MAGIC ...): violent = true; legacy
-- spell_parser.cpp special-cases it so it may still be cast on yourself). With violent = false the runtime never
-- started a fight with the target. Ray of Enfeeblement is already violent; the runtime now engages the victim of
-- any violent spell, damaging or not. Soul Tap is also violent in legacy but here is a self-targeted lifesteal buff,
-- so it stays as is.
UPDATE "Ability"
SET violent = true
WHERE plain_name = 'DISPEL_MAGIC'
  AND NOT violent;

-- #109: casting Fly on someone else told the caster "You rise into the air and begin to fly." and told the room
-- "<caster> rises into the air" although the target was the one flying. The caster line and the room line now
-- name the target; the victim line stays first person and the self-cast lines (success_to_self /
-- success_self_room) are unchanged. Legacy magic.cpp SPELL_FLY: to_char "$N lifts into the air." for the caster.
UPDATE "AbilityMessages" am
SET success_to_caster = CASE WHEN am.success_to_caster = 'You rise into the air and begin to fly.'
                             THEN '{target.name} rises into the air and begins to fly.' ELSE am.success_to_caster END,
    success_to_room = CASE WHEN am.success_to_room = '{actor.name} rises into the air and begins to fly.'
                           THEN '{target.name} rises into the air and begins to fly.' ELSE am.success_to_room END
FROM "Ability" a
WHERE am.ability_id = a.id
  AND a.plain_name = 'FLY'
  AND (am.success_to_caster = 'You rise into the air and begin to fly.'
       OR am.success_to_room = '{actor.name} rises into the air and begins to fly.');
