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

Before doing per-table work, run these existing seeders — they would
zero-out a chunk of section 1:

```bash
# achievement catalog (currently 0 rows; seeder + grant-call sites already exist)
poetry run fierylib seed achievements

# regenerate room layout coordinates (layout_x/y/z all NULL right now)
poetry run fierylib layout generate

# re-seed game-settings to fill in any new SystemText / LevelDefinition rows
poetry run fierylib seed game-settings
```

`achievements` + `layout` were skipped by whoever last ran the import.
`full_reset_and_import.sh` already wires achievements / layout but they
were apparently bypassed. The remaining sections assume those have been
run.

---

## 1. Wholly empty catalog tables that runtime reads

Tables with 0 rows where Rust code already issues `SELECT … FROM "X"`.
Any of these silently degrade behavior on a real player session.

### P0 — blocks visible behavior

- **`achievement` (0 rows)** — Runtime: `mud-db/src/achievements.rs::list_all`,
  hydrated into `mud_world::AchievementCatalog`; `combat.rs::1683` calls
  `grant_achievement(world, killer, "first_kill")`, `combat.rs::2242`
  emits `level_<n>` on each level-up. With the catalog empty, every call
  logs `grant_achievement: unknown code` and the player sees nothing on
  the `achievements` listing. Source of truth:
  `fierylib/src/fierylib/seeders/achievement_seeder.py` (static combat
  achievements + one `zone_<id>_cleared` per inhabited zone). Just run
  `poetry run fierylib seed achievements`.

- **`Room.layout_x/y/z` (0/10296 rooms populated)** — Runtime: `mud-net`
  GMCP map frame + the `map`/`scan` commands rely on this for the ASCII
  minimap. With every row NULL, the map shows blank or breaks. Generator:
  `fierylib layout generate`. Step 8 of `full_reset_and_import.sh`.

### P1 — empty, runtime reads OK with empty set

