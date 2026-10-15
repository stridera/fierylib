---
keywords: [group, groups, grouping, party, invite]
title: Groups
category: guide
min_level: 0
usage: "follow {name} | invite {player} | group | gsay {message} | split {copper}"
---
Adventuring together is safer and shares the rewards. Following someone only
makes you trail them through exits; it does not put you in their group. A
group is formed by invitation: the leader invites, the other player accepts.

JOINING
  follow Aria        trail Aria; when she moves through an exit, you do too.
                     You are not in her group until she invites you.
  invite Aria        ask Aria to join your group. She answers with
                     "accept" or "decline". Invites expire after 5 minutes.
  accept / decline   answer an invite you have received.
  unfollow           stop following (follow self does the same).

RUNNING THE GROUP
  group              list the leader and members with HP and whether each
                     is in your room.
  dismiss {name}     remove a member who follows you directly.
  group dismiss {name}   the same thing.
  group {pet}        add your own charmed pet to the group, or remove it again.
  disband            dismiss everyone who follows you.
  order {name|all} {command}   give a command to your mob followers.

TALKING
  gsay {message}     speak to the whole group wherever they are (gtell, gt).
  greport            tell the group your HP and stamina.

SHARING
  Experience from a kill is split evenly between group members who are in
  the same room as the killer.
  split 5000         divide 5000 copper of your own coin between the group
                     members in your room.
  autogold           toggle: coin from your kills is collected for you.
  autosplit          toggle: with autogold on, that coin is split among
                     the group members in your room.
  autoassist         toggle: when the person you follow is attacked in
                     your room, you jump into the fight.
  gretreat           the whole group in your room flees together.

See also: CHANNELS, CONSENT, MAGIC (summon).
