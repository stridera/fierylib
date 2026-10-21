-- fierymud-rs #175 / #176 follow-up: the kick and bash help entries said the lag blocks every command "including
-- fleeing" and that a bash knockdown lasts "a few rounds". In fact each is a per-skill cooldown (kick 6 s, bash 8 s)
-- that only refuses that same skill; the bash victim is simply left sitting.
--
-- The HelpEntry rows come from the legacy help.hlp import (no file under fierylib/data holds them), so this patch is
-- the committed record. It SETs the full new body, keyed by keyword ({kick}, {bash}), so it does not depend on the
-- wording a given database currently holds (dev and prod differ).
--
-- Idempotent: a row is only rewritten while its content differs from the new body, so a second run changes 0 rows.
-- Note this replaces the whole body (including the Usage/Classes header): re-edits made in Muditor before this patch
-- are overwritten once; later edits survive only until this file is re-run, so do not re-run it after editing.

BEGIN;

UPDATE "HelpEntry"
SET content = $help$================================================
Usage      : kick <victim>
Aggressive : yes
Classes    : Anti-Paladin   Level 1
           : Assassin       Level 10
           : Berserker      Level 1
           : Mercenary      Level 1
           : Monk           Level 1
           : Paladin        Level 1
           : Ranger         Level 1
           : Warrior        Level 1
================================================
 
KICK is one of the most basic actions available to neophyte warriors. It 
may not be the best tool in a fighter's arsenal, but it's a reliable 
classic. The success of a KICK is calculated just like any other regular 
attack. The higher your skill level, the more damage you do when you 
connect. There is one small catch -- whenever you KICK (or miss) you
cannot KICK again for 6 seconds, so use it wisely. The cooldown only
affects KICK: you can still fight, flee, or use any other command or skill
while it runs.
 
See also: BASH, RESCUE$help$,
    updated_at = now()
WHERE keywords = ARRAY['kick']
  AND content IS DISTINCT FROM $help$================================================
Usage      : kick <victim>
Aggressive : yes
Classes    : Anti-Paladin   Level 1
           : Assassin       Level 10
           : Berserker      Level 1
           : Mercenary      Level 1
           : Monk           Level 1
           : Paladin        Level 1
           : Ranger         Level 1
           : Warrior        Level 1
================================================
 
KICK is one of the most basic actions available to neophyte warriors. It 
may not be the best tool in a fighter's arsenal, but it's a reliable 
classic. The success of a KICK is calculated just like any other regular 
attack. The higher your skill level, the more damage you do when you 
connect. There is one small catch -- whenever you KICK (or miss) you
cannot KICK again for 6 seconds, so use it wisely. The cooldown only
affects KICK: you can still fight, flee, or use any other command or skill
while it runs.
 
See also: BASH, RESCUE$help$;

UPDATE "HelpEntry"
SET content = $help$================================================
Usage      : bash [<victim>]
Aggressive : yes
Classes    : Anti-Paladin   Level 1
           : Mercenary      Level 1
           : Paladin        Level 1
           : Ranger         Level 1
           : Warrior        Level 1
================================================
 
BASH is an attempt to use a shield to knock that person over. The 
success of a BASH depends upon how experienced you are. If you 
succeed, you will inflict minor damage, and cause the victim to fall on 
its rear. The victim is left sitting and must get back on its
feet. If you miss, you lose your balance and fall and 
suffer similar penalties from being in the prone position.
 
BASH relies on wearing a shield to work. Wielding a two-handed weapon 
will allow a character to BASH a target, albeit with a very reduced 
success rate. Although it is possible to BASH a target while not wearing 
a shield or two-handed weapon, it is extremely unlikely to succeed.
 
Regardless of success or failure, BASH has an 8 second cooldown: you
cannot BASH again until it has passed. The cooldown only affects BASH, so
you can still fight, flee, or use any other command or skill meanwhile.
 
Note that bashing a person who is resting/sitting will inflict more 
damage. A successful BASH will stop someone from casting a spell.
 
You can only BASH a mob within one size category of yourself. Dragons are 
immune to bashing.
 
Some races and classes have similar skills. Large races, such as 
barbarians, ogres, and trolls, have BODYSLAM. Monks have SPRINGLEAP.
 
See also: KICK, RESCUE, FLEE, BODYSLAM, SPRINGLEAP$help$,
    updated_at = now()
WHERE keywords = ARRAY['bash']
  AND content IS DISTINCT FROM $help$================================================
Usage      : bash [<victim>]
Aggressive : yes
Classes    : Anti-Paladin   Level 1
           : Mercenary      Level 1
           : Paladin        Level 1
           : Ranger         Level 1
           : Warrior        Level 1
================================================
 
BASH is an attempt to use a shield to knock that person over. The 
success of a BASH depends upon how experienced you are. If you 
succeed, you will inflict minor damage, and cause the victim to fall on 
its rear. The victim is left sitting and must get back on its
feet. If you miss, you lose your balance and fall and 
suffer similar penalties from being in the prone position.
 
BASH relies on wearing a shield to work. Wielding a two-handed weapon 
will allow a character to BASH a target, albeit with a very reduced 
success rate. Although it is possible to BASH a target while not wearing 
a shield or two-handed weapon, it is extremely unlikely to succeed.
 
Regardless of success or failure, BASH has an 8 second cooldown: you
cannot BASH again until it has passed. The cooldown only affects BASH, so
you can still fight, flee, or use any other command or skill meanwhile.
 
Note that bashing a person who is resting/sitting will inflict more 
damage. A successful BASH will stop someone from casting a spell.
 
You can only BASH a mob within one size category of yourself. Dragons are 
immune to bashing.
 
Some races and classes have similar skills. Large races, such as 
barbarians, ogres, and trolls, have BODYSLAM. Monks have SPRINGLEAP.
 
See also: KICK, RESCUE, FLEE, BODYSLAM, SPRINGLEAP$help$;

COMMIT;
