-- Text fixes from the 2026-10-11 playtest (#3, #10, #34, #39). Every UPDATE is guarded on the old
-- text, so a builder-edited row is left alone and a second run changes 0 rows.
--
--  * Socials: "fiercly" -> "fiercely" (slap, glomp); every targeted social answers a missing
--    target with one message instead of ~150 one-offs (some with a double space).
--  * 30:7 "continues on the the west", 30:111 "bends the the north": doubled word fixed.
--  * 30:32 bag: "possesions" -> "possessions".
--  * help bash: "knock someone over that person over" -> "knock that person over".
--  * help magic (HelpEntry 246): casting time is "several seconds, depending on the spell".

BEGIN;

UPDATE "Social" SET
  char_no_arg = replace(char_no_arg, 'fiercly', 'fiercely'),
  others_no_arg = replace(others_no_arg, 'fiercly', 'fiercely'),
  char_found = replace(char_found, 'fiercly', 'fiercely'),
  others_found = replace(others_found, 'fiercly', 'fiercely'),
  vict_found = replace(vict_found, 'fiercly', 'fiercely'),
  not_found = replace(not_found, 'fiercly', 'fiercely'),
  char_auto = replace(char_auto, 'fiercly', 'fiercely'),
  others_auto = replace(others_auto, 'fiercly', 'fiercely'),
  updated_at = now()
WHERE concat_ws(' ', char_no_arg, others_no_arg, char_found, others_found, vict_found, not_found, char_auto, others_auto)
      LIKE '%fiercly%';

UPDATE "Social" s
SET not_found = $nf$You don't see anyone like that here.$nf$, updated_at = now()
FROM (VALUES
  ('accuse', $nf$Accuse somebody who's not even there??$nf$),
  ('agree', $nf$Agree with who?$nf$),
  ('amaze', $nf$Amaze who?$nf$),
  ('apologize', $nf$You don't need to apologize to that person.$nf$),
  ('ayt', $nf$No, that person isn't home.$nf$),
  ('bang', $nf$No one to bang, sorry.$nf$),
  ('bark', $nf$You bark in vain, not present.$nf$),
  ('beckon', $nf$There's nobody like that around.$nf$),
  ('beer', $nf$Drink it yourself dude, that person isn't here.$nf$),
  ('beg', $nf$They can't hear you begging.$nf$),
  ('bird', $nf$Birdie crashed. No target found.$nf$),
  ('bite', $nf$Bite... huh?$nf$),
  ('bleed', $nf$Keep your blood.$nf$),
  ('blink', $nf$Aw... you should be able to believe THAT person.$nf$),
  ('blush', $nf$You are you embarrased by?$nf$),
  ('boggle', $nf$You would if that person were here.$nf$),
  ('bonk', $nf$Bonk... oops, where'd they go?$nf$),
  ('bounce', $nf$Boing!$nf$),
  ('bow', $nf$Who's that?$nf$),
  ('burp', $nf$Who?$nf$),
  ('cackle', $nf$Cackle at someone who's here.$nf$),
  ('cheer', $nf$Can't cheer for someone who's not here.$nf$),
  ('choke', $nf$ERROR: Choke victim not found.$nf$),
  ('chuckle', $nf$You feel silly, chuckling at no one.$nf$),
  ('comb', $nf$That person is not here.$nf$),
  ('comfort', $nf$Comfort who?$nf$),
  ('cough', $nf$Are you sure you want to cough at them?$nf$),
  ('cringe', $nf$I don't see anyone by that name here... what are you afraid of?$nf$),
  ('cry', $nf$Who's that?$nf$),
  ('cuddle', $nf$They aren't here.$nf$),
  ('curtsey', $nf$There's nobody like that here.$nf$),
  ('dance', $nf$Eh, WHO?$nf$),
  ('dream', $nf$Dream indeed, that person is not here.$nf$),
  ('drool', $nf$Pardon??$nf$),
  ('duh', $nf$Duh! Nobody's home.$nf$),
  ('embrace', $nf$Alas, your embracee is not here.  $nf$),
  ('envy', $nf$WHO?$nf$),
  ('eyebrow', $nf$Sorry, that Spock imitation won't do.$nf$),
  ('fart', $nf$The fumes roam around the room, looking for them.$nf$),
  ('flex', $nf$Flex away... nobody's watching by that name.$nf$),
  ('flirt', $nf$Sorry, your dearly beloved is not around.$nf$),
  ('fondle', $nf$You fondly try to fondle someone not in the room, but who cares.$nf$),
  ('fool', $nf$Looks like you're the fool...  no one's here by that name.$nf$),
  ('french', $nf$Your heart is filled with despair as that person is not here.$nf$),
  ('fume', $nf$Fume away... that person isn't here.$nf$),
  ('gag', $nf$Gag... oops not present.$nf$),
  ('gape', $nf$Gape away... you'll never figure that one out.$nf$),
  ('giggle', $nf$They can't hear you giggling.$nf$),
  ('glare', $nf$You try to glare at somebody who is not present.$nf$),
  ('glomp', $nf$Who's that?$nf$),
  ('glower', $nf$Glower at who?$nf$),
  ('greet', $nf$Please -- try someone who is here?$nf$),
  ('grin', $nf$You grin at nothing.$nf$),
  ('groan', $nf$You groan loudly to yourself.$nf$),
  ('grope', $nf$Try someone who's here.$nf$),
  ('grovel', $nf$Who?$nf$),
  ('growl', $nf$You growl loudly at no one.$nf$),
  ('grumble', $nf$Grumble away, no one is here by that name.$nf$),
  ('hi5', $nf$You wave your hand in the air... who's that?$nf$),
  ('hiss', $nf$Pffft... hiss where?$nf$),
  ('hug', $nf$Sorry, friend, I can't see that person here.$nf$),
  ('hunger', $nf$Starvation sets in, making you blubber.$nf$),
  ('imitate', $nf$You feel stupid imitating someone that's not here.$nf$),
  ('impale', $nf$You impale yourself, looking for that person.$nf$),
  ('kiss', $nf$Never around when required.$nf$),
  ('laugh', $nf$They're not worth laughing about.$nf$),
  ('lean', $nf$You lean over and fall to the ground looking for them.$nf$),
  ('lick', $nf$Lick away, nobody's here with that name.$nf$),
  ('love', $nf$Alas, your love is not present...$nf$),
  ('massage', $nf$You can only massage someone in the same room as you.$nf$),
  ('moan', $nf$They can't hear you moaning.$nf$),
  ('moon', $nf$That person isn't watching at the moment.$nf$),
  ('mosh', $nf$Must've died in the mosh pit, find someone else.$nf$),
  ('mutter', $nf$Mutter away...$nf$),
  ('nap', $nf$That person doesn't need sleep.$nf$),
  ('nibble', $nf$Sorry, not here, better go back to dreaming about it.$nf$),
  ('nod', $nf$You agree.  They're not here.$nf$),
  ('nog', $nf$Nog at who??$nf$),
  ('noogie', $nf$Noogie victim not found.$nf$),
  ('nudge', $nf$Eh?  That person isn't here, you know.$nf$),
  ('nuzzle', $nf$No... nobody here by that name...$nf$),
  ('panic', $nf$Panic about someone who is here.$nf$),
  ('pant', $nf$Sorry, that would be a waste of breath.$nf$),
  ('pat', $nf$Who, where, what??$nf$),
  ('peer', $nf$You didn't find them.$nf$),
  ('pet', $nf$You can't pet THAT person.$nf$),
  ('point', $nf$You must have a VERY long index-finger...$nf$),
  ('poke', $nf$You can't poke someone who's not here!$nf$),
  ('ponder', $nf$Ponder at someone who's HERE.$nf$),
  ('pounce', $nf$Your prey escapes!$nf$),
  ('pray', $nf$No such person around; your prayers vanish into the endless voids.$nf$),
  ('protect', $nf$Sorry, that person doesn't need protection.$nf$),
  ('puke', $nf$Your jetstream of puke misses.$nf$),
  ('punch', $nf$Punch who?$nf$),
  ('ready', $nf$That person doesn't really care if you're ready or not.$nf$),
  ('roar', $nf$That person isn't here.$nf$),
  ('rofl', $nf$Laughing at your imaginary friend again?$nf$),
  ('roll', $nf$Um... who?$nf$),
  ('ruffle', $nf$Might be a bit difficult.$nf$),
  ('salute', $nf$You snap to attention and realize that person isn't here.$nf$),
  ('scare', $nf$That person left already because you're so scary.$nf$),
  ('scold', $nf$You cannot scold somebody who is not here.$nf$),
  ('scratch', $nf$You scratch your drug-induced imaginary friend's back.$nf$),
  ('seduce', $nf$Sorry, that person isn't interested.$nf$),
  ('shake', $nf$Sorry good buddy, but that person doesn't seem to be here.$nf$),
  ('shudder', $nf$That person can't make you nervous!$nf$),
  ('slap', $nf$How about slapping someone in the same room as you??$nf$),
  ('slobber', $nf$You should save your saliva for somebody who is here.$nf$),
  ('smell', $nf$You can't smell that far!$nf$),
  ('smile', $nf$There's no one by that name around.$nf$),
  ('snarl', $nf$Eh?  Who?  Not here, my friend.$nf$),
  ('sneeze', $nf$You block your nose and your head explodes.$nf$),
  ('snicker', $nf$Wrongo!$nf$),
  ('snoogie', $nf$That person isn't here to receive it.$nf$),
  ('snowball', $nf$You stand with the snowball in your hand because your victim is not here.$nf$),
  ('snuggle', $nf$They aren't here.$nf$),
  ('spam', $nf$Spew all you want, it can't affect that person.$nf$),
  ('spank', $nf$Are you sure about this?  I mean, that person isn't even here!$nf$),
  ('spit', $nf$Can you spit that far?$nf$),
  ('squeeze', $nf$Where, what, how, WHO???$nf$),
  ('stare', $nf$You stare and stare but can't see that person anywhere...$nf$),
  ('stomp', $nf$Toes specified not found in current room.$nf$),
  ('stroke', $nf$That person is not within reach.$nf$),
  ('strut', $nf$You strut for an empty audience.$nf$),
  ('swat', $nf$Swat! That bug is already dead!$nf$),
  ('tackle', $nf$You missed.$nf$),
  ('tango', $nf$That person isn't around.  Better sit this one out.$nf$),
  ('tap', $nf$Tap, tap, tap... who?$nf$),
  ('taunt', $nf$Hmmmmmmm.....nope, no one by that name here.$nf$),
  ('tease', $nf$It is really difficult to tease somebody who is not here.$nf$),
  ('thank', $nf$No one answers to that name here.$nf$),
  ('think', $nf$You'd better think harder, if you hope to make contact!$nf$),
  ('thirst', $nf$You die of thirst looking for that person.$nf$),
  ('tickle', $nf$Who is that??$nf$),
  ('tip', $nf$You tip over looking for them.$nf$),
  ('tongue', $nf$Your tongue searches in vain.$nf$),
  ('trip', $nf$Whatever...$nf$),
  ('tug', $nf$You cant tug on someone who's not here.$nf$),
  ('twibble', $nf$Once, upon a time, there lived a bug called Twibble. Every spring he...$nf$),
  ('twitch', $nf$What? Who?$nf$),
  ('veto', $nf$Veto overridden, loser!$nf$),
  ('wave', $nf$They didn't wait for you to wave goodbye.$nf$),
  ('wet', $nf$Wet what?$nf$),
  ('whap', $nf$You whap yourself in the nuts, looking for that person.$nf$),
  ('whatever', $nf$That person can't make you upset.$nf$),
  ('whistle', $nf$You blew yer whistle.$nf$),
  ('wink', $nf$No one with that name is present.$nf$),
  ('worship', $nf$They're not here you crazy zealot.$nf$),
  ('yawn', $nf$You can't yawn THAT loudly!$nf$),
  ('yodel', $nf$Yodel away - nobody's listening.$nf$)
) AS v(name, old_not_found)
WHERE s.name = v.name
  AND s.not_found = v.old_not_found;

UPDATE "Room"
SET room_description = replace(room_description, 'continues on the the west', 'continues to the west'),
    plain_room_description = replace(plain_room_description, 'continues on the the west', 'continues to the west'),
    updated_at = now()
WHERE zone_id = 30 AND id = 7 AND room_description LIKE '%continues on the the west%';

UPDATE "Room"
SET room_description = replace(room_description, 'bends the the north', 'bends to the north'),
    plain_room_description = replace(plain_room_description, 'bends the the north', 'bends to the north'),
    updated_at = now()
WHERE zone_id = 30 AND id = 111 AND room_description LIKE '%bends the the north%';

UPDATE "Objects"
SET examine_description = replace(examine_description, 'possesions', 'possessions'),
    plain_examine_description = replace(plain_examine_description, 'possesions', 'possessions'),
    updated_at = now()
WHERE zone_id = 30 AND id = 32 AND examine_description LIKE '%possesions%';

UPDATE "HelpEntry"
SET content = replace(
      content,
      E'knock someone over that person \nover. The success',
      E'knock that person over. The \nsuccess'),
    updated_at = now()
WHERE 'bash' = ANY(keywords)
  AND content LIKE E'%knock someone over that person \nover. The success%';

UPDATE "HelpEntry"
SET content = replace(
      content,
      $h$Casting takes a few seconds ("You begin casting... about 3s"). "abort"$h$,
      $h$Casting takes several seconds, depending on the spell. "abort"$h$),
    updated_at = now()
WHERE keywords @> ARRAY['magic']
  AND content LIKE '%Casting takes a few seconds ("You begin casting... about 3s")%';

COMMIT;
