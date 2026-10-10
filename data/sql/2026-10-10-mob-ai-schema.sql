-- Mob spellcasting / skill AI, data model (WP-A of ops/plans/mob-ai.md).
--
--   * enum "MobAiMode" (CLASS | CUSTOM | NONE) and "Mobs".ai_mode (default CLASS)
--   * "ClassAiRules": per-class rule list (ability, priority, chance, cooldown, conditions, target)
--   * "MobAbilities": rule columns for per-mob rules (used when Mobs.ai_mode = CUSTOM)
--   * GameConfig mob_ai.enabled (BOOL, false) and mob_ai.scale (FLOAT, 1.0)
--
-- Matches what `prisma db push` produces for muditor packages/db/prisma/schema.prisma (verified with
-- `prisma migrate diff`). Purely additive and idempotent: every statement is guarded, so a second
-- run changes nothing and a database already touched by `db push` is left as is. With mob_ai.enabled
-- false (the default) the runtime behaves exactly as before.

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'MobAiMode') THEN
        CREATE TYPE "MobAiMode" AS ENUM ('CLASS', 'CUSTOM', 'NONE');
    END IF;
END
$$;

ALTER TABLE "Mobs"
    ADD COLUMN IF NOT EXISTS "ai_mode" "MobAiMode" NOT NULL DEFAULT 'CLASS';

ALTER TABLE "MobAbilities"
    ADD COLUMN IF NOT EXISTS "chance_pct" INTEGER NOT NULL DEFAULT 100,
    ADD COLUMN IF NOT EXISTS "conditions" JSONB,
    ADD COLUMN IF NOT EXISTS "cooldown_s" INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS "priority" INTEGER NOT NULL DEFAULT 100,
    ADD COLUMN IF NOT EXISTS "target" TEXT;

CREATE TABLE IF NOT EXISTS "ClassAiRules" (
    "id" SERIAL NOT NULL,
    "class_id" INTEGER NOT NULL,
    "ability_id" INTEGER NOT NULL,
    "priority" INTEGER NOT NULL,
    "chance_pct" INTEGER NOT NULL DEFAULT 100,
    "cooldown_s" INTEGER NOT NULL DEFAULT 0,
    "conditions" JSONB,
    "target" TEXT NOT NULL,
    "min_level" INTEGER,
    "enabled" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "ClassAiRules_pkey" PRIMARY KEY ("id")
);

CREATE INDEX IF NOT EXISTS "ClassAiRules_class_id_idx" ON "ClassAiRules"("class_id");

CREATE UNIQUE INDEX IF NOT EXISTS "ClassAiRules_class_id_ability_id_priority_key"
    ON "ClassAiRules"("class_id", "ability_id", "priority");

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ClassAiRules_class_id_fkey') THEN
        ALTER TABLE "ClassAiRules" ADD CONSTRAINT "ClassAiRules_class_id_fkey"
            FOREIGN KEY ("class_id") REFERENCES "Class"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ClassAiRules_ability_id_fkey') THEN
        ALTER TABLE "ClassAiRules" ADD CONSTRAINT "ClassAiRules_ability_id_fkey"
            FOREIGN KEY ("ability_id") REFERENCES "Ability"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END
$$;

-- Master switch and global scale knob. Existing rows (builder edits) are never overwritten.
INSERT INTO "GameConfig" (category, key, value, value_type, description, updated_at)
VALUES
    ('mob_ai', 'enabled', 'false', 'BOOL',
     'Mob spellcasting / skill AI master switch. Off: mobs only melee, spawn is unchanged.', now()),
    ('mob_ai', 'scale', '1.0', 'FLOAT',
     'Multiplier on mob AI rule chance and frequency (1.0 = as authored).', now())
ON CONFLICT (category, key) DO NOTHING;
