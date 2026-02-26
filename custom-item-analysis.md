# Custom Item Analysis Report

Analysis of **vnum -1** (custom) items found in player equipment files.
These are items with no prototype in the world object database — typically
created by immortals for quest rewards, RP events, or personal use.

## Overall Numbers

| Metric | Count |
|--------|-------|
| Total custom items found | 713 |
| Mail (NOTE type, skipped) | 390 |
| Corpses (skipped) | 20 |
| **Analyzed** | **303** |
| Confident match (score >= 50) | 266 (88%) |
| Tentative match (score 30-49) | 26 (8.6%) |
| Unmatched (score < 30) | 11 (3.6%) |
| **Unique items needing review** | **29** |

> **266 of 303 items (88%)** are confident structural matches to existing prototypes —
> just renamed by players. These can be imported by linking to their matched prototype.
> The remaining **37 items (29 unique)** are detailed below.

## Matching Algorithm

Items are scored against all database objects of the same type. Name/description
matching is weighted *low* because custom items are almost always renamed. Structural
properties are weighted high:

| Signal | Points |
|--------|--------|
| Exact values match (AC, dice, spells) | +40 |
| Same applies (stat bonuses) | +30 |
| Same wear flags | +15 |
| Exact weight | +10 |
| Exact level | +10 |
| Same item flags | +10 |
| Same cost | +5 |
| Keyword overlap (Jaccard > 0.5) | +5 |
| Same short description | +5 |

---

## Immortal Toys — Skip Import (4 items)

> **Disposition:** Skip entirely. Do not import.

Items with absurdly overpowered stats (200d20 damage, +100 hit/dam, +150 concealment, etc.)
that were clearly created by immortals for testing or personal use. Not suitable for import.

### 1. a pair of bronze dragon wings

| Field | Value |
|-------|-------|
| **Owner(s)** | Golanth |
| **Type** | TREASURE |
| **Level** | 85 |
| **Weight** | 21.0 |
| **Cost** | 10000 |
| **Values** | AC: 10 |
| **Applies** | DamRoll +2, Move +20, Hit +100, Focus +5 |
| **Wear** | TAKE, ABOUT |
| **Best Match** | zone 123 id 115 "a silver and quartz moon diadem" (score: 45) |

### 2. a pair of enourmous claws

| Field | Value |
|-------|-------|
| **Owner(s)** | Esteii |
| **Type** | WEAPON |
| **Level** | 0 |
| **Weight** | 1.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 40, Hit Dice: 10d10+0, Average: 55.0, Damage Type: MAUL |
| **Applies** | Regeneration +40, HitRoll +10 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 370 id 77 "a lightsaber" (score: 30) |

### 3. a &6lightsabre&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Laich |
| **Type** | WEAPON |
| **Level** | 99 |
| **Weight** | 1.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 20, Hit Dice: 200d20+0, Average: 2010.0, Damage Type: SLASH |
| **Applies** | HitRoll +100, DamRoll +100 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 22 id 2 "a razor-sharp dagger" (score: 20) |

### 4. the sheriff's badge

| Field | Value |
|-------|-------|
| **Owner(s)** | Geeter |
| **Type** | LIGHT |
| **Level** | 96 |
| **Weight** | 0.0 |
| **Cost** | 0 |
| **Values** | Is_Lit:: True, Capacity: -1, Remaining: -1 |
| **Applies** | Concealment +150, Hit +125, AC +7 |
| **Wear** | TAKE, BADGE |
| **Best Match** | zone 0 id 42 "a <red>small </><b:red>red </><red>dragon</>" (score: 15) |

---

## Quest Variants — Link to Existing Prototype (17 items)

> **Disposition:** Import by linking to the matched prototype. Store custom name/desc as overrides on the CharacterItem.

Modified versions of existing items, typically given as quest rewards. These share the same
base item (same name or very similar structural properties) but have tweaked stats, custom
names, or different applies. The matched prototype is a strong candidate for the base item.

### 1. a Polar Claw

| Field | Value |
|-------|-------|
| **Owner(s)** | Cnas, Naocl, Orshel |
| **Type** | WEAPON |
| **Level** | 45 |
| **Weight** | 2.0 |
| **Cost** | 1000 |
| **Values** | HitRoll: 0, Hit Dice: 2d6+0, Average: 9.0, Damage Type: SLASH |
| **Applies** | HitRoll +3 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 2 id 18 "a Polar Claw" (score: 45) |

### 2. a miniature Ehlissa doll

