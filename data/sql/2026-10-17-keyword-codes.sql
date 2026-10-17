-- Playtest r14 polish: legacy '&' colour codes in object keyword lists.
--
-- Keywords are for matching, not display; the importer now strips the codes (strip_keyword_codes).
-- Two rows were imported before that:
--   12:72 Fountain            {&0&4a,Small,Fountain&0}               -> {Small,Fountain}
--   12:5  Belt of GODLYNESS   {belt,godly,godlyness,&1NEVER_LET_A_MORTAL_KEEP&0}
--                                                                    -> {belt,godly,godlyness,NEVER_LET_A_MORTAL_KEEP}
-- A DB-wide scan found no other '&' in Objects, Mobs, ObjectExtraDescriptions or RoomExtraDescriptions keywords.
--
-- Guarded: a row is rewritten only while it still holds the exact imported keyword list, so anything
-- edited in Muditor since is left alone. Idempotent: a rerun matches nothing.
-- Objects load at boot, so the fix is live after the next fieryNT restart.

BEGIN;

UPDATE "Objects"
SET keywords = ARRAY['Small','Fountain']::text[], updated_at = now()
WHERE zone_id = 12 AND id = 72
  AND keywords = ARRAY['&0&4a','Small','Fountain&0']::text[];

UPDATE "Objects"
SET keywords = ARRAY['belt','godly','godlyness','NEVER_LET_A_MORTAL_KEEP']::text[], updated_at = now()
WHERE zone_id = 12 AND id = 5
  AND keywords = ARRAY['belt','godly','godlyness','&1NEVER_LET_A_MORTAL_KEEP&0']::text[];

COMMIT;
