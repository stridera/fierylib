# Content gap audit — `fierydev` PostgreSQL DB

**Generated:** 2026-05-16. Live audit of the dev database after the most recent
import. Companion to `/home/strider/Code/mud/fierymud-rs/docs/design/remaining-work.md`
(runtime / engine remaining work). This file tracks *content* gaps a
seeder/importer can fill — no code changes required for most items.

A handful of items overlap with the engine doc; cross-references are noted
inline. Items marked **DONE in part** mean the data is partially imported
and just needs a wider sweep, vs. completely empty (which need a fresh
seeder run).

Conventions:
- **P0** — would block player-visible behavior on next playtest.
- **P1** — blocks builder workflow / immersion / a future feature already wired.
- **P2** — polish, optional, or waiting on engine work.

Counts captured 2026-05-16 against `fierydev` on minastirith.

---

## 0. Quick-win runbook

Status note (2026-05-17): `full_reset_and_import.sh` now invokes the
achievement seeder explicitly (step 8, commit `3391cf9`) so a fresh
run zeroes out the prior `achievements` + `layout` gap on its own.
Last DB state has achievement=146, layout=10296/10296.

If you ever want to run those seeders standalone:

```bash
poetry run fierylib seed achievements           # 146 rows
poetry run fierylib layout generate             # 10296 rooms
poetry run fierylib seed game-settings          # config + levels + text
```

---

## 1. Wholly empty catalog tables that runtime reads

Tables with 0 rows where Rust code already issues `SELECT … FROM "X"`.
Any of these silently degrade behavior on a real player session.

### P0 — blocks visible behavior

- ~~**`achievement` (0 rows)**~~ ✅ Closed 2026-05-17. 146 rows
  (6 COMBAT + 6 MISC + 134 EXPLORATION zone-clears). Seeder wired
  into `full_reset_and_import.sh` step 8 (commit `3391cf9`).

- ~~**`Room.layout_x/y/z` (0/10296 rooms populated)**~~ ✅ Closed
  2026-05-17. All 10296 rooms have layout coordinates. Already
  wired into the full-reset script.

### P1 — empty, runtime reads OK with empty set

- ~~**`HelpEntry` (0 rows)**~~ ✅ Closed earlier — 775 rows.
  Audit was stale at write-time.

- ~~**`ConsumableEffects` (0 rows)**~~ ✅ Closed earlier — 167
  rows. Audit was stale at write-time; the seeder shipped in a
  prior pass.

- **`MobAbilities` (0 rows)** — Defer. Runtime doesn't load this
  table yet. When mob-casting AI ships, populate from a new
  importer pass. Engine §J3 follow-up tracks the consumer.

- **`MobDefaultEffects` (0 rows)** — Defer. Runtime not loading
  (audit doc §1; engine doc J3). When the consumer ships, fierylib
  populates from legacy mob `aff_flags`.

- ~~**`ObjectResistance` (0 rows)**~~ Partially closed 2026-05-17.
  Importer emits per-element resistance rows from legacy
  `EFF_PROT_*` / `*SHIELD` / `NEGATE_*` effect flags
  (`PROTECT_FIRE/COLD/AIR/EARTH` → FIRE/COLD/SHOCK/ACID @ 25%,
  `FIRESHIELD/COLDSHIELD` → COLD/FIRE @ 25%, `NEGATE_*` → 100%).
  Backfill landed 11/43 rows (the 32 remaining live in unimported
  zones and round-trip on full reset). Engine schema asks J1
  (MINOR/MAJOR_GLOBE circle absorb) and J2 (PROTECT_EVIL/GOOD
  alignment resist) cover the legacy shapes that don't fit
  `ObjectResistance.element`.

- **`Quest` (87 rows) / `QuestObjective` / `QuestPhase` /
  `QuestPrerequisite` / `QuestReward` / `QuestDialogue` /
  `DialogueTree` / `DialogueNode` / `DialogueResponse` (all 0
  rows)** — Quest headers imported by `quest_importer.py` (re-run
  in full reset). The objective / phase / dialogue tables are
  empty because **legacy CircleMUD never authored structured
  quest content** — quest progression lived in DG-script triggers
  per zone. `lib/misc/quests` is just `name → id → max_stage`
  (85 entries). Filling these tables would require reverse-
  engineering each trigger to extract objective/phase boundaries
  — content-author task per zone, not an importable sweep. **Defer**
  unless a builder picks it up.

### P2 — schema-present, runtime not consuming yet (don't author until consumer ships)

These exist for symmetry but should NOT be filled in until the engine
side lands — see referenced engine-doc items.

- **`CombatMessage`** — engine **C1**.
- **`PositionMessage`** — engine **C2**.
- **`SystemMessage`** — engine **C3**.
- **`PositionData`** + `_PositionAppliesEffect` — engine **C4**.
- **`RaceSpellSlotBonus`** — engine **B4** (runtime not reading yet).
- **`RoomEnvironmentalEffect`** — runtime *does* read this (loader
  loop at `mud-world/loader.rs::1064`), and the consumer at
  `commands.rs::6243` is wired. 0 rows means no room currently applies
  a passive Effect (e.g. "icy cave drains 1 HP / tick"). Authoring this
  needs a builder pass per zone — defer unless a zone-owner asks. **P2**
  in audit terms.