| Field | Value |
|-------|-------|
| **Owner(s)** | Ehlissa |
| **Type** | STAFF |
| **Level** | 20 |
| **Weight** | 0.0 |
| **Cost** | 30000 |
| **Values** | Level: 25, Max_Charges: 10, Charges_Left: 9, Spell: MAGIC_MISSILE |
| **Applies** | *none* |
| **Wear** | TAKE, HOLD |
| **Best Match** | zone 30 id 145 "a miniature ambitious mage doll" (score: 45) |

### 3. a &1Chaos&b&0 orb

| Field | Value |
|-------|-------|
| **Owner(s)** | Falon |
| **Type** | LIGHT |
| **Level** | 65 |
| **Weight** | 2.0 |
| **Cost** | 0 |
| **Values** | Is_Lit:: True, Capacity: -1, Remaining: -1 |
| **Applies** | Dex +1, DamRoll +2, Con +2, Focus +3 |
| **Wear** | TAKE, HOLD, HOVER |
| **Best Match** | zone 40 id 3 "a <red>Chaos</> orb" (score: 45) |

### 4. &2a &9&bdark&0 &2dagger of &9&bshadows&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Gilgal |
| **Type** | WEAPON |
| **Level** | 70 |
| **Weight** | 0.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 3, Hit Dice: 5d6+0, Average: 18.0, Damage Type: PIERCE |
| **Applies** | Dex +2, Age +8, Con +1, DamRoll +2 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 40 id 6 "a dagger of <b:black>shadows</>" (score: 45) |

### 5. a murky yellow potion

| Field | Value |
|-------|-------|
| **Owner(s)** | Hinn, Kaan |
| **Type** | POTION |
| **Level** | 20 |
| **Weight** | 0.1 |
| **Cost** | 0 |
| **Values** | Level: 20, Spells: ['GREATER_ENDURANCE'] |
| **Applies** | *none* |
| **Wear** | TAKE |
| **Best Match** | zone 100 id 12 "a clear vial of invisibility" (score: 45) |

### 6. a dagger of &9&bshadows&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Meeka |
| **Type** | WEAPON |
| **Level** | 70 |
| **Weight** | 0.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 0, Hit Dice: 5d6+0, Average: 18.0, Damage Type: PIERCE |
| **Applies** | Dex +2, Age +8, Con +1, DamRoll +2 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 40 id 6 "a dagger of <b:black>shadows</>" (score: 45) |

### 7. a dark red potion

| Field | Value |
|-------|-------|
| **Owner(s)** | Muuth |
| **Type** | POTION |
| **Level** | 20 |
| **Weight** | 0.1 |
| **Cost** | 1600 |
| **Values** | Level: 20, Spells: ['VIGORIZE_CRITIC'] |
| **Applies** | *none* |
| **Wear** | TAKE |
| **Best Match** | zone 100 id 12 "a clear vial of invisibility" (score: 45) |

### 8. the Nomkie Tabard of Heroes

| Field | Value |
|-------|-------|
| **Owner(s)** | Nomkie |
| **Type** | ARMOR |
| **Level** | 95 |
| **Weight** | 15.0 |
| **Cost** | 5000 |
| **Values** | AC: 17 |
| **Applies** | Regeneration +5 |
| **Wear** | TAKE, ABOUT |
| **Best Match** | zone 554 id 35 "<magenta>Believer's Plate</>" (score: 45) |

### 9. &5&bthe Sword of the Third Star&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Paver |
| **Type** | WEAPON |
| **Level** | 80 |
| **Weight** | 12.0 |
| **Cost** | 500000 |
| **Values** | HitRoll: 0, Hit Dice: 16d11+0, Average: 93.5, Damage Type: SLASH |
| **Applies** | *none* |
| **Wear** | TAKE, TWO_HAND_WIELD |
| **Best Match** | zone 489 id 2 "the Starsword" (score: 45) |

### 10. A Special weighted chain

| Field | Value |
|-------|-------|
| **Owner(s)** | Zhan |
| **Type** | WEAPON |
| **Level** | 13 |
| **Weight** | 3.0 |
| **Cost** | 3627 |
| **Values** | HitRoll: 1, Hit Dice: 6d2+0, Average: 7.0, Damage Type: BLUDGEON |
| **Applies** | *none* |
| **Wear** | TAKE, TWO_HAND_WIELD |
| **Best Match** | zone 55 id 39 "a staff of the 3rd Black Legion" (score: 45) |

### 11. the trunk of an oak

