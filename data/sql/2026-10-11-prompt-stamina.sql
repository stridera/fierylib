-- One word for the stamina resource (playtest 2026-10-11 #76): the prompt said "mv" while
-- score and greport say Stamina/stamina. The short prompt form is now "st".
--
--  * Characters.prompt: rows still holding the old seeded default become the new default.
--    Prompts a player wrote or changed are left alone.
--  * Characters.prompt column default: new characters get the new form. (The Prisma schema
--    default in muditor must change to match, or `db push` will put "mv" back.)
--  * GameConfig display.prompt_templates: the ready-made `prompt list` presets say "st".
--
-- Idempotent: every statement is guarded on the old text, so a second run changes 0 rows.
UPDATE "Characters"
   SET prompt = '<%h/%Hhp %v/%Vst>'
 WHERE prompt = '<%h/%Hhp %v/%Vmv>';

ALTER TABLE "Characters" ALTER COLUMN prompt SET DEFAULT '<%h/%Hhp %v/%Vst>';

UPDATE "GameConfig"
   SET value = replace(value, '%V mv', '%V st'), updated_at = now()
 WHERE category = 'display'
   AND key = 'prompt_templates'
   AND value LIKE '%\%V mv%';
