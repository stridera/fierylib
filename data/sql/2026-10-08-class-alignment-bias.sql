-- Killer-class alignment bias for existing databases (data-over-code).
--
-- Legacy `change_alignment` (fight.cpp) adds a per-class bias to the killer's
-- alignment before the kill formula. fierymud-rs used to hard-code that table
-- in combat.rs by plain_name; it now reads "Class".alignment_bias instead:
--   * adds "Class".alignment_bias if the column is missing (default 0);
--   * sets it per class with the legacy values (Paladin/Priest +100,
--     Ranger/Druid +50, Anti-Paladin/Diabolist/Necromancer -100,
--     Thief/Assassin -50; every other class stays 0).
--
-- Idempotent: rerunning is a no-op (the UPDATE skips rows already at the
-- target value, so a builder's later edit is only overwritten on first run).

BEGIN;

ALTER TABLE "Class"
    ADD COLUMN IF NOT EXISTS alignment_bias integer NOT NULL DEFAULT 0;

UPDATE "Class" AS c
SET alignment_bias = v.bias, updated_at = now()
FROM (VALUES
        ('paladin', 100),
        ('priest', 100),
        ('ranger', 50),
        ('druid', 50),
        ('anti-paladin', -100),
        ('diabolist', -100),
        ('necromancer', -100),
        ('thief', -50),
        ('assassin', -50)
) AS v(plain_name, bias)
WHERE lower(c.plain_name) = v.plain_name
  AND c.alignment_bias IS DISTINCT FROM v.bias;

COMMIT;
