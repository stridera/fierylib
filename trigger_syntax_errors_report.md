# Trigger Syntax Errors Report

Generated after FieryLib import of legacy DG Scripts to Lua.

## Summary

- **Total Triggers Imported:** 2695
- **Triggers Needing Review:** 289
- **Success Rate:** 89.3%

## Error Pattern Breakdown

              Error Pattern              | Count 
-----------------------------------------+-------
 Array access pattern: get_variable["x"] |    97
 Multi-word condition: if foo bar then   |    71
 Variable expansion: %var% not converted |    56
 Other                                   |    36
 Parentheses mismatch                    |    18
 Block end mismatch                      |    11
(6 rows)


## Action Required

These triggers were imported into the database with the `needsReview` flag set to `true`.  
Use **Muditor** to view and fix them:

1. Open Muditor at http://localhost:3002
2. Navigate to Scripts/Triggers
3. Filter by "Needs Review"
4. Edit the Lua code to fix syntax errors
5. Use the "Validate Lua" button to check fixes
6. Save when the syntax is valid

## Detailed Error List by Zone

 Zone | VNUM  |  Type  |                   Name                   |                            Error                             
------+-------+--------+------------------------------------------+--------------------------------------------------------------
    0 |    13 | MOB    | Templace Gate                            | luac: <Templace Gate>:8: unexpected symbol near '$'
    0 |    25 | WORLD  | instant reboot                           | luac: <instant reboot>:14: ')' expected near '.3054'
    1 |   107 | MOB    | Priest Quest Spell Hints                 | luac: <Priest Quest Spell Hints>:27: unexpected symbol near 
    3 |   302 | MOB    | phase wands bigby research assistant rec | luac: <phase wands bigby research assistant receive>:44: fun
    3 |   303 | OBJECT | phase wands attack counter               | luac: <phase wands attack counter>:49: function arguments ex
    3 |   304 | OBJECT | phase wands give owner check             | luac: <phase wands give owner check>:4: 'then' expected near
    3 |   305 | OBJECT | phase weapon owner wield check           | luac: <phase weapon owner wield check>:14: unexpected symbol
    3 |   306 | MOB    | phase wand general greet                 | luac: <phase wand general greet>:7: function arguments expec
    3 |   308 | MOB    | phase wand general receive               | luac: <phase wand general receive>:4: function arguments exp
    3 |   309 | OBJECT | phase wand command imbue                 | luac: <phase wand command imbue>:88: function arguments expe
    3 |   312 | MOB    | phase wand general death                 | luac: <phase wand general death>:45: function arguments expe
    3 |   314 | MOB    | phase wand status checker questmasters   | luac: <phase wand status checker questmasters>:20: function 
    3 |   326 | MOB    | phase mace receive                       | luac: <phase mace receive>:25: function arguments expected n
    3 |   327 | OBJECT | phase wand play                          | luac: <phase wand play>:26: function arguments expected near
    4 |   406 | OBJECT | Troll Mask progress journal              | luac: <Troll Mask progress journal>:4: 'then' expected near 
    4 |   407 | OBJECT | Fiery Island Progress journal            | luac: <Fiery Island Progress journal>:4: 'then' expected nea
    4 |   408 | OBJECT | Griffin quest progress journal           | luac: <Griffin quest progress journal>:4: 'then' expected ne
    4 |   409 | OBJECT | Sunfire Rescue progress journal          | luac: <Sunfire Rescue progress journal>:4: 'then' expected n
    4 |   410 | OBJECT | Vilekka Stew progress journal            | luac: <Vilekka Stew progress journal>:4: 'then' expected nea
    4 |   411 | OBJECT | Guild Armor Phase One progress journal   | luac: <Guild Armor Phase One progress journal>:107: function
    4 |   412 | OBJECT | Guild Armor Phase Two progress journal   | luac: <Guild Armor Phase Two progress journal>:322: function
    4 |   413 | OBJECT | Guild Armor Phase Three progress journal | luac: <Guild Armor Phase Three progress journal>:322: functi
    4 |   414 | OBJECT | Relocate progress journal                | luac: <Relocate progress journal>:20: unexpected symbol near
    4 |   416 | OBJECT | Tower in the Wastes progress journal     | luac: <Tower in the Wastes progress journal>:4: 'then' expec
    4 |   418 | OBJECT | Twisted Sorrow progress journal          | luac: <Twisted Sorrow progress journal>:4: 'then' expected n
    4 |   419 | OBJECT | Major Globe progress journal             | luac: <Major Globe progress journal>:4: 'then' expected near
    4 |   420 | OBJECT | Doom Entrance progress journal           | luac: <Doom Entrance progress journal>:4: 'then' expected ne
    4 |   421 | OBJECT | Sacred Haven progress journal            | luac: <Sacred Haven progress journal>:4: 'then' expected nea
    4 |   422 | OBJECT | Combat in Eldoria progress journal       | luac: <Combat in Eldoria progress journal>:4: 'then' expecte
    4 |   425 | OBJECT | Resurrection progress journal            | luac: <Resurrection progress journal>:33: unexpected symbol 
    4 |   426 | OBJECT | Group Heal progress journal              | luac: <Group Heal progress journal>:4: 'then' expected near 
    4 |   427 | OBJECT | Group Armor progress journal             | luac: <Group Armor progress journal>:4: 'then' expected near
    4 |   428 | OBJECT | Supernova progress journal               | luac: <Supernova progress journal>:116: 'end' expected (to c
    4 |   429 | OBJECT | Meteorswarm progress journal             | luac: <Meteorswarm progress journal>:25: unexpected symbol n
    4 |   431 | OBJECT | The Great Rite progress journal          | luac: <The Great Rite progress journal>:4: 'then' expected n
    4 |   432 | OBJECT | Word of Command progress journal         | luac: <Word of Command progress journal>:4: 'then' expected 
    4 |   433 | OBJECT | Heavens Gate progress journal            | luac: <Heavens Gate progress journal>:4: 'then' expected nea
    4 |   434 | OBJECT | Dragons Health Progress journal          | luac: <Dragons Health Progress journal>:4: 'then' expected n
    4 |   435 | OBJECT | Creeping Doom progress journal           | luac: <Creeping Doom progress journal>:4: 'then' expected ne
    4 |   436 | OBJECT | Wall of Ice progress journal             | luac: <Wall of Ice progress journal>:4: 'then' expected near
    4 |   438 | OBJECT | Ice Shards progress journal              | luac: <Ice Shards progress journal>:4: 'then' expected near 
    4 |   442 | OBJECT | Wizard Eye progress journal              | luac: <Wizard Eye progress journal>:4: 'then' expected near 
    4 |   445 | OBJECT | Hell Gate progress journal               | luac: <Hell Gate progress journal>:4: 'then' expected near '
    4 |   447 | OBJECT | Illusory Wall progress journal           | luac: <Illusory Wall progress journal>:4: 'then' expected ne
    4 |   448 | OBJECT | The Finale progress journal              | luac: <The Finale progress journal>:33: unexpected symbol ne
    4 |   452 | OBJECT | Acid Wand progress journal               | luac: <Acid Wand progress journal>:44: unexpected symbol nea
    4 |   456 | OBJECT | Assassin Mask progress journal           | luac: <Assassin Mask progress journal>:4: unexpected symbol 
    4 |   457 | OBJECT | Dragon Slayers progress journal          | luac: <Dragon Slayers progress journal>:4: 'then' expected n
    4 |   458 | OBJECT | Divine Devotion progress journal         | luac: <Divine Devotion progress journal>:4: 'then' expected 
    4 |   460 | OBJECT | Eye of the Tiger progress journal        | luac: <Eye of the Tiger progress journal>:4: 'then' expected
    4 |   461 | OBJECT | Siege Mystwatch Fortress progress journa | luac: <Siege Mystwatch Fortress progress journal>:20: syntax
    4 |   484 | OBJECT | Major Paralysis progress journal         | luac: <Major Paralysis progress journal>:4: 'then' expected 
    4 |   485 | OBJECT | Monk Chants progress journal             | luac: <Monk Chants progress journal>:5: 'then' expected near
    4 |   486 | OBJECT | Infernal Weaponry progress journal       | luac: <Infernal Weaponry progress journal>:4: 'then' expecte
    4 |   489 | OBJECT | Crown of Madness progress journal        | luac: <Crown of Madness progress journal>:4: 'then' expected
    4 |   491 | OBJECT | Greater Displacement progress journal    | luac: <Greater Displacement progress journal>:4: 'then' expe
    4 |   492 | OBJECT | Major Sanctuary progress journal         | luac: <Major Sanctuary progress journal>:4: 'then' expected 
    4 |   493 | OBJECT | Greater Sanctuary                        | luac: <Greater Sanctuary>:4: 'then' expected near 'sanctuary
    4 |   496 | OBJECT | Treasure Hunter progress journal         | luac: <Treasure Hunter progress journal>:4: 'then' expected 
    4 |   498 | OBJECT | Group Recall progress journal            | luac: <Group Recall progress journal>:4: 'then' expected nea
    5 |   500 | OBJECT | Elemental Chaos progress journal         | luac: <Elemental Chaos progress journal>:4: 'then' expected 
    5 |   501 | OBJECT | Enlightenment progress journal           | luac: <Enlightenment progress journal>:4: 'then' expected ne
    5 |   502 | OBJECT | **UNUSED**                               | luac: <**UNUSED**>:4: 'then' expected near 'of'
    5 |   503 | OBJECT | Tempest of Saint Augustine progress jour | luac: <Tempest of Saint Augustine progress journal>:4: 'then
    5 |   504 | OBJECT | **UNUSED**                               | luac: <**UNUSED**>:4: 'then' expected near 'of'
    5 |   506 | OBJECT | **UNUSED**                               | luac: <**UNUSED**>:4: 'then' expected near 'of'
   12 |  1212 | OBJECT | calian_slayer                            | luac: <calian_slayer>:21: function arguments expected near '
   12 |  1270 | OBJECT | 8ball message generator                  | luac: <8ball message generator>:14: malformed number near '8
   18 |  1820 | WORLD  | Coup                                     | luac: <Coup>:3: unexpected symbol near '.1802'
   18 |  1833 | WORLD  | blur_winds_preentry                      | luac: <blur_winds_preentry>:21: function arguments expected 
   18 |  1834 | MOB    | blur_winds_speech                        | luac: <blur_winds_speech>:76: function arguments expected ne
   22 |  2242 | WORLD  | belial_return_banter                     | luac: <belial_return_banter>:4: unexpected symbol near '%'
   22 |  2247 | WORLD  | belial_enervation_script                 | luac: <belial_enervation_script>:15: unexpected symbol near 
   23 |  2301 | MOB    | patriarch receives truthstone            | luac: <patriarch receives truthstone>:120: function argument
   23 |  2307 | MOB    | high-druid-receive                       | luac: <high-druid-receive>:80: 'end' expected (to close 'if'
   28 |  2802 | MOB    | waterform_wave_receive                   | luac: <waterform_wave_receive>:5: unexpected symbol near '='
   28 |  2804 | MOB    | waterform_tri_death                      | luac: <waterform_tri_death>:9: unexpected symbol near '='
   28 |  2805 | MOB    | waterform_water_death                    | luac: <waterform_water_death>:23: function arguments expecte
   28 |  2806 | OBJECT | waterform_waters_examine                 | luac: <waterform_waters_examine>:4: function arguments expec
   28 |  2808 | MOB    | **UNUSED**                               | luac: <**UNUSED**>:24: function arguments expected near ']'
   31 |  3116 | OBJECT | UNUSED                                   | luac: <UNUSED>:4: unexpected symbol near '%'
   31 |  3171 | MOB    | shaman pay for training                  | luac: <shaman pay for training>:10: unexpected symbol near '
   41 |  4103 | MOB    | 3bl_turn_in                              | luac: <3bl_turn_in>:207: function arguments expected near ']
   41 |  4107 | MOB    | 3eg_turn_in                              | luac: <3eg_turn_in>:193: function arguments expected near ']
   43 |  4309 | MOB    | karla_chichi                             | luac: <karla_chichi>:15: unexpected symbol near '%'
   43 |  4362 | MOB    | LP2_bard_subclass_speech3                | luac: <LP2_bard_subclass_speech3>:14: 'then' expected near '
   49 |  4907 | OBJECT | TD PY Capture                            | luac: <TD PY Capture>:21: 'then' expected near 'iT'
   52 |  5202 | MOB    | pyromancer_subclass_quest_emmath_greet   | luac: <pyromancer_subclass_quest_emmath_greet>:7: function a
   52 |  5208 | MOB    | Emmath flames receive                    | luac: <Emmath flames receive>:6: function arguments expected
   52 |  5214 | MOB    | Emmath blue flame receive                | luac: <Emmath blue flame receive>:58: function arguments exp
   52 |  5215 | MOB    | Emmath staff receive                     | luac: <Emmath staff receive>:25: function arguments expected
   52 |  5216 | MOB    | Emmath receive decline                   | luac: <Emmath receive decline>:11: syntax error near 'you'
   55 |  5503 | MOB    | 3bl_turn_in                              | luac: <3bl_turn_in>:267: function arguments expected near ']
   55 |  5507 | MOB    | 3eg_turn_in                              | luac: <3eg_turn_in>:266: function arguments expected near ']
   60 |  6033 | MOB    | Green Woman refuse                       | luac: <Green Woman refuse>:10: 'end' expected (to close 'if'
   60 |  6050 | MOB    | Berix bounty hunt greet                  | luac: <Berix bounty hunt greet>:6: 'then' expected near '='
   60 |  6053 | MOB    | Berix bounty hunt receive                | luac: <Berix bounty hunt receive>:200: ')' expected (to clos
   60 |  6061 | OBJECT | connectfour start                        | luac: <connectfour start>:25: unexpected symbol near '&'
   60 |  6077 | OBJECT | hearts deal                              | luac: <hearts deal>:20: unexpected symbol near 'then'
   60 |  6082 | OBJECT | hearts play                              | luac: <hearts play>:468: ')' expected (to close '(' at line 
   62 |  6207 | WORLD  | supernova_clue_rooms                     | luac: <supernova_clue_rooms>:6: function arguments expected 
   62 |  6211 | MOB    | supernova_phayla_speech2                 | luac: <supernova_phayla_speech2>:9: 'then' expected near 'ar
   62 |  6212 | MOB    | supernova_phayla_receive                 | luac: <supernova_phayla_receive>:5: function arguments expec
   85 |  8501 | MOB    | quest_preamble_ziijhan                   | luac: <quest_preamble_ziijhan>:9: 'then' expected near 'know
   85 |  8510 | MOB    | torturer_greet1                          | luac: <torturer_greet1>:3: 'then' expected near 'can_be_seen
   85 |  8550 | MOB    | Resurrect_greet                          | luac: <Resurrect_greet>:10: unexpected symbol near '='
   85 |  8551 | MOB    | norisent speech                          | luac: <norisent speech>:15: unexpected symbol near '='
   85 |  8554 | OBJECT | Resurrection Death Talisman Give         | luac: <Resurrection Death Talisman Give>:74: 'end' expected 
   85 |  8599 | MOB    | resurrection_quest_status_checker        | luac: <resurrection_quest_status_checker>:22: unexpected sym
   87 |  8796 | MOB    | tr'ven(replace old items)                | luac: <tr'ven(replace old items)>:3: 'then' expected near '=
  103 | 10304 | MOB    | rianne-quest-receive                     | luac: <rianne-quest-receive>:8: function arguments expected 
  103 | 10309 | MOB    | khysan-greet                             | luac: <khysan-greet>:4: <name> expected near 'return'
  103 | 10312 | MOB    | ice_shards_khysan_speech3                | luac: <ice_shards_khysan_speech3>:19: 'then' expected near '
  103 | 10313 | MOB    | ice_shards_khysan_receive1               | luac: <ice_shards_khysan_receive1>:6: function arguments exp
  103 | 10325 | MOB    | Khysan refuse                            | luac: <Khysan refuse>:26: syntax error near 'think'
  120 | 12003 | MOB    | Druid receive                            | luac: <Druid receive>:35: function arguments expected near '
  123 | 12301 | MOB    | priestess_speech1                        | luac: <priestess_speech1>:14: 'then' expected near '?'
  123 | 12302 | MOB    | priestess_speech2                        | luac: <priestess_speech2>:14: 'then' expected near 'RITE'
  123 | 12303 | MOB    | priestess_speech3                        | luac: <priestess_speech3>:14: 'then' expected near 'gods'
  123 | 12304 | MOB    | priestess_speech4                        | luac: <priestess_speech4>:14: 'then' expected near 'away'
  123 | 12305 | MOB    | megalith_quest_priestess_speech_start    | luac: <megalith_quest_priestess_speech_start>:66: ')' expect
  123 | 12306 | MOB    | megalith_quest_priestess_receive         | luac: <megalith_quest_priestess_receive>:103: function argum
  123 | 12312 | MOB    | megalith_quest_priestess_speech_progress | luac: <megalith_quest_priestess_speech_progress>:74: syntax 
  123 | 12313 | MOB    | megalith_quest_keeper_greet              | luac: <megalith_quest_keeper_greet>:7: function arguments ex
  123 | 12314 | MOB    | megalith_quest_keeper_speech             | luac: <megalith_quest_keeper_speech>:16: 'then' expected nea
  123 | 12315 | MOB    | megalith_quest_keeper_receive            | luac: <megalith_quest_keeper_receive>:37: function arguments
  123 | 12323 | MOB    | megalith_quest_mother_act_kneel_rewards  | luac: <megalith_quest_mother_act_kneel_rewards>:110: ')' exp
  123 | 12326 | MOB    | witch_priestess_exposition               | luac: <witch_priestess_exposition>:14: ')' expected near 'ar
  123 | 12336 | MOB    | vityaz_exposition                        | luac: <vityaz_exposition>:9: ')' expected near 'are'
  123 | 12337 | MOB    | north_exposition                         | luac: <north_exposition>:9: ')' expected near 'are'
  123 | 12338 | MOB    | south_exposition                         | luac: <south_exposition>:9: ')' expected near 'are'
  123 | 12339 | MOB    | east_exposition                          | luac: <east_exposition>:9: ')' expected near 'are'
  123 | 12340 | MOB    | west_exposition                          | luac: <west_exposition>:9: ')' expected near 'are'
  123 | 12341 | MOB    | witch_exposition                         | luac: <witch_exposition>:9: ')' expected near 'are'
  123 | 12342 | MOB    | Keeper refuse                            | luac: <Keeper refuse>:32: function arguments expected near '
  125 | 12532 | MOB    | StoneCultWhat                            | luac: <StoneCultWhat>:8: unexpected symbol near '.5'
  133 | 13301 | MOB    | raph_greet_queststart                    | luac: <raph_greet_queststart>:8: <eof> expected near 'else'
  133 | 13328 | OBJECT | heavens_gate_pedestal_put                | luac: <heavens_gate_pedestal_put>:41: function arguments exp
  133 | 13329 | OBJECT | heavens_gate_key_seal                    | luac: <heavens_gate_key_seal>:17: function arguments expecte
  133 | 13330 | MOB    | heavens_gate_starlight_speech1           | luac: <heavens_gate_starlight_speech1>:14: unexpected symbol
  163 | 16301 | MOB    | quest_eleweiss_ranger_druid_subclass_gre | luac: <quest_eleweiss_ranger_druid_subclass_greet>:7: functi
  163 | 16302 | MOB    | quest_eleweiss_ranger_druid_subclass_spe | luac: <quest_eleweiss_ranger_druid_subclass_speak1>:9: ')' e
  163 | 16342 | MOB    | dryad_moonwell_yesno                     | luac: <dryad_moonwell_yesno>:16: unexpected symbol near '='
  172 | 17206 | OBJECT | Ill-subclass: Drop the vial              | luac: <Ill-subclass: Drop the vial>:20: unexpected symbol ne
  172 | 17214 | MOB    | Ill-subclass: Grand Master answers 'help | luac: <Ill-subclass: Grand Master answers 'help'>:30: 'end' 
  178 | 17803 | MOB    | shaman_greet1                            | luac: <shaman_greet1>:11: function arguments expected near '
  185 | 18501 | MOB    | silania_welcome                          | luac: <silania_welcome>:37: function arguments expected near
  185 | 18502 | MOB    | quest_preamble_silania                   | luac: <quest_preamble_silania>:14: ')' expected near '?'
  185 | 18518 | MOB    | group_heal_doctor_speech2                | luac: <group_heal_doctor_speech2>:15: 'then' expected near '
  185 | 18520 | MOB    | group_heal_doctor_receive                | luac: <group_heal_doctor_receive>:82: function arguments exp
  185 | 18522 | MOB    | group_heal_chefs_receive                 | luac: <group_heal_chefs_receive>:6: function arguments expec
  185 | 18523 | OBJECT | group_heal_injured_give                  | luac: <group_heal_injured_give>:10: function arguments expec
  185 | 18525 | MOB    | group_heal_new_rite                      | luac: <group_heal_new_rite>:15: unexpected symbol near 'else
  185 | 18599 | MOB    | group_heal_status_check                  | luac: <group_heal_status_check>:106: 'end' expected (to clos
  188 | 18803 | WORLD  | Block_entry                              | luac: <Block_entry>:27: unexpected symbol near 'then'
  188 | 18804 | WORLD  | test_trigger                             | luac: <test_trigger>:7: unexpected symbol near '%'
  188 | 18821 | OBJECT | xcast_xdecide                            | luac: <xcast_xdecide>:37: 'then' expected near 'string'
  188 | 18842 | OBJECT | talon_wear                               | luac: <talon_wear>:4: function arguments expected near '.'
  188 | 18844 | OBJECT | globe_get                                | luac: <globe_get>:4: function arguments expected near '.'
  188 | 18870 | MOB    | smart combat                             | luac: <smart combat>:3: unexpected symbol near ')'
  188 | 18880 | OBJECT | ctf_armband_tag                          | luac: <ctf_armband_tag>:169: unexpected symbol near ')'
  188 | 18881 | OBJECT | ctf_flag_get                             | luac: <ctf_flag_get>:19: unexpected symbol near '%'
  188 | 18888 | OBJECT | quest_item_binding                       | luac: <quest_item_binding>:26: function arguments expected n
  188 | 18891 | OBJECT | summon_dragon                            | luac: <summon_dragon>:20: unexpected symbol near ')'
  237 | 23705 | MOB    | shroom-attack                            | luac: <shroom-attack>:15: unexpected symbol near '='
  237 | 23724 | MOB    | ***UNUSED***                             | luac: <***UNUSED***>:33: <eof> expected near 'end'
  237 | 23728 | MOB    | serin-receive                            | luac: <serin-receive>:48: 'end' expected (to close 'if' at l
  237 | 23752 | MOB    | receive-rewards                          | luac: <receive-rewards>:92: function arguments expected near
  237 | 23781 | OBJECT | glazed-stiletto-wield                    | luac: <glazed-stiletto-wield>:4: function arguments expected
  238 | 23810 | MOB    | mage_greet                               | luac: <mage_greet>:7: function arguments expected near ']'
  238 | 23818 | WORLD  | tempest_fight_room                       | luac: <tempest_fight_room>:13: unexpected symbol near '.2389
  238 | 23842 | WORLD  | wall-refit                               | luac: <wall-refit>:5: ')' expected near 'The'
  364 | 36404 | MOB    | illusory_wall_lyara_receive              | luac: <illusory_wall_lyara_receive>:9: function arguments ex
  364 | 36405 | OBJECT | illusory_wall_glasses_examine            | luac: <illusory_wall_glasses_examine>:223: unexpected symbol
  370 | 37018 | MOB    | mes-rec                                  | luac: <mes-rec>:9: unexpected symbol near '%'
  390 | 39004 | OBJECT | flood_heart_speech                       | luac: <flood_heart_speech>:19: 'then' expected near 'Arabel'
  390 | 39007 | MOB    | flood_spirits_receive                    | luac: <flood_spirits_receive>:81: function arguments expecte
  430 | 43057 | MOB    | word_of_command_dargo_order              | luac: <word_of_command_dargo_order>:9: 'then' expected near 
  462 | 46200 | WORLD  | Nukreth Spire start path1 human          | luac: <Nukreth Spire start path1 human>:3: 'then' expected n
  462 | 46201 | WORLD  | Nukreth Spire start path2 kobold         | luac: <Nukreth Spire start path2 kobold>:3: 'then' expected 
  462 | 46202 | WORLD  | Nukreth Spire start path3 orc            | luac: <Nukreth Spire start path3 orc>:3: 'then' expected nea
  462 | 46203 | WORLD  | Nukreth Spire start path4 goblin         | luac: <Nukreth Spire start path4 goblin>:3: 'then' expected 
  462 | 46204 | MOB    | Nukreth Spire chieftain death            | luac: <Nukreth Spire chieftain death>:25: function arguments
  462 | 46205 | MOB    | Nukreth Spire path2 3 4 captive greet    | luac: <Nukreth Spire path2 3 4 captive greet>:5: function ar
  462 | 46206 | MOB    | Nukreth Spire captive follow me          | luac: <Nukreth Spire captive follow me>:16: function argumen
  462 | 46235 | MOB    | Nukreth Spire path1 captive greet        | luac: <Nukreth Spire path1 captive greet>:17: function argum
  481 | 48124 | MOB    | vulcera_greet1                           | luac: <vulcera_greet1>:19: function arguments expected near 
  482 | 48253 | MOB    | mccabe greet                             | luac: <mccabe greet>:49: unexpected symbol near '='
  482 | 48256 | MOB    | mccabe dialog                            | luac: <mccabe dialog>:20: ')' expected near '?'
  482 | 48258 | MOB    | mccabe_receive                           | luac: <mccabe_receive>:12: unexpected symbol near '='
  482 | 48299 | MOB    | meteorswarm_status_checker               | luac: <meteorswarm_status_checker>:16: unexpected symbol nea
  484 | 48401 | MOB    | oracle-sun-greet                         | luac: <oracle-sun-greet>:11: function arguments expected nea
  484 | 48428 | MOB    | Justice refuse                           | luac: <Justice refuse>:10: syntax error near 'can'
  488 | 48809 | MOB    | stormlord fight                          | luac: <stormlord fight>:56: syntax error near 'end'
  490 | 49022 | MOB    | Seer refuse                              | luac: <Seer refuse>:7: 'end' expected (to close 'if' at line
  495 | 49504 | WORLD  | Transfer trig                            | luac: <Transfer trig>:15: unexpected symbol near '+'
  510 | 51001 | WORLD  | maze_room_one                            | luac: <maze_room_one>:35: unexpected symbol near '%'
  510 | 51005 | MOB    | want_to_help_Luchiaans                   | luac: <want_to_help_Luchiaans>:16: 'then' expected near '?'
  519 | 51900 | MOB    | academy_recruitor_speech_select          | luac: <academy_recruitor_speech_select>:84: 'end' expected (
  519 | 51911 | MOB    | academy_instructor_command_get           | luac: <academy_instructor_command_get>:46: 'then' expected n
  519 | 51965 | MOB    | academy_revel_command_deposit            | luac: <academy_revel_command_deposit>:14: 'then' expected ne
  520 | 52000 | WORLD  | rock_demon_call_rock                     | luac: <rock_demon_call_rock>:35: unexpected symbol near '='
  520 | 52025 | WORLD  | rock_well_load_door                      | luac: <rock_well_load_door>:8: unexpected symbol near '='
  533 | 53308 | MOB    | wall_ice_sculptor_greet                  | luac: <wall_ice_sculptor_greet>:7: function arguments expect
  534 | 53467 | MOB    | Major Globe Lirne receive 3              | luac: <Major Globe Lirne receive 3>:7: function arguments ex
  535 | 53504 | OBJECT | Staff damage user                        | luac: <Staff damage user>:20: unexpected symbol near ')'
  550 | 55000 | MOB    | quest_cryo_greet                         | luac: <quest_cryo_greet>:13: function arguments expected nea
  550 | 55001 | MOB    | Tech_Master_Shaman_1                     | luac: <Tech_Master_Shaman_1>:47: function arguments expected
  550 | 55008 | MOB    | Master Shaman refuse                     | luac: <Master Shaman refuse>:13: 'end' expected (to close 'i
  550 | 55034 | MOB    | wizard_eye_seer_greet                    | luac: <wizard_eye_seer_greet>:10: function arguments expecte
  550 | 55036 | MOB    | wizard_eye_seer_receive                  | luac: <wizard_eye_seer_receive>:13: function arguments expec
  550 | 55038 | MOB    | wizard_eye_apothecary_speech             | luac: <wizard_eye_apothecary_speech>:10: 'then' expected nea
  550 | 55039 | MOB    | wizard_eye_apothecary_receive            | luac: <wizard_eye_apothecary_receive>:15: function arguments
  550 | 55040 | MOB    | wizard_eye_oracle_receive                | luac: <wizard_eye_oracle_receive>:15: function arguments exp
  553 | 55301 | MOB    | cleric_phase_1                           | luac: <cleric_phase_1>:112: function arguments expected near
  553 | 55320 | MOB    | warrior_phase_1                          | luac: <warrior_phase_1>:113: function arguments expected nea
  553 | 55330 | MOB    | sorcerer_phase_1                         | luac: <sorcerer_phase_1>:112: function arguments expected ne
  553 | 55340 | MOB    | rogue_phase_1                            | luac: <rogue_phase_1>:112: function arguments expected near 
  553 | 55350 | MOB    | anti-paladin_phase_2                     | luac: <anti-paladin_phase_2>:112: function arguments expecte
  553 | 55360 | MOB    | cleric_phase_2                           | luac: <cleric_phase_2>:111: function arguments expected near
  553 | 55370 | MOB    | diabolist_phase_2                        | luac: <diabolist_phase_2>:112: function arguments expected n
  553 | 55380 | MOB    | druid_phase_2                            | luac: <druid_phase_2>:112: function arguments expected near 
  553 | 55390 | MOB    | monk_phase_2                             | luac: <monk_phase_2>:112: function arguments expected near '
  554 | 55400 | MOB    | necromancer_phase_2                      | luac: <necromancer_phase_2>:112: function arguments expected
  554 | 55410 | MOB    | paladin_phase_2                          | luac: <paladin_phase_2>:112: function arguments expected nea
  554 | 55420 | MOB    | ranger_phase_2                           | luac: <ranger_phase_2>:112: function arguments expected near
  554 | 55430 | MOB    | rogue_phase_2                            | luac: <rogue_phase_2>:111: function arguments expected near 
  554 | 55440 | MOB    | warrior_phase_2                          | luac: <warrior_phase_2>:112: function arguments expected nea
  554 | 55450 | MOB    | sorcerer_phase_2                         | luac: <sorcerer_phase_2>:111: function arguments expected ne
  554 | 55460 | MOB    | anti-paladin_phase_3                     | luac: <anti-paladin_phase_3>:112: function arguments expecte
  554 | 55470 | MOB    | **UNUSED**                               | luac: <**UNUSED**>:111: function arguments expected near ']'
  554 | 55480 | MOB    | diabolist_phase_3                        | luac: <diabolist_phase_3>:112: function arguments expected n
  554 | 55490 | MOB    | druid_phase_3                            | luac: <druid_phase_3>:112: function arguments expected near 
  555 | 55500 | MOB    | sorcerer_phase_3                         | luac: <sorcerer_phase_3>:111: function arguments expected ne
  555 | 55510 | MOB    | monk_phase_3                             | luac: <monk_phase_3>:112: function arguments expected near '
  555 | 55520 | MOB    | necromancer_phase_3                      | luac: <necromancer_phase_3>:112: function arguments expected
  555 | 55530 | MOB    | paladin_phase_3                          | luac: <paladin_phase_3>:112: function arguments expected nea
  555 | 55540 | MOB    | ranger_phase_3                           | luac: <ranger_phase_3>:112: function arguments expected near
  555 | 55550 | MOB    | rogue_phase_3                            | luac: <rogue_phase_3>:111: function arguments expected near 
  555 | 55560 | MOB    | warrior_phase_3                          | luac: <warrior_phase_3>:112: function arguments expected nea
  556 | 55606 | MOB    | phase_1_warrior_status                   | luac: <phase_1_warrior_status>:40: function arguments expect
  556 | 55607 | MOB    | phase_1_sorcerer_status                  | luac: <phase_1_sorcerer_status>:8: unexpected symbol near '=
  556 | 55608 | MOB    | phase_1_rogue_status                     | luac: <phase_1_rogue_status>:8: unexpected symbol near '='
  556 | 55609 | MOB    | phase_1_cleric_status                    | luac: <phase_1_cleric_status>:8: unexpected symbol near '='
  556 | 55610 | MOB    | phase_2_cleric_status                    | luac: <phase_2_cleric_status>:8: unexpected symbol near '='
  556 | 55611 | MOB    | phase_2_druid_status                     | luac: <phase_2_druid_status>:8: unexpected symbol near '='
  556 | 55612 | MOB    | phase_2_sorcerer_status                  | luac: <phase_2_sorcerer_status>:39: function arguments expec
  556 | 55613 | MOB    | phase_2_paladin_status                   | luac: <phase_2_paladin_status>:39: function arguments expect
  556 | 55614 | MOB    | phase_2_monk_status                      | luac: <phase_2_monk_status>:39: function arguments expected 
  556 | 55615 | MOB    | phase_2_necromancer_status               | luac: <phase_2_necromancer_status>:39: function arguments ex
  556 | 55616 | MOB    | phase_2_ranger_status                    | luac: <phase_2_ranger_status>:39: function arguments expecte
  556 | 55617 | MOB    | phase_3_anti-paladin_status              | luac: <phase_3_anti-paladin_status>:39: function arguments e
  556 | 55618 | MOB    | phase_3_monk_status                      | luac: <phase_3_monk_status>:39: function arguments expected 
  556 | 55619 | MOB    | phase_3_druid_status                     | luac: <phase_3_druid_status>:39: function arguments expected
  556 | 55620 | MOB    | phase_3_paladin_status                   | luac: <phase_3_paladin_status>:39: function arguments expect
  556 | 55621 | MOB    | phase_2_warrior_status                   | luac: <phase_2_warrior_status>:39: function arguments expect
  556 | 55622 | MOB    | phase_2_anti-paladin_status              | luac: <phase_2_anti-paladin_status>:38: function arguments e
  556 | 55623 | MOB    | phase_2_diabolist_status                 | luac: <phase_2_diabolist_status>:34: function arguments expe
  556 | 55624 | MOB    | phase_2_rogue_status                     | luac: <phase_2_rogue_status>:39: function arguments expected
  556 | 55625 | MOB    | phase_3_warrior_status                   | luac: <phase_3_warrior_status>:39: function arguments expect
  556 | 55626 | MOB    | phase_3_ranger_status                    | luac: <phase_3_ranger_status>:39: function arguments expecte
  556 | 55627 | MOB    | **UNUSED**                               | luac: <**UNUSED**>:39: function arguments expected near ']'
  556 | 55628 | MOB    | phase_3_necromancer_status               | luac: <phase_3_necromancer_status>:39: function arguments ex
  556 | 55629 | MOB    | phase_3_sorcerer_status                  | luac: <phase_3_sorcerer_status>:39: function arguments expec
  556 | 55630 | MOB    | phase_3_diabolist_status                 | luac: <phase_3_diabolist_status>:39: function arguments expe
  556 | 55631 | MOB    | phase_3_rogue_status                     | luac: <phase_3_rogue_status>:39: function arguments expected
  557 | 55700 | MOB    | Phase Armor - Greet                      | luac: <Phase Armor - Greet>:100: 'then' expected near 'self'
  557 | 55702 | MOB    | Phase Armor - Armor                      | luac: <Phase Armor - Armor>:29: 'then' expected near '?'
  557 | 55703 | MOB    | Phase Armor - Receive                    | luac: <Phase Armor - Receive>:85: function arguments expecte
  557 | 55704 | MOB    | Phase Armor - Status                     | luac: <Phase Armor - Status>:32: function arguments expected
  564 | 56404 | MOB    | hell_gate_diabolist_receive              | luac: <hell_gate_diabolist_receive>:54: function arguments e
  564 | 56405 | MOB    | hell_gate_mob_death                      | luac: <hell_gate_mob_death>:25: function arguments expected 
  564 | 56406 | WORLD  | hell_gate_island_drop                    | luac: <hell_gate_island_drop>:5: function arguments expected
  580 | 58005 | MOB    | charm_person_hinazuru_receive            | luac: <charm_person_hinazuru_receive>:69: function arguments
  580 | 58008 | MOB    | charm_person_status_checker              | luac: <charm_person_status_checker>:16: unexpected symbol ne
  583 | 58380 | OBJECT | holy_burn_the_wicked                     | luac: <holy_burn_the_wicked>:21: unexpected symbol near '='
  584 | 58412 | MOB    | Dancer_quest_ASK                         | luac: <Dancer_quest_ASK>:17: unexpected symbol near '='
  586 | 58601 | MOB    | dragons_health_myorrhed_speech           | luac: <dragons_health_myorrhed_speech>:11: 'then' expected n
  586 | 58602 | MOB    | dragons_health_myorrhed_receive          | luac: <dragons_health_myorrhed_receive>:113: function argume
  590 | 59005 | MOB    | dark_robed_greet1                        | luac: <dark_robed_greet1>:13: ')' expected near 'then'
  590 | 59046 | MOB    | group_armor_forgemaster_receive          | luac: <group_armor_forgemaster_receive>:7: function argument
  615 | 61553 | MOB    | creeping_doom_pixie_receive              | luac: <creeping_doom_pixie_receive>:7: function arguments ex
  615 | 61555 | WORLD  | creeping_doom_logging_camp_drop          | luac: <creeping_doom_logging_camp_drop>:9: ')' expected near
  615 | 61556 | MOB    | creeping_doom_status_checker             | luac: <creeping_doom_status_checker>:53: function arguments 
  625 | 62501 | MOB    | calling for help                         | luac: <calling for help>:9: unexpected symbol near '%'
  625 | 62518 | MOB    | merchant dialogue                        | luac: <merchant dialogue>:18: 'then' expected near '?'
  625 | 62550 | WORLD  | quest room                               | luac: <quest room>:61: unexpected symbol near '%'
  625 | 62551 | MOB    | letters for the merchant                 | luac: <letters for the merchant>:3: unexpected symbol near '
  625 | 62571 | OBJECT | the BIG hurt                             | luac: <the BIG hurt>:28: 'end' expected (to close 'if' at li
(289 rows)

---
