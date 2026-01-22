# Trigger Review Status

## Summary
- Total: 2746 triggers
- Clean: 2220 (80.8%)
- Needs Review: 526 (19.2%)
- Syntax Errors: 295 (need converter improvements)
- UNCONVERTED Patterns: 54 (reduced from 274)

## Recent Changes (2026-01-22)

### Converter Improvements
Added support for wdoor subcommands in `dg_to_lua.py`:
- `wdoor ROOM DIR flags FLAGS` → `doors.set_flags()`
- `wdoor ROOM DIR name TEXT` → `doors.set_name()`
- `wdoor ROOM DIR key NUM` → `doors.set_key()`
- `wdoor ROOM DIR description TEXT` → `doors.set_description()`
- `wdoor %VAR% DIR room %VAR%` → `doors.set_exit()`
- Added orphaned text/fragment detection

### Deleted Unused Triggers
Removed 83 triggers marked as `**UNUSED**` across zones 1, 16, 18, 23, 28, 43, 52, 53, 60, 120, 123, 125, 133, 185, 188, 237, 300, 302, 364, 390, 410, 481, 484, 488, 490, 502, 510, 520, 534, 550, 554, 556, 580, 590, 615.

### Refactored Triggers
| Trigger | Change | Lines Reduced |
|---------|--------|---------------|
| 060_80 hearts_look_table | Indexed loop for 52 cards | 362 → 78 |
| 004_47 illusory_wall_progress_journal | Data-driven region table | 366 → 105 |
| 364_06 illusory_wall_lyara_status | Shared region data | 360 → 93 |

### New Shared Modules
- `shared/illusory_wall_regions.lua` - Shared region data for illusory wall quest
- `quest_helpers.lua` - Reusable functions for quest displays

## Needs Review

