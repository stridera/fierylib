-- Summon spells' room wear-off line used the pronoun token {actor.pos}, which the
-- wear-off path never rendered ("{actor.pos} summoned creature fades away.").
-- Name the owner instead: "Strider's summoned creature fades away."
-- Idempotent: matches only the old text.
UPDATE "AbilityMessages"
SET wearoff_to_room = '{actor.name}''s summoned creature fades away.'
WHERE wearoff_to_room = '{actor.pos} summoned creature fades away.';
