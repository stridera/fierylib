-- Text fixes from the 2026-10-11 playtest (#3, #10, #34, #39). Every UPDATE is guarded on the old
-- text, so a builder-edited row is left alone and a second run changes 0 rows.
--
--  * Socials: "fiercly" -> "fiercely" (slap, glomp). The legacy not_found jokes are kept; only
--    defects are fixed (double spaces, trailing whitespace, capital/end punctuation: 7 rows). A row
--    holding the legacy text, or the generic "You don't see anyone like that here." an earlier
--    version of this patch wrote, is set to the cleaned legacy text; edited rows are left alone.
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
SET not_found = v.new_not_found, updated_at = now()
FROM (VALUES
  ('accuse', $nf$Accuse somebody who's not even there??$nf$, $nf$Accuse somebody who's not even there??$nf$),
  ('beg', $nf$They can't hear you begging.$nf$, $nf$They can't hear you begging.$nf$),
  ('bleed', $nf$Keep your blood.$nf$, $nf$Keep your blood.$nf$),
  ('blush', $nf$You are you embarrased by?$nf$, $nf$You are you embarrased by?$nf$),
  ('boggle', $nf$You would if that person were here.$nf$, $nf$You would if that person were here.$nf$),
  ('bounce', $nf$Boing!$nf$, $nf$Boing!$nf$),
  ('bow', $nf$Who's that?$nf$, $nf$Who's that?$nf$),
  ('burp', $nf$Who?$nf$, $nf$Who?$nf$),
  ('cackle', $nf$Cackle at someone who's here.$nf$, $nf$Cackle at someone who's here.$nf$),
  ('chuckle', $nf$You feel silly, chuckling at no one.$nf$, $nf$You feel silly, chuckling at no one.$nf$),
  ('comb', $nf$That person is not here.$nf$, $nf$That person is not here.$nf$),
  ('comfort', $nf$Comfort who?$nf$, $nf$Comfort who?$nf$),
  ('cough', $nf$Are you sure you want to cough at them?$nf$, $nf$Are you sure you want to cough at them?$nf$),
  ('cringe', $nf$I don't see anyone by that name here... what are you afraid of?$nf$, $nf$I don't see anyone by that name here... what are you afraid of?$nf$),
  ('cry', $nf$Who's that?$nf$, $nf$Who's that?$nf$),
  ('cuddle', $nf$They aren't here.$nf$, $nf$They aren't here.$nf$),
  ('curtsey', $nf$There's nobody like that here.$nf$, $nf$There's nobody like that here.$nf$),
  ('dance', $nf$Eh, WHO?$nf$, $nf$Eh, WHO?$nf$),
  ('drool', $nf$Pardon??$nf$, $nf$Pardon??$nf$),
  ('embrace', $nf$Alas, your embracee is not here.  $nf$, $nf$Alas, your embracee is not here.$nf$),
  ('eyebrow', $nf$Sorry, that Spock imitation won't do.$nf$, $nf$Sorry, that Spock imitation won't do.$nf$),
  ('fart', $nf$The fumes roam around the room, looking for them.$nf$, $nf$The fumes roam around the room, looking for them.$nf$),
  ('flirt', $nf$Sorry, your dearly beloved is not around.$nf$, $nf$Sorry, your dearly beloved is not around.$nf$),
  ('fondle', $nf$You fondly try to fondle someone not in the room, but who cares.$nf$, $nf$You fondly try to fondle someone not in the room, but who cares.$nf$),
  ('french', $nf$Your heart is filled with despair as that person is not here.$nf$, $nf$Your heart is filled with despair as that person is not here.$nf$),
  ('fume', $nf$Fume away... that person isn't here.$nf$, $nf$Fume away... that person isn't here.$nf$),
  ('giggle', $nf$They can't hear you giggling.$nf$, $nf$They can't hear you giggling.$nf$),
  ('glare', $nf$You try to glare at somebody who is not present.$nf$, $nf$You try to glare at somebody who is not present.$nf$),
  ('greet', $nf$Please -- try someone who is here?$nf$, $nf$Please -- try someone who is here?$nf$),
  ('grin', $nf$You grin at nothing.$nf$, $nf$You grin at nothing.$nf$),
  ('groan', $nf$You groan loudly to yourself.$nf$, $nf$You groan loudly to yourself.$nf$),
  ('grope', $nf$Try someone who's here.$nf$, $nf$Try someone who's here.$nf$),
  ('grovel', $nf$Who?$nf$, $nf$Who?$nf$),
  ('growl', $nf$You growl loudly at no one.$nf$, $nf$You growl loudly at no one.$nf$),
  ('hug', $nf$Sorry, friend, I can't see that person here.$nf$, $nf$Sorry, friend, I can't see that person here.$nf$),
  ('kiss', $nf$Never around when required.$nf$, $nf$Never around when required.$nf$),
  ('laugh', $nf$They're not worth laughing about.$nf$, $nf$They're not worth laughing about.$nf$),
  ('lick', $nf$Lick away, nobody's here with that name.$nf$, $nf$Lick away, nobody's here with that name.$nf$),
  ('love', $nf$Alas, your love is not present...$nf$, $nf$Alas, your love is not present...$nf$),
  ('massage', $nf$You can only massage someone in the same room as you.$nf$, $nf$You can only massage someone in the same room as you.$nf$),
  ('moan', $nf$They can't hear you moaning.$nf$, $nf$They can't hear you moaning.$nf$),
  ('nibble', $nf$Sorry, not here, better go back to dreaming about it.$nf$, $nf$Sorry, not here, better go back to dreaming about it.$nf$),
  ('nod', $nf$You agree.  They're not here.$nf$, $nf$You agree. They're not here.$nf$),
  ('nudge', $nf$Eh?  That person isn't here, you know.$nf$, $nf$Eh? That person isn't here, you know.$nf$),
  ('nuzzle', $nf$No... nobody here by that name...$nf$, $nf$No... nobody here by that name...$nf$),
  ('pat', $nf$Who, where, what??$nf$, $nf$Who, where, what??$nf$),
  ('peer', $nf$You didn't find them.$nf$, $nf$You didn't find them.$nf$),
  ('point', $nf$You must have a VERY long index-finger...$nf$, $nf$You must have a VERY long index-finger...$nf$),
  ('poke', $nf$You can't poke someone who's not here!$nf$, $nf$You can't poke someone who's not here!$nf$),
  ('ponder', $nf$Ponder at someone who's HERE.$nf$, $nf$Ponder at someone who's HERE.$nf$),
  ('pray', $nf$No such person around; your prayers vanish into the endless voids.$nf$, $nf$No such person around; your prayers vanish into the endless voids.$nf$),
  ('puke', $nf$Your jetstream of puke misses.$nf$, $nf$Your jetstream of puke misses.$nf$),
  ('punch', $nf$Punch who?$nf$, $nf$Punch who?$nf$),
  ('roll', $nf$Um... who?$nf$, $nf$Um... who?$nf$),
  ('ruffle', $nf$Might be a bit difficult.$nf$, $nf$Might be a bit difficult.$nf$),
  ('shake', $nf$Sorry good buddy, but that person doesn't seem to be here.$nf$, $nf$Sorry good buddy, but that person doesn't seem to be here.$nf$),
  ('slap', $nf$How about slapping someone in the same room as you??$nf$, $nf$How about slapping someone in the same room as you??$nf$),
  ('smile', $nf$There's no one by that name around.$nf$, $nf$There's no one by that name around.$nf$),
  ('snarl', $nf$Eh?  Who?  Not here, my friend.$nf$, $nf$Eh? Who? Not here, my friend.$nf$),
  ('sneeze', $nf$You block your nose and your head explodes.$nf$, $nf$You block your nose and your head explodes.$nf$),
  ('snicker', $nf$Wrongo!$nf$, $nf$Wrongo!$nf$),
  ('snowball', $nf$You stand with the snowball in your hand because your victim is not here.$nf$, $nf$You stand with the snowball in your hand because your victim is not here.$nf$),
  ('snuggle', $nf$They aren't here.$nf$, $nf$They aren't here.$nf$),
  ('spank', $nf$Are you sure about this?  I mean, that person isn't even here!$nf$, $nf$Are you sure about this? I mean, that person isn't even here!$nf$),
  ('spit', $nf$Can you spit that far?$nf$, $nf$Can you spit that far?$nf$),
  ('squeeze', $nf$Where, what, how, WHO???$nf$, $nf$Where, what, how, WHO???$nf$),
  ('stare', $nf$You stare and stare but can't see that person anywhere...$nf$, $nf$You stare and stare but can't see that person anywhere...$nf$),
  ('stroke', $nf$That person is not within reach.$nf$, $nf$That person is not within reach.$nf$),
  ('strut', $nf$You strut for an empty audience.$nf$, $nf$You strut for an empty audience.$nf$),
  ('tackle', $nf$You missed.$nf$, $nf$You missed.$nf$),
  ('tango', $nf$That person isn't around.  Better sit this one out.$nf$, $nf$That person isn't around. Better sit this one out.$nf$),
  ('taunt', $nf$Hmmmmmmm.....nope, no one by that name here.$nf$, $nf$Hmmmmmmm.....nope, no one by that name here.$nf$),
  ('thank', $nf$No one answers to that name here.$nf$, $nf$No one answers to that name here.$nf$),
  ('think', $nf$You'd better think harder, if you hope to make contact!$nf$, $nf$You'd better think harder, if you hope to make contact!$nf$),
  ('tickle', $nf$Who is that??$nf$, $nf$Who is that??$nf$),
  ('tip', $nf$You tip over looking for them.$nf$, $nf$You tip over looking for them.$nf$),
  ('tug', $nf$You cant tug on someone who's not here.$nf$, $nf$You cant tug on someone who's not here.$nf$),
  ('wave', $nf$They didn't wait for you to wave goodbye.$nf$, $nf$They didn't wait for you to wave goodbye.$nf$),
  ('whistle', $nf$You blew yer whistle.$nf$, $nf$You blew yer whistle.$nf$),
  ('wink', $nf$No one with that name is present.$nf$, $nf$No one with that name is present.$nf$),
  ('worship', $nf$They're not here you crazy zealot.$nf$, $nf$They're not here you crazy zealot.$nf$),
  ('yawn', $nf$You can't yawn THAT loudly!$nf$, $nf$You can't yawn THAT loudly!$nf$),
  ('yodel', $nf$Yodel away - nobody's listening.$nf$, $nf$Yodel away - nobody's listening.$nf$),
  ('beer', $nf$Drink it yourself dude, that person isn't here.$nf$, $nf$Drink it yourself dude, that person isn't here.$nf$),
  ('nog', $nf$Nog at who??$nf$, $nf$Nog at who??$nf$),
  ('agree', $nf$Agree with who?$nf$, $nf$Agree with who?$nf$),
  ('rofl', $nf$Laughing at your imaginary friend again?$nf$, $nf$Laughing at your imaginary friend again?$nf$),
  ('mutter', $nf$Mutter away...$nf$, $nf$Mutter away...$nf$),
  ('roar', $nf$That person isn't here.$nf$, $nf$That person isn't here.$nf$),
  ('noogie', $nf$Noogie victim not found.$nf$, $nf$Noogie victim not found.$nf$),
  ('bird', $nf$Birdie crashed. No target found.$nf$, $nf$Birdie crashed. No target found.$nf$),
  ('bang', $nf$No one to bang, sorry.$nf$, $nf$No one to bang, sorry.$nf$),
  ('bite', $nf$Bite... huh?$nf$, $nf$Bite... huh?$nf$),
  ('blink', $nf$Aw... you should be able to believe THAT person.$nf$, $nf$Aw... you should be able to believe THAT person.$nf$),
  ('bonk', $nf$Bonk... oops, where'd they go?$nf$, $nf$Bonk... oops, where'd they go?$nf$),
  ('cheer', $nf$Can't cheer for someone who's not here.$nf$, $nf$Can't cheer for someone who's not here.$nf$),
  ('duh', $nf$Duh! Nobody's home.$nf$, $nf$Duh! Nobody's home.$nf$),
  ('whap', $nf$You whap yourself in the nuts, looking for that person.$nf$, $nf$You whap yourself in the nuts, looking for that person.$nf$),
  ('flex', $nf$Flex away... nobody's watching by that name.$nf$, $nf$Flex away... nobody's watching by that name.$nf$),
  ('mosh', $nf$Must've died in the mosh pit, find someone else.$nf$, $nf$Must've died in the mosh pit, find someone else.$nf$),
  ('tongue', $nf$Your tongue searches in vain.$nf$, $nf$Your tongue searches in vain.$nf$),
  ('envy', $nf$WHO?$nf$, $nf$WHO?$nf$),
  ('eyebrow', $nf$Sorry, that Spock imitation won't do.$nf$, $nf$Sorry, that Spock imitation won't do.$nf$),
  ('gag', $nf$Gag... oops not present.$nf$, $nf$Gag... oops not present.$nf$),
  ('panic', $nf$Panic about someone who is here.$nf$, $nf$Panic about someone who is here.$nf$),
  ('hiss', $nf$Pffft... hiss where?$nf$, $nf$Pffft... hiss where?$nf$),
  ('fool', $nf$Looks like you're the fool...  no one's here by that name.$nf$, $nf$Looks like you're the fool... no one's here by that name.$nf$),
  ('hi5', $nf$You wave your hand in the air... who's that?$nf$, $nf$You wave your hand in the air... who's that?$nf$),
  ('gape', $nf$Gape away... you'll never figure that one out.$nf$, $nf$Gape away... you'll never figure that one out.$nf$),
  ('spam', $nf$Spew all you want, it can't affect that person.$nf$, $nf$Spew all you want, it can't affect that person.$nf$),
  ('scold', $nf$You cannot scold somebody who is not here.$nf$, $nf$You cannot scold somebody who is not here.$nf$),
  ('smell', $nf$You can't smell that far!$nf$, $nf$You can't smell that far!$nf$),
  ('pet', $nf$You can't pet THAT person.$nf$, $nf$You can't pet THAT person.$nf$),
  ('protect', $nf$Sorry, that person doesn't need protection.$nf$, $nf$Sorry, that person doesn't need protection.$nf$),
  ('salute', $nf$You snap to attention and realize that person isn't here.$nf$, $nf$You snap to attention and realize that person isn't here.$nf$),
  ('scratch', $nf$You scratch your drug-induced imaginary friend's back.$nf$, $nf$You scratch your drug-induced imaginary friend's back.$nf$),
  ('grumble', $nf$Grumble away, no one is here by that name.$nf$, $nf$Grumble away, no one is here by that name.$nf$),
  ('swat', $nf$Swat! That bug is already dead!$nf$, $nf$Swat! That bug is already dead!$nf$),
  ('ayt', $nf$No, that person isn't home.$nf$, $nf$No, that person isn't home.$nf$),
  ('veto', $nf$Veto overridden, loser!$nf$, $nf$Veto overridden, loser!$nf$),
  ('slobber', $nf$You should save your saliva for somebody who is here.$nf$, $nf$You should save your saliva for somebody who is here.$nf$),
  ('impale', $nf$You impale yourself, looking for that person.$nf$, $nf$You impale yourself, looking for that person.$nf$),
  ('stomp', $nf$Toes specified not found in current room.$nf$, $nf$Toes specified not found in current room.$nf$),
  ('pant', $nf$Sorry, that would be a waste of breath.$nf$, $nf$Sorry, that would be a waste of breath.$nf$),
  ('seduce', $nf$Sorry, that person isn't interested.$nf$, $nf$Sorry, that person isn't interested.$nf$),
  ('pounce', $nf$Your prey escapes!$nf$, $nf$Your prey escapes!$nf$),
  ('moon', $nf$That person isn't watching at the moment.$nf$, $nf$That person isn't watching at the moment.$nf$),
  ('shudder', $nf$That person can't make you nervous!$nf$, $nf$That person can't make you nervous!$nf$),
  ('lean', $nf$You lean over and fall to the ground looking for them.$nf$, $nf$You lean over and fall to the ground looking for them.$nf$),
  ('bark', $nf$You bark in vain, not present.$nf$, $nf$You bark in vain, not present.$nf$),
  ('snoogie', $nf$That person isn't here to receive it.$nf$, $nf$That person isn't here to receive it.$nf$),
  ('imitate', $nf$You feel stupid imitating someone that's not here.$nf$, $nf$You feel stupid imitating someone that's not here.$nf$),
  ('amaze', $nf$Amaze who?$nf$, $nf$Amaze who?$nf$),
  ('tap', $nf$Tap, tap, tap... who?$nf$, $nf$Tap, tap, tap... who?$nf$),
  ('twibble', $nf$Once, upon a time, there lived a bug called Twibble. Every spring he...$nf$, $nf$Once, upon a time, there lived a bug called Twibble. Every spring he...$nf$),
  ('wet', $nf$Wet what?$nf$, $nf$Wet what?$nf$),
  ('apologize', $nf$You don't need to apologize to that person.$nf$, $nf$You don't need to apologize to that person.$nf$),
  ('dream', $nf$Dream indeed, that person is not here.$nf$, $nf$Dream indeed, that person is not here.$nf$),
  ('whatever', $nf$That person can't make you upset.$nf$, $nf$That person can't make you upset.$nf$),
  ('trip', $nf$Whatever...$nf$, $nf$Whatever...$nf$),
  ('ready', $nf$That person doesn't really care if you're ready or not.$nf$, $nf$That person doesn't really care if you're ready or not.$nf$),
  ('hunger', $nf$Starvation sets in, making you blubber.$nf$, $nf$Starvation sets in, making you blubber.$nf$),
  ('thirst', $nf$You die of thirst looking for that person.$nf$, $nf$You die of thirst looking for that person.$nf$),
  ('tease', $nf$It is really difficult to tease somebody who is not here.$nf$, $nf$It is really difficult to tease somebody who is not here.$nf$),
  ('scare', $nf$That person left already because you're so scary.$nf$, $nf$That person left already because you're so scary.$nf$),
  ('nap', $nf$That person doesn't need sleep.$nf$, $nf$That person doesn't need sleep.$nf$),
  ('choke', $nf$ERROR: Choke victim not found.$nf$, $nf$ERROR: Choke victim not found.$nf$),
  ('glomp', $nf$Who's that?$nf$, $nf$Who's that?$nf$),
  ('twitch', $nf$What? Who?$nf$, $nf$What? Who?$nf$),
  ('beckon', $nf$There's nobody like that around.$nf$, $nf$There's nobody like that around.$nf$),
  ('glower', $nf$Glower at who?$nf$, $nf$Glower at who?$nf$)
) AS v(name, legacy_not_found, new_not_found)
WHERE s.name = v.name
  AND s.not_found IN (v.legacy_not_found, $nf$You don't see anyone like that here.$nf$)
  AND s.not_found IS DISTINCT FROM v.new_not_found;

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