- **`AbilityComponent`** — Runtime: `mud-db/src/ability_components.rs`
  loads it; `commands.rs::11197` walks `AbilityComponentReq` to consume
  spell components. 0 rows means components are never required even if
  a spell flags them. Engine **E9** territory (spellbook + components).
- **`AbilitySchool`** — Runtime: no consumer in `mud-db` or `mud-server`
  yet (`grep` found nothing). `Ability.school_id` is NULL for all 408
  abilities. Engine **E9**.

---

## 2. Sparse / under-populated columns

Columns that exist and are partly populated; the gap is content
authoring, not engine work.

### P1

- **`Ability.school_id` (0/408 populated)** — Pair with §1 `AbilitySchool`.
  Defer until the schools list is finalized engine-side.

- **`Ability.memorization_time` (0/408 > 0)** — Default 0, no spell has a
  memorization tax. Engine **E9**. Defer until memorization system lands.

- **`Ability.pages` (250/408 > 0)** — Most spells have spellbook page count
  authored; 158 are 0. This drift is consistent with abilities.json having
  been the source for the populated entries — skills/songs/chants etc.
  legitimately don't have pages. Probably correct as-is.

- **`Ability.lua_script` (0/408 populated)** — Engine **E9** (lua hook).
  Defer.

- **`Ability.contested_visibility` + `visibility_check` (9 + 9 of 408)** —
  Used by hide/invisibility detection — only 9 abilities author it. May be
  intentional (only stealth-relevant spells use it).

- **`Mobs.aggression_formula` (597/2139 populated, 28%)** — **Update needed
  in the engine doc.** The B3 bullet in `remaining-work.md` says "0 mobs
  have the column populated" but the importer has clearly run. 597 mobs
  carry a Lua expression like
  `(target.alignment <= ALIGN.EVIL) or (target.race.alignment == 'EVIL')`.
  The blocker on B3 is now just *wiring the runtime tick*, not data. The
  other 1542 mobs are intentionally non-aggressive (trainers, shopkeepers,
  trash mobs in cleared zones). **Action:** edit engine doc B3 to drop
  the "0 mobs" claim.

- **`Mobs.rider_presence_message` (0/2139)** — Engine **E6** (mount
  system). Defer.

- **`Mobs.activity_restrictions` (0/2139)** — Engine **E7** (Lua
  schedule). Defer.

- **`Room.is_death_trap` (0/10296)** — Modern flag, never set.
  Legacy DEATH room flag existed; either importer doesn't translate it
  or every legacy DT room was content-decided to be removed. Worth a
  builder pass to confirm intent — at minimum the classic "Junker's
  Junkyard" / "Slug Pit" type rooms.

- **`Room.entry_restriction` (32/10296)** — Authored where it matters
  (gated/quest-only rooms). Probably correct.

- ~~**`RoomExit.hit_points` (0/25929)**~~ ✅ Closed 2026-05-17.
  Importer now derives HP per door from state + key presence + HIDDEN
  flag (50 base, +50 with key, +100 if LOCKED, +30 if HIDDEN; band
  50-230). 1214 / 1214 IS_DOOR exits populated; non-doors stay NULL
  (correctly not bashable). Live DB backfilled via SQL; future
  `import-legacy` runs round-trip the same values from
  `room_importer.py`. Engine B2 data half is done.

- **`Objects.fixture_room_zone_id` (0/3496)** — Engine **E1**.
- **`Objects.passenger_capacity` (0/3496)** — Engine **E2**.
- **`Objects.presence_override` (0/3496)** — Engine **E3**.
- ~~**`Objects.allowed_races` / `restricted_races` (0/3496)**~~ —
  **Verified 2026-05-17: zero legacy items carry race-gating flags
  in `lib/world/obj/*.json`.** The `flag_normalizer` mappings exist
  (`ELVEN`/`DWARVEN` → allowed_races, `ANTI_ARBOREAN` → restricted_
  races) so any future builder content lights them up automatically.
  Not a gap — matches legacy intent.
- ~~**`Objects.min_size` / `max_size` (0/3496)**~~ — **Verified
  2026-05-17: zero legacy items carry the `ANTI_TINY` / `ANTI_SMALL`
  / `ANTI_LARGE` family flags.** Engine B6 consumer is wired, but
  there's no source data to import. Not a gap — matches legacy
  intent.

- **`Effect.parameters` / `Effect.default_params`** — schema column is
  `default_params jsonb DEFAULT '{}'`. With only 28 Effect rows and a
  parameterized-effects seeder, this is likely fine. Worth a spot-check
  by another agent that the parameters JSON column has non-trivial
  values for at least the damage/heal/stat_mod rows.

- **`AbilityRestrictions` (26/408 abilities have a row)** — class /
  level / alignment gates for spells. 382 abilities have no restriction
  row → they're freely castable by anyone who knows the ability.
  Knowing-the-ability is the *real* gate (via `ClassAbilities`), so this
  is probably correct, but worth verifying that quest-only / race-only /
  level-min gates aren't being dropped.

