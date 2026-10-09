-- Characters.command_grants: per-character command grants and revokes (legacy `grant`,
-- `revoke`, `ungrant`). A grant lets a character use one command above their rank; a revoke
-- takes away a command they would otherwise have. JSON shape:
--   { "grants":  [ { "command": "goto", "grantor": "Strider", "level": 104 } ],
--     "revokes": [ ... ] }
-- `level` is the grantor's level; a lower-level staffer cannot undo an entry placed by a higher
-- one. NULL means no grants or revokes (every existing character).
--
-- Idempotent. ADD COLUMN keeps the existing table owner, so no ownership change is needed.
-- Type matches Prisma's Json? (jsonb).
ALTER TABLE "Characters" ADD COLUMN IF NOT EXISTS command_grants JSONB;

-- GameConfig grants.mortal_allowlist: the commands a mortal (effective role Player) may hold a
-- grant for. A JSON array of command names; EMPTY by default, so `grant` refuses every command
-- for a mortal until an operator lists one. Even when listed, a command with a required
-- permission, a rank above immortal, or one of grant/revoke/ungrant is never honoured for a
-- mortal. Checked on every use, not just when the grant is made. Staff grants are honoured only
-- while the holder is still staff. Inserted only when missing (an edited list is kept).
INSERT INTO "GameConfig" ("category", "key", "value", "value_type", "description", "updated_at")
VALUES ('grants', 'mortal_allowlist', '[]', 'JSON'::"ConfigValueType",
        'Command names a mortal may be granted (JSON array). Empty = mortals cannot hold grants', CURRENT_TIMESTAMP)
ON CONFLICT ("category", "key") DO NOTHING;
