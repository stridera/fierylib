-- PLAIN_TELNET_NOTICE: one sentence per line (follow-up to fierymud-rs #49).
--
-- The row was seeded as a single paragraph with no line breaks. Rewrite it
-- with each sentence on its own line, but ONLY while it still equals the old
-- seeded text, so a builder's edit through Muditor survives.
--
-- Idempotent: after the first run the row no longer matches the old text,
-- so rerunning updates nothing.

BEGIN;

UPDATE "LoginMessage"
SET message = E'This connection is not encrypted.\r\nFor a secure connection use the TLS port {tls_port}.\r\nTo log in without sending a password, type `code` at the password prompt and approve it on the website.\r\n',
    updated_at = now()
WHERE stage = 'PLAIN_TELNET_NOTICE'
  AND variant = 'default'
  AND message = 'This connection is not encrypted. For a secure connection use the TLS port {tls_port}. To log in without sending a password, type `code` at the password prompt and approve it on the website.';

COMMIT;