- **`AbilityTargeting` (9/408)** — Only 9 abilities have an explicit
  targeting row. Runtime falls through to `def.violent` / `target_scope`
  default, which works for single-target spells but misses
  area / room-scope semantics. Engine **I8** noted
  `HELLFIRE_BRIMSTONE` needs a `scope = ROOM_ENEMIES` row added —
  this is the *content* half of that fix. Pair with the cone spell list
  (`ACID_BREATH`, `FIRE_BREATH`, `FROST_BREATH`, `GAS_BREATH`,
  `LIGHTNING_BREATH`, `VAMPIRIC_BREATH`, `CONE_OF_COLD`,
  `BURNING_HANDS` if reverted to cone).

- ~~**`AbilitySavingThrow` (2/408)**~~ Closed 2026-05-17 to 126 rows.
  Authoring script `scripts/author_saving_throws.py` walks the
  catalog and writes one save per violent SPELL/CHANT/SONG, picking
  SaveType from the spell's flavor:
    - REFLEX (53) for elemental damage (FIRE/COLD/SHOCK/ACID/etc.)
      and dodge-class debuffs (ENTANGLE/WEB/BIND)
    - WILL (65) for divine/death/mental damage + generic enchantment
      debuffs (CHARM/CONFUSION/BLINDNESS)
    - FORTITUDE (8) for biological debuffs (POISON/DISEASE/PARALYSIS/
      PETRIFICATION/SLEEP)
  Uniform DC: `10 + skill / 5 + max(int_bonus, wis_bonus)`.
  onSaveAction = NEGATE for most; HALF_DURATION for long curses
  (CURSE/DOOM/INSANITY/MADNESS). Legacy fierymud halved damage on
  save; the runtime only ships NEGATE / HALF_DURATION arms today, so
  damage spells use NEGATE (engine ask §K2 for HALF_DAMAGE). 232
  non-violent buffs intentionally don't get saves.

### P2

- **`ShopItems.visibility_requirement` / `purchase_requirement`
  (0/424)** — Engine **E14**. `spawn_chance` is populated for all 424
  rows (default 1.0). The two gating columns are unauthored. Defer
  until builder workflow surfaces the need.

- **`ShopMobs` (0 rows)** — Mob-as-merchandise (think pet shops). 0
  rows means no shop sells mobs. Probably correct unless any legacy
  zone had a pet trader.

- **`Mobs.notes` / `tags`** — **Schema doesn't have these columns**
  on `Mobs` (verified via `\d`). Removed earlier — engine doc E4 already
  notes this. No-op.

---

## 3. Drift / under-imported families

Cases where the JSON source is richer than the DB rows, or where the
importer skipped a section.

- **Abilities.json source vs DB Ability rows.** JSON has 405 entries,
  DB has 408. The 3 extras are likely seeder-injected variants. The
  H/I-section formula rewrites (see engine doc §I) updated the JSON
  but the DB still has some pre-rewrite rows — fierymud-rs **I8**
  enumerates 6 spells that were hand-patched in the live DB. A clean
  `fierylib seed magic-system` re-run would re-author them from JSON
  and make those patches obsolete. **Recommend doing this as the first
  housekeeping step**, then re-verifying H.5 / I-section spells.

- **Per-class authoring (`ClassAbilities` + `ClassSkills`):**
  | Class       | abilities | skills | Notes |
  |-------------|-----------|--------|-------|
  | Sorcerer    | 46 | 0  | pure caster, correct |
  | Cleric      | 56 | 3  | correct |
  | Thief       | 0  | 18 | correct (skill class) |
  | Warrior     | 0  | 19 | correct (skill class) |
  | Paladin     | 17 | 21 | hybrid, correct |
  | Anti-Paladin| 18 | 22 | hybrid, correct |
  | Ranger      | 18 | 18 | hybrid, correct |
  | Druid       | 52 | 7  | correct |
  | Shaman      | 37 | 6  | correct |
  | Assassin    | 0  | 16 | correct (skill class) |
  | Mercenary   | 0  | 22 | correct (skill class) |
  | Necromancer | 36 | 0  | pure caster, correct |
  | Conjurer    | 30 | 0  | correct |
  | Monk        | 0  | 28 | correct |
  | Berserker   | 0  | 26 | correct |
  | Priest      | 62 | 3  | correct |
  | Diabolist   | 56 | 3  | correct |
  | Mystic      | 29 | 4  | correct |
  | Rogue       | 0  | 19 | correct (I.6 sealed in last pass) |
  | Bard        | 57 | 26 | correct |
  | Pyromancer  | 44 | 0  | correct |
  | Cryomancer  | 45 | 0  | correct |
  | Illusionist | 37 | 3  | correct |
  | Hunter      | 0  | 19 | correct (skill class) |
  No per-class authoring gaps detected — every class has at least one
  ability or skill. **No P0/P1 item here**, just confirmation.

