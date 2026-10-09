-- Missing socials (fierymud-rs command parity). The legacy socials file has a `hi5` entry, but the
-- parser skipped it because the name has a digit (fixed in socials_parser.py: isalnum, not isalpha),
-- so it never reached the "Social" table and `hi5` was an unknown command.
--
-- `screw` is listed in the legacy command table (interpreter.cpp) but lib/misc/socials has no entry
-- for it, so legacy answered "That action is not supported." There is no text to port; none is
-- invented here.
--
-- Text is exactly what SocialsSeeder produces for the legacy entry (position 0 -> RESTING,
-- $-codes -> {actor.*}/{target.*} templates).
--
-- Idempotent: ON CONFLICT (name) DO NOTHING, so a second run inserts 0 rows and never overwrites a
-- builder's edit.

INSERT INTO "Social" (
  name, hide, min_victim_position,
  char_no_arg, others_no_arg,
  char_found, others_found, vict_found, not_found,
  char_auto, others_auto,
  updated_at
) VALUES (
  'hi5', false, 'RESTING',
  'Hi-Five WHO?', NULL,
  'You high five {target.pronoun.objective}. Yeah!',
  '{actor.name} high fives {target.name}. ROR!',
  '{actor.name} hi-fives you! Yeah!',
  'You wave your hand in the air... who''s that?',
  'You slap your hands together above your head, uhhhh ok.',
  '{actor.name} hi-five''s {actor.pronoun.reflexive}.  Strange.',
  CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;
