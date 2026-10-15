-- `effects` is a read-only info command: allow it mid-cast (playtest r12 F6).
-- Idempotent. Existing rows keep their flag when the seeder reruns, so this updates them directly.
UPDATE "Command" SET allowed_while_casting = true WHERE name = 'effects' AND allowed_while_casting = false;
