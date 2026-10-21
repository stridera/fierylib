-- The `consent` help (HelpEntry 86) said the CONSENT flag does not change who can loot you. Since fierymud-rs
-- main 95daf98 other players may loot a player's corpse while its owner is online with CONSENT set, the same
-- flag `drag` uses. Only the CONSENT paragraph changes. Keyed by keyword; idempotent (IS DISTINCT FROM guard).
UPDATE "HelpEntry"
SET content = $help$Three switches control how other players can affect you. Each is a toggle:
type the command once to turn it on and again to turn it off. "flags" lists
the ones you have set.

NOSUMMON
  Someone casting summon on you doesn't move you straight away. You are
  told who wants to summon you and where to, and have 30 seconds to answer:

    accept    go to the caster.
    decline   stay where you are.

  "nosummon" skips the prompt altogether: every summon is refused
  silently and the caster just sees that you are not accepting summons.
  It is handy when you are away from the keyboard. Turn it off again to
  get the prompts back. Staff with the summon permission, and players with
  PK switched on, can't be shielded this way (see PK).

PK
  "pk" marks you as willing to take part in player-versus-player play. While
  it is on, area attacks in your room count you as an enemy and summons reach
  you without a prompt. Leave it off unless you want that.

CONSENT
  "consent" toggles your CONSENT flag, which marks you as trusting other
  players for shared interactions. While it is set, other players can drag
  you ("drag") and, while you are online, loot your corpse. Log out or turn
  consent off and your corpse is safe again: only you (and staff) can take
  things from it. Without consent set, nobody else can loot your corpse.

See also: MAGIC, GROUPS, FLAGS.$help$,
    updated_at = now()
WHERE 'consent' = ANY(keywords)
  AND content IS DISTINCT FROM $help$Three switches control how other players can affect you. Each is a toggle:
type the command once to turn it on and again to turn it off. "flags" lists
the ones you have set.

NOSUMMON
  Someone casting summon on you doesn't move you straight away. You are
  told who wants to summon you and where to, and have 30 seconds to answer:

    accept    go to the caster.
    decline   stay where you are.

  "nosummon" skips the prompt altogether: every summon is refused
  silently and the caster just sees that you are not accepting summons.
  It is handy when you are away from the keyboard. Turn it off again to
  get the prompts back. Staff with the summon permission, and players with
  PK switched on, can't be shielded this way (see PK).

PK
  "pk" marks you as willing to take part in player-versus-player play. While
  it is on, area attacks in your room count you as an enemy and summons reach
  you without a prompt. Leave it off unless you want that.

CONSENT
  "consent" toggles your CONSENT flag, which marks you as trusting other
  players for shared interactions. While it is set, other players can drag
  you ("drag") and, while you are online, loot your corpse. Log out or turn
  consent off and your corpse is safe again: only you (and staff) can take
  things from it. Without consent set, nobody else can loot your corpse.

See also: MAGIC, GROUPS, FLAGS.$help$;
