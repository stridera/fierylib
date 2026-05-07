-- Trigger: tattle_tail_guard_killer
-- Zone: 35, ID: 49
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #3549

-- Converted from DG Script #3549: tattle_tail_guard_killer
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- When this guild guard dies, force the killer to file a bug report.
actor:command("bug I HAVE KILLED A GUILD GUARD IN THIS ROOM!  TELL TANLE IMMEDIATELY IF YOU SEE THIS BUG REPORT.")