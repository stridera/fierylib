---
keywords: [quest, quests, qaccept, questinfo, qreward, quest-guide]
title: Quests
category: guide
min_level: 0
usage: "quests | questinfo {zone} {id} | qaccept {zone} {id} | abandon {#} | qreward"
---
Quests give you goals and rewards. Most are handed out by creatures and
people you meet in the world.

GETTING A QUEST
  Talk to NPCs with "say" or "ask {mob} {topic}". When you hit a keyword
  they respond to, a conversation starts and may offer you a quest. Some
  quests begin on their own when you reach a level, pick up an item, enter
  a room or use a skill; you are told when that happens. Quests that you
  accept by hand use their zone and id numbers:

    questinfo 30 12    read a quest's level range, flags and description
    qaccept 30 12      accept it

  qaccept refuses if your level is outside the quest's range, a required
  quest is unfinished, you already have it (or finished a quest that can't
  be repeated), it is on cooldown, or it conflicts with another quest you
  hold from the same exclusive group.

TRACKING PROGRESS
  quests             (also qstat, qlist, questlog) list your quests.
                     In-progress quests come first, with their phases and
                     objectives. An arrow marks your current phase and a
                     check mark a finished one; counters such as [2/5]
                     show how far along an objective is. Completed and
                     abandoned quests are listed below.
  abandon {#}        drop an in-progress quest. The number is its position
                     in the in-progress list. It is kept in your history
                     as abandoned.

  Progress is counted automatically as you kill, collect, visit or talk
  to whatever an objective asks for.

REWARDS
  When the last objective is done the quest completes and its fixed rewards
  are granted. Some quests offer a choice (one pick per group):

    qreward                    list choices you haven't claimed yet
    qreward 30 12              list the choices for one quest
    qreward 30 12 7            claim reward number 7 from that list

See also: BOARDS (quest board), CHANNELS (qsay), GROUPS, NEWBIE.
