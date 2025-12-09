# FieryMUD Spell Implementation Report

**Generated from**: magic.cpp (mag_affect function)
**Total spells extracted**: 128

---

## Summary

- **Spells**: 107
- **Chants**: 15
- **Songs**: 6

### Coverage

- Spells with duration formula: 115 (89.8%)
- Spells with effects: 102 (79.7%)
- Spells with messages: 120 (93.8%)
- Spells with requirements: 41 (32.0%)
- Spells with conflicts: 17 (13.3%)
- Spells with saving throws: 21 (16.4%)

---

## Detailed Spell Implementations

### CHANT_ARIA_OF_DISSONANCE

**Source**: `magic.cpp:3057-3068`

**Duration**:
- Formula: `5 + (skill / 30)`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Messages**:
- To victim: "$n fills your ears with an aria of dissonance, causing confusion!"
- To room: "$N winces as $n's dissonant song fills $S ears."
- To caster: "Your song of dissonance confuses $N!"

---

### CHANT_BATTLE_HYMN

**Source**: `magic.cpp:3070-3082`

**Duration**:
- Formula: `skill / 25 + 1`
- Effect 1: `skill / 25 + 1`

**Effects**:
- Effect slot 0:
  - **APPLY_skill / 25 + 1**: `HITROLL`
- Effect slot 1:
  - **APPLY_skill / 25 + 1**: `DAMROLL`

**Messages**:
- To victim: "Your heart beats with the rage of your fallen brothers."
- To room: "$n's chest swells with courage!"

---

### CHANT_BLIZZARDS_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2363-2384`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_ICEHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&4&bYou unleash the blizzard in your heart.&0"
- To room: "&4&b$N unleashes the blizzard in $S heart.&0"

---

### CHANT_FIRES_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2386-2407`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_FIREHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&1Your fists burn with inner fire.&0"
- To room: "&1$N's fists burn with inner fire.&0"

---

### CHANT_HYMN_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:1990-1997`

**Special Mechanics**:
- Conflicts with other monk hand spells

---

### CHANT_INTERMINABLE_WRATH

**Source**: `magic.cpp:3084-3089`

**Duration**:
- Formula: `(skill / 20)`

**Effects**:
- **Flag**: `EFF_WRATH`

**Messages**:
- To victim: "A feeling of unforgiving wrath fills you."
- To room: "$n bristles with anger."

---

### CHANT_REGENERATION

**Source**: `magic.cpp:3112-3118`

**Duration**:
- Formula: `skill / 2 + 3`

**Messages**:
- To victim: "You feel your health improve."
- To room: "$n looks a little healthier."

---

### CHANT_SEED_OF_DESTRUCTION

**Source**: `magic.cpp:3091-3110`

**Duration**:
- Formula: `(skill / 20)`
- Effect 1: `(skill / 20)`

**Effects**:
- Effect slot 0:
  - **APPLY_-(skill * GET_VIEWED_CON(victim) / 2) / 100**: `CON`
  - **Flag**: `EFF_DISEASE`
- Effect slot 1:
  - **APPLY_-(skill * GET_VIEWED_STR(victim) / 2) / 100**: `STR`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Messages**:
- To victim: "You feel your time in this world growing short..."
- To room: "$n plants the seed of destruction in $N's mind."
- To caster: "You force $N down the path to destruction..."

---

### CHANT_SHADOWS_SORROW_SONG

**Source**: `magic.cpp:3120-3142`

**Duration**:
- Formula: `5 + (skill / 14)`

**Special Mechanics**:
- Effect modifiers accumulate

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "$n's song of sorrow fills your mind with darkness and shadows."
- To room: "A dark look clouds $N's visage as $n sings $M a song of sorrow."
- To caster: "You depress $N with a song of darkness and sorrow!"

---

### CHANT_SONATA_OF_MALAISE

**Source**: `magic.cpp:3144-3165`

**Duration**:
- Formula: `eff[1].duration = eff[2].duration = eff[3].duration = eff[4].duration =

            1 + (skill / 20)`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Messages**:
- To victim: "Malaise fills the air, hampering your movements!"
- To room: "$N contorts $S face briefly in anger and fear."
- To caster: "You fill $N with a sense of malaise!"

---

### CHANT_SPIRIT_BEAR

**Source**: `magic.cpp:3192-3197`

**Duration**:
- Formula: `(skill / 20)`

**Effects**:
- **Flag**: `EFF_SPIRIT_BEAR`

**Messages**:
- To victim: "The spirit of the bear consumes your body."
- To room: "$n shifts $s weight, seeming heavier and more dangerous."

---

### CHANT_SPIRIT_WOLF

**Source**: `magic.cpp:3199-3204`

**Duration**:
- Formula: `(skill / 20)`

**Effects**:
- **Flag**: `EFF_SPIRIT_WOLF`

**Messages**:
- To victim: "You feel a wolf-like fury come over you."
- To room: "$n seems to take on a fearsome, wolf-like demeanor."

---

### CHANT_TEMPEST_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2409-2430`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_LIGHTNINGHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&6&bYour knuckles crackle with lightning.&0"
- To room: "&6&b$N's knuckles crackle with lightning.&0"

---

### CHANT_TREMORS_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2339-2361`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_ACIDHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&3&bYou charge your hands with corrosive chi.&0"
- To room: "&3&b$N charges $S hands with corrosive chi.&0"

---

### CHANT_WAR_CRY

**Source**: `magic.cpp:3206-3215`

**Duration**:
- Formula: `skill / 25 + 1`
- Effect 1: `skill / 25 + 1`

**Effects**:
- Effect slot 0:
  - **APPLY_skill / 25 + 1**: `HITROLL`
- Effect slot 1:
  - **APPLY_skill / 25 + 1**: `DAMROLL`

**Messages**:
- To victim: "You feel more determined than ever!"
- To room: "$N looks more determined than ever!"

---

### SONG_BALLAD_OF_TEARS

**Source**: `magic.cpp:3268-3302`

**Duration**:
- Formula: `eff[1].duration = eff[2].duration = eff[3].duration =

                skill / (15 - (GET_CHA(ch) / 10))`
- Effect 4: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 5: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 6: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 7: `skill / (15 - (GET_CHA(ch) / 10))`

**Effects**:
- Effect slot 4:
  - **APPLY_-(((skill + GET_CHA(ch)) / 4) * (GET_VIEWED_CON(victim) / 2)) / 100**: `CON`
