-- Rescue ability messages (playtest 2026-10-11 round 2 #44): the success line was the generic
-- "You use rescue on X!". Now the legacy do_rescue (act.offensive.cpp) wording:
--   caster  "Banzai! To the rescue..."            (legacy "Banzai!   To the rescue...")
--   victim  "You are rescued by <rescuer>, you are confused!"
--   room    "<rescuer> heroically rescues <target>!"
--   fail    "You fail the rescue!"  (caster only, as in legacy)
-- Guarded on the generic text, so a row edited in Muditor is left alone and a second run changes 0 rows.
UPDATE "AbilityMessages" m
   SET success_to_caster = 'Banzai! To the rescue...',
       success_to_victim = 'You are rescued by {actor.name}, you are confused!',
       success_to_room   = '{actor.name} heroically rescues {target.name}!',
       fail_to_caster    = 'You fail the rescue!'
  FROM "Ability" a
 WHERE m.ability_id = a.id
   AND a.plain_name = 'RESCUE'
   AND m.success_to_caster = 'You use rescue on {target.name}!'
   AND m.success_to_victim = '{actor.name} uses rescue on you!'
   AND m.success_to_room   = '{actor.name} uses rescue on {target.name}!';