| Zone | ID | Name | Issue |
|------|-----|------|-------|
| 1 | 7 | Priest Quest Spell Hints | Complex nesting: 8 if statements |
| 1 | 9 | Sorcerer Quest Spell Hints | Complex nesting: 6 if statements |
| 1 | 10 | Cryomancer Quest Spell Hints | Complex nesting: 8 if statements |
| 1 | 16 | Bard combat songs AI | Complex nesting: 8 if statements |
| 103 | 4 | rianne-quest-receive | Complex nesting: 20 if statements |
| 103 | 5 | rianne-quest-look | Complex nesting: 19 if statements |
| 103 | 9 | khysan-greet | Complex nesting: 19 if statements |
| 103 | 18 | ice_shards_status_tracker | Complex nesting: 12 if statements |
| 103 | 23 | ice_shards_khysan_receive6 | -- UNCONVERTED: zone |
| 103 | 25 | Khysan refuse | Complex nesting: 9 if statements |
| 105 | 3 | Witch_rand2 | -- UNCONVERTED: pond |
| 105 | 6 | Old_Dweller_greet | Complex nesting: 6 if statements |
| 120 | 3 | Druid receive | Complex nesting: 11 if statements |
| 120 | 99 | twisted_sorrow_status_tracker | Complex nesting: 13 if statements |
| 123 | 6 | megalith_quest_priestess_recei | Complex nesting: 15 if statements |
| 123 | 11 | megalith_quest_priestess_speec | Complex nesting: 13 if statements |
| 123 | 12 | megalith_quest_priestess_speec | Complex nesting: 22 if statements |
| 123 | 13 | megalith_quest_keeper_greet | Complex nesting: 8 if statements |
| 123 | 14 | megalith_quest_keeper_speech | Complex nesting: 9 if statements |
| 123 | 15 | megalith_quest_keeper_receive | Complex nesting: 10 if statements |
| 123 | 23 | megalith_quest_mother_act_knee | Complex nesting: 11 if statements |
| 123 | 39 | east_exposition | Large script: 5835 chars |
| 123 | 42 | Keeper refuse | Complex nesting: 8 if statements |
| 125 | 20 | SilentOneRRTrig | Complex nesting: 6 if statements |
| 125 | 25 | DemonLordBow | Complex nesting: 17 if statements |
| 125 | 35 | Krisenna greet | Complex nesting: 8 if statements |
| 125 | 45 | Injured halfling help | Complex nesting: 6 if statements |
| 133 | 12 | tell_raph_Please | Complex nesting: 11 if statements |
| 133 | 28 | heavens_gate_pedestal_put | Complex nesting: 6 if statements |
| 133 | 29 | heavens_gate_key_seal | Complex nesting: 8 if statements |
| 133 | 31 | heavens_gate_starlight_status_ | Complex nesting: 36 if statements |
| 160 | 17 | myst_general_death | Complex nesting: 6 if statements |
| 160 | 23 | shadow_demon_death | Complex nesting: 6 if statements |
| 163 | 1 | quest_eleweiss_ranger_druid_su | Complex nesting: 6 if statements |
| 163 | 2 | quest_eleweiss_ranger_druid_su | Complex nesting: 11 if statements |
| 163 | 3 | quest_eleweiss_ranger_druid_su | Complex nesting: 10 if statements |
| 163 | 9 | quest_eleweiss_ranger_druid_su | Complex nesting: 9 if statements |
| 163 | 41 | dryad_moonwell_again | Complex nesting: 7 if statements |
| 172 | 3 | Ill-subclass: Grand Master sta | Complex nesting: 6 if statements |
| 172 | 16 | Ill-subclass: Grand Master's e | Complex nesting: 7 if statements |
| 172 | 18 | Ill-subclass: Flowers make peo | Complex nesting: 7 if statements |
| 18 | 28 | blur_ranger_speech2 | Complex nesting: 7 if statements |
| 18 | 34 | blur_winds_speech | Complex nesting: 11 if statements |
| 18 | 55 | test_for_nok | Complex nesting: 6 if statements |
| 185 | 1 | silania_welcome | Complex nesting: 13 if statements |
| 185 | 2 | quest_preamble_silania | Complex nesting: 14 if statements |
| 185 | 3 | start_quest_silania | Complex nesting: 14 if statements |
| 185 | 9 | Priest_Paladin_Subclass_Quest_ | Complex nesting: 10 if statements |
| 185 | 20 | group_heal_doctor_receive | Complex nesting: 10 if statements |
| 185 | 22 | group_heal_chefs_receive | Complex nesting: 6 if statements |
| 185 | 28 | Phase mace Sexton speech upgra | -- UNCONVERTED: 18528 - Sexton upgrade speech |
| 185 | 31 | Silania refuse | -- UNCONVERTED: msend %actor |
| 185 | 51 | **UNUSED** | Complex nesting: 9 if statements |
| 185 | 52 | p2_3eg_death_p2_55574_boss_18 | Complex nesting: 9 if statements |
| 185 | 99 | group_heal_status_check | Complex nesting: 21 if statements |
| 188 | 20 | xcast_xcast | Complex nesting: 21 if statements |
| 188 | 21 | xcast_xdecide | Complex nesting: 12 if statements |
| 188 | 44 | globe_get | Complex nesting: 7 if statements |
| 188 | 70 | smart combat | Complex nesting: 10 if statements |
| 188 | 80 | ctf_armband_tag | Complex nesting: 14 if statements |
| 188 | 81 | ctf_flag_get | Complex nesting: 11 if statements |
| 188 | 82 | ctf_flag_pass | Complex nesting: 7 if statements |
| 188 | 83 | test | -- UNCONVERTED: eval %speech% |
| 188 | 91 | summon_dragon | Complex nesting: 8 if statements |
| 188 | 93 | dragonegg_hatch | Complex nesting: 7 if statements |
| 188 | 97 | fierytag_bat_capturetheflag | Complex nesting: 18 if statements |
| 3 | 0 | phase wand bigby research assi | Complex nesting: 15 if statements |
| 3 | 1 | phase wand bigby research assi | Complex nesting: 12 if statements |
| 3 | 2 | phase wands bigby research ass | Complex nesting: 11 if statements |
| 3 | 3 | phase wands attack counter | Complex nesting: 10 if statements |
| 3 | 4 | phase wands give owner check | Complex nesting: 7 if statements |
| 3 | 5 | phase weapon owner wield check | Complex nesting: 8 if statements |
| 3 | 7 | phase wand and phase mace upgr | Complex nesting: 16 if statements |
| 3 | 8 | phase wand general receive | Complex nesting: 24 if statements |
| 3 | 9 | phase wand command imbue | Complex nesting: 18 if statements |
| 3 | 10 | Hell Trident attack manager | Complex nesting: 9 if statements |
| 3 | 11 | phase wand questmaster setup l | Large script: 6557 chars |
| 3 | 12 | phase wand general death | Complex nesting: 9 if statements |
| 3 | 13 | phase wand bigby research assi | Complex nesting: 41 if statements |
| 3 | 14 | phase wand status checker ques | Complex nesting: 31 if statements |
| 3 | 15 | phase mace speech upgrade | Complex nesting: 8 if statements |
| 3 | 16 | Phase mace progress | Complex nesting: 23 if statements |
| 3 | 19 | Phase Mace attack counter and  | Complex nesting: 7 if statements |
| 3 | 20 | Phase mace dig trigger | Complex nesting: 9 if statements |
| 3 | 26 | phase mace receive | Complex nesting: 23 if statements |
| 200 | 17 | rec_axe | -- UNCONVERTED: clothes. |
| 22 | 22 | Nezer_head_rip_1 | Complex nesting: 7 if statements |
| 22 | 44 | belial_combat_ai_script | Complex nesting: 8 if statements |
| 22 | 48 | belial_fissure_script | Complex nesting: 6 if statements |
| 23 | 1 | patriarch receives truthstone | Complex nesting: 13 if statements |
| 23 | 7 | high-druid-receive | Complex nesting: 6 if statements |
| 23 | 12 | hellfire_brimstone_status_chec | Complex nesting: 19 if statements |
| 23 | 14 | Hell Trident speech trident up | Complex nesting: 23 if statements |
| 23 | 15 | **UNUSED** | Complex nesting: 11 if statements |
| 237 | 5 | shroom-attack | Complex nesting: 8 if statements |
| 237 | 28 | serin-receive | Complex nesting: 10 if statements |
| 237 | 50 | vilekka-greet | Complex nesting: 8 if statements |
| 237 | 51 | vilekka-service | Complex nesting: 8 if statements |
| 237 | 52 | receive-rewards | Complex nesting: 40 if statements |
| 237 | 98 | sunfire_rescue_status_checker | Complex nesting: 9 if statements |
| 237 | 99 | vilekka_stew_status_check | Complex nesting: 17 if statements |
| 238 | 16 | mage_speak3 | Complex nesting: 10 if statements |
| 28 | 2 | waterform_wave_receive | -- UNCONVERTED: quest |
| 28 | 5 | waterform_water_death | Complex nesting: 9 if statements |
| 28 | 7 | waterform_wave_status_checker | Complex nesting: 22 if statements |
| 28 | 8 | **UNUSED** | Complex nesting: 15 if statements |
| 30 | 29 | quest_banter_magistrate3 | Complex nesting: 7 if statements |
| 30 | 30 | Myst_quest_reward | Complex nesting: 7 if statements |
| 30 | 31 | Phase Mace Templar speech upgr | Complex nesting: 6 if statements |
| 30 | 51 | Armor Exchange set type | Complex nesting: 17 if statements |
| 30 | 53 | Armor Exchange receive exchang | Complex nesting: 25 if statements |
| 30 | 81 | Dragon Slayers Isilynor Speech | Complex nesting: 15 if statements |
| 30 | 82 | Dragon Slayer Isilynor Speech  | Complex nesting: 10 if statements |
| 30 | 83 | Dragon Slayer Isilynor Receive | Complex nesting: 19 if statements |
| 30 | 88 | Paladin pendant command pray | Complex nesting: 15 if statements |
| 30 | 89 | Paladin Pendant progress track | Complex nesting: 19 if statements |
| 31 | 40 | Freddy random load doll | Complex nesting: 7 if statements |
| 31 | 56 | trainers not level gain | Complex nesting: 6 if statements |
| 31 | 60 | ***skill trainer speach*** | Complex nesting: 16 if statements |
| 31 | 65 | Calken trainer speech | Complex nesting: 17 if statements |
| 31 | 70 | shaman trainer speech | -- UNCONVERTED: Let's talk about improving a skill you actually know.' |
| 31 | 80 | load random gems | Complex nesting: 11 if statements |
| 31 | 82 | corpse retrieval price set | Complex nesting: 11 if statements |
| 300 | 20 | load random gems | Complex nesting: 8 if statements |
| 302 | 2 | Sliding into the abyss | Complex nesting: 7 if statements |
| 302 | 3 | Sliding into the abyss II | Complex nesting: 7 if statements |
| 302 | 4 | A mild avalanche | Complex nesting: 7 if statements |
| 302 | 12 | banish_murgbol_greet | Large script: 6154 chars |
| 360 | 20 | Girbina_Tickmaster_greet | Complex nesting: 22 if statements |
| 364 | 5 | illusory_wall_glasses_examine | -- UNCONVERTED: breal |
| 364 | 6 | illusory_wall_lyara_status | Complex nesting: 106 if statements |
| 364 | 16 | berserker_bear_death | Complex nesting: 7 if statements |
| 364 | 20 | berserker subclass progress ch | Complex nesting: 7 if statements |
| 370 | 18 | mes-rec | Complex nesting: 11 if statements |
| 390 | 4 | flood_heart_speech | Complex nesting: 19 if statements |
| 390 | 6 | flood_spirits_speech2 | Large script: 9311 chars |
| 390 | 7 | flood_spirits_receive | Complex nesting: 15 if statements |
| 390 | 9 | flood_frozen_death | Complex nesting: 6 if statements |
| 390 | 10 | flood_lady_status_checker | Complex nesting: 24 if statements |
| 4 | 1 | Adventure quests | Complex nesting: 16 if statements |
| 4 | 2 | Equipment quests | Complex nesting: 34 if statements |
| 4 | 3 | Heroes for Hire quests | Complex nesting: 6 if statements |
| 4 | 4 | Spell quests | Complex nesting: 79 if statements |
| 4 | 5 | Subclass quests | Complex nesting: 22 if statements |
| 4 | 6 | Troll Mask progress journal | Complex nesting: 12 if statements |
| 4 | 7 | Fiery Island Progress journal | Complex nesting: 6 if statements |
| 4 | 9 | Sunfire Rescue progress journa | Complex nesting: 11 if statements |
| 4 | 10 | Vilekka Stew progress journal | Complex nesting: 21 if statements |
| 4 | 11 | Guild Armor Phase One progress | Complex nesting: 27 if statements |
| 4 | 12 | Guild Armor Phase Two progress | Complex nesting: 28 if statements |
| 4 | 13 | Guild Armor Phase Three progre | Complex nesting: 28 if statements |
| 4 | 14 | Relocate progress journal | Complex nesting: 7 if statements |
| 4 | 15 | Moonwell progress journal | Complex nesting: 7 if statements |
| 4 | 17 | Emmath Flameball progress jour | Complex nesting: 12 if statements |
| 4 | 18 | Twisted Sorrow progress journa | Complex nesting: 14 if statements |
| 4 | 19 | Major Globe progress journal | Complex nesting: 13 if statements |
| 4 | 21 | Sacred Haven progress journal | Complex nesting: 12 if statements |
| 4 | 22 | Combat in Eldoria progress jou | Complex nesting: 15 if statements |
| 4 | 23 | Phoenix Sous Chef progress jou | Complex nesting: 20 if statements |
| 4 | 24 | Rhell Forest progress journal | Complex nesting: 11 if statements |
| 4 | 25 | Resurrection progress journal | Complex nesting: 26 if statements |
| 4 | 26 | Group Heal progress journal | Complex nesting: 24 if statements |
| 4 | 27 | Group Armor progress journal | Complex nesting: 18 if statements |
| 4 | 28 | Supernova progress journal | Complex nesting: 18 if statements |
| 4 | 29 | Meteorswarm progress journal | Complex nesting: 12 if statements |
| 4 | 30 | Banish progress journal | Complex nesting: 6 if statements |
| 4 | 31 | The Great Rite progress journa | Complex nesting: 28 if statements |
| 4 | 33 | Heavens Gate progress journal | Complex nesting: 37 if statements |
| 4 | 34 | Dragons Health Progress journa | Complex nesting: 22 if statements |
| 4 | 35 | Creeping Doom progress journal | Complex nesting: 12 if statements |
| 4 | 37 | Flood progress journal | Complex nesting: 27 if statements |
| 4 | 38 | Ice Shards progress journal | Complex nesting: 14 if statements |
| 4 | 39 | Waterform progress journal | Complex nesting: 25 if statements |
| 4 | 42 | Wizard Eye progress journal | Complex nesting: 16 if statements |
| 4 | 43 | Blur progress journal | Complex nesting: 10 if statements |
| 4 | 44 | Charm Person progress journal | Complex nesting: 28 if statements |
| 4 | 45 | Hell Gate progress journal | Complex nesting: 29 if statements |
| 4 | 46 | Hellfire and Brimstone progres | Complex nesting: 20 if statements |
| 4 | 47 | Illusory Wall progress journal | Complex nesting: 109 if statements |
| 4 | 48 | The Finale progress journal | Complex nesting: 10 if statements |
| 4 | 49 | Air Wand progress journal | Complex nesting: 36 if statements |
| 4 | 50 | Fire Wand progress journal | Complex nesting: 36 if statements |
| 4 | 51 | Ice Wand progress journal | Complex nesting: 36 if statements |
| 4 | 52 | Acid Wand progress journal | Complex nesting: 36 if statements |
| 4 | 53 | Spirit Maces progress journal | Complex nesting: 26 if statements |
| 4 | 54 | The Horrors of Nukreth Spire | Complex nesting: 9 if statements |
| 4 | 55 | Contract Killers progress jour | Complex nesting: 15 if statements |
| 4 | 56 | Assassin Mask progress journal | Complex nesting: 18 if statements |
| 4 | 57 | Dragon Slayers progress journa | Complex nesting: 9 if statements |
| 4 | 58 | Divine Devotion progress journ | Complex nesting: 18 if statements |
| 4 | 59 | Beast Masters progress journal | Complex nesting: 9 if statements |
| 4 | 60 | Eye of the Tiger progress jour | Complex nesting: 18 if statements |
| 4 | 64 | Pyromancer Subclass progress j | Complex nesting: 6 if statements |
| 4 | 65 | Mercenary Assassin Thief Subcl | Complex nesting: 12 if statements |
| 4 | 66 | Illusionist Subclass progress  | Complex nesting: 6 if statements |
| 4 | 68 | Ranger Druid Subclass progress | Complex nesting: 7 if statements |
| 4 | 69 | Cryomancer Subclass progress j | Complex nesting: 7 if statements |
| 4 | 85 | Monk Chants progress journal | Complex nesting: 6 if statements |
| 4 | 86 | Infernal Weaponry progress jou | Complex nesting: 27 if statements |
| 4 | 96 | Treasure Hunter progress journ | Complex nesting: 9 if statements |
| 4 | 97 | Rogue Cloak progress journal | Complex nesting: 18 if statements |
| 4 | 99 | Eldoria variable load | Large script: 6905 chars |
| 5 | 0 | Elemental Chaos progress journ | Complex nesting: 13 if statements |
| 5 | 1 | Enlightenment progress journal | Complex nesting: 18 if statements |
| 5 | 5 | Saint Augustine clarification | Complex nesting: 6 if statements |
| 40 | 4 | soul capture | Complex nesting: 8 if statements |
| 40 | 5 | soul siphon | Complex nesting: 6 if statements |
| 41 | 3 | 3bl_turn_in | Complex nesting: 16 if statements |
| 41 | 4 | 3bl_rewards_list | Complex nesting: 10 if statements |
| 41 | 7 | 3eg_turn_in | Complex nesting: 16 if statements |
| 41 | 8 | 3eg_rewards_list | Complex nesting: 10 if statements |
| 410 | 5 | **UNUSED** | Complex nesting: 11 if statements |
| 410 | 6 | **UNUSED** | Complex nesting: 11 if statements |
| 410 | 7 | **UNUSED** | Complex nesting: 11 if statements |
| 43 | 1 | catherine_key | Complex nesting: 16 if statements |
| 43 | 2 | charlemagne_key | Complex nesting: 20 if statements |
| 43 | 3 | lewis_key | Complex nesting: 7 if statements |
| 43 | 38 | fire_goddess_skirt | Complex nesting: 6 if statements |
| 43 | 41 | pippin_torch | Complex nesting: 9 if statements |
| 43 | 42 | torch hold | Complex nesting: 7 if statements |
| 43 | 58 | LP2_bard_subclass_command_danc | Complex nesting: 7 if statements |
| 43 | 62 | LP2_bard_subclass_speech3 | Complex nesting: 6 if statements |
| 43 | 66 | LP2_bard_subclass_status_check | Complex nesting: 8 if statements |
| 43 | 69 | **UNUSED** | Complex nesting: 7 if statements |
| 43 | 99 | The_Finale | Complex nesting: 7 if statements |
| 430 | 54 | word_command_dargo_escape | Complex nesting: 12 if statements |
| 462 | 4 | Nukreth Spire chieftain death | Complex nesting: 7 if statements |
| 462 | 5 | Nukreth Spire path2 3 4 captiv | Complex nesting: 11 if statements |
| 462 | 6 | Nukreth Spire captive follow m | Complex nesting: 14 if statements |
| 462 | 13 | Nukreth Spire human help speec | Complex nesting: 8 if statements |
| 462 | 35 | Nukreth Spire path1 captive gr | Complex nesting: 9 if statements |
| 480 | 31 | Prince speech challenge | Complex nesting: 6 if statements |
| 480 | 33 | Infidel receive | Complex nesting: 6 if statements |
| 481 | 4 | hold_good_parchment | Complex nesting: 6 if statements |
| 481 | 9 | wise_woman_give_parchment | Complex nesting: 8 if statements |
| 481 | 24 | vulcera_greet1 | Complex nesting: 7 if statements |
| 481 | 33 | shaman_receive1 | Complex nesting: 11 if statements |
| 481 | 41 | elder_woman_speak1 | Complex nesting: 7 if statements |
| 481 | 43 | vulcera_dead | Complex nesting: 6 if statements |
| 482 | 53 | mccabe greet | Complex nesting: 8 if statements |
| 482 | 56 | mccabe dialog | Large script: 8236 chars |
| 482 | 99 | meteorswarm_status_checker | Complex nesting: 7 if statements |
| 484 | 1 | oracle-sun-greet | Complex nesting: 25 if statements |
| 484 | 20 | wild-hunt death | Complex nesting: 7 if statements |
| 484 | 22 | keeper-keys-yes | Complex nesting: 6 if statements |
| 485 | 4 | mighty druid random paralysis- | Complex nesting: 8 if statements |
| 485 | 5 | mighty_druid entanglement | Complex nesting: 31 if statements |
| 486 | 37 | titan fight | Complex nesting: 7 if statements |
| 488 | 1 | shrynn fight | Complex nesting: 9 if statements |
| 488 | 6 | stormchild fight | Complex nesting: 6 if statements |
| 488 | 9 | stormlord fight | -- UNCONVERTED: %victim.o%.&0 (&4%damdone%&0) |
| 488 | 53 | **UNUSED** | Complex nesting: 6 if statements |
| 489 | 2 | lokari init | Complex nesting: 7 if statements |
| 489 | 3 | lokari fight | -- UNCONVERTED: stone |
| 489 | 6 | lokari throw player | Complex nesting: 12 if statements |
| 489 | 12 | maid-cleric spells | Complex nesting: 26 if statements |
| 489 | 25 | dark servant fight | Complex nesting: 11 if statements |
| 489 | 31 | wandering minstrel fight | Complex nesting: 10 if statements |
| 489 | 33 | severan shockwave | Complex nesting: 7 if statements |
| 49 | 2 | TD WR Capture | Complex nesting: 7 if statements |
| 49 | 7 | TD PY Capture | Complex nesting: 6 if statements |
| 49 | 9 | TD WR Countdown | Complex nesting: 8 if statements |
| 49 | 10 | TD WR Cancel | Complex nesting: 7 if statements |
| 490 | 20 | seer_speak1 | Complex nesting: 7 if statements |
| 490 | 22 | Seer refuse | -- UNCONVERTED: %action% |
| 490 | 26 | derceta_speak2 | Complex nesting: 8 if statements |
| 490 | 27 | Earle receive sword | Complex nesting: 6 if statements |
| 490 | 43 | cult_leader_load_dagon | Complex nesting: 8 if statements |
| 492 | 54 | quest_relocate_receive | -- UNCONVERTED: sta |
| 502 | 1 | Ghostly Diplomat Earring Quest | Complex nesting: 9 if statements |
| 51 | 8 | monk_subclass_quest_arre_speec | Complex nesting: 8 if statements |
| 51 | 17 | monk_subclass_quest_arre_statu | Complex nesting: 6 if statements |
| 510 | 0 | Pawn Shop (Nordus) | Complex nesting: 8 if statements |
| 510 | 5 | want_to_help_Luchiaans | -- UNCONVERTED: it. |
| 519 | 0 | academy_recruitor_speech_selec | Complex nesting: 9 if statements |
| 519 | 4 | academy_instructor_speech_yes_ | Complex nesting: 13 if statements |
| 519 | 15 | academy_instructor_speech_expl | Large script: 5264 chars |
| 519 | 16 | academy_instructor_speech_inv_ | Large script: 6651 chars |
| 519 | 26 | academy_rogue_greet | Complex nesting: 10 if statements |
| 519 | 30 | academy_warrior_greet | Complex nesting: 8 if statements |
| 519 | 36 | academy_cleric_greet | Complex nesting: 6 if statements |
| 519 | 45 | academy_sorcerer_greet | Complex nesting: 12 if statements |
| 519 | 48 | academy_sorcerer_command_spell | Complex nesting: 8 if statements |
| 519 | 80 | academy_recruiter_speech_resum | Complex nesting: 6 if statements |
| 519 | 81 | academy_instructor_speech_comm | Complex nesting: 6 if statements |
| 519 | 82 | academy_instructor_speech_inve | Complex nesting: 7 if statements |
| 519 | 83 | academy_instructor_speech_expl | Complex nesting: 6 if statements |
| 519 | 88 | academy_clerk_speech_yes_no_sk | Complex nesting: 7 if statements |
| 519 | 91 | academy_revel_speech_resting | Complex nesting: 8 if statements |
| 52 | 2 | pyromancer_subclass_quest_emma | Complex nesting: 9 if statements |
| 52 | 3 | pyromancer_subclass_quest_emma | Complex nesting: 7 if statements |
| 52 | 4 | pyromancer_subclass_quest_emma | Complex nesting: 7 if statements |
| 52 | 8 | Emmath flames receive | Complex nesting: 18 if statements |
| 52 | 11 | pyro_subclass_flameball_emmath | Complex nesting: 9 if statements |
| 52 | 13 | Flameball quest status checker | Complex nesting: 10 if statements |
| 52 | 15 | Emmath staff receive | Complex nesting: 6 if statements |
| 53 | 11 | Beast Master Pumahl speech1 | Complex nesting: 15 if statements |
| 53 | 12 | Beast Master Pumahl speech yes | Complex nesting: 9 if statements |
| 53 | 13 | Beast Master Ranger Trophy rec | Complex nesting: 20 if statements |
| 53 | 18 | Ranger Trophy command forage | Complex nesting: 14 if statements |
| 53 | 19 | Ranger Trophy Pumahl progress | Complex nesting: 19 if statements |
| 53 | 21 | Honus speech hunt treasure | Complex nesting: 21 if statements |
| 53 | 22 | Honus speech yes | Complex nesting: 9 if statements |
| 53 | 23 | Honus order receive | Complex nesting: 9 if statements |
| 53 | 24 | Treasure Hunter treasure get | Complex nesting: 7 if statements |
| 53 | 25 | Honus treasure receive | Complex nesting: 11 if statements |
| 53 | 26 | Honus cloak receive | Complex nesting: 10 if statements |
| 53 | 29 | Rogue cloak search | Complex nesting: 14 if statements |
| 53 | 30 | Rogue Cloak Progress | Complex nesting: 18 if statements |
| 53 | 32 | Treasure Hunter object give | Complex nesting: 7 if statements |
| 53 | 36 | Elemental Chaos Hakujo speech  | Complex nesting: 19 if statements |
| 53 | 37 | Elemental Chaos Hakujo speech  | Complex nesting: 10 if statements |
| 53 | 38 | Elemental Chaos Hakujo mission | Complex nesting: 9 if statements |
| 53 | 39 | Elemental Chaos mission look | Complex nesting: 6 if statements |
| 53 | 40 | Monk Vision Hakujo receive | Complex nesting: 15 if statements |
| 53 | 42 | Monk Vision command read | Complex nesting: 30 if statements |
| 53 | 43 | Elemental Chaos Hakujo progres | Complex nesting: 22 if statements |
| 53 | 46 | Elemental Chaos target death | Complex nesting: 7 if statements |
| 53 | 47 | Monk Chants command meditate | Complex nesting: 17 if statements |
| 53 | 48 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 49 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 50 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 51 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 52 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 53 | **UNUSED** | Complex nesting: 8 if statements |
| 53 | 54 | Monk Chants Hakujo Speech chan | Complex nesting: 18 if statements |
| 53 | 55 | Hell Trident receive | Complex nesting: 22 if statements |
| 53 | 57 | Hell Trident progress tracker | Complex nesting: 38 if statements |
| 533 | 8 | wall_ice_sculptor_greet | Complex nesting: 6 if statements |
| 533 | 10 | wall_ice_crystalize_speech | Complex nesting: 6 if statements |
| 534 | 15 | timetravel_shake | Complex nesting: 10 if statements |
| 534 | 54 | Lirne Refuse | Complex nesting: 6 if statements |
| 534 | 57 | major_globe_elemental_greet | Complex nesting: 7 if statements |
| 534 | 99 | major_globe_quest_status_check | Complex nesting: 10 if statements |
| 55 | 3 | 3bl_turn_in | Complex nesting: 16 if statements |
| 55 | 4 | 3bl_rewards_list | Complex nesting: 16 if statements |
| 55 | 7 | 3eg_turn_in | Complex nesting: 16 if statements |
| 55 | 8 | 3eg_rewards_list | Complex nesting: 16 if statements |
| 55 | 21 | degeneration_cat_receive | Large script: 11930 chars |
| 55 | 24 | Eldoria Quartermasters load | Large script: 8061 chars |
| 550 | 0 | quest_cryo_greet | Complex nesting: 10 if statements |
| 550 | 1 | Tech_Master_Shaman_1 | Complex nesting: 11 if statements |
| 550 | 8 | Master Shaman refuse | Complex nesting: 8 if statements |
| 550 | 21 | quest_suralla_yesno | Complex nesting: 7 if statements |
| 550 | 28 | cryomancer_subclass_status | Complex nesting: 10 if statements |
| 550 | 34 | wizard_eye_seer_greet | Complex nesting: 9 if statements |
| 550 | 36 | wizard_eye_seer_receive | Complex nesting: 8 if statements |
| 550 | 42 | wizard_eye_status_checker | Complex nesting: 14 if statements |
| 553 | 1 | cleric_phase_1 | Complex nesting: 15 if statements |
| 553 | 20 | warrior_phase_1 | Complex nesting: 15 if statements |
| 553 | 30 | sorcerer_phase_1 | Complex nesting: 15 if statements |
| 553 | 40 | rogue_phase_1 | Complex nesting: 15 if statements |
| 553 | 50 | anti-paladin_phase_2 | Complex nesting: 15 if statements |
| 553 | 53 | phase_2_cleric_boots | -- UNCONVERTED: >= 2 |
| 553 | 60 | cleric_phase_2 | Complex nesting: 15 if statements |
| 553 | 70 | diabolist_phase_2 | Complex nesting: 15 if statements |
| 553 | 80 | druid_phase_2 | Complex nesting: 15 if statements |
| 553 | 90 | monk_phase_2 | Complex nesting: 15 if statements |
| 554 | 0 | necromancer_phase_2 | Complex nesting: 15 if statements |
| 554 | 10 | paladin_phase_2 | Complex nesting: 15 if statements |
| 554 | 20 | ranger_phase_2 | Complex nesting: 15 if statements |
| 554 | 30 | rogue_phase_2 | Complex nesting: 15 if statements |
| 554 | 40 | warrior_phase_2 | Complex nesting: 15 if statements |
| 554 | 50 | sorcerer_phase_2 | Complex nesting: 15 if statements |
| 554 | 60 | anti-paladin_phase_3 | Complex nesting: 15 if statements |
| 554 | 70 | **UNUSED** | Complex nesting: 15 if statements |
| 554 | 80 | diabolist_phase_3 | Complex nesting: 15 if statements |
| 554 | 90 | druid_phase_3 | Complex nesting: 15 if statements |
| 555 | 0 | sorcerer_phase_3 | Complex nesting: 15 if statements |
| 555 | 10 | monk_phase_3 | Complex nesting: 15 if statements |
| 555 | 20 | necromancer_phase_3 | Complex nesting: 15 if statements |
| 555 | 30 | paladin_phase_3 | Complex nesting: 15 if statements |
| 555 | 40 | ranger_phase_3 | Complex nesting: 15 if statements |
| 555 | 50 | rogue_phase_3 | Complex nesting: 15 if statements |
| 555 | 60 | warrior_phase_3 | Complex nesting: 15 if statements |
| 555 | 61 | drop_phase_1_mini_boss_2 | Complex nesting: 6 if statements |
| 555 | 62 | drop_phase_1_boss_2 | Complex nesting: 6 if statements |
| 555 | 63 | drop_phase_1_mini_boss_4 | Complex nesting: 6 if statements |
| 555 | 64 | drop_phase_1_boss_4 | Complex nesting: 6 if statements |
| 555 | 65 | drop_phase_1_mini_boss_7 | Complex nesting: 6 if statements |
| 555 | 66 | drop_phase_1_boss_7 | Complex nesting: 6 if statements |
| 555 | 67 | drop_phase_1_mini_boss_9 | Complex nesting: 6 if statements |
| 555 | 68 | drop_phase_1_boss_9 | Complex nesting: 6 if statements |
| 555 | 69 | drop_phase_1_mini_boss_12 | Complex nesting: 6 if statements |
| 555 | 70 | drop_phase_1_boss_12 | Complex nesting: 6 if statements |
| 555 | 71 | drop_phase_1_mini_boss_15 | Complex nesting: 6 if statements |
| 555 | 72 | drop_phase_1_boss_15 | Complex nesting: 6 if statements |
| 555 | 73 | drop_phase_1_mini_boss_18 | Complex nesting: 6 if statements |
| 555 | 74 | drop_phase_1_boss_18 | Complex nesting: 6 if statements |
| 555 | 75 | drop_phase_2_mini_boss_22 | Complex nesting: 6 if statements |
| 555 | 76 | drop_phase_2_boss_22 | Complex nesting: 6 if statements |
| 555 | 77 | drop_phase_2_mini_boss_24 | Complex nesting: 6 if statements |
| 555 | 78 | drop_phase_2_boss_24 | Complex nesting: 6 if statements |
| 555 | 79 | drop_phase_2_mini_boss_27 | Complex nesting: 6 if statements |
| 555 | 80 | drop_phase_2_boss_27 | Complex nesting: 6 if statements |
| 555 | 81 | drop_phase_2_mini_boss_29 | Complex nesting: 6 if statements |
| 555 | 82 | drop_phase_2_boss_29 | Complex nesting: 6 if statements |
| 555 | 83 | drop_phase_2_mini_boss_32 | Complex nesting: 6 if statements |
| 555 | 84 | drop_phase_2_boss_32 | Complex nesting: 6 if statements |
| 555 | 85 | drop_phase_2_mini_boss_35 | Complex nesting: 6 if statements |
| 555 | 86 | drop_phase_2_boss_35 | Complex nesting: 6 if statements |
| 555 | 87 | drop_phase_2_mini_boss_38 | Complex nesting: 6 if statements |
| 555 | 88 | drop_phase_2_boss_38 | Complex nesting: 6 if statements |
| 555 | 89 | drop_phase_3_mini_boss_42 | Complex nesting: 6 if statements |
| 555 | 90 | drop_phase_3_boss_42 | Complex nesting: 6 if statements |
| 555 | 91 | drop_phase_3_mini_boss_44 | Complex nesting: 6 if statements |
| 555 | 92 | drop_phase_3_boss_44 | Complex nesting: 6 if statements |
| 555 | 93 | drop_phase_3_mini_boss_47 | Complex nesting: 6 if statements |
| 555 | 94 | drop_phase_3_boss_47 | Complex nesting: 6 if statements |
| 555 | 95 | drop_phase_3_mini_boss_49 | Complex nesting: 6 if statements |
| 555 | 96 | drop_phase_3_boss_49 | Complex nesting: 6 if statements |
| 555 | 97 | drop_phase_3_mini_boss_52 | Complex nesting: 6 if statements |
| 555 | 98 | drop_phase_3_boss_52 | Complex nesting: 6 if statements |
| 555 | 99 | drop_phase_3_mini_boss_55 | Complex nesting: 6 if statements |
| 556 | 0 | drop_phase_3_boss_55 | Complex nesting: 6 if statements |
| 556 | 1 | drop_phase_3_mini_boss_58 | Complex nesting: 6 if statements |
| 556 | 2 | drop_phase_3_boss_58 | Complex nesting: 6 if statements |
| 556 | 6 | phase_1_warrior_status | Complex nesting: 26 if statements |
| 556 | 7 | phase_1_sorcerer_status | Complex nesting: 26 if statements |
| 556 | 8 | phase_1_rogue_status | Complex nesting: 26 if statements |
| 556 | 9 | phase_1_cleric_status | Complex nesting: 26 if statements |
| 556 | 10 | phase_2_cleric_status | Complex nesting: 26 if statements |
| 556 | 11 | phase_2_druid_status | Complex nesting: 26 if statements |
| 556 | 12 | phase_2_sorcerer_status | Complex nesting: 26 if statements |
| 556 | 13 | phase_2_paladin_status | Complex nesting: 26 if statements |
| 556 | 14 | phase_2_monk_status | Complex nesting: 26 if statements |
| 556 | 15 | phase_2_necromancer_status | Complex nesting: 26 if statements |
| 556 | 16 | phase_2_ranger_status | Complex nesting: 26 if statements |
| 556 | 17 | phase_3_anti-paladin_status | Complex nesting: 26 if statements |
| 556 | 18 | phase_3_monk_status | Complex nesting: 26 if statements |
| 556 | 19 | phase_3_druid_status | Complex nesting: 26 if statements |
| 556 | 20 | phase_3_paladin_status | Complex nesting: 26 if statements |
| 556 | 21 | phase_2_warrior_status | Complex nesting: 26 if statements |
| 556 | 22 | phase_2_anti-paladin_status | Complex nesting: 26 if statements |
| 556 | 23 | phase_2_diabolist_status | Complex nesting: 25 if statements |
| 556 | 24 | phase_2_rogue_status | Complex nesting: 26 if statements |
| 556 | 25 | phase_3_warrior_status | Complex nesting: 26 if statements |
| 556 | 26 | phase_3_ranger_status | Complex nesting: 26 if statements |
| 556 | 27 | **UNUSED** | Complex nesting: 26 if statements |
| 556 | 28 | phase_3_necromancer_status | Complex nesting: 26 if statements |
| 556 | 29 | phase_3_sorcerer_status | Complex nesting: 26 if statements |
| 556 | 30 | phase_3_diabolist_status | Complex nesting: 26 if statements |
| 556 | 31 | phase_3_rogue_status | Complex nesting: 26 if statements |
| 557 | 0 | Phase Armor - Greet | Complex nesting: 24 if statements |
| 557 | 2 | Phase Armor - Armor | Complex nesting: 6 if statements |
| 557 | 3 | Phase Armor - Receive | Complex nesting: 17 if statements |
| 557 | 4 | Phase Armor - Status | Complex nesting: 28 if statements |
| 564 | 4 | hell_gate_diabolist_receive | Complex nesting: 9 if statements |
| 564 | 9 | hell_gate_status_checker | Complex nesting: 27 if statements |
| 564 | 10 | hell_gate_armor_p2_doppelgange | Complex nesting: 9 if statements |
| 580 | 1 | odai_kannon_receive | Complex nesting: 6 if statements |
| 580 | 5 | charm_person_hinazuru_receive | Complex nesting: 8 if statements |
| 580 | 7 | charm_person_instruments_comma | Complex nesting: 8 if statements |
| 580 | 8 | charm_person_status_checker | Complex nesting: 25 if statements |
| 580 | 10 | charm_person_mobs_play_command | Complex nesting: 9 if statements |
| 584 | 12 | Dancer_quest_ASK | Complex nesting: 9 if statements |
| 586 | 1 | dragons_health_myorrhed_speech | Complex nesting: 11 if statements |
| 586 | 2 | dragons_health_myorrhed_receiv | Complex nesting: 15 if statements |
| 586 | 3 | dragons_health_myorrhed_bribe | Complex nesting: 7 if statements |
| 586 | 5 | dragons_health_myorrhed_status | Complex nesting: 21 if statements |
| 590 | 5 | dark_robed_greet1 | -- UNCONVERTED: %actor.quest_variable[sacred_haven:given_earring]% != 1) |
| 590 | 7 | dark_robed_yes | Complex nesting: 7 if statements |
| 590 | 8 | dark_robed_recieve1 | -- UNCONVERTED: &3&b* vial of blood&0 |
| 590 | 9 | dark_robed_artifacts | Complex nesting: 7 if statements |
| 590 | 18 | three_lever_pull | Complex nesting: 18 if statements |
| 590 | 21 | stop_west_R69 | -- UNCONVERTED: past. |
| 590 | 46 | group_armor_forgemaster_receiv | Complex nesting: 13 if statements |
| 590 | 48 | group_armor_forgemaster_status | Complex nesting: 16 if statements |
| 590 | 99 | sacred_haven_status_check | Complex nesting: 10 if statements |
| 60 | 3 | Green Woman Apothecary shop lo | Complex nesting: 10 if statements |
| 60 | 5 | quest_timulos_greet | Complex nesting: 7 if statements |
| 60 | 8 | quest_timulos_assassin | Complex nesting: 6 if statements |
| 60 | 10 | quest_timulous_yesno | Complex nesting: 8 if statements |
| 60 | 25 | quest_timulos_status | Complex nesting: 10 if statements |
| 60 | 34 | random gem for broker | Complex nesting: 8 if statements |
| 60 | 51 | Berix bounty hunt speech | Complex nesting: 15 if statements |
| 60 | 52 | Berix bounty hunt speech2 | Complex nesting: 9 if statements |
| 60 | 53 | Berix bounty hunt receive | Complex nesting: 23 if statements |
| 60 | 54 | Bounty hunt death triggers | Complex nesting: 8 if statements |
| 60 | 55 | Bounty hunt contract look | Complex nesting: 8 if statements |
| 60 | 56 | Bount hunt contract examine | Complex nesting: 11 if statements |
| 60 | 58 | Assassin mask command hide | Complex nesting: 14 if statements |
| 60 | 59 | Assassin mask progress checker | Complex nesting: 19 if statements |
| 60 | 61 | connectfour start | Complex nesting: 6 if statements |
| 60 | 63 | connectfour select color | Complex nesting: 7 if statements |
| 60 | 64 | connectfour look board | Complex nesting: 20 if statements |
| 60 | 66 | connectfour drop piece | Complex nesting: 21 if statements |
| 60 | 68 | connectfour reset game | Complex nesting: 6 if statements |
| 60 | 70 | connectfour forfeit game | Complex nesting: 8 if statements |
| 60 | 75 | hearts start | Complex nesting: 11 if statements |
| 60 | 77 | hearts deal | -- UNCONVERTED: (%player4.name% != %actor.name%) |
| 60 | 79 | hearts hand view | Complex nesting: 57 if statements |
| 60 | 80 | hearts look table | Complex nesting: 111 if statements |
| 60 | 83 | hearts endgame | Complex nesting: 22 if statements |
| 615 | 24 | Wise leprechaun receiving good | Complex nesting: 15 if statements |
| 615 | 53 | creeping_doom_pixie_receive | Complex nesting: 9 if statements |
| 615 | 56 | creeping_doom_status_checker | Complex nesting: 10 if statements |
| 615 | 95 | Lighting a string of firecrack | Large script: 5371 chars |
| 615 | 99 | Lighting a roman candle | Complex nesting: 6 if statements |
| 62 | 1 | necromancer_quest_spell_hints_ | Complex nesting: 6 if statements |
| 62 | 4 | pyromancer_quest_spell_hints_a | Complex nesting: 7 if statements |
| 62 | 6 | supernova_guildmaster_speech2 | Complex nesting: 7 if statements |
| 62 | 16 | supernova clue 2 | Complex nesting: 7 if statements |
| 62 | 17 | supernova clue 3 | Complex nesting: 9 if statements |
| 62 | 93 | Gem Exchange set type | Complex nesting: 29 if statements |
| 62 | 95 | Gem Exchange receive exchange | Complex nesting: 25 if statements |
| 625 | 1 | calling for help | Complex nesting: 12 if statements |
| 625 | 18 | merchant dialogue | Complex nesting: 8 if statements |
| 625 | 50 | quest room | Complex nesting: 7 if statements |
| 625 | 71 | the BIG hurt | Complex nesting: 12 if statements |
| 625 | 82 | facade remove trigger | -- UNCONVERTED: m&0&7ol&bten&0&7 in&3&bner &0&3la&1&byers!&0 |
| 625 | 99 | Progress trigger | Complex nesting: 10 if statements |
| 63 | 90 | Herlequin vial trigger | -- UNCONVERTED: hands! |
| 63 | 92 | Herlequin volcano trigger 2 | -- UNCONVERTED: %victim.name%! |
| 80 | 34 | wug_drake_death | Complex nesting: 6 if statements |
| 85 | 0 | ziijhan_welcome | Complex nesting: 10 if statements |
| 85 | 1 | quest_preamble_ziijhan | Complex nesting: 18 if statements |
| 85 | 2 | start_quest_ziijhan | Complex nesting: 8 if statements |
| 85 | 25 | Anti-Necro-Dia subclass status | Complex nesting: 10 if statements |
| 85 | 51 | norisent speech | Complex nesting: 10 if statements |
| 85 | 54 | Resurrection Death Talisman Gi | Complex nesting: 8 if statements |
| 85 | 55 | Norisent Receive | Complex nesting: 11 if statements |
| 85 | 99 | resurrection_quest_status_chec | Complex nesting: 26 if statements |
| 87 | 97 | skillset_skills_A-G | Complex nesting: 6 if statements |
| 87 | 98 | skillset_skills_H-V | Complex nesting: 6 if statements |
| 87 | 99 | skillset_questspells | Complex nesting: 6 if statements |

