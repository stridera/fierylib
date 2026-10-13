-- Playtest r9 #12: `help set` documented the legacy field table (hit, mana, move, str, maxmana, ...)
-- while `set fields` lists the real, much smaller set. This replaces the legacy HelpEntry text with
-- the fields the command actually writes (mirrors SET_FIELDS in fierymud-rs commands/admin_inspect.rs).
-- Guarded on the legacy text, so a help entry rewritten since is left alone. Idempotent.
BEGIN;

UPDATE "HelpEntry"
SET usage = $h$set <player> <field> <value>  |  set fields$h$,
    content = $h$Usage: set <player> <field> <value>  |  set fields

SET changes one field of a player directly. It needs Builder rank (level 101);
the level and xp fields need Coder (level 104). The player must be online and
visible to you. Run "set fields" for the live list with each field's aliases.

Fields:
  level                   the character's level (at least 1)
  xp (exp, experience)    experience points (at least 0)
  hp                      current hit points (clamped to 0..max)
  maxhp                   maximum hit points (current hp is pinned to it)
  stamina (stam)          current stamina (clamped to 0..max)
  maxstamina (maxstam)    maximum stamina
  platinum (plat)         platinum coins on hand, other coins are kept
  gold, silver, copper    that many coins on hand, 0-9 each, other coins are kept
  wealth                  total coin on hand, counted in copper
  alignment (align)       alignment, signed

There is no field for class, race, stats or skills. To change abilities, use
SKILLSET. "stat <player>" shows everything a character currently has; pair the
two when adjusting a test character.

See also: STAT, SKILLSET, RESTORE.$h$,
    updated_at = now()
WHERE 'set' = ANY(keywords)
  AND category = 'command'
  AND content LIKE 'Usage: set [ file | player ] <character> <field> <value>%';

COMMIT;
