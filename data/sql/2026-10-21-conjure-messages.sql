-- Conjure-item spells (Minor Creation, Create Food) tell the caster what was made and where it went (issue #177).
--
-- The `create` effect reads two optional override params:
--   message      to the caster. {object} = the item's short description; {where} = "appears in your hands"
--                (inventory) or "falls to the ground" (too heavy to carry).
--   roomMessage  to everyone else. {actor.name} as in AbilityMessages.
-- The bare "You cast minor creation." / "You cast create food." success lines are no longer sent for these spells
-- (the effect's own lines replace them). With no params the runtime uses "You create {object}, which {where}." and
-- "{actor.name} creates {object}."; these rows only set the wording builders can then edit.
-- Minor Creation's room line keeps legacy spell_minor_creation's flash of light.
--
-- Keyed by Ability.plain_name and Effect.name (ids differ between dev and prod). Idempotent: only rows without a
-- `message` param are touched, so builder edits survive a re-run.

UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
    || jsonb_build_object('message', m.message, 'roomMessage', m.room_message)
FROM "Ability" a, "Effect" e,
     (VALUES
       ('MINOR_CREATION',
        'You create {object}, which {where}.',
        '{actor.name} invokes the powers of creation, and {object} appears in a bright flash of light!'),
       ('CREATE_FOOD',
        'You create {object}, which {where}.',
        '{actor.name} creates {object}.')
     ) AS m(plain_name, message, room_message)
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = m.plain_name
  AND e.name = 'create'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'message');
