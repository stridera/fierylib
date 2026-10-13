-- Playtest r9 #9: Eye Gouge read "TestRogue lunges at it ... with TestRogue's thumbs" and "into a rottweiler's eye sockets".
-- {..pos} renders as "<Name>'s"; the pronoun possessive is {..his}, and the room line names the target
-- instead of "it". Guarded on the old text so builder edits stay. Idempotent.
BEGIN;

UPDATE "AbilityMessages" SET success_to_caster = '{target.name} reels back as you jam your thumbs right into {target.his} eye sockets!'
WHERE success_to_caster = '{target.name} reels back as you jam your thumbs right into {target.pos} eye sockets!'
  AND ability_id = (SELECT id FROM "Ability" WHERE name = 'Eye Gouge');

UPDATE "AbilityMessages" SET success_to_victim = 'Blood fills your vision as {actor.name} slips {actor.his} thumbs into your eyes!'
WHERE success_to_victim = 'Blood fills your vision as {actor.name} slips {actor.pos} thumbs into your eyes!'
  AND ability_id = (SELECT id FROM "Ability" WHERE name = 'Eye Gouge');

UPDATE "AbilityMessages" SET success_to_room = '{actor.name} lunges at {target.name}, gouging into {target.his} eyes with {actor.his} thumbs!'
WHERE success_to_room = '{actor.name} lunges at {target.him}, gouging into {target.pos} eyes with {actor.pos} thumbs!'
  AND ability_id = (SELECT id FROM "Ability" WHERE name = 'Eye Gouge');

UPDATE "AbilityMessages" SET fail_to_caster = 'Your lunge goes wide, missing {target.his} head by a mile.'
WHERE fail_to_caster = 'Your lunge goes wide, missing {target.pos} head by a mile.'
  AND ability_id = (SELECT id FROM "Ability" WHERE name = 'Eye Gouge');

UPDATE "AbilityMessages" SET fail_to_room = '{actor.name} lunges wildly at {target.name}, nearly taking out an eye!'
WHERE fail_to_room = '{actor.name} lunges wildly at {target.him}, nearly taking out an eye!'
  AND ability_id = (SELECT id FROM "Ability" WHERE name = 'Eye Gouge');

COMMIT;
