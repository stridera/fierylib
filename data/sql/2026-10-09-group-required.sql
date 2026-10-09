-- Group abilities need a group (legacy MAG_GROUP).
-- Legacy cast_spell (spell_parser.cpp:974), do_chant (:1068) and do_perform (:1166) refuse a MAG_GROUP ability
-- while the caster is not IS_GROUPED (group_master or groupees), and the refusal charges nothing:
--   spells: "You can't cast this spell if you're not in a group!"
--   chants: "You can't chant this song if you're not in a group!"
--   songs:  "You can't perform this if you're not in a group!"
-- The runtime reads a "grouped" rule from AbilityRestrictions.requirements (the caster belongs to a group by real
-- invite + accept membership; a lone leader nobody joined and a plain follower are not grouped). Nine legacy
-- abilities are MAG_GROUP (skills.cpp): Divine Essence, Group Armor, Group Heal, Group Recall, Invigorate, War Cry,
-- Freedom Song, Hearthsong and Heroic Journey.
--
-- Source of truth for reimports: data/abilities.json (tests/test_group_required.py keeps them in sync).
--
-- Keyed ONLY by Ability.plain_name (ids differ between dev and prod). Idempotent: a rule is added only where the
-- ability has no "grouped" rule yet, so a second run changes 0 rows and a builder's rewritten message survives.

-- Add the rule to an existing restrictions row...
UPDATE "AbilityRestrictions" r
SET requirements = r.requirements
      || ARRAY[jsonb_build_object('type', 'grouped', 'message', g.message)]
FROM "Ability" a
JOIN (VALUES
  ('DIVINE_ESSENCE', 'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_ARMOR',    'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_HEAL',     'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_RECALL',   'You can''t cast this spell if you''re not in a group!'),
  ('INVIGORATE',     'You can''t cast this spell if you''re not in a group!'),
  ('WAR_CRY',        'You can''t chant this song if you''re not in a group!'),
  ('FREEDOM_SONG',   'You can''t perform this if you''re not in a group!'),
  ('HEARTHSONG',     'You can''t perform this if you''re not in a group!'),
  ('HEROIC_JOURNEY', 'You can''t perform this if you''re not in a group!')
) AS g(plain_name, message) ON g.plain_name = a.plain_name
WHERE r.ability_id = a.id
  AND NOT EXISTS (SELECT 1 FROM unnest(r.requirements) AS req WHERE req->>'type' = 'grouped');

-- ...or create the row.
INSERT INTO "AbilityRestrictions" (ability_id, requirements)
SELECT a.id, ARRAY[jsonb_build_object('type', 'grouped', 'message', g.message)]
FROM "Ability" a
JOIN (VALUES
  ('DIVINE_ESSENCE', 'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_ARMOR',    'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_HEAL',     'You can''t cast this spell if you''re not in a group!'),
  ('GROUP_RECALL',   'You can''t cast this spell if you''re not in a group!'),
  ('INVIGORATE',     'You can''t cast this spell if you''re not in a group!'),
  ('WAR_CRY',        'You can''t chant this song if you''re not in a group!'),
  ('FREEDOM_SONG',   'You can''t perform this if you''re not in a group!'),
  ('HEARTHSONG',     'You can''t perform this if you''re not in a group!'),
  ('HEROIC_JOURNEY', 'You can''t perform this if you''re not in a group!')
) AS g(plain_name, message) ON g.plain_name = a.plain_name
WHERE NOT EXISTS (SELECT 1 FROM "AbilityRestrictions" r WHERE r.ability_id = a.id);