- **Per-race authoring (`RaceAbilities` / `RaceEffects` /
  `RaceSpellSlotBonus`):**
  - 22 playable races. **Status corrected 2026-05-17:** 8 races now
    carry `RaceAbilities` rows (was 6 — DROW and ELF SLASHING entries
    were silently failing to resolve in the importer's skill-name
    cache because it only indexed by display name, not `plain_name`).
    `race_importer.py::load_skill_mappings` now indexes by both, so
    races.json content like `"SKILL_SLASHING"` resolves to the
    ability whose `plain_name` is `SLASHING`. The remaining races
    (Human, Gnome, Dwarf, Duergar, Half-Elf, Halfling, Sverfneblin,
    Goliath, Faerie-Seelie/Unseelie, Nymph, Troll, Ogre, Orc) have
    no racial abilities in legacy `races.cpp::assign_race_skills` —
    those slots are intentionally empty by legacy design. Content
    decision needed if we want to author non-legacy racial perks.
  - `RaceEffects` covers 17 playable + 6 unplayable races (passive
    racial effects like dwarven con bonus or drow infravision).
    `Human`, `Half-Elf`, `Goliath`, `Nymph`, `Orc` (all playable) have
    0 `RaceEffects` — likely intentional ("plain" races) but worth
    verifying.
  - `RaceSpellSlotBonus` has 0 rows for any race. Pair with engine **B4**.

- **Triggers (`Triggers` 2730, attached 2016, orphan 714).** 714
  trigger rows aren't attached to any mob/object/room — these are
  either intentional library triggers or orphan content. Worth a sweep
  to confirm none of them are *supposed* to be attached. Suggested
  query for the next agent:
  ```sql
  SELECT t.zone_id, t.id, t.name, t."attachType"
  FROM "Triggers" t
  WHERE NOT EXISTS (SELECT 1 FROM "MobTriggers"    WHERE trigger_zone_id=t.zone_id AND trigger_id=t.id)
    AND NOT EXISTS (SELECT 1 FROM "ObjectTriggers" WHERE trigger_zone_id=t.zone_id AND trigger_id=t.id)
    AND NOT EXISTS (SELECT 1 FROM "RoomTriggers"   WHERE trigger_zone_id=t.zone_id AND trigger_id=t.id)
  ORDER BY t.zone_id, t.id;
  ```

- **Zones with no MobResets (16/134).** Most likely legitimately
  unbuilt zones, but worth a sanity check that no inhabited zone is
  accidentally absent from `MobResets`. Same for "Zones with no Mobs"
  (24/134) and "Zones with no Objects" (10/134).

---

## 4. Trigger health

- **Total triggers:** 2730
- **`needs_review = true`:** 111 (close to the 112 noted in engine doc E13)
- **`syntax_error != NULL`:** 0 (zero stored syntax errors — clean)

`needs_review` hot-spots by zone:

| Zone | Count | Likely owner |
|------|-------|--------------|
| 53   | 43    | Beast Master / Ranger questline |
| 87   | 9     | ? |
| 188  | 8     | ? |
| 580  | 8     | ? |
| 103  | 6     | ? |
| 390  | 6     | ? |
| 533  | 5     | ? |
| 52   | 4     | Pyromancer subclass quest |

Zone 53 alone holds 39% of all needs_review markers. Beast Master / Ranger
trophy triggers and Pumahl speech triggers dominate the sample. **P1
recommendation:** assign zone 53 to a builder for a single-zone audit
pass — that would clear nearly half of `needs_review` in one go.

Trigger source-of-truth: `fierylib/data/triggers/<zone_id>/<id>.{lua,toml}`
(107 zone directories). Fixes to specific triggers should be authored
there, not in the DB — the importer round-trips JSON → DB and any
DB-only edits get clobbered on next import.

---

## 5. Liquids / shops / quests / boards

- **Liquids (42 rows).** Engine doc F2 said "only 30 liquids imported" —
  that's stale; the seeder source (`liquid_seeder.py::LIQUID_DATA`) has
  42 hardcoded liquid tuples, all of which are in DB. The number is
  unlikely to grow further unless someone explicitly adds player-craftable
  / magical liquids. **F2 in the engine doc can be closed** — current
  count matches source.

- **Shops (79 shops, 424 ShopItems, 263 ShopAccepts, 0 ShopMobs).**
  Average ~5.4 items per shop, ~3.3 accepted types per shop. Reasonable
  density. `ShopMobs` 0 → no pet shops or mob-vendors. Spot-check
  whether any legacy zone had a pet trader (Mosswood / Faerie courts
  are usual candidates).

- **Boards (8 boards, 390 messages).** Healthy. Two archive boards
  (`Mortal Board Archive`, `Coding Board`) accept old content. No
  action needed.

- **Quests (0 across all quest-* tables).** See §1. Either the
  legacy zone files had no DG-script quest objectives, or the importer
  was skipped. Verify by running
  `poetry run fierylib import-quests --verbose` and watching for
  zero-import warnings.

---

## 6. Player content (informational, not blocking)

- **Users (3), Characters (6)** — minimal dev seed. Matches the
  expected test user roster from MEMORY.md.
- **CharacterAbilities (208)** — populated from seeder pass.
- **CharacterItems (0)** — no test users have starting gear in DB.
  Engine doc I.3 already covered this; the user_seeder.py grant is the
  fix.
