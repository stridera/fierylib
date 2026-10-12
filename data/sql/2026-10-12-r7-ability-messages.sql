-- Playtest r7 #22: room lines read "at it who staggers"; name the target
-- instead of the pronoun. Guarded on the old text so builder edits stay.
BEGIN;

UPDATE "AbilityMessages"
SET success_to_room = '{actor.name} throws colors at {target.name}, who in vain tries to escape!'
WHERE true
  AND success_to_room = '{actor.name} throws colors at {target.him} who in vain tries to escape!';

UPDATE "AbilityMessages"
SET success_to_room = '{actor.name} throws a magic missile at {target.name}, who staggers under the blow!'
WHERE true
  AND success_to_room = '{actor.name} throws a magic missile at {target.him} who staggers under the blow!';

UPDATE "AbilityMessages"
SET success_to_caster = 'You watch with pride as your magic missile hits {target.name}!'
WHERE true
  AND success_to_caster = 'You watch with pride as your magic missile hits {target.him}!';

UPDATE "AbilityMessages"
SET success_to_room = '{actor.name} throws a spirit arrow at {target.name}, who waivers under the blow!'
WHERE true
  AND success_to_room = '{actor.name} throws a spirit arrow at {target.him} who waivers under the blow!';

COMMIT;