| Field | Value |
|-------|-------|
| **Owner(s)** | Kacor |
| **Type** | WEAPON |
| **Level** | 22 |
| **Weight** | 2.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 0, Hit Dice: 16d11+0, Average: 93.5, Damage Type: CRUSH |
| **Applies** | *none* |
| **Wear** | TAKE, TWO_HAND_WIELD |
| **Best Match** | zone 10 id 47 "<b:blue>a</> <blue>dag</><b:blue>ger</> <blue>o</><b:blue>f</> <b:blue>ice</>" (score: 40) |

### 12. a slightly curved longsword

| Field | Value |
|-------|-------|
| **Owner(s)** | Berz |
| **Type** | WEAPON |
| **Level** | 5 |
| **Weight** | 4.0 |
| **Cost** | 500 |
| **Values** | HitRoll: 2, Hit Dice: 4d9+0, Average: 22.5, Damage Type: SLASH |
| **Applies** | DamRoll +3 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 30 id 242 "a huge bastard sword" (score: 35) |

### 13. the Orb of Catastrophe

| Field | Value |
|-------|-------|
| **Owner(s)** | Gaz |
| **Type** | LIGHT |
| **Level** | 60 |
| **Weight** | 5.0 |
| **Cost** | 0 |
| **Values** | Is_Lit:: True, Capacity: -1, Remaining: -1 |
| **Applies** | Str +3, Int +5, Focus +5 |
| **Wear** | TAKE, HOLD, HOVER |
| **Best Match** | zone 430 id 21 "the Orb of Catastrophe" (score: 35) |

### 14. a sickle

| Field | Value |
|-------|-------|
| **Owner(s)** | Sclown |
| **Type** | WEAPON |
| **Level** | 50 |
| **Weight** | 4.0 |
| **Cost** | 200 |
| **Values** | HitRoll: 0, Hit Dice: 4d10+0, Average: 25.0, Damage Type: SLASH |
| **Applies** | HitRoll +3, Str +2, DamRoll +4 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 85 id 11 "a sickle" (score: 35) |

### 15. a sickle

| Field | Value |
|-------|-------|
| **Owner(s)** | Sclown |
| **Type** | WEAPON |
| **Level** | 50 |
| **Weight** | 4.0 |
| **Cost** | 200 |
| **Values** | HitRoll: 0, Hit Dice: 4d10+0, Average: 25.0, Damage Type: SLASH |
| **Applies** | HitRoll +2, Str +2, DamRoll +5 |
| **Wear** | TAKE, TWO_HAND_WIELD |
| **Best Match** | zone 85 id 11 "a sickle" (score: 35) |

### 16. a Miniature Sun

| Field | Value |
|-------|-------|
| **Owner(s)** | Voltel |
| **Type** | LIGHT |
| **Level** | 60 |
| **Weight** | 5.0 |
| **Cost** | 600 |
| **Values** | Is_Lit:: True, Capacity: -1, Remaining: -1 |
| **Applies** | Hit +50, AC +2, SavingSpell -10, Focus +3 |
| **Wear** | TAKE, HOLD, HOVER |
| **Best Match** | zone 510 id 73 "a Miniature Sun" (score: 35) |

### 17. Ministry

| Field | Value |
|-------|-------|
| **Owner(s)** | Goaah |
| **Type** | WEAPON |
| **Level** | 41 |
| **Weight** | 1.0 |
| **Cost** | 8000 |
| **Values** | HitRoll: 0, Hit Dice: 3d4+0, Average: 8.0, Damage Type: PIERCE |
| **Applies** | Wis +5, SavingSpell -5 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 4 id 134 "Ministry" (score: 30) |

---

## RP / Vanity Items — Needs New Prototype (5 items)

> **Disposition:** Create new prototypes in a dedicated zone (e.g., zone 999) or skip.

Player-specific custom items that don't match any existing prototype well. These were likely
created from scratch by immortals for specific players or events.

### 1. a scythe of &1Chaos&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Anulo, Ija |
| **Type** | WEAPON |
| **Level** | 99 |
| **Weight** | 12.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 7, Hit Dice: 6d24+0, Average: 84.0, Damage Type: SLASH |
| **Applies** | Age +10, Dex +1, DamRoll +2, Con -2 |
| **Wear** | TAKE, TWO_HAND_WIELD |
| **Best Match** | zone 40 id 7 "a blade of <red>Chaos</>" (score: 20) |

### 2. a broom