- **player_houses / clan / discord_config / AccountMail /
  tell_message** — all 0 rows. Expected for a fresh dev env; these are
  player-created.

---

## 7. Tables to verify (low-priority sanity checks)

The following showed 0 rows but appear to be either runtime-write-only
or correctly empty on a dev DB. Listed for completeness so the
parallel agent doesn't waste time on them:

- `AuditLogs`, `BanRecords`, `Events`, `ChangeLogs`, `reports`,
  `script_error_log`, `entity_variables`, `account_items`,
  `discord_links`, `google_links`, `user_grants`, `BoardMessageEdit`,
  `_EffectImmunity`, `_prisma_migrations`.

`_EffectImmunity` is worth a single check — schema implies
"effect X grants immunity to effect Y" junction. If any Effect row
should imply blanket immunity to another (e.g. `petrified` ⇒ immune to
`poison`), this is the table. Currently 0 rows.

---

## Top 5 priorities (summary)

1. **`achievement` empty → grant_achievement calls all silently no-op.**
   Run `fierylib seed achievements`.
2. **`Room.layout_x/y/z` all NULL → map/scan broken.** Run
   `fierylib layout generate`.
3. **`HelpEntry` empty → `help` command returns nothing.** Re-run step 6
   of `full_reset_and_import.sh`.
4. **`RoomExit.hit_points` all NULL → engine B2 (bashable doors)
   blocked even after wire lands.** Needs importer to write HP per door
   from legacy door bits + tier default.
5. **`ConsumableEffects` empty → every potion/scroll/wand is inert
   inventory.** Authoring pass: walk `ObjectType=POTION|SCROLL|WAND|STAFF`
   protos and map legacy `values.spell_1..3` to `AbilityEffect` bindings.

## 8. New tables proposed (no schema yet)

### `CreationRecipe` — builder-editable creation lookup

**Why:** Minor Creation / Create Food / similar utility spells need a
builder-editable keyword → proto mapping. Today there's a 40-entry
hard-coded array in the Rust runtime (`MINOR_CREATION_KEYWORDS` in
`commands.rs`) and a single `objectZoneId`/`objectId` field on the
ability's `create` effect for the default. Both violate the
"data-over-code" rule.

**Proposed schema** (add to `muditor/packages/db/prisma/schema.prisma`):

```prisma
model CreationRecipe {
  id            Int     @id @default(autoincrement())
  abilityId     Int     @map("ability_id")
  keyword       String  // matched as abbreviation against the cast arg
  objectZoneId  Int     @map("object_zone_id")
  objectId      Int     @map("object_id")
  minSkill      Int?    @map("min_skill")     // null → no skill gate
  classId       Int?    @map("class_id")      // null → any class
  sortOrder     Int     @default(0) @map("sort_order")
  notes         String?

  ability  Ability  @relation(fields: [abilityId], references: [id], onDelete: Cascade)
  object   Objects  @relation(fields: [objectZoneId, objectId], references: [zoneId, id])
  gameClass Class?  @relation(fields: [classId], references: [id])

  @@unique([abilityId, keyword, classId])
  @@index([abilityId])
  @@map("creation_recipe")
}
```

**Initial seed rows** (replaces the Rust array + hand-patched defaults):

- For `MINOR_CREATION`, 40 rows mirroring `fierymud_legacy/src/constants.cpp:28`
  `minor_creation_items[]` — keyword + `(zone 10, id i)`.
- For `CREATE_FOOD`, 5 rows × 10 ids per class = 50 rows:
  - Cleric → (120, 0..9), Paladin → (110, 0..9), Priest → (100, 0..9),
    Anti-Paladin → (130, 0..9), Druid → (140, 0..9). Most of zones 100-140
    are not imported — the importer needs a sweep there too.
  - Plus one un-classed fallback row pointing at waybread (185, 8) so
    a generic Create Food still resolves.

**Runtime consumer:** `commands.rs::invoke_ability_with` `create` arm
loads `HashMap<ability_id, Vec<Recipe>>` from a new `CreationRecipeCatalog`
ECS resource. The arm walks the recipes for `def.id`, matches the cast
arg as an abbreviation, applies the optional class / min_skill filters,
and overrides the proto. The fallback (currently `objectZoneId` on the
ability effect) becomes the un-keyword'd row (`keyword = ""`).

**Then retire:**
- The hard-coded `MINOR_CREATION_KEYWORDS` const in `commands.rs`.
- The `objectZoneId`/`objectId` hand-patches on `AbilityEffect.override_params`
  for create spells.
- The `MINOR_CREATION` `if def.plain_name.eq_ignore_ascii_case(...)` special-case
  in the `create` arm.

**Muditor surface:** a CRUD table editor under the ability page,
filtered by `abilityId`. Same shape as `ObjectExtraDescriptions`.

**Priority:** **P2** — a hard-coded bridge ships today (commit hash
in `fierymud-rs` repo for Minor Creation arg lookup). The bridge
works; the schema cleanup is a "do it before the const ossifies"
follow-up.

---

## Cross-references to engine doc

