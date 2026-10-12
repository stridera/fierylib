-- Playtest round 5 N9: login screen text.
--   * The banner told new players to register on the website and never said
--     that typing a new name at the prompt creates a character in the game.
--   * The new-password prompt said "(6-20 characters)" but the server only
--     enforces a minimum of 6.
-- Guarded and idempotent: each UPDATE matches only a row that still holds the
-- old text, so a second run changes 0 rows.

UPDATE "LoginMessage"
SET message = replace(
      message,
      'New players: visit https://fierymud.org to register.',
      'New players: type a new character name to start one here.'),
    updated_at = now()
WHERE stage = 'WELCOME_BANNER'
  AND position('New players: visit https://fierymud.org to register.' in message) > 0;

UPDATE "LoginMessage"
SET message = replace(message, '(6-20 characters)', '(at least 6 characters)'),
    updated_at = now()
WHERE stage = 'CREATE_PASSWORD'
  AND position('(6-20 characters)' in message) > 0;
