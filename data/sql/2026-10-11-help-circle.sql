-- `help circle` (playtest 2026-10-11 #36) showed a jumbled two-column druid spell table
-- with "Category: race". That entry (keywords circle, 1, circle, 6) is a stray fragment of
-- the druid spell list in legacy help.hlp: its first line is the table header
-- "&4&bCircle 1&0   &4&bCircle 6&0", which the importer read as keywords. The real list is
-- the SPELL_DRUID article. fierylib's help parser now skips such entries.
--
--  * Delete the fragment (matched on its exact keywords, title and category).
--  * Let `help circle` find the assassin Circle skill article (keywords: circle_skill).
--
-- Idempotent: the DELETE matches nothing once the row is gone, and the UPDATE only fires
-- while the keyword is missing, so a second run changes 0 rows.
DELETE FROM "HelpEntry"
 WHERE keywords = ARRAY['circle', '1', 'circle', '6']::text[]
   AND title = 'Circle'
   AND category = 'race';

UPDATE "HelpEntry"
   SET keywords = array_append(keywords, 'circle'), updated_at = now()
 WHERE keywords = ARRAY['circle_skill']::text[]
   AND title = 'Circle Skill';