The following engine-doc items have *data-side* corollaries here:

- **B2** (bashable doors) — runtime ✅ shipped 2026-05-17 (engine
  doc). Content side ✅ shipped 2026-05-17: legacy CircleMUD's
  `EX_*` bitfield never had EX_BASHABLE — every IS_DOOR exit was
  bashable by default. `room_importer.import_exit` now synthesizes
  BASHABLE for every IS_DOOR (skipping MAGICPROOF — story doors
  stay sealed). Live DB backfilled with the same rule: 1214 doors
  flipped BASHABLE in one UPDATE.
- **B3** (aggression_formula) — engine doc claims 0 mobs populated;
  reality is 597. Edit engine doc.
- **B4** (RaceSpellSlotBonus) — runtime not reading; defer.
- **B6** (object equip restrictions) — needs §2 `min_size`/`max_size` /
  `allowed_races` populated.
- **C1-C4** (flavor-text catalogs) — schema present, defer per engine doc.
- **E1-E3** (Object.fixture_room / passenger_capacity /
  presence_override) — engine work, no content yet.
- **E14** (Shop spawn controls) — §2 `ShopItems.visibility_requirement` /
  `purchase_requirement`.
- **F2** (liquid table seeded?) — close it: 42 rows match source.
- **I8** (HELLFIRE_BRIMSTONE area scope) — §2 `AbilityTargeting` needs
  the scope row.
- ~~**K1** (cast time consumer in runtime)~~ ✅ Closed 2026-05-17.
  Engine K1 (cast queue + cast_time_rounds consumer) shipped. Content
  sweep (`scripts/rebalance_cast_times.py`) raised cast_time_rounds
  on 30 high-circle spells where the authored value sat below the
  per-circle floor (C6-C7≥2, C8-C9≥3, C10+≥4) plus a +1-round nudge
  for AoE damage spells. Cast-time average curve went from a
  near-flat 1.6→3.4 to a much clearer 1.6 (C1) → 3.7 (C11). Cantrips
  and intentionally-fast spells stay at their authored low values
  (BURNING_HANDS at 2, MAGIC_MISSILE at 1).
- **K4** (dead-spell audit — content side) — once the runtime emits
  the dead-spell warn list, walk each unmapped effect_type and either
  (a) add the missing AbilityEffect rows pointing at an existing
  effect, or (b) add the new effect to `fierylib/data/effects.json` +
  re-seed. Common gaps from the 2026-05-17 sample: utility spells like
  `IDENTIFY`, `KNOW_SPELL`, `DIVINATION_*`, plus any SKILL row that
  was authored without AbilityEffect coverage. Tag each spell as
  "stub" / "missing effect" / "missing dispatcher arm" in
  `fierylib/data/abilities.json` notes field so a future content pass
  has the breakdown handy.
- **L** (summon family) — engine doc §L covers the SUMMON spell
  player-target gates (PRF_SUMMONABLE → `PlayerFlag::NO_SUMMON`,
  PLR_KILLER → `PlayerFlag::PK_ENABLED`, room/mob NoSummon, level
  cap, same-zone, arena asymmetry). All gates already have schema
  primitives — no new columns needed. Content-side TODOs:
  1. **User-file importer:** `user_importer.py` (or wherever the
     legacy player_files → Characters mapping lives) must translate
     legacy `PRF_SUMMONABLE` bit → CLEAR `NO_SUMMON` and *missing*
     bit → SET `NO_SUMMON`. Legacy default was "protected" (bit
     unset); our `NO_SUMMON = true` matches. Verify no inversion bug
     in the migration sweep.
  2. **Seed defaults:** confirm `user_seeder.py` test characters
     ship with `NO_SUMMON` in `playerFlags` by default; flip
     TestWarrior / TestMage / TestRogue to summon-protected; leave
     AdminChar / BuilderChar alone (gods bypass via
     `Permission::SUMMON` anyway).
  3. **Mob importer:** verify `mob_importer.py` carries legacy
     MOB_NOSUMMON / MOB_NOCHARM bits onto `MobBehaviors::NO_SUMMON`
     / `NO_CHARM` so the per-mob refusal works at runtime. Pull the
     row count after import to confirm a non-trivial population.
  4. **Optional SummonRecipe table** (deferred, mirrors §8
     CreationRecipe): builder-editable per-class table for the seven
     SUMMON_xxx conjuration spells. Defer schema until the runtime
     L1 (player-target summon) lands and L3 demand is concrete.

---

## 9.5. Status-effect flag dispatch (2026-05-17)

The catchall arm in `invoke_ability_with` now reads the
`override_params.flag` (falling back to `default_params.flag`) and
installs known markers on the target:

- `flag: "hidden"` / `"sneak"` / `"concealment"` → `Stealth` (was
  already wired for hidden/sneak; concealment added here).
- `flag: "fly"` → `Flying` — the drowning + movement-cost gates see
  the target as airborne.

`effects_tick` mirrors the Stealth teardown for Flying: when the
last backing instance with name `"fly"` expires, `Flying` is removed.
Race-set Flying remains (not subject to teardown).

Remaining flag dispatchers to wire when the matching marker /
consumer lands:

