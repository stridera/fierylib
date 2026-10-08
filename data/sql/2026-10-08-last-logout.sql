-- Characters.last_logout: stamped when a session ENDS (quit/rent/camp/idle kick/linkdead
-- retirement/shutdown). Rested-XP (repose) offline accrual measures from this column; the old
-- source, last_login, is stamped at session START, so time spent playing counted as rest.
-- NULL (never logged out since this patch) means "grant no repose".
--
-- Idempotent. ADD COLUMN keeps the existing table owner, so no ownership change is needed.
-- Type matches Prisma's DateTime? (timestamp(3) without time zone), same as last_login.
ALTER TABLE "Characters" ADD COLUMN IF NOT EXISTS last_logout TIMESTAMP(3);