- Effect slot 5:
  - **APPLY_-(((skill + GET_CHA(ch)) / 4) * (GET_VIEWED_STR(victim) / 2)) / 100**: `STR`
- Effect slot 6:
  - **APPLY_-(skill / (15 - (GET_CHA(ch) / 20)))**: `HITROLL`
- Effect slot 7:
  - **APPLY_-(skill / (15 - (GET_CHA(ch) / 20)))**: `DAMROLL`

**Conflicts With**:
- `SONG_INSPIRATION`
- `SONG_HEROIC_JOURNEY`

**Messages**:
- To victim: "Your spirit withers in terror and sorrow!"
- To room: "$N's spirit withers in terror and sorrow!"

---

### SONG_CROWN_OF_MADNESS

**Source**: `magic.cpp:2159-2179`

**Duration**:
- Formula: `5`

**Effects**:
- **APPLY_-50**: `WIS`
- **Flag**: `EFF_INSANITY`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_SPELL`

**Messages**:
- To victim: "&5You go out of your &bMIND!&0"
- To room: "&5$N's&5 psyche snaps... A crazed gleam fills $S eyes.&0"
- To caster: "You cause &5$N to snap... A crazed gleam fills $S eyes.&0"

---

### SONG_ENRAPTURE

**Source**: `magic.cpp:2226-2255`

**Duration**:
- Formula: `2`

**Effects**:
- **Flag**: `EFF_MESMERIZED`

**Requirements**:
- Cannot target NPCs

**Messages**:
- To victim: "$n shows you a truly fascinating puzzle.  You simply must work it out."
- To room: "$n &0&5w&4e&5av&4es a &5mesme&4rizing pa&5ttern before &0$N's eyes.\n"
- To caster: "You weave a mesmerizing pattern before $N, and $E seems to be utterly absorbed by it."

---

### SONG_INSPIRATION

**Source**: `magic.cpp:3219-3253`

**Duration**:
- Formula: `skill / (15 - (GET_CHA(ch) / 20))`
- Effect 1: `skill / (15 - (GET_CHA(ch) / 20))`
- Effect 2: `eff[3].duration = eff[4].duration = eff[5].duration = eff[6].duration =

                    eff[7].duration = skill / (15 - (GET_CHA(ch) / 20))`
- Effect 8: `skill / (15 - (GET_CHA(ch) / 20))`

**Effects**:
- Effect slot 0:
  - **APPLY_skill / (25 - (GET_CHA(ch) / 20))**: `HITROLL`
- Effect slot 1:
  - **APPLY_skill / (25 - (GET_CHA(ch) / 20))**: `DAMROLL`
- Effect slot 8:
  - **APPLY_(skill + (GET_CHA(ch)) * 2)**: `HIT`

**Conflicts With**:
- `SONG_TERROR`
- `SONG_BALLAD_OF_TEARS`

**Messages**:
- To victim: "Your spirit swells with inspiration!"
- To room: "$N's spirit stirs with inspiration!"

---

### SONG_SONG_OF_REST

**Source**: `magic.cpp:3255-3266`

**Duration**:
- Formula: `skill / (15 - (GET_CHA(ch) / 20))`

**Effects**:
- **Flag**: `EFF_SONG_OF_REST`

**Messages**:
- To victim: "$n sings you a gentle lullaby to help you rest."
- To room: "$n sings $N a gentle lullaby to help $M rest."
- To caster: "You sing $N a gentle lullaby to help $M rest.\n"

---

### SONG_TERROR

**Source**: `magic.cpp:3268-3302`

**Duration**:
- Formula: `eff[1].duration = eff[2].duration = eff[3].duration =

                skill / (15 - (GET_CHA(ch) / 10))`
- Effect 4: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 5: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 6: `skill / (15 - (GET_CHA(ch) / 10))`
- Effect 7: `skill / (15 - (GET_CHA(ch) / 10))`

**Effects**:
- Effect slot 4:
  - **APPLY_-(((skill + GET_CHA(ch)) / 4) * (GET_VIEWED_CON(victim) / 2)) / 100**: `CON`
- Effect slot 5:
  - **APPLY_-(((skill + GET_CHA(ch)) / 4) * (GET_VIEWED_STR(victim) / 2)) / 100**: `STR`
- Effect slot 6:
  - **APPLY_-(skill / (15 - (GET_CHA(ch) / 20)))**: `HITROLL`
- Effect slot 7:
  - **APPLY_-(skill / (15 - (GET_CHA(ch) / 20)))**: `DAMROLL`

**Conflicts With**:
- `SONG_INSPIRATION`
- `SONG_HEROIC_JOURNEY`

**Messages**:
- To victim: "Your spirit withers in terror and sorrow!"
- To room: "$N's spirit withers in terror and sorrow!"

---

### SPELL_ARMOR

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_GREATER_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_BARKSKIN

**Source**: `magic.cpp:1191-1200`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_BLESS

**Source**: `magic.cpp:1212-1257`

**Duration**:
- Formula: `10 + (skill / 7)`
- Effect 1: `eff[0].duration`
- Effect 2: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_-2 - (skill / 10)**: `SAVING_SPELL`
- Effect slot 1:
  - **APPLY_1 + (skill > 95)**: `DAMROLL`
- Effect slot 2:
  - **Flag**: `EFF_BLESS`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Requirements**:
- Alignment: Cannot target evil
- Alignment: Caster cannot be evil

**Messages**:
- To victim: "Your inner angel is inspired.\r\nYou feel righteous."
- To room: "$n is inspired to do good."
- To caster: "$N is inspired by your gods."

---

### SPELL_BLINDING_BEAUTY

**Source**: `magic.cpp:1259-1289`

**Duration**:
- Formula: `2`
- Effect 1: `2`

**Effects**:
- Effect slot 0:
  - **APPLY_-4**: `HITROLL`
  - **Flag**: `EFF_BLIND`
- Effect slot 1:
  - **APPLY_-40**: `AC`
  - **Flag**: `EFF_BLIND`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&9&bYou have been blinded!&0"
- To room: "&9&b$N&9&b is blinded by $n!&0"
- To caster: "&9&b$N&9&b is blinded by you!&0"

---

### SPELL_BLINDNESS

**Source**: `magic.cpp:1259-1289`

**Duration**:
- Formula: `2`
- Effect 1: `2`

**Effects**:
- Effect slot 0:
  - **APPLY_-4**: `HITROLL`
  - **Flag**: `EFF_BLIND`
- Effect slot 1:
  - **APPLY_-40**: `AC`
  - **Flag**: `EFF_BLIND`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&9&bYou have been blinded!&0"
- To room: "&9&b$N&9&b is blinded by $n!&0"
- To caster: "&9&b$N&9&b is blinded by you!&0"

---

### SPELL_BLIZZARDS_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2363-2384`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_ICEHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&4&bYou unleash the blizzard in your heart.&0"
- To room: "&4&b$N unleashes the blizzard in $S heart.&0"