- ~~`bless` → +N accuracy.~~ ✅ 2026-05-17. `Bless` marker
  installed by the catchall arm when `flag == "bless"`;
  `apply_swing` adds a flat +5 to the attacker's accuracy when
  Bless is present. `effects_tick` removes the marker on the
  last backing instance.
- ~~`sanctuary` → halve damage.~~ ✅ 2026-05-17. `Sanctuary`
  marker installed by the catchall arm when `flag == "sanctuary"`;
  `apply_damage` halves positive incoming damage when the target
  carries it. Auto-removed by `effects_tick`.
- ~~`haste` → extra attack / +speed.~~ ✅ 2026-05-17. `Haste`
  marker installed by the catchall arm when `flag == "haste"`.
  `combat_tick` runs a Haste pass after the main swing pass and
  re-fires `apply_swing` for every Haste'd attacker whose target
  is still alive. `effects_tick` removes the marker on the last
  backing instance.
- ~~`detect_invisible` → see-invis.~~ ✅ 2026-05-17. `DetectInvis`
  marker installed by the catchall arm when
  `flag == "detect_invisible"`; auto-removed by `effects_tick`.
- ~~Magical Invisible / MASS_INVIS.~~ ✅ 2026-05-17. New
  `Invisible` marker + `InvisibleSource` tag on the EffectInstance
  entity. `can_see_player` returns false when the target carries
  `Invisible` and the viewer lacks `DetectInvis` or `HOLY_LIGHT`.
  Teardown checks for surviving `InvisibleSource` tags so a
  recast / overlapping cast holds the invisibility past the
  first expiry.
- ~~`resistance` (with `type` + `amount`) → write into the player's
  `Resistances` map.~~ ✅ 2026-05-17. Catchall arm parses
  `type` (mapped to `ElementType`) + `amount`, applies the delta
  to the target's `Resistances` map, and tags the EffectInstance
  with `SpellResistanceDelta` so `effects_tick` reverses the delta
  on expiry. Unlocks PROT_FROM_FIRE/COLD/AIR/EARTH/SHOCK/ACID,
  STONE_SKIN, NEGATE_* — every element-keyed protection spell.
  Alignment-keyed (`type: "evil"` / `"good"`) still deferred —
  needs the J2 alignment-protection axis.
- ~~`empowered` → next damage spell at +N%.~~ ✅ 2026-05-17.
  `Empowered` marker installed by the catchall arm when
  `flag == "empowered"`. The damage arm in
  `invoke_ability_with` consumes it (×1.5 damage, then removes
  the marker AND despawns the backing EffectInstance so the
  `effects` list stays accurate). `effects_tick` is the fallback
  removal for the duration-based expiry edge case.

Each consumer is small (~20 lines of Rust) but together they unlock
the 65 dormant buff spells. Author content-side per-spell tuning
notes against `fierylib/data/abilities.json` so the runtime tier is
recoverable from data.

---

## 9. Dead-spell audit (2026-05-17)

DB query against `fierydev` revealed:

- ~~**Zero-effect spells (12):** `GAIAS_CLOAK`, `INN_ASCEN`,
  `INN_BRILL`, `INN_STRENGTH`, `INN_SYLL`, `INN_TASS`, `INN_TREN`,
  `MONK_ACID`, `MONK_COLD`, `MONK_FIRE`, `MONK_SHOCK`, `RAY_OF_ENFEEB`.~~
  ✅ Closed 2026-05-17. Root cause: legacy plain-names (INN_*,
  RAY_OF_ENFEEB) were created by `skill_seeder` from CPP without
  effects, while abilities.json carried separate "modern"-named
  entries (INNATE_*, RAY_OF_ENFEEBLEMENT) with the actual effects.
  Class + character imports point at the legacy names, so they
  loaded the stub rows and silently no-op'd. Fix in
  `scripts/merge_duplicate_abilities.py`: collapsed the 7 duplicate
  pairs into the legacy plain-name, authored 4 MONK_*, PEACE, and
  GAIAS_CLOAK bodies (no legacy duplicate to merge), dropped the 7
  orphan modern rows. Total abilities went 408 → 401. Live verified:
  all 13 now carry an AbilityEffect row.

  Net behaviour: stat-boost spells (INN_*) apply modify-stat for
  ~50 hours at skill 100; RAY_OF_ENFEEB applies a -25 STR debuff;
  MONK_* deal `4d19 + pow(skill, 1.25)` of their element; PEACE
  fires the `stop_combat` effect (room scope); GAIAS_CLOAK applies
  +15-21 armor for 5-12 hours. Note that the runtime's `status` /
  `modify` consumer table isn't fully wired yet (engine §K4) — the
  effect rows land in `effects` lists but some are still decorative
  until those walkers ship. The catalog is correct now; runtime
  will catch up.