- **`HelpEntry` (0 rows)** — Runtime: `mud-db/src/help.rs`, surfaced by
  the `help` command. Without rows, every `help <topic>` answers "no
  help". Source: legacy `lib/text/help/*` + `fierylib seed help-entries
  --clear` (step 6 of full_reset). Re-run.

- **`ConsumableEffects` (0 rows)** — Runtime: `mud-db/src/consumable_effects.rs`,
  hydrated into `ConsumableEffectCatalog` and consumed by
  `commands.rs::spawn_consumable_effect` (drink-container `quaff`, eat,
  liquid-effects). Schema is there for both `Liquids.id`-bound and
  `Object.id`-bound effects. Source: needs a `fierylib seed
  consumable-effects` step authoring at minimum potion / scroll → ability
  bindings (e.g. "potion of healing" object proto → `cure_light` ability
  on quaff). Currently `info.rs::753` literally prints "Effects (hunger,
  ConsumableEffects) are deferred." Authoring template: walk every
  `ObjectType=POTION|SCROLL|WAND|STAFF` and map the legacy
  `values.spell_1/2/3` to an `AbilityEffect` binding. Same shape for
  drink-containers via `Liquids`. **High value for player experience —
  potions are dead inventory today.**

- **`MobAbilities` (0 rows)** — Runtime: not currently loaded by any
  `mud-db` file (verified via grep). When mob casting is wired, this
  table is the natural source for "what spells does this mob know?".
  Today mobs only autocast hardcoded behavior. Schema exists, importer
  doesn't. **No P0 because runtime doesn't read it** — but if mob casting
  ships, this is the source-of-truth table.

- **`MobDefaultEffects` (0 rows)** — Runtime: not loaded. This is the
  intended source for "permanent auras / passives on this proto" (e.g.
  the lich's permanent fear aura). Source: needs an importer that walks
  legacy mob `aff_flags` → modern Effect IDs. Adjacent to B3 in the
  engine doc.

- ~~**`ObjectResistance` (0 rows)**~~ Partially closed 2026-05-17.
  Object importer now emits ObjectResistance rows for legacy
  `EFF_PROT_*` / `*SHIELD` / `NEGATE_*` effect flags
  (`PROTECT_FIRE/COLD/AIR/EARTH` → FIRE/COLD/SHOCK/ACID @ 25%,
  `FIRESHIELD/COLDSHIELD` → COLD/FIRE @ 25%, `NEGATE_*` → 100%
  immunity). Backfill script `scripts/backfill_object_resistance.py`
  populated 11 rows from imported zones (out of 43 legacy items
  carrying protection flags — 32 live in zones that aren't yet
  imported). Future `import-legacy` runs round-trip the rows via
  `object_importer.py::EFFECT_TO_RESISTANCE`. Still defer-pending:
  `EFF_MINOR_GLOBE` / `EFF_MAJOR_GLOBE` are spell-circle-filter
  absorbs that don't map to a single ElementType; `PROTECT_EVIL` /
  `PROTECT_GOOD` are alignment-vs-alignment, not element. See engine
  doc for the schema asks.

- **`Quest` / `QuestObjective` / `QuestPhase` / `QuestPrerequisite`
  / `QuestReward` / `QuestDialogue` / `DialogueTree` / `DialogueNode`
  / `DialogueResponse` (all 0 rows)** — Runtime: `mud-db/src/quests.rs`
  loads them; `mud-db/src/dialogue.rs` reads dialogue trees. Today
  `quest` command returns "no quests known". Quest importer exists
  (`fierylib/src/fierylib/importers/quest_importer.py`) but the
  full_reset script only invokes it under `--with-players` (step 9b).
  Run with `--with-players` or invoke `poetry run fierylib import-quests`
  separately. **Player-facing gap if quest content was authored
  legacy-side.**

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
- **`Objects.allowed_races` / `restricted_races` (0/3496)** — Schema for
  race-gated wear. `restricted_class_ids` is populated for 945 items, so
  the importer does write restrictions — just not the race axis. May be
  fine if legacy data didn't carry it.
- **`Objects.min_size` / `max_size` (0/3496)** — Engine **B6** consumer
  is shipped but every object accepts every size today.

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

- **`AbilitySavingThrow` (2/408)** — Almost no spells have a save
  configured. With only 2 rows, only those 2 ever roll a save. Likely
  legacy data dropped this in import — needs a sweep against legacy
  source spells.json / spec_procs.

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
  - 22 playable races. Only `Elf` (1) and the 5 dragonborn races (1
    each) have any `RaceAbilities` row — most playable races have 0
    racial abilities authored.
  - `RaceEffects` covers 17 playable + 6 unplayable races (passive
    racial effects like dwarven con bonus or drow infravision).
    `Human`, `Half-Elf`, `Goliath`, `Nymph`, `Orc` (all playable) have
    0 `RaceEffects` — likely intentional ("plain" races) but worth
    verifying.
  - `RaceSpellSlotBonus` has 0 rows for any race. Pair with engine **B4**.
  **P1 gap:** racial abilities / passives for the 16 playable races
  without `RaceAbilities` (Human, Gnome, Dwarf, Drow, Duergar,
  Half-Elf, Halfling, Sverfneblin, Goliath, Faerie-Seelie,
  Faerie-Unseelie, Nymph, Troll, Ogre, Orc, and the dragonborn variants
  beyond their single ability). Legacy races.json source already exists
  (`fierylib/data/races.json`, 36 entries) — needs an importer pass to
  author the per-race ability list.

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

- **B2** (bashable doors) — needs §2 `RoomExit.hit_points` populated.
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
- **K1** (cast time consumer in runtime) — needs the per-circle default
  table seeded into `GameConfig` (`spells.cast_time_default_circle_N`)
  and per-ability overrides on the existing `cast_time_rounds` column.
  Today most spells = 1, big AoEs vary; sweep the catalog for a sane
  ladder once the runtime consumer (engine §K1) lands.
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
  - `room` — 10 spells (CIRCLE_OF_FIRE, DARKNESS, WALL_OF_FOG, etc.).
    Need a `RoomEffectInstance` consumer; today the marker lands on
    the caster instead of the room.
  - `summon` — 7 spells (ANIMATE_DEAD, CLONE, SUMMON_DEMON, etc.).
    Need a spawn-companion arm. CHARM equivalent exists for taming
    existing mobs; summon needs a fresh proto spawn.
  - `globe` — 2 spells (MINOR_GLOBE, MAJOR_GLOBE). Engine §J1 — needs
    a spell-circle absorb gate.
  - `inspect` — 1 spell (IDENTIFY). Should print the same output
    `cmd_identify` does on a non-spell-cast path.
  - `resurrect` — 1 spell. Needs corpse → live-entity revival.

Sequencing recommendation: implement the **status consumer table**
first (highest ROI) — a `Stats:: total_acc_bonus_from_effects(...)`
walker the combat pipeline calls, plus parallel walkers for armor,
ward, vision, movement. Once that lands, 60 spells become functional
overnight. Other effect-type arms are smaller scope; do them as
needed.