---

### SPELL_BLUR

**Source**: `magic.cpp:1291-1297`

**Duration**:
- Formula: `2 + (skill / 21)`

**Effects**:
- **Flag**: `EFF_BLUR`

**Messages**:
- To victim: "&7The world seems to slow as you start moving with unnatural speed!&0"
- To room: "&7$N's image blurs in unnatural speed!&0"

---

### SPELL_BONE_ARMOR

**Source**: `magic.cpp:1299-1308`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_BONE_CAGE

**Source**: `magic.cpp:1319-1339`

**Duration**:
- Formula: `1`

**Effects**:
- **APPLY_4**: `NONE`
- **Flag**: `EFF_IMMOBILIZED`

**Requirements**:
- Cannot target NPCs

**Messages**:
- To victim: "$n conjures four magical bones which bind your legs!"
- To room: "$n conjures four magical bones that lock around $N's legs!"
- To caster: "You conjure four magical bones to lock $N in place!"

---

### SPELL_CHILL_TOUCH

**Source**: `magic.cpp:1350-1367`

**Duration**:
- Formula: `3 + (skill / 20)`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "You feel your strength wither!"
- To room: "$N withers slightly from $n's cold!"
- To caster: "$N is withered by your cold!"

---

### SPELL_CIRCLE_OF_LIGHT

**Source**: `magic.cpp:1369-1375`

**Duration**:
- Formula: `5 + (skill / 2)`

**Effects**:
- **Flag**: `EFF_LIGHT`

**Messages**:
- To victim: "&7&bA bright white circle of light begins hovering about your head.&0"
- To room: "&7&bA bright white circle of light appears over $N's&7&b head."

---

### SPELL_CLARITY

**Source**: `magic.cpp:1341-1348`

**Duration**:
- Formula: `10 + (skill / 10)`

**Effects**:
- **APPLY_(1 + (skill > 95)) * 10**: `FOCUS`

**Messages**:
- To victim: "You feel more clear-headed."
- To room: "$N looks more clear-headed."
- To caster: "You feel more clear-headed."

---

### SPELL_COLDSHIELD

**Source**: `magic.cpp:1377-1390`

**Duration**:
- Formula: `skill / 20`

**Effects**:
- **Flag**: `EFF_COLDSHIELD`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&4A jagged formation of i&bc&7e sh&4ard&0&4s forms around you.&0"
- To room: "&4A jagged formation of i&bc&7e sh&4ard&0&4s forms around $N&0&4.&0"

---

### SPELL_CONFUSION

**Source**: `magic.cpp:1392-1408`

**Duration**:
- Formula: `2 + skill / 40`

**Effects**:
- **Flag**: `EFF_CONFUSION`

**Special Mechanics**:
- Does not refresh existing spell duration

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&5You suddenly find it difficult to focus upon your foes.&0"
- To room: "$N can't decide which way to cross $S eyes!"

---

### SPELL_CURSE

**Source**: `magic.cpp:1410-1433`

**Duration**:
- Formula: `5 + (skill / 14)`
- Effect 1: `eff[0].duration`

**Effects**:
- **Flag**: `EFF_CURSE`

**Special Mechanics**:
- Effect modifiers accumulate

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "You feel very uncomfortable."
- To room: "$N briefly glows red!"
- To caster: "You curse $N! Muahahah!"

---

### SPELL_DARK_PRESENCE

**Source**: `magic.cpp:1435-1495`

**Duration**:
- Formula: `10 + (skill / 7)`
- Effect 1: `eff[0].duration`
- Effect 2: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_-2 - (skill / 10)**: `SAVING_SPELL`
- Effect slot 1:
  - **APPLY_1 + (skill > 95)**: `DAMROLL`
- Effect slot 2:
  - **Flag**: `EFF_BLESS`

**Requirements**:
- Alignment: Cannot target good
- Alignment: Caster cannot be good

**Conflicts With**:
- `SPELL_BLESS`
- `SPELL_WINGS_OF_HEAVEN`
- `SPELL_EARTH_BLESSING`

**Messages**:
- To victim: "You summon allegiance from your dark gods to protect yourself.\n&9&bA dark presence fills your "
- To room: "$n seizes up in pain!\n$n crosses $s arms on $s chest, and is surrounded by a dark presence."
- To caster: "You summon allegiance from your dark gods to protect $N."

---

### SPELL_DEMONIC_ASPECT

**Source**: `magic.cpp:1497-1529`

**Duration**:
- Formula: `5 + (skill / 20)`
- Effect 1: `eff[0].duration`

**Effects**:
- **APPLY_5 + (skill / 14)**: `STR`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Conflicts With**:
- `SPELL_DEMONIC_MUTATION`

**Messages**:
- To victim: "&1Your body fills with a demonic strength.&0"
- To room: "&1$n's&1 body &bglows red&0&1 briefly and grows stronger.&0"

---

### SPELL_DEMONIC_MUTATION

**Source**: `magic.cpp:1497-1529`

**Duration**:
- Formula: `5 + (skill / 20)`
- Effect 1: `eff[0].duration`

**Effects**:
- **APPLY_5 + (skill / 14)**: `STR`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Conflicts With**:
- `SPELL_DEMONIC_ASPECT`

**Messages**:
- To victim: "&1Your body fills with a demonic strength.&0"
- To room: "&1$n's&1 body &bglows red&0&1 briefly and grows stronger.&0"

---

### SPELL_DEMONSKIN

