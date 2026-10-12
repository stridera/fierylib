-- Help entry for the `cancel` command (fierymud-rs#136).
-- Idempotent: inserts only when no entry carries the keyword "cancel".
INSERT INTO "HelpEntry"
  (keywords, title, content, min_level, category, usage, updated_at)
SELECT
  ARRAY['cancel']::text[],
  'Cancel',
  $help$Usage: cancel [<effect>]

Drops one of your own spell effects before it wears off. Use it to get
rid of a beneficial spell you no longer want, for instance to recast it
fresh, or to shed a form (such as waterform) that limits what you can do.

With no argument, CANCEL lists the effects you can cancel and how long
each has left. With a name, it ends that effect right away, just as if it
had worn off: the stat bonuses go away and you see the usual wear-off
message. The name can be shortened ("cancel stone"), and a name of
several words can be quoted ("cancel 'stone skin'"). An exact name wins
over a longer one that merely starts the same way.

What you can cancel:
  - Beneficial spells with a limited duration.

What you cannot cancel:
  - Permanent effects, such as racial traits and what your gear grants.
  - Harmful effects: curses, poison, blindness, and the like.
  - Anything at all while you are fighting.

CANCEL takes no time and has no cooldown.

See also: ABORT, EFFECTS, AFFECTS.$help$,
  0,
  'command',
  'cancel [<effect>]',
  now()
WHERE NOT EXISTS (
  SELECT 1 FROM "HelpEntry" WHERE 'cancel' = ANY(keywords)
);