| Field | Value |
|-------|-------|
| **Owner(s)** | Elphaba |
| **Type** | WAND |
| **Level** | 1 |
| **Weight** | 0.9 |
| **Cost** | 10 |
| **Values** | Level: 90, Max_Charges: 20, Charges_Left: 20, Spell: FIREBALL |
| **Applies** | Int +5, Hit +50, Regeneration +10 |
| **Wear** | TAKE, HOLD, HOVER |
| **Best Match** | zone 123 id 47 "a manticore tail spike" (score: 20) |

### 3. the Orb of Winds

| Field | Value |
|-------|-------|
| **Owner(s)** | Meina |
| **Type** | LIGHT |
| **Level** | 45 |
| **Weight** | 0.0 |
| **Cost** | 1000 |
| **Values** | Is_Lit:: True, Capacity: -1, Remaining: -1 |
| **Applies** | HitRoll +12, SavingParalysis -2, Regeneration +3 |
| **Wear** | TAKE, HOLD |
| **Best Match** | zone 160 id 6 "the Orb of Winds" (score: 20) |

### 4. a stone dagger

| Field | Value |
|-------|-------|
| **Owner(s)** | Sclown |
| **Type** | WEAPON |
| **Level** | 20 |
| **Weight** | 0.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 9, Hit Dice: 4d13+0, Average: 32.5, Damage Type: PIERCE |
| **Applies** | HitRoll -2 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 2 id 112 "a wand of flames" (score: 20) |

### 5. a sat sword

| Field | Value |
|-------|-------|
| **Owner(s)** | Akiko |
| **Type** | WEAPON |
| **Level** | 10 |
| **Weight** | 0.0 |
| **Cost** | 0 |
| **Values** | HitRoll: 10, Hit Dice: 5d6+0, Average: 18.0, Damage Type: SLASH |
| **Applies** | Hit +25, Move +25 |
| **Wear** | TAKE, WIELD |
| **Best Match** | zone 12 id 12 "a tasty dill pickle" (score: 15) |

---

## Missing Prototypes — Type Not in Database (3 items)

> **Disposition:** Add DRINK_CONTAINER type to schema, then create prototypes.

Normal items whose object type (DRINK_CONTAINER) doesn't exist in the current database.
These are legitimate items that just need their type added to the schema.

### 1. &3a leather water skin&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Discord |
| **Type** | DRINK_CONTAINER |
| **Level** | 1 |
| **Weight** | 2.0 |
| **Cost** | 10 |
| **Values** | Capacity: 256, Remaining: 256, Liquid: WATER, Poisoned: False |
| **Applies** | *none* |
| **Wear** | TAKE, HOLD |
| **Best Match** | *none found* |

### 2. a miniature water elemental doll

| Field | Value |
|-------|-------|
| **Owner(s)** | Eone |
| **Type** | DRINK_CONTAINER |
| **Level** | 40 |
| **Weight** | 35.0 |
| **Cost** | 25000 |
| **Values** | Capacity: 30, Remaining: 0, Liquid: WATER, Poisoned: False |
| **Applies** | Hit +25 |
| **Wear** | TAKE, HOLD |
| **Best Match** | *none found* |

### 3. &3a leather water skin&0

| Field | Value |
|-------|-------|
| **Owner(s)** | Kra |
| **Type** | DRINK_CONTAINER |
| **Level** | 1 |
| **Weight** | 2.0 |
| **Cost** | 10 |
| **Values** | Capacity: 256, Remaining: 188, Liquid: WATER, Poisoned: False |
| **Applies** | *none* |
| **Wear** | TAKE, HOLD |
| **Best Match** | *none found* |

---

## Disposition Summary

| Category | Count | Action |
|----------|-------|--------|
| Confident matches (score >= 50) | 266 | Link to matched prototype |
| Immortal toys | 4 | Skip |
| Quest variants | 17 | Link to matched prototype with overrides |
| RP/vanity items | 5 | Create new prototypes in zone 999, or skip |
| Missing prototypes | 3 | Add DRINK_CONTAINER type, create prototypes |
| **Total needing review** | **29** | |

## Open Questions for Team

1. **Quest variants**: Should we link these to the matched prototype and store
   the custom name/description as overrides? Or create separate prototypes?
2. **RP items**: Are any of these worth preserving? (e.g., Chaos scythe shared
   by 2 players, Elphaba's broom) Or skip all of them?
3. **Match threshold**: The current confident threshold is score >= 50. Should
   we lower it to include some of the tentative matches (score 35-49)?
4. **DRINK_CONTAINER**: Should we add this type to the schema? Only 3 items need it.

