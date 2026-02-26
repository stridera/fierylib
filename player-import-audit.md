# Player Import Audit Report

Comprehensive audit of what data is silently dropped, skipped, or lost during the
legacy player import process (`player_importer.py`).

## Overall Numbers

| File Type | Count | Import Status |
|-----------|-------|---------------|
| `.plr` (player data) | 3,420 | Imported |
| `.quest` (quest progress) | 3,277 | **NOT IMPORTED** |
| `.objs` (equipment/inventory) | 2,608 | Partially imported |
| `.pet` (pets) | 1,578 | Imported (44 have data) |
| `.notes` (immortal notes) | 254 | **NOT IMPORTED** |

---

## 1. Equipment — 9,450 Items with Valid Vnums Silently Dropped

**Impact: HIGH**

| Metric | Count |
|--------|-------|
| Total item blocks in all .objs files | 241,710 |
| Successfully resolved to DB prototype | 231,542 |
| Custom items (vnum -1) | 713 (covered by custom item analyzer) |
| **Valid vnum but prototype NOT in DB** | **9,450** |

These items have real vnums pointing to objects that existed in the game but whose
**zones were never imported** (zone files were deleted or excluded from the index).

### Unresolved Items by Zone

| Zone | Items | Status | Top Item Examples |
|------|-------|--------|-------------------|
| 31 | 3,181 | MISSING | "a turkey sandwich", "a satin-black potion", "a scrumptious bear claw" |
| 32 | 2,243 | MISSING | "a vial of sparks", "a vial of acid", "a vial of tiny flames", "an iron ring" |
| 118 | 1,577 | MISSING | "a small bolt of energy" |
| 5 | 1,090 | MISSING | "a Christmas stocking-cap", "Crest of the Dragon Hunter", "the Night Gaze" |
| 124 | 277 | MISSING | "a silver and gold twist bracelet" |
| 3 | 276 | MISSING | |
| 535 | 261 | MISSING | "a tiny white stud" |
| 581 | 213 | MISSING | "a jet-black kimono" |
| 485 | 104 | MISSING | |
| 200 | 61 | MISSING | |
| 521 | 46 | MISSING | |
| 301 | 19 | MISSING | |
| 482 | 19 | MISSING | |
| 33 | 1 | MISSING | |
| **Total from missing zones** | **9,368** | | |

An additional **82 items** reference objects in zones that **exist** but whose specific
vnum doesn't resolve (could be objects with id >= 100 in zones that use the extended
vnum range, or objects that were individually deleted).

| Zone | Items | Notes |
|------|-------|-------|
| 105 | 18 | Zone exists, vnums don't resolve |
| 350 | 9 | |
| 615 | 9 | |
| 324 | 8 | |
| 411 | 7 | |
| 16 | 7 | |
| 120 | 6 | |
| Others | 18 | Scattered across 9 zones (1-3 each) |

### What These Zones Were

- **Zone 31 (3,181 items)**: Mielikki shops — food, potions, scrolls, common supplies.
  This is the single biggest source of dropped items.
- **Zone 32 (2,243 items)**: Mielikki magic shops — potions, scrolls, spell reagents.
- **Zone 5 (1,090 items)**: Quest reward items — holiday items, Crest of the Dragon
  Hunter, Blackthorn, Night Gaze, Mask of Betrayal. These are significant player items.
- **Zone 118 (1,577 items)**: Likely a shop/consumable zone ("a small bolt of energy"
  is ammunition).
- **Zone 124 (277 items)**: Jewelry zone ("silver and gold twist bracelet").
- **Zone 535, 581**: Specialty equipment zones.

### Recommendation

Zones 31/32 are shop consumables (food, potions, scrolls) that don't need to persist —
players can rebuy them. Zone 5 contains quest reward items that players earned and
**should be preserved**. The remaining zones need investigation.

**Action items:**
1. Import zone 5's object definitions (quest rewards) — these are valuable player items
2. Zones 31/32/118 are shop consumables — acceptable to skip
3. Investigate zones 124, 535, 581 for significant items
4. For zones in "EXISTS" category, investigate vnum resolution failures (likely id >= 100)

---

## 2. Container Contents — 170,266 Items Silently Dropped

**Impact: HIGH**

| Location Type | Count | Imported? |
|---------------|-------|-----------|
| Equipped (slots 0-27) | 26,594 | Yes |
| Inventory (location 127) | 44,850 | Yes |
| **Inside containers (location < 0)** | **170,266** | **NO** |

The importer only extracts `vnum` and `location` from each block, then creates a
`CharacterItem` linking to the prototype. Items nested inside containers (bags, backpacks,
corpses) have negative location values indicating nesting depth, and are **completely
skipped**.

This means: if a player had a bag with 50 items in it, only the bag itself is imported.
All 50 items inside are lost.

**170,266 items** is 70% of all item blocks. This is the single largest source of data loss.

### Recommendation

The `Object.parse_player()` method already handles container nesting correctly (populating
`obj.contains`). The importer just doesn't use it — it uses a simplified vnum-only parser
instead. Fix: use the full parser and recursively import container contents.

---

## 3. Quest Progress — 8,255 Entries Not Imported

**Impact: HIGH**