**Source**: `magic.cpp:1531-1543`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)
- Conflicts with other blessing spells (check_bless_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_DETECT_ALIGN

**Source**: `magic.cpp:1567-1574`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_DETECT_ALIGN`

**Messages**:
- To victim: "Your eyes tingle."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "$N can determine alignment."

---

### SPELL_DETECT_INVIS

**Source**: `magic.cpp:1576-1583`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **APPLY_10**: `PERCEPTION`
- **Flag**: `EFF_DETECT_INVIS`

**Messages**:
- To victim: "Your eyes tingle."

---

### SPELL_DETECT_MAGIC

**Source**: `magic.cpp:1585-1590`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_DETECT_MAGIC`

**Messages**:
- To victim: "Your eyes tingle."

---

### SPELL_DETECT_POISON

**Source**: `magic.cpp:1592-1597`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_DETECT_POISON`

**Messages**:
- To victim: "Your eyes tingle."

---

### SPELL_DISEASE

**Source**: `magic.cpp:1599-1622`

**Duration**:
- Formula: `5 + (skill / 10)`
- Effect 1: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_-10 - (skill / 10)**: `CON`
  - **Flag**: `EFF_DISEASE`
- Effect slot 1:
  - **APPLY_eff[0].modifier**: `STR`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_SPELL`

**Messages**:
- To victim: "&3You choke and gasp on $n's foul air as a sick feeling overtakes you.\n"
- To room: "&3$N&3 chokes and gasps on $n's foul air, $E looks seriously ill!"
- To caster: "Your diseased air infects $N!"

---

### SPELL_DISPLACEMENT

**Source**: `magic.cpp:1624-1647`

**Duration**:
- Formula: `(skill / 50) + ((stat_bonus[GET_INT(ch)].magic + stat_bonus[GET_WIS(ch)].magic) / 7)`

**Effects**:
- **Flag**: `EFF_DISPLACEMENT`
- **Flag**: `EFF_GREATER_DISPLACEMENT`

**Special Mechanics**:
- Does not refresh existing spell duration

**Conflicts With**:
- `SPELL_GREATER_DISPLACEMENT`

**Messages**:
- To victim: "&9&bYour image blurs into the shadows!&0"
- To room: "&9&b$N's image blurs into the shadows!&0"
- To caster: "&9&b$N's image blurs into the shadows!&0"

---

### SPELL_DRAGONS_HEALTH

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_GREATER_VITALITY`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_EARTH_BLESSING

**Source**: `magic.cpp:1649-1702`

**Duration**:
- Formula: `10 + (skill / 7)`
- Effect 1: `eff[0].duration`
- Effect 2: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_-2 - (skill / 10)**: `SAVING_SPELL`
- Effect slot 1:
  - **APPLY_1 + (skill > 95)**: `DAMROLL`
- Effect slot 2:
  - **Flag**: `EFF_BLESS`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Requirements**:
- Alignment: Cannot target evil
- Alignment: Cannot target good
- Alignment: Caster must be neutral

**Messages**:
- To victim: "You imbue yourself with the power of nature."
- To room: "$N is imbued with the power of nature."
- To caster: "$N is imbued with the power of nature."

---

### SPELL_ELEMENTAL_WARDING

**Source**: `magic.cpp:1704-1740`

**Duration**:
- Formula: `5 + (skill / 14)`

**Effects**:
- **Flag**: `EFF_PROT_FIRE`
- **Flag**: `EFF_PROT_COLD`
- **Flag**: `EFF_PROT_AIR`
- **Flag**: `EFF_PROT_EARTH`

**Special Mechanics**:
- Requires parameter: fire, cold, air, earth

**Messages**:
- To victim: "You are warded from &1fire&0."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "You protect $N from &1fire&0."

---

### SPELL_ENDURANCE

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_GREATER_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_ENHANCE_ABILITY

**Source**: `magic.cpp:1742-1803`

**Duration**:
- Formula: `5 + (skill / 14)`

**Special Mechanics**:
- Conflicts with other enhancement spells
- Requires parameter: strength, dexterity, constitution, intelligence, wisdom, charisma

**Messages**:
- To victim: "You feel stronger!"
- To room: "$N looks stronger!"
- To caster: "You increase $N's strength!"

---

### SPELL_ENHANCE_CHA

**Source**: `magic.cpp:1895-1902`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENHANCE_CON

**Source**: `magic.cpp:1841-1848`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENHANCE_DEX

**Source**: `magic.cpp:1823-1830`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENHANCE_INT

**Source**: `magic.cpp:1859-1866`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENHANCE_STR

**Source**: `magic.cpp:1805-1812`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENHANCE_WIS

**Source**: `magic.cpp:1877-1884`

**Special Mechanics**:
- Conflicts with other enhancement spells

---

### SPELL_ENLARGE

**Source**: `magic.cpp:1913-1933`

**Duration**:
- Formula: `1 + (skill / 40)`
- Effect 1: `eff[0].duration`
- Effect 2: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_1**: `SIZE`
  - **Flag**: `EFF_ENLARGE`
- Effect slot 1:
  - **APPLY_10**: `CON`
- Effect slot 2:
  - **APPLY_10**: `STR`

**Requirements**:
- Cannot target NPCs

**Messages**:
- To victim: "&9&bYour skin starts to itch as you enlarge to twice your normal size!&0"
- To room: "&9&b$N's skin ripples as $E enlarges to twice $S normal size!&0"

---

### SPELL_ENTANGLE

**Source**: `magic.cpp:1935-1971`

**Duration**:
- Formula: `2 + (skill / 24)`

**Effects**:
- **Flag**: `EFF_MAJOR_PARALYSIS`
- **Flag**: `EFF_MINOR_PARALYSIS`

**Special Mechanics**:
- Does not refresh existing spell duration

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "&2&bA slew of thick branches and vines burst"
- To room: "&2&bA slew of thick branches and vines burst"
- To caster: "&2&bYour crop of thick branches and vines burst"

---

### SPELL_FAMILIARITY

**Source**: `magic.cpp:1973-1980`

**Duration**:
- Formula: `skill / 5 + 4`

**Effects**:
- **Flag**: `EFF_FAMILIARITY`

**Messages**:
- To victim: "&7&bAn aura of comfort and solidarity surrounds you.&0"
- To room: "You know in your heart that $N is a steady friend, to be "

---

### SPELL_FARSEE

**Source**: `magic.cpp:1982-1988`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_FARSEE`

**Messages**:
- To victim: "Your sight improves dramatically."
- To room: "$N's pupils dilate rapidly for a second."

---

### SPELL_FEATHER_FALL

**Source**: `magic.cpp:2192-2199`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_FEATHER_FALL`

**Messages**:
- To victim: "&6You float up into the air.&0"
- To room: "&6$N&0&6 floats up into the air.&0"
- To caster: "&6$N&0&6 floats up into the air.&0"

---

### SPELL_FIRESHIELD

**Source**: `magic.cpp:2031-2044`

**Duration**:
- Formula: `skill / 20`

**Effects**:
- **Flag**: `EFF_FIRESHIELD`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&1A burning shield of f&bi&3r&7e&0&1 explodes from your body!&0"
- To room: "&1A burning shield of f&bi&3r&7e&0&1 explodes from $N&0&1's body!&0"

---

### SPELL_FIRES_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2386-2407`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_FIREHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&1Your fists burn with inner fire.&0"
- To room: "&1$N's fists burn with inner fire.&0"

---

### SPELL_FLY

**Source**: `magic.cpp:2046-2062`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_FLY`

**Special Mechanics**:
- Weight restriction for flying

**Messages**:
- To victim: "You feel somewhat lighter."
- To room: "&6&b$N lifts into the air.&0"
- To caster: "$N remains earthbound."

---

### SPELL_GAIAS_CLOAK

**Source**: `magic.cpp:2064-2074`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_GAS_BREATH

**Source**: `magic.cpp:2489-2517`

**Duration**:
- Formula: `2 + (skill / 33) + (stat_bonus[GET_WIS(ch)].magic / 2)`

**Effects**:
- **APPLY_(-2 - (skill / 4) - (skill / 20)) * susceptibility(victim, DAM_POISON) / 100**: `STR`
- **Flag**: `EFF_POISON`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "You feel very sick."
- To room: "$N gets violently ill!"
- To caster: "$N gets violently ill!"

---

### SPELL_GLORY

**Source**: `magic.cpp:2085-2093`

**Duration**:
- Formula: `5 + skill / 20`
- Effect 1: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **Flag**: `EFF_GLORY`
- Effect slot 1:
  - **APPLY_50**: `CHA`

**Messages**:
- To victim: "&7&bYou stand tall in the light, a beacon of greatness.&0"
- To room: "&7&b$N seems taller in the light, and appears like unto a god.&0"

---

### SPELL_GREATER_DISPLACEMENT

**Source**: `magic.cpp:1624-1647`

**Duration**:
- Formula: `(skill / 50) + ((stat_bonus[GET_INT(ch)].magic + stat_bonus[GET_WIS(ch)].magic) / 7)`

**Effects**:
- **Flag**: `EFF_DISPLACEMENT`
- **Flag**: `EFF_GREATER_DISPLACEMENT`

**Special Mechanics**:
- Does not refresh existing spell duration

**Conflicts With**:
- `SPELL_DISPLACEMENT`

**Messages**:
- To victim: "&9&bYour image blurs into the shadows!&0"
- To room: "&9&b$N's image blurs into the shadows!&0"
- To caster: "&9&b$N's image blurs into the shadows!&0"

---

### SPELL_GREATER_ENDURANCE

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_GREATER_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_GREATER_VITALITY

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_HARNESS

**Source**: `magic.cpp:2095-2107`

**Duration**:
- Formula: `(skill >= 20)`

**Effects**:
- **Flag**: `EFF_HARNESS`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&4&bYour veins begin to pulse with energy!&0"
- To room: "&4&b$N&4&b's veins bulge as a surge of energy rushes into $M!&0"

---

### SPELL_HASTE

**Source**: `magic.cpp:2109-2116`

**Duration**:
- Formula: `2 + (skill / 21)`

**Effects**:
- **Flag**: `EFF_HASTE`

**Messages**:
- To victim: "&1You start to move with uncanny speed!&0"
- To room: "&1$N starts to move with uncanny speed!&0"
- To caster: "&1$N starts to move with uncanny speed!&0"

---

### SPELL_ICE_ARMOR

**Source**: `magic.cpp:2118-2128`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_INFRAVISION

**Source**: `magic.cpp:2138-2157`

**Duration**:
- Formula: `5 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_INFRAVISION`

**Conflicts With**:
- `SPELL_NIGHT_VISION`

**Messages**:
- To victim: "Your eyes glow red."
- To room: "$N's eyes glow red."
- To caster: "$N's eyes glow red."

---

### SPELL_INN_ASCEN

**Source**: `magic.cpp:3045-3053`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel more resplendent!"

---

### SPELL_INN_BRILL

**Source**: `magic.cpp:3025-3033`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel smarter!"

---

### SPELL_INN_CHAZ

**Source**: `magic.cpp:2995-3003`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel stronger!"

---

### SPELL_INN_SYLL

**Source**: `magic.cpp:3005-3013`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel nimbler!"

---

### SPELL_INN_TASS

**Source**: `magic.cpp:3015-3023`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel wiser!"

---

### SPELL_INN_TREN

**Source**: `magic.cpp:3035-3043`

**Duration**:
- Formula: `(skill >> 1) + 4`

**Messages**:
- To victim: "You feel healthier!"

---

### SPELL_INSANITY

**Source**: `magic.cpp:2159-2179`

**Duration**:
- Formula: `5`

**Effects**:
- **APPLY_-50**: `WIS`
- **Flag**: `EFF_INSANITY`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_SPELL`

**Messages**:
- To victim: "&5You go out of your &bMIND!&0"
- To room: "&5$N's&5 psyche snaps... A crazed gleam fills $S eyes.&0"
- To caster: "You cause &5$N to snap... A crazed gleam fills $S eyes.&0"

---

### SPELL_INVISIBLE

**Source**: `magic.cpp:2181-2190`

**Duration**:
- Formula: `9 + (skill / 9)`

**Effects**:
- **APPLY_AC**: `40`
- **Flag**: `EFF_INVISIBLE`

**Messages**:
- To victim: "You vanish."
- To room: "$N slowly fades out of existence."

---

### SPELL_LESSER_ENDURANCE

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_VITALITY`
- `SPELL_GREATER_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_MAGIC_TORCH

**Source**: `magic.cpp:2201-2207`

**Duration**:
- Formula: `5 + (skill / 2)`

**Effects**:
- **Flag**: `EFF_LIGHT`

**Messages**:
- To victim: "&1A magical flame bursts into focus, lighting the area.&0"
- To room: "&1A magical flame bursts into focus, lighting the area.&0"

---

### SPELL_MAJOR_GLOBE

**Source**: `magic.cpp:2209-2224`

**Duration**:
- Formula: `4 + (skill / 20)`

**Effects**:
- **Flag**: `EFF_MAJOR_GLOBE`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&1&bA shimmering globe of force wraps around your body.&0"
- To room: "&1&bA shimmering globe of force wraps around $N&1&b's body.&0"
- To caster: "&1&bYour shimmering globe of force wraps around $N&1&b's body.&0"

---

### SPELL_MASS_INVIS

**Source**: `magic.cpp:2181-2190`

**Duration**:
- Formula: `9 + (skill / 9)`

**Effects**:
- **APPLY_AC**: `40`
- **Flag**: `EFF_INVISIBLE`

**Messages**:
- To victim: "You vanish."
- To room: "$N slowly fades out of existence."

---

### SPELL_MESMERIZE

**Source**: `magic.cpp:2226-2255`

**Duration**:
- Formula: `2`

**Effects**:
- **Flag**: `EFF_MESMERIZED`

**Requirements**:
- Cannot target NPCs

**Messages**:
- To victim: "$n shows you a truly fascinating puzzle.  You simply must work it out."
- To room: "$n &0&5w&4e&5av&4es a &5mesme&4rizing pa&5ttern before &0$N's eyes.\n"
- To caster: "You weave a mesmerizing pattern before $N, and $E seems to be utterly absorbed by it."

---

### SPELL_MINOR_GLOBE

**Source**: `magic.cpp:2257-2272`

**Duration**:
- Formula: `skill / 20`

**Effects**:
- **Flag**: `EFF_MINOR_GLOBE`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&1A shimmering globe wraps around your body.&0"
- To room: "&1A shimmering globe wraps around $N&0&1's body.&0"
- To caster: "&1Your shimmering globe wraps around $N&0&1's body.&0"

---

### SPELL_MINOR_PARALYSIS

**Source**: `magic.cpp:2274-2304`

**Duration**:
- Formula: `2 + (skill / 15)`

**Effects**:
- **Flag**: `EFF_MINOR_PARALYSIS`

**Special Mechanics**:
- Does not refresh existing spell duration

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "&7&bAll motion in your body grinds to a halt.&0"
- To room: "&7&bAll motion in $N&7&b's body grinds to a halt.&0"
- To caster: "You temporarily paralyze $N!"

---

### SPELL_MIRAGE

**Source**: `magic.cpp:2306-2317`

**Special Mechanics**:
- Conflicts with other armor spells (check_armor_spells)

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "&7&b$n magically restores the gaps in $N's armor.&0"

---

### SPELL_MISDIRECTION

**Source**: `magic.cpp:2331-2337`

**Duration**:
- Formula: `2 + skill / 4`

**Effects**:
- **Flag**: `EFF_MISDIRECTION`

**Messages**:
- To victim: "You feel like a stack of little illusions all pointing in "

---

### SPELL_NATURES_EMBRACE

**Source**: `magic.cpp:2448-2453`

**Duration**:
- Formula: `(skill / 3) + 1`

**Effects**:
- **Flag**: `EFF_CAMOUFLAGED`

**Messages**:
- To victim: "&9&bYou phase into the landscape.&0"
- To room: "&9&b$n&9&b phases into the landscape.&0"

---

### SPELL_NATURES_GUIDANCE

**Source**: `magic.cpp:2455-2461`

**Duration**:
- Formula: `(skill / 20) + 1`

**Effects**:
- **APPLY_eff[0].duration = (skill / 20) + 1**: `HITROLL`

**Messages**:
- To victim: "You feel a higher power guiding your hands."
- To room: "$N calls on guidance from a higher power."

---

### SPELL_NEGATE_COLD

**Source**: `magic.cpp:2432-2438`

**Duration**:
- Formula: `2 + (skill / 20)`

**Effects**:
- **Flag**: `EFF_NEGATE_COLD`

**Messages**:
- To victim: "&4&bYour body becomes impervious to the cold!&0"
- To room: "&4$n&4's is protected by a &3&bwarm&0&4-looking magical field.&0"

---

### SPELL_NEGATE_HEAT

**Source**: `magic.cpp:2440-2446`

**Duration**:
- Formula: `2 + (skill / 20)`

**Effects**:
- **Flag**: `EFF_NEGATE_HEAT`

**Messages**:
- To victim: "&6Your body becomes impervious to all forms of heat!&0"
- To room: "&6$n&6 is surrounded by a frigid crystalline field.&0"

---

### SPELL_NIGHT_VISION

**Source**: `magic.cpp:2463-2478`

**Duration**:
- Formula: `(skill / 21)`

**Effects**:
- **Flag**: `EFF_ULTRAVISION`

**Conflicts With**:
- `SPELL_INFRAVISION`

**Messages**:
- To victim: "&9&bYour vision sharpens a bit."
- To room: "$N's eyes glow a dim neon green."

---

### SPELL_NIMBLE

**Source**: `magic.cpp:2480-2487`

**Duration**:
- Formula: `2 + (skill / 21)`

**Effects**:
- **Flag**: `EFF_NIMBLE`

**Messages**:
- To victim: "&1You start to move with uncanny grace!&0"
- To room: "&1$N starts to move with uncanny grace!&0"
- To caster: "&1$N starts to move with uncanny grace!&0"

---

### SPELL_POISON

**Source**: `magic.cpp:2489-2517`

**Duration**:
- Formula: `2 + (skill / 33) + (stat_bonus[GET_WIS(ch)].magic / 2)`

**Effects**:
- **APPLY_(-2 - (skill / 4) - (skill / 20)) * susceptibility(victim, DAM_POISON) / 100**: `STR`
- **Flag**: `EFF_POISON`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "You feel very sick."
- To room: "$N gets violently ill!"
- To caster: "$N gets violently ill!"

---

### SPELL_PRAYER

**Source**: `magic.cpp:2519-2535`

**Duration**:
- Formula: `5 + (skill / 14)`
- Effect 1: `eff[0].duration`

**Effects**:
- **APPLY_-5 - (skill / 14)**: `SAVING_SPELL`

**Messages**:
- To victim: "Your prayer is answered...\nYou feel full of life!"
- To room: "$N perks up, looking full of life."

---

### SPELL_PROTECT_ACID

**Source**: `magic.cpp:2569-2581`

**Duration**:
- Formula: `5 + (skill / 14)`

**Effects**:
- **Flag**: `EFF_PROT_EARTH`

**Messages**:
- To victim: "You are warded from &3earth&0."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "You protect $N from &3earth&0."

---

### SPELL_PROTECT_COLD

**Source**: `magic.cpp:2583-2595`

**Duration**:
- Formula: `5 + (skill / 14)`

**Effects**:
- **Flag**: `EFF_PROT_COLD`

**Messages**:
- To victim: "You are warded from the &4cold&0."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "You protect $N from the &4cold&0."

---

### SPELL_PROTECT_FIRE

**Source**: `magic.cpp:2597-2609`

**Duration**:
- Formula: `5 + (skill / 14)`

**Effects**:
- **Flag**: `EFF_PROT_FIRE`

**Messages**:
- To victim: "You are warded from &1fire&0."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "You protect $N from &1fire&0."

---

### SPELL_PROTECT_SHOCK

**Source**: `magic.cpp:2611-2623`

**Duration**:
- Formula: `5 + (skill / 14)`

**Effects**:
- **Flag**: `EFF_PROT_AIR`

**Messages**:
- To victim: "You are warded from &6&bair&0."
- To room: "&7&b$N&7&b glows briefly.&0"
- To caster: "You protect $N from &6&bair&0."

---

### SPELL_PROT_FROM_EVIL

**Source**: `magic.cpp:2537-2551`

**Duration**:
- Formula: `9 + (skill / 9)`

**Effects**:
- **Flag**: `EFF_PROTECT_EVIL`

**Requirements**:
- Alignment: Cannot target evil

**Messages**:
- To victim: "You feel invulnerable!"
- To caster: "You surround $N with glyphs of holy warding."

---

### SPELL_PROT_FROM_GOOD

**Source**: `magic.cpp:2553-2567`

**Duration**:
- Formula: `9 + (skill / 9)`

**Effects**:
- **Flag**: `EFF_PROTECT_GOOD`

**Requirements**:
- Alignment: Cannot target good

**Messages**:
- To victim: "You feel invulnerable!"
- To caster: "You surround $N with glyphs of unholy warding."

---

### SPELL_RAY_OF_ENFEEB

**Source**: `magic.cpp:2625-2648`

**Duration**:
- Formula: `8 + (skill / 20)`

**Effects**:
- **Flag**: `EFF_RAY_OF_ENFEEB`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "You feel the strength flow out of your body."
- To room: "$N turns pale and starts to sag."
- To caster: "$N turns pale and starts to sag."

---

### SPELL_REBUKE_UNDEAD

**Source**: `magic.cpp:2650-2677`

**Duration**:
- Formula: `eff[1].duration = eff[2].duration = skill / 10`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_SPELL`

**Messages**:
- To victim: "&5You catch a glimpse of $n's true power and cower in fear!&0"
- To room: "&5$N cowers in fear as $n rebukes $M.&0"
- To caster: "&5You shout a powerful rebuke at $N, forcing $M to cower in fear!&0"

---

### SPELL_REDUCE

**Source**: `magic.cpp:2679-2701`

**Duration**:
- Formula: `1 + (skill / 40)`
- Effect 1: `eff[0].duration`
- Effect 2: `eff[0].duration`

**Effects**:
- Effect slot 0:
  - **APPLY_-1**: `SIZE`
  - **Flag**: `EFF_REDUCE`
- Effect slot 1:
  - **APPLY_-10**: `CON`
- Effect slot 2:
  - **APPLY_-10**: `STR`

**Requirements**:
- Cannot target NPCs

**Messages**:
- To victim: "&1&bYour skin starts to itch as you reduce to half your normal "
- To room: "&1&b$N's skin ripples as $E shrinks to half $S normal size!&0"

---

### SPELL_SANCTUARY

**Source**: `magic.cpp:2703-2713`

**Duration**:
- Formula: `4`

**Effects**:
- **Flag**: `EFF_SANCTUARY`

**Messages**:
- To victim: "This spell doesn't exist.  Ask no questions."
- To room: "Absolutely nothing happens to $N."

---

### SPELL_SENSE_LIFE

**Source**: `magic.cpp:2715-2721`

**Duration**:
- Formula: `17 + (skill / 3)`

**Effects**:
- **Flag**: `EFF_SENSE_LIFE`

**Messages**:
- To victim: "Your feel your awareness improve."
- To room: "$N seems more aware of $S surroundings."

---

### SPELL_SILENCE

**Source**: `magic.cpp:2723-2746`

**Duration**:
- Formula: `2 + (skill / 15)`

**Effects**:
- **Flag**: `EFF_SILENCE`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&9&bYour throat begins to close, sealing off all chance of "
- To room: "&0$N&7 squeaks as all sound is squelched from $S throat.&0"
- To caster: "You silence $N!"

---

### SPELL_SLEEP

**Source**: `magic.cpp:2748-2782`

**Duration**:
- Formula: `9 + (skill / 9)`

**Effects**:
- **Flag**: `EFF_SLEEP`

**Special Mechanics**:
- Does not refresh existing spell duration

**Requirements**:
- Cannot target NPCs

**Saving Throw**: `SAVING_PARA`

---

### SPELL_SMOKE

**Source**: `magic.cpp:2784-2818`

**Duration**:
- Formula: `2`
- Effect 1: `2`

**Effects**:
- Effect slot 0:
  - **APPLY_-1**: `HITROLL`
  - **Flag**: `EFF_BLIND`
- Effect slot 1:
  - **APPLY_-10**: `AC`
  - **Flag**: `EFF_BLIND`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&9&bYou have been temporarily choked by $n's&9&b column of smoke!&0"
- To room: "&9&b$N&9&b is slightly choked by $n's&9&b column of smoke!&0"
- To caster: "You temporarily choke $N with your column of smoke."

---

### SPELL_SOULSHIELD

**Source**: `magic.cpp:2820-2837`

**Duration**:
- Formula: `2 + (skill / 10)`

**Effects**:
- **Flag**: `EFF_SOULSHIELD`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&3&bA bright golden aura surrounds your body!&0"
- To room: "&3&bA bright golden aura surrounds $N's body!&0"

---

### SPELL_SPINECHILLER

**Source**: `magic.cpp:3167-3190`

**Duration**:
- Formula: `2 + (skill / 15)`

**Effects**:
- **Flag**: `EFF_MINOR_PARALYSIS`

**Special Mechanics**:
- Does not refresh existing spell duration

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "Tingles run up and down your spine as $n scrambles your nerves!"
- To room: "$N gasps for breath as $n scrambles $S nerves!"
- To caster: "You grab $N and scramble $S nerves!"

---

### SPELL_STATUE

**Source**: `magic.cpp:2839-2844`

**Duration**:
- Formula: `(skill / 5) + (GET_INT(ch) / 4)`

**Effects**:
- **Flag**: `EFF_FAMILIARITY`

**Messages**:
- To victim: "&9&bYou disguise yourself as a little statue.&0"
- To room: "You realize $N has disappeared and been replaced by a statue!"

---

### SPELL_STONE_SKIN

**Source**: `magic.cpp:2846-2862`

**Duration**:
- Formula: `2`

**Effects**:
- **APPLY_7 + (skill / 16)**: `NONE`
- **Flag**: `EFF_STONE_SKIN`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&9&bYour skin hardens and turns to stone!&0"
- To room: "&9&b$N's skin hardens and turns to stone!&0"
- To caster: "&9&b$N's skin hardens and turns to stone!&0"

---

### SPELL_SUNRAY

**Source**: `magic.cpp:2864-2892`

**Duration**:
- Formula: `2`
- Effect 1: `2`

**Effects**:
- Effect slot 0:
  - **APPLY_-4**: `HITROLL`
  - **Flag**: `EFF_BLIND`
- Effect slot 1:
  - **APPLY_-40**: `AC`
  - **Flag**: `EFF_BLIND`

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `savetype`

**Messages**:
- To victim: "&9&bYou have been blinded!&0"
- To room: "&9&b$N&9&b seems to be blinded!&0"
- To caster: "&9&bYou have blinded $N with your sunray!&0"

---

### SPELL_TEMPEST_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2409-2430`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_LIGHTNINGHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&6&bYour knuckles crackle with lightning.&0"
- To room: "&6&b$N's knuckles crackle with lightning.&0"

---

### SPELL_TREMORS_OF_SAINT_AUGUSTINE

**Source**: `magic.cpp:2339-2361`

**Duration**:
- Formula: `((skill / 10) + (GET_WIS(ch) / 20))`

**Effects**:
- **Flag**: `EFF_ACIDHANDS`

**Special Mechanics**:
- Conflicts with other monk hand spells

**Requirements**:
- Must have SKILL_BAREHAND (monk-only)

**Messages**:
- To victim: "&3&bYou charge your hands with corrosive chi.&0"
- To room: "&3&b$N charges $S hands with corrosive chi.&0"

---

### SPELL_VAPORFORM

**Source**: `magic.cpp:2894-2909`

**Duration**:
- Formula: `2 + (skill / 25)`

**Effects**:
- **APPLY_COMP_MIST**: `COMPOSITION`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&6&bYour body sublimates into a &7cloud &6of &7vapor&6.&0"
- To room: "&6&b$N's body dematerializes into a translucent &7cloud &6of "

---

### SPELL_VITALITY

**Source**: `magic.cpp:1138-1177`

**Duration**:
- Formula: `get_spell_duration(ch, spellnum)`

**Effects**:
- **APPLY_get_vitality_hp_gain(ch, spellnum)**: `HIT`

**Special Mechanics**:
- HP gain calculated by get_vitality_hp_gain()
- Duration calculated by get_spell_duration()
- Conflicts with other armor spells (check_armor_spells)

**Conflicts With**:
- `SPELL_LESSER_ENDURANCE`
- `SPELL_ENDURANCE`
- `SPELL_GREATER_ENDURANCE`
- `SPELL_GREATER_VITALITY`
- `SPELL_DRAGONS_HEALTH`

**Messages**:
- To victim: "&7&bThe gaps in your armor are restored.&0"
- To room: "$N looks healthier than before!"
- To caster: "$N looks healthier than before!"

---

### SPELL_WATERFORM

**Source**: `magic.cpp:2911-2926`

**Duration**:
- Formula: `2 + (skill / 20)`

**Effects**:
- **APPLY_COMP_WATER**: `COMPOSITION`

**Special Mechanics**:
- Does not refresh existing spell duration

**Messages**:
- To victim: "&4&bYour body liquifies.&0"
- To room: "&4&b$N&4&b's body wavers a bit, slowly changing into a "

---

### SPELL_WATERWALK

**Source**: `magic.cpp:2928-2934`

**Duration**:
- Formula: `35 + (skill / 4)`

**Effects**:
- **Flag**: `EFF_WATERWALK`

**Messages**:
- To victim: "You feel webbing between your toes."
- To room: "$N sprouts webbing between $S toes!"

---

### SPELL_WEB

**Source**: `magic.cpp:2936-2959`

**Duration**:
- Formula: `2 + (skill / 50)`

**Effects**:
- **Flag**: `EFF_IMMOBILIZED`

**Special Mechanics**:
- Does not refresh existing spell duration

**Requirements**:
- Requires attack_ok check (offensive spell)

**Saving Throw**: `SAVING_PARA`

**Messages**:
- To victim: "&2&b$n tangles you in a glowing &3&bweb&2&b!&0"
- To room: "&2&b$n tangles $N in a glowing &3&bweb&2&b!&0"
- To caster: "&2&bYou tangle $N in a glowing &3&bweb&2&b!&0"

---

### SPELL_WINGS_OF_HEAVEN

**Source**: `magic.cpp:2961-2975`

**Duration**:
- Formula: `10 + (skill / 5)`

**Effects**:
- **Flag**: `EFF_FLY`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Messages**:
- To victim: "&7&bBeautiful bright white wings unfurl behind you as you lift into the air.&0"
- To room: "&7&bBeautiful bright white wings unfurl from $n's&7&b back, lifting $m into the air.&0"

---

### SPELL_WINGS_OF_HELL

**Source**: `magic.cpp:2977-2991`

**Duration**:
- Formula: `10 + (skill / 5)`

**Effects**:
- **Flag**: `EFF_FLY`

**Special Mechanics**:
- Conflicts with other blessing spells (check_bless_spells)

**Messages**:
- To victim: "&1&bHuge leathery &9bat-like&1 wings sprout from your back.&0"
- To room: "&1&bHuge leathery &9bat-like&1 wings sprout out of $n's&1&b back.&0"

---
