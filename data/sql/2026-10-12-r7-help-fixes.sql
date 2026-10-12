-- Playtest r7 help text fixes (#8 group, #29 quit, #32 sell). Each UPDATE is
-- keyed on a phrase from the old text, so an entry a builder has since
-- rewritten is left alone and a rerun updates nothing.
BEGIN;

UPDATE "HelpEntry"
SET content = replace(
      replace(
        content,
        E'A group is formed by\nfollowing: whoever you follow, directly or through a chain, is your group\nleader.',
        E'Following someone only\nmakes you trail them through exits; it does not put you in their group. A\ngroup is formed by invitation: the leader invites, the other player accepts.'),
      E'  follow Aria        trail Aria; when she moves through an exit, you do too.\n',
      E'  follow Aria        trail Aria; when she moves through an exit, you do too.\n                     You are not in her group until she invites you.\n'),
    updated_at = now()
WHERE 'group' = ANY(keywords)
  AND content LIKE '%A group is formed by%following:%';

UPDATE "HelpEntry"
SET content = E'When you get tired of playing, type QUIT to leave the game. Your character is\nsaved where you stand: your equipment, items and money stay with you, and\nwhen you enter the game again you come back to the same room.\n\nResting at an inn (RENT) is the same, except you return to the inn''s\nreception room.\n\nSee also: RENT, INN, CAMP',
    updated_at = now()
WHERE 'quit' = ANY(keywords)
  AND content LIKE '%Your equipment, items, and money will drop to the ground%';

UPDATE "HelpEntry"
SET content = replace(
      content,
      E'For now, shopkeepers seem uninterested in buying anything, including\nitems they have sold. Hopefully they will be more interested in the\nnear future!',
      E'  > sell all         (sell everything you carry that the shopkeeper wants)\n  > sell all.sword   (sell every sword you carry)\n\nA shopkeeper only buys the kinds of goods the shop deals in, and pays\nless than the asking price. VALUE tells you what the shopkeeper would\npay before you sell.'),
    updated_at = now()
WHERE 'sell' = ANY(keywords)
  AND content LIKE '%shopkeepers seem uninterested in buying anything%';

COMMIT;