| Metric | Count |
|--------|-------|
| Total .quest files | 3,277 |
| Non-empty | 1,796 |
| Quest header entries | 8,255 |
| Quest variable entries | 44,533 |

Quest files track per-player progress on zone quests. Format:
```
<zone_id> <state> <num_variables>
<var_name> <value>
<var_name> <value>
...
```

The importer has a `# TODO: .quest files` comment at line 819 and completely skips them.
This means **all quest progress is lost** — players who had partially or fully completed
quests would need to redo them.

### Recommendation

Implement quest file parsing and import. The format is simple. Requires a
`CharacterQuestProgress` table or similar in the schema.

---

## 4. Item Instance Properties Not Preserved

**Impact: MEDIUM**

The `CharacterItems` table only stores:
- `objectZoneId` / `objectId` (link to prototype)
- `equippedLocation`
- `condition` (hardcoded to 100)
- `charges` (hardcoded to -1)

Every item in the .objs file has **per-instance properties** that differ from the
prototype. These are all lost:

| Property | What's Lost | Affects |
|----------|-------------|---------|
| Custom name/shortdesc | Renamed items show prototype name | All 266 confident-match custom items |
| Values (charges, filling, etc.) | Wands/staves lose charge count, food loses filling | Wands, staves, food, potions |
| Timer/decompose state | Items that were decomposing restart fresh | Temporary items |
| Instance flags | Per-item flag modifications lost | Items with added/removed flags |
| Instance effect flags | Effect modifications lost | Items with added effects |
| Instance applies/affects | Stat bonuses may differ from prototype | Enchanted/modified items |
| Extra descriptions | Custom descriptions added to instance | Items with added examine text |
| Concealment | Hidden item state lost | Concealed items |

### Recommendation

The `CharacterItems` schema should support instance overrides. At minimum:
- `customName` (nullable) — for renamed items
- `currentCharges` — for wands/staves
- `instanceValues` (JSON) — for per-instance value overrides

---

## 5. Player Fields Dropped

**Impact: MEDIUM to LOW**

### Medium Impact (game-relevant persistent data)

| Field | Description | % Players With Data |
|-------|-------------|---------------------|
| `saving_throws` | Paralysis/Rod/Petrification/Breath/Spell saves | 100% |
| `life_force` | Life, Undead, Magic, Celestial, etc. | 100% |
| `composition` | Flesh, Earth, Air, Fire, etc. | 100% |
| `trophy` | Kill tracking data (mob type, ID, count) | 58% |

Saving throws, life force, and composition are **character-defining attributes** that
100% of players have. These are not runtime state — they're persistent character data.

### Low Impact (runtime state / preferences)

| Field | Description | % Players With Data |
|-------|-------------|---------------------|
| `preference_flags` | AUTOEXIT, BRIEF, COMPACT, etc. | 100% |
| `effect_flags` | Active magical effects | 48% |
| `gossips` | Recent gossip messages | 44% |
| `tells` | Recent tell messages | 36% |
| `effects` | Active spell effects (duration, etc.) | 8% |
| `quit_reason` | Rent/Cryo/Camp/Quit/etc. | 100% |
| `clan` | Clan membership | 2% |
| `current_title` | Current clan/custom title | 4% |
| `host` | Last login IP | 100% |

These are generally acceptable to lose — they're runtime state that resets on login,
UI preferences that can be reconfigured, or ephemeral message history.

---

## 6. Pet Files

**Impact: LOW**

| Metric | Count |
|--------|-------|
| Total .pet files | 1,578 |
| With valid mob vnum | 44 |
| Mob prototype missing from DB | 10 |
| Currently imported to DB | 0 |

Only 44 players actually have pets. 10 of those reference mob prototypes that don't
exist in the database. The importer supports pet import but may not be running
(0 imported to DB — could be an ordering issue or the import-players command
wasn't run after the pet import code was added).

---

## 7. Immortal Notes

**Impact: LOW**

254 non-empty `.notes` files containing admin notes about players (warnings, bans,
observations). Example:
```
Daedela  (Feb 15 2022) [ 3088]  has been warned to deactivate assist triggers...
```

These have historical/administrative value but aren't needed for gameplay.

---

## Summary: Priority Action Items

### P0 — Fix Now (Major Data Loss)
1. **Container contents (170,266 items)**: Use full parser, recursively import nested items
2. **Missing zone 5 objects (1,090 quest rewards)**: Import zone 5 object definitions

### P1 — Fix Soon (Significant Data Loss)
3. **Quest progress (8,255 entries, 1,796 players)**: Parse and import .quest files
4. **Unresolved zone items**: Investigate zones 124, 535, 581 for importable objects
5. **Item instance properties**: Add customName, currentCharges to CharacterItems schema

### P2 — Nice to Have
6. **Player saving_throws, life_force, composition**: Add to Characters schema
7. **Trophy/kill data**: Add CharacterTrophy table
8. **Pet import verification**: Verify pets are actually being imported (0 in DB)
9. **Zones 31/32/118 consumables**: Decide whether to import shop zones

### Acceptable Losses
- Runtime effects, cooldowns, spell durations (reset on login anyway)
- UI preferences (players can reconfigure)
- Message history (tells, gossips)
- Immortal admin fields (grants, poof messages, OLC zones)
- Immortal notes (historical only)