- **Effect types with no real consumer (catchall arm spawns a marker
  but nothing reads it):**
  - `status` — 65 spells (BLESS, INVISIBLE, STONE_SKIN, FLY, HASTE,
    DETECT_MAGIC, etc.). Today only `blind`, `drag`, `sneak`,
    `hidden`, `bleed` markers are read by gameplay code. The other
    60 markers exist in the player's `effects` list but mechanically
    do nothing. **Highest impact** — half the spellbook is decorative.
  - `room` — light + burning ✅ 2026-05-17. New "room" arm in
    `invoke_ability_with`: parses `params.type`, installs a marker
    on the caster's room entity with a backing `EffectInstance`
    via `AppliedTo(room)` for duration tracking. Today's coverage:
    `light` → `RoomMagicalLight` (ILLUMINATION, MAGIC_TORCH);
    `darkness` → `RoomMagicalDarkness` (DARKNESS); `burning` →
    `RoomBurningEffect { damage_per_move }` (CIRCLE_OF_FIRE). The
    burning marker is consumed in `cmd_move`: leaving the room
    deals `damage_per_move` HP to the mover, with a flavor line.
    Live-DB fix: CIRCLE_OF_FIRE marked `violent=false` so it
    self-targets and the room arm runs. `room_is_dark` /
    `room_has_light` consult the markers first, so a player can
    cast ILLUMINATION at night and immediately see the room.
    Remaining types still decorative (no consumer): `fog`,
    `ice`, `stone`, `illusion` barriers — need exit-blocking
    machinery.
  - `summon` — 7 spells (ANIMATE_DEAD, CLONE, SUMMON_DEMON, etc.).
    Need a spawn-companion arm. CHARM equivalent exists for taming
    existing mobs; summon needs a fresh proto spawn.
  - `globe` — 2 spells (MINOR_GLOBE, MAJOR_GLOBE). Engine §J1 — needs
    a spell-circle absorb gate.
  - ~~`inspect` — 1 spell (IDENTIFY).~~ ✅ 2026-05-17. New
    "inspect" arm in `invoke_ability_with` routes the cast's
    target_word through `cmd_identify` so the player gets the
    full property panel, then flips the per-item Identified
    marker (legacy semantic: give/sell carries the knowledge
    with the item).
  - ~~`resurrect` — 1 spell.~~ ✅ 2026-05-17. New "resurrect" arm
    in `invoke_ability_with`: target must be a Player with the
    Ghost component. Restores HP to 50% max, removes Ghost,
    moves the player to the caster's room. Equipment transfer
    from the corpse is a follow-up — players still walk back for
    their gear. Live verified the refusal path ("AdminChar isn't
    a wandering spirit"). Full revival flow needs a death-and-
    rez playtest with two real characters.

Sequencing recommendation: implement the **status consumer table**
first (highest ROI) — a `Stats:: total_acc_bonus_from_effects(...)`
walker the combat pipeline calls, plus parallel walkers for armor,
ward, vision, movement. Once that lands, 60 spells become functional
overnight. Other effect-type arms are smaller scope; do them as
needed.

---

## Rest / Repose system (2026-05-17)

Companion to
[`/fierymud-rs/docs/design/rest-and-repose.md`](../fierymud-rs/docs/design/rest-and-repose.md)
and
[`/fierymud-rs/docs/adr/0001-rest-system-tradeoffs.md`](../fierymud-rs/docs/adr/0001-rest-system-tradeoffs.md).
Vocabulary in
[`/muditor/CONTEXT.md`](../muditor/CONTEXT.md) under "Resting and
Repose".

This block owns the **schema migration** for the rest system.

### Status 2026-05-17

- ~~**RR1. Update Prisma schema.**~~ ✅ Closed. Schema additions
  landed in `/muditor/packages/db/prisma/schema.prisma`:
  `RestSource` enum, three `Characters` columns (`repose`,
  `restSource`, `restTier`), three `Rooms` columns (`isInn`,
  `innName`, `innTiers`), `Objects.campKitTier`, and the two
  junction tables `RoomWakeEffects` and `ObjectWakeEffects`.
- ~~**RR2. Regenerate clients + apply migration.**~~ ✅ Closed.
  Live DB now carries the new columns and tables (verified via
  `\d` against fierydev).
- ~~**RR3. Seed `Refreshed` Effect row.**~~ ✅ Closed.
  `data/effects.json` carries the Refreshed entry; row landed in
  DB as id 29 (effectType=`status`). Lua hooks for on_apply /
  on_tick / on_remove already captured in the JSON. Refresh
  hook math (`base_regen * 0.25 * strength`) lives in the on_tick
  body for runtime to consume.
- ~~**RR4. Importer defaults for new columns.**~~ ✅ Closed —
  no importer change needed. Prisma `@default` directives in the
  schema flow through on insert when fields are unspecified. Live
  verified: existing Characters rows after re-seed show
  `repose=0`, `restSource=NONE`, `restTier=0`; Room rows show
  `isInn=false` / `innName=null` / `innTiers=null`; Objects show
  `campKitTier=null`.
- **RR5. (Optional) Seed example wizard academy inn.** Deferred —
  blocked on FOCUS Effect not being seeded yet, and not needed
  for runtime unblock. Re-visit when fierymud-rs runtime fires
  the wake pipeline end-to-end and a smoke-test room is helpful.

**Blocker:** none. Runtime work (engine R1-R7) can proceed.