## Clean (Auto-converted OK)

| Zone | ID | Name |
|------|-----|------|
| 0 | 1 | command_trig_test |
| 0 | 2 | obj get test |
| 0 | 3 | no littering |
| 0 | 4 | new trigger |
| 0 | 5 | weather speech |
| 0 | 6 | firecaster |
| 0 | 7 | Kerristone Castle (South) |
| 0 | 8 | Shadow Doom 1 |
| 0 | 9 | Shadow Doom 2 |
| 0 | 10 | Obelisk (Food) |
| 0 | 11 | Kerristone (Royal Stables) |
| 0 | 12 | arena |
| 0 | 13 | Templace Gate |
| 0 | 14 | King of dreams (Swan Princess) |
| 0 | 15 | Obz Kwan Yin Release |
| 0 | 16 | Eye peck |
| 0 | 25 | instant reboot |
| 0 | 40 | Minor Life Restore |
| 0 | 85 | Mausloeum trigger |
| 0 | 86 | Mausoleum 2 |
| 0 | 87 | antipaladin quest |
| 0 | 88 | run |
| 0 | 89 | blind seer |
| 0 | 90 | blind seer |
| 0 | 91 | howls |
| 0 | 92 | shadows |
| 0 | 93 | gargoyles |
| 0 | 94 | vines |
| 0 | 95 | tree branch |
| 0 | 96 | Evil energy |
| 0 | 97 | crystalline monument (griffin) |
| 1 | 0 | set Breathe Fire |
| 1 | 1 | set Breathe Frost |
| 1 | 2 | set Breathe Acid |
| 1 | 3 | set Breathe Gas |
| 1 | 4 | set Breathe Lightning |
| 1 | 5 | set Roar |
| 1 | 6 | Cleric Quest Spell Hints |
| 1 | 8 | Diabolist Quest Spell Hints |
| 1 | 11 | Druid Quest Spell Hints |
| 1 | 12 | Ranger Quest Spell Hints |
| 1 | 13 | object casts hellbolt |
| 1 | 14 | object casts stygian eruption |
| 1 | 15 | Bard AI |
| 1 | 17 | **UNUSED** |
| 1 | 18 | **UNUSED** |
| 1 | 19 | vampiric weapon effect |
| 1 | 20 | Bonus fire damage |
| 1 | 21 | Bonus cold damage |
| 1 | 22 | Bonus shock damage |
| ... | ... | (2160 more) |
| 87 | 9 | muleard_greet |
| 87 | 10 | ambush |
| 87 | 11 | anti-get trigger |
| 87 | 50 | anti_thief_obj_trigger |
| 87 | 51 | to_small_wield |
| 87 | 58 | white_mask_wear |
| 87 | 91 | Tr'ven (Speak fix) |
| 87 | 95 | Tr'ven(greet) |
| 87 | 96 | tr'ven(replace old items) |
| 88 | 0 | thief_subclass_farmer_greeting |

## Reviewed & Approved

| Zone | ID | Name | Reviewed By | Date |
|------|-----|------|-------------|------|
| (none yet) |  |  |  |  |
