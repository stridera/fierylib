"""
Flags for the MUD.  These are all items that can be set via a bitflag.
"""

SPELLS = [
    "NONE",
    "ARMOR",  # 1
    "TELEPORT",  # 2
    "BLESS",  # 3
    "BLINDNESS",  # 4
    "BURNING_HANDS",  # 5
    "CALL_LIGHTNING",  # 6
    "CHARM",  # 7
    "CHILL_TOUCH",  # 8
    "CLONE",  # 9
    "COLOR_SPRAY",  # 10
    "CONTROL_WEATHER",  # 11
    "CREATE_FOOD",  # 12
    "CREATE_WATER",  # 13
    "CURE_BLIND",  # 14
    "CURE_CRITIC",  # 15
    "CURE_LIGHT",  # 16
    "CURSE",  # 17
    "DETECT_ALIGN",  # 18
    "DETECT_INVIS",  # 19
    "DETECT_MAGIC",  # 20
    "DETECT_POISON",  # 21
    "DISPEL_EVIL",  # 22
    "EARTHQUAKE",  # 23
    "ENCHANT_WEAPON",  # 24
    "ENERGY_DRAIN",  # 25
    "FIREBALL",  # 26
    "HARM",  # 27
    "HEAL",  # 28
    "INVISIBLE",  # 29
    "LIGHTNING_BOLT",  # 30
    "LOCATE_OBJECT",  # 31
    "MAGIC_MISSILE",  # 32
    "POISON",  # 33
    "PROT_FROM_EVIL",  # 34
    "REMOVE_CURSE",  # 35
    "SANCTUARY",  # 36
    "SHOCKING_GRASP",  # 37
    "SLEEP",  # 38
    "ENHANCE_ABILITY",  # 39
    "SUMMON",  # 40
    "VENTRILOQUATE",  # 41
    "WORD_OF_RECALL",  # 42
    "REMOVE_POISON",  # 43
    "SENSE_LIFE",  # 44
    "ANIMATE_DEAD",  # 45
    "DISPEL_GOOD",  # 46
    "GROUP_ARMOR",  # 47
    "GROUP_HEAL",  # 48
    "GROUP_RECALL",  # 49
    "INFRAVISION",  # 50
    "WATERWALK",  # 51
    "STONE_SKIN",  # 52
    "FULL_HEAL",  # 53
    "FULL_HARM",  # 54
    "WALL_OF_FOG",  # 55
    "WALL_OF_STONE",  # 56
    "FLY",  # 57
    "SUMMON_DRACOLICH",  # 58
    "SUMMON_ELEMENTAL",  # 59
    "SUMMON_DEMON",  # 60
    "SUMMON_GREATER_DEMON",  # 61
    "DIMENSION_DOOR",  # 62
    "CREEPING_DOOM",  # 63
    "DOOM",  # 64
    "METEORSWARM",  # 65
    "BIGBYS_CLENCHED_FIST",  # 66
    "FARSEE",  # 67
    "HASTE",  # 68
    "BLUR",  # 69
    "GREATER_ENDURANCE",  # 70
    "MOONWELL",  # 71
    "INN_STRENGTH",  # 72
    "DARKNESS",  # 73
    "ILLUMINATION",  # 74
    "COMPREHEND_LANG",  # 75
    "CONE_OF_COLD",  # 76
    "ICE_STORM",  # 77
    "ICE_SHARDS",  # 78
    "MAJOR_PARALYSIS",  # 79
    "VAMPIRIC_BREATH",  # 80
    "RESURRECT",  # 81
    "INCENDIARY_NEBULA",  # 82
    "MINOR_PARALYSIS",  # 83
    "CAUSE_LIGHT",  # 84
    "CAUSE_SERIOUS",  # 85
    "CAUSE_CRITIC",  # 86
    "PRESERVE",  # 87
    "CURE_SERIOUS",  # 88
    "VIGORIZE_LIGHT",  # 89
    "VIGORIZE_SERIOUS",  # 90
    "VIGORIZE_CRITIC",  # 91
    "SOULSHIELD",  # 92
    "DESTROY_UNDEAD",  # 93
    "SILENCE",  # 94
    "FLAMESTRIKE",  # 95
    "UNHOLY_WORD",  # 96
    "HOLY_WORD",  # 97
    "PLANE_SHIFT",  # 98
    "DISPEL_MAGIC",  # 99
    "MINOR_CREATION",  # 100
    "CONCEALMENT",  # 101
    "RAY_OF_ENFEEB",  # 102
    "FEATHER_FALL",  # 103
    "WIZARD_EYE",  # 104
    "FIRESHIELD",  # 105
    "COLDSHIELD",  # 106
    "MINOR_GLOBE",  # 107
    "MAJOR_GLOBE",  # 108
    "DISINTEGRATE",  # 109
    "HARNESS",  # 110
    "CHAIN_LIGHTNING",  # 111
    "MASS_INVIS",  # 112
    "RELOCATE",  # 113
    "FEAR",  # 114
    "CIRCLE_OF_LIGHT",  # 115
    "DIVINE_BOLT",  # 116
    "PRAYER",  # 117
    "ELEMENTAL_WARDING",  # 118
    "DIVINE_RAY",  # 119
    "LESSER_EXORCISM",  # 120
    "DECAY",  # 121
    "SPEAK_IN_TONGUES",  # 122
    "ENLIGHTENMENT",  # 123
    "EXORCISM",  # 124
    "SPINECHILLER",  # 125
    "WINGS_OF_HEAVEN",  # 126
    "BANISH",  # 127
    "WORD_OF_COMMAND",  # 128
    "DIVINE_ESSENCE",  # 129
    "HEAVENS_GATE",  # 130
    "DARK_PRESENCE",  # 131
    "DEMONSKIN",  # 132
    "DARK_FEAST",  # 133
    "HELL_BOLT",  # 134
    "DISEASE",  # 135
    "INSANITY",  # 136
    "DEMONIC_ASPECT",  # 137
    "HELLFIRE_BRIMSTONE",  # 138
    "STYGIAN_ERUPTION",  # 139
    "DEMONIC_MUTATION",  # 140
    "WINGS_OF_HELL",  # 141
    "SANE_MIND",  # 142
    "HELLS_GATE",  # 143
    "BARKSKIN",  # 144
    "NIGHT_VISION",  # 145
    "WRITHING_WEEDS",  # 146
    "CREATE_SPRING",  # 147
    "NOURISHMENT",  # 148
    "GAIAS_CLOAK",  # 149
    "NATURES_EMBRACE",  # 150
    "ENTANGLE",  # 151
    "INVIGORATE",  # 152
    "WANDERING_WOODS",  # 153
    "URBAN_RENEWAL",  # 154
    "SUNRAY",  # 155
    "ARMOR_OF_GAIA",  # 156
    "FIRE_DARTS",  # 157
    "MAGIC_TORCH",  # 158
    "SMOKE",  # 159
    "MIRAGE",  # 160
    "FLAME_BLADE",  # 161
    "POSITIVE_FIELD",  # 162
    "FIRESTORM",  # 163
    "MELT",  # 164
    "CIRCLE_OF_FIRE",  # 165
    "IMMOLATE",  # 166
    "SUPERNOVA",  # 167
    "CREMATE",  # 168
    "NEGATE_HEAT",  # 169
    "ACID_BURST",  # 170
    "ICE_DARTS",  # 171
    "ICE_ARMOR",  # 172
    "ICE_DAGGER",  # 173
    "FREEZING_WIND",  # 174
    "FREEZE",  # 175
    "WALL_OF_ICE",  # 176
    "ICEBALL",  # 177
    "FLOOD",  # 178
    "VAPORFORM",  # 179
    "NEGATE_COLD",  # 180
    "WATERFORM",  # 181
    "EXTINGUISH",  # 182
    "RAIN",  # 183
    "REDUCE",  # 184
    "ENLARGE",  # 185
    "IDENTIFY",  # 186
    "BONE_ARMOR",  # 187
    "SUMMON_CORPSE",  # 188
    "SHIFT_CORPSE",  # 189
    "GLORY",  # 190
    "ILLUSORY_WALL",  # 191
    "NIGHTMARE",  # 192
    "DISCORPORATE",  # 193
    "ISOLATION",  # 194
    "FAMILIARITY",  # 195
    "HYSTERIA",  # 196
    "MESMERIZE",  # 197
    "SEVERANCE",  # 198
    "SOUL_REAVER",  # 199
    "DETONATION",  # 200
    "FIRE_BREATH",  # 201
    "GAS_BREATH",  # 202
    "FROST_BREATH",  # 203
    "ACID_BREATH",  # 204
    "LIGHTNING_BREATH",  # 205
    "LESSER_ENDURANCE",  # 206
    "ENDURANCE",  # 207
    "VITALITY",  # 208
    "GREATER_VITALITY",  # 209
    "DRAGONS_HEALTH",  # 210
    "REBUKE_UNDEAD",  # 211
    "DEGENERATION",  # 212
    "SOUL_TAP",  # 213
    "NATURES_GUIDANCE",  # 214
    "MOONBEAM",  # 215
    "PHANTASM",  # 216
    "SIMULACRUM",  # 217
    "MISDIRECTION",  # 218
    "CONFUSION",  # 219
    "PHOSPHORIC_EMBERS",  # 220
    "RECALL",  # 221
    "PYRE",  # 222
    "IRON_MAIDEN",  # 223
    "FRACTURE",  # 224
    "FRACTURE_SHRAPNEL",  # 225
    "BONE_CAGE",  # 226
    "PYRE_RECOIL",  # 227
    "WORLD_TELEPORT",  # 228
    "INN_SYLL",  # 229
    "INN_TREN",  # 230
    "INN_TASS",  # 231
    "INN_BRILL",  # 232
    "INN_ASCEN",  # 233
    "SPIRIT_ARROWS",  # 234
    "PROT_FROM_GOOD",  # 235
    "ANCESTRAL_VENGEANCE",  # 236
    "CIRCLE_OF_DEATH",  # 237
    "BALEFUL_POLYMORPH",  # 238
    "SPIRIT_RAY",  # 239
    "VICIOUS_MOCKERY",  # 240
    "REMOVE_PARALYSIS",  # 241
    "CLOUD_OF_DAGGERS",  # 242
    "REVEAL_HIDDEN",  # 243
    "BLINDING_BEAUTY",  # 244
    "ACID_FOG",  # 245
    "WEB",  # 246
    "EARTH_BLESSING",  # 247
    "PROTECT_FIRE",  # 248
    "PROTECT_COLD",  # 249
    "PROTECT_ACID",  # 250
    "PROTECT_SHOCK",  # 251
    "ENHANCE_STR",  # 252
    "ENHANCE_DEX",  # 253
    "ENHANCE_CON",  # 254
    "ENHANCE_INT",  # 255
    "ENHANCE_WIS",  # 256
    "ENHANCE_CHA",  # 257
    "MONK_FIRE",  # 258
    "MONK_COLD",  # 259
    "MONK_ACID",  # 260
    "MONK_SHOCK",  # 261
    "STATUE",  # 262
    "WATER_BLAST",  # 263
    "DISPLACEMENT",  # 264
    "GREATER_DISPLACEMENT",  # 265
    "NIMBLE",  # 266
    "CLARITY",  # 267
]

# Player skills starting at index 401
PLAYER_SKILLS = [
    "BACKSTAB",  # 401
    "BASH",  # 402
    "HIDE",  # 403
    "KICK",  # 404
    "PICK_LOCK",  # 405
    "PUNCH",  # 406
    "RESCUE",  # 407
    "SNEAK",  # 408
    "STEAL",  # 409
    "TRACK",  # 410
    "DUAL_WIELD",  # 411
    "DOUBLE_ATTACK",  # 412
    "BERSERK",  # 413
    "SPRINGLEAP",  # 414
    "MOUNT",  # 415
    "RIDING",  # 416
    "TAME",  # 417
    "THROATCUT",  # 418
    "DOORBASH",  # 419
    "PARRY",  # 420
    "DODGE",  # 421
    "RIPOSTE",  # 422
    "MEDITATE",  # 423
    "QUICK_CHANT",  # 424
    "TWO_BACKSTAB",  # 425
    "CIRCLE",  # 426
    "BODYSLAM",  # 427
    "BIND",  # 428
    "SHAPECHANGE",  # 429
    "SWITCH",  # 430
    "DISARM",  # 431
    "DISARM_FUMBLING_WEAPON",  # 432
    "DISARM_DROPPED_WEAPON",  # 433
    "GUARD",  # 434
    "BREATHE_LIGHTNING",  # 435
    "SWEEP",  # 436
    "ROAR",  # 437
    "DOUSE",  # 438
    "AWARE",  # 439
    "INSTANT_KILL",  # 440
    "HITALL",  # 441 (C++ uses SKILL_HITALL, not SKILL_HIT_ALL)
    "HUNT",  # 442
    "BANDAGE",  # 443
    "FIRST_AID",  # 444
    "VAMP_TOUCH",  # 445 (C++ uses SKILL_VAMP_TOUCH, not SKILL_VAMPIRIC_TOUCH)
    "CHANT",  # 446
    "SCRIBE",  # 447
    "SAFEFALL",  # 448
    "BAREHAND",  # 449
    "SUMMON_MOUNT",  # 450
    "KNOW_SPELL",  # 451
    "SPHERE_GENERIC",  # 452
    "SPHERE_FIRE",  # 453
    "SPHERE_WATER",  # 454
    "SPHERE_EARTH",  # 455
    "SPHERE_AIR",  # 456
    "SPHERE_HEALING",  # 457
    "SPHERE_PROTECTION",  # 458
    "SPHERE_ENCHANT",  # 459
    "SPHERE_SUMMON",  # 460
    "SPHERE_DEATH",  # 461
    "SPHERE_DIVINATION",  # 462
    "BLUDGEONING",  # 463
    "PIERCING",  # 464
    "SLASHING",  # 465
    "2H_BLUDGEONING",  # 466 (C++ uses SKILL_2H_BLUDGEONING, not SKILL_TWO_HAND_BLUDGEONING)
    "2H_PIERCING",  # 467 (C++ uses SKILL_2H_PIERCING, not SKILL_TWO_HAND_PIERCING)
    "2H_SLASHING",  # 468 (C++ uses SKILL_2H_SLASHING, not SKILL_TWO_HAND_SLASHING)
    "MISSILE",  # 469
    "ON_FIRE",  # 470 (spell effect in skill range)
    "LAY_HANDS",  # 471
    "EYE_GOUGE",  # 472
    "RETREAT",  # 473
    "GROUP_RETREAT",  # 474
    "CORNER",  # 475
    "STEALTH",  # 476
    "SHADOW",  # 477
    "CONCEAL",  # 478
    "PECK",  # 479
    "CLAW",  # 480
    "ELECTRIFY",  # 481
    "TANTRUM",  # 482
    "GROUND_SHAKER",  # 483
    "BATTLE_HOWL",  # 484
    "MAUL",  # 485
    "BREATHE_FIRE",  # 486
    "BREATHE_FROST",  # 487
    "BREATHE_ACID",  # 488
    "BREATHE_GAS",  # 489
    "PERFORM",  # 490
    "CARTWHEEL",  # 491
    "LURE",  # 492
    "SNEAK_ATTACK",  # 493
    "REND",  # 494
    "ROUNDHOUSE",  # 495
]

# Bardic songs starting at index 551
BARDIC_SONGS = [
    "INSPIRATION",  # 551
    "TERROR",  # 552
    "ENRAPTURE",  # 553
    "HEARTHSONG",  # 554
    "CROWN_OF_MADNESS",  # 555
    "SONG_OF_REST",  # 556
    "BALLAD_OF_TEARS",  # 557
    "HEROIC_JOURNEY",  # 558
    "FREEDOM_SONG",  # 559
    "JOYFUL_NOISE",  # 560
]

# Monk chants starting at index 601
MONK_CHANTS = [
    "REGENERATION",  # 601
    "BATTLE_HYMN",  # 602
    "WAR_CRY",  # 603
    "PEACE",  # 604
    "SHADOWS_SORROW_SONG",  # 605
    "IVORY_SYMPHONY",  # 606
    "ARIA_OF_DISSONANCE",  # 607
    "SONATA_OF_MALAISE",  # 608
    "APOCALYPTIC_ANTHEM",  # 609
    "SEED_OF_DESTRUCTION",  # 610
    "SPIRIT_WOLF",  # 611
    "SPIRIT_BEAR",  # 612
    "INTERMINABLE_WRATH",  # 613
    "HYMN_OF_SAINT_AUGUSTINE",  # 614
    "FIRES_OF_SAINT_AUGUSTINE",  # 615
    "BLIZZARDS_OF_SAINT_AUGUSTINE",  # 616
    "TREMORS_OF_SAINT_AUGUSTINE",  # 617
    "TEMPEST_OF_SAINT_AUGUSTINE",  # 618
]

# Legacy SKILLS dictionary for backwards compatibility
# Maps skill IDs to names: spells (1-267), player skills (401-495), songs (551-560), chants (601-618)
# Note: Spell IDs match SPELLS array indices directly (SPELLS[0]="NONE" is unused placeholder)
# C++ defines: SPELL_ARMOR=1, SPELL_BURNING_HANDS=5, etc. match SPELLS[1], SPELLS[5], etc.
SKILLS = {
    **{i: spell for i, spell in enumerate(SPELLS) if spell and i > 0},  # Use index directly, skip NONE
    **{i + 401: f"SKILL_{skill}" for i, skill in enumerate(PLAYER_SKILLS)},
    **{i + 551: f"SONG_{song}" for i, song in enumerate(BARDIC_SONGS)},
    **{i + 601: f"CHANT_{chant}" for i, chant in enumerate(MONK_CHANTS)},
}


OBJECT_TYPES = [
    "NOTHING",
    "LIGHT",  # 1,   # /* Item is a light source          */
    "SCROLL",  # 2,   # /* Item is a scroll                */
    "WAND",  # 3,   # /* Item is a wand                  */
    "STAFF",  # 4,   # /* Item is a staff                 */
    "WEAPON",  # 5,   # /* Item is a weapon                */
    "FIREWEAPON",  # 6,   # /* Unimplemented                   */
    "MISSILE",  # 7,   # /* Unimplemented                   */
    "TREASURE",  # 8,   # /* Item is a treasure, not gold    */
    "ARMOR",  # 9 ,   # /* Item is armor                   */
    "POTION",  # 10,  # /* Item is a potion                */
    "WORN",  # 11,  # /* Unimplemented                   */
    "OTHER",  # 12,  # /* Misc object                     */
    "TRASH",  # 13,  # /* Trash - shopkeeps won't buy     */
    "TRAP",  # 14,  # /* Unimplemented                   */
    "CONTAINER",  # 15,  # /* Item is a container             */
    "NOTE",  # 16,  # /* Item is note                    */
    "DRINK_CONTAINER",  # 17,  # /* Item is a drink container       */
    "KEY",  # 18,  # /* Item is a key                   */
    "FOOD",  # 19,  # /* Item is food                    */
    "MONEY",  # 20,  # /* Item is money (gold)            */
    "PEN",  # 21,  # /* Item is a pen                   */
    "BOAT",  # 22,  # /* Item is a boat                  */
    "FOUNTAIN",  # 23,  # /* Item is a fountain              */
    "PORTAL",  # 24,  # /* Item teleports to another room  */
    "ROPE",  # 25,  # /* Item is used to bind chars      */
    "SPELLBOOK",  # 26,  # /* Spells can be scribed for mem   */
    "WALL",  # 27,  # /* Blocks passage in one direction */
    "TOUCHSTONE",  # 28,  # /* Item sets homeroom when touched */
    "BOARD",  # 29,  # Bullitin board
    "INSTRUMENT",  # 30, # /* Item is a musical instrument */
]

WEAR_FLAGS = [
    "TAKE",  # /* Item can be taken         */
    "FINGER",  # /* Can be worn on finger     */
    "NECK",  # /* Can be worn around neck   */
    "BODY",  # /* Can be worn on body       */
    "HEAD",  # /* Can be worn on head       */
    "LEGS",  # /* Can be worn on legs       */
    "FEET",  # /* Can be worn on feet       */
    "HANDS",  # /* Can be worn on hands      */
    "ARMS",  # /* Can be worn on arms       */
    "SHIELD",  # /* Can be used as a shield   */
    "ABOUT",  # /* Can be worn about body    */
    "WAIST",  # /* Can be worn around waist  */
    "WRIST",  # /* Can be worn on wrist      */
    "WIELD",  # /* Can be wielded            */
    "HOLD",  # /* Can be held               */
    "TWO_HAND_WIELD",  # /* Can be wielded two handed */
    "EYES",  # /* Can be worn on eyes       */
    "FACE",  # /* Can be worn upon face     */
    "EAR",  # /* Can be worn in ear        */
    "BADGE",  # /* Can be worn as badge      */
    "BELT",  # /* Can be worn on belt       */
    "HOVER",  # /*Hovers above you    */
]


OBJECT_FLAGS = [
    "GLOW",  # 0               /* Item is glowing               */
    "HUM",  # 1                /* Item is humming               */
    "TEMPORARY",  # 2          /* Temporary item - not saved on rent/camp */
    "ANTI_BERSERKER",  # 3     /* Not usable by berserkers      */
    "NO_INVISIBLE",  # 4       /* Item cannot be made invis     */
    "INVISIBLE",  # 5          /* Item is invisible             */
    "MAGIC",  # 6              /* Item is magical               */
    "NO_DROP",  # 7            /* Item can't be dropped         */
    "PERMANENT",  # 8          /* Item doesn't decompose        */
    "ANTI_GOOD",  # 9          /* Not usable by good people     */
    "ANTI_EVIL",  # 10         /* Not usable by evil people     */
    "ANTI_NEUTRAL",  # 11      /* Not usable by neutral people  */
    "ANTI_SORCERER",  # 12     /* Not usable by sorcerers       */
    "ANTI_CLERIC",  # 13       /* Not usable by clerics         */
    "ANTI_ROGUE",  # 14        /* Not usable by rogues          */
    "ANTI_WARRIOR",  # 15      /* Not usable by warriors        */
    "NO_SELL",  # 16           /* Shopkeepers won't touch it    */
    "ANTI_PALADIN",  # 17      /* Not usable by paladins        */
    "ANTI_ANTI_PALADIN",  # 18 /* Not usable by anti-paladins   */
    "ANTI_RANGER",  # 19       /* Not usable by rangers         */
    "ANTI_DRUID",  # 20        /* Not usable by druids          */
    "ANTI_SHAMAN",  # 21       /* Not usable by shamans         */
    "ANTI_ASSASSIN",  # 22     /* Not usable by assassins       */
    "ANTI_MERCENARY",  # 23    /* Not usable by mercenaries     */
    "ANTI_NECROMANCER",  # 24  /* Not usable by necromancers    */
    "ANTI_CONJURER",  # 25     /* Not usable by conjurers       */
    "NO_BURN",  # 26           /* Not destroyed by purge/fire   */
    "NO_LOCATE",  # 27         /* Cannot be found by locate obj */
    "DECOMPOSING",  # 28       /* Item is currently decomposing */
    "FLOAT",  # 29             /* Floats in water rooms         */
    "NO_FALL",  # 30           /* Doesn't fall - unaffected by gravity */
    "WAS_DISARMED",  # 31      /* Disarmed from mob             */
    "ANTI_MONK",  # 32         /* Not usable by monks           */
    "ANTI_BARD",  # 33
    "ELVEN",  # 34   /* Item usable by Elves          */
    "DWARVEN",  # 35 /* Item usable by Dwarves        */
    "ANTI_THIEF",  # 36
    "ANTI_PYROMANCER",  # 37
    "ANTI_CRYOMANCER",  # 38
    "ANTI_ILLUSIONIST",  # 39
    "ANTI_PRIEST",  # 40
    "ANTI_DIABOLIST",  # 41
    "ANTI_TINY",  # 42
    "ANTI_SMALL",  # 43
    "ANTI_MEDIUM",  # 44
    "ANTI_LARGE",  # 45
    "ANTI_HUGE",  # 46
    "ANTI_GIANT",  # 47
    "ANTI_GARGANTUAN",  # 48
    "ANTI_COLOSSAL",  # 49
    "ANTI_TITANIC",  # 50
    "ANTI_MOUNTAINOUS",  # 51
    "ANTI_ARBOREAN",  # 52 /* Not usable by Arboreans */
]

AFFECTS = [
    "NONE",  # 0        /* No effect                       */
    "STR",  # 1        /* Apply to strength               */
    "DEX",  # 2        /* Apply to dexterity              */
    "INT",  # 3        /* Apply to intelligence           */
    "WIS",  # 4        /* Apply to wisdom                 */
    "CON",  # 5        /* Apply to constitution           */
    "CHA",  # 6        /* Apply to charisma               */
    "CLASS",  # 7        /* Reserved                        */
    "LEVEL",  # 8        /* Reserved                        */
    "AGE",  # 9        /* Apply to age                    */
    "CHAR_WEIGHT",  # 10        /* Apply to weight                 */
    "CHAR_HEIGHT",  # 11        /* Apply to height                 */
    "MANA",  # 12        /* Apply to max mana               */
    "HIT",  # 13        /* Apply to max hit points         */
    "MOVE",  # 14        /* Apply to max move points        */
    "GOLD",  # 15        /* Reserved                        */
    "EXP",  # 16        /* Reserved                        */
    "AC",  # 17        /* Apply to Armor Class            */
    "HITROLL",  # 18        /* Apply to hitroll                */
    "DAMROLL",  # 19        /* Apply to damage roll            */
    "SAVING_PARA",  # 20        /* Apply to save throw: paralz     */
    "SAVING_ROD",  # 21        /* Apply to save throw: rods       */
    "SAVING_PETRI",  # 22        /* Apply to save throw: petrif     */
    "SAVING_BREATH",  # 23        /* Apply to save throw: breath     */
    "SAVING_SPELL",  # 24        /* Apply to save throw: spells     */
    "SIZE",  # 25        /* Apply to size                   */
    "HIT_REGEN",  # 26
    "FOCUS",  # 27
    "PERCEPTION",  # 28
    "HIDDENNESS",  # 29
    "COMPOSITION",  # 30
]

EFFECTS = [
    "BLIND",  # 0   /* (R) Char is blind            */
    "INVISIBLE",  # 1   /* Char is invisible            */
    "DETECT_ALIGN",  # 2   /* Char is sensitive to align   */
    "DETECT_INVIS",  # 3   /* Char can see invis chars     */
    "DETECT_MAGIC",  # 4   /* Char is sensitive to magic   */
    "SENSE_LIFE",  # 5   /* Char can sense hidden life   */
    "WATERWALK",  # 6   /* Char can walk on water       */
    "SANCTUARY",  # 7   /* Char protected by sanct.     */
    "CONFUSION",  # 8   /* Char is confused             */
    "CURSE",  # 9   /* Char is cursed               */
    "INFRAVISION",  # 10   /* Char can see in dark         */
    "POISON",  # 11   /* (R) Char is poisoned         */
    "PROTECT_EVIL",  # 12   /* Char protected from evil     */
    "PROTECT_GOOD",  # 13   /* Char protected from good     */
    "SLEEP",  # 14   /* (R) Char magically asleep    */
    "NO_TRACK",  # 15   /* Char can't be tracked        */
    "TAMED",  # 16   /* Tamed!                       */
    "BERSERK",  # 17   /* Char is berserking           */
    "SNEAK",  # 18   /* Char is sneaking             */
    "STEALTH",  # 19   /* Char is using stealth        */
    "FLY",  # 20   /* Char has the ability to fly  */
    "CHARM",  # 21   /* Char is charmed              */
    "STONE_SKIN",  # 22
    "FARSEE",  # 23
    "HASTE",  # 24
    "BLUR",  # 25
    "VITALITY",  # 26
    "GLORY",  # 27
    "MAJOR_PARALYSIS",  # 28
    "FAMILIARITY",  # 29   /* Char is considered friend    */
    "MESMERIZED",  # 30   /* Super fasciated by something */
    "IMMOBILIZED",  # 31   /* Char cannot move             */
    "LIGHT",  # 32
    "UNUSED",  # 33
    "MINOR_PARALYSIS",  # 34
    "HURT_THROAT",  # 35
    "FEATHER_FALL",  # 36
    "WATERBREATH",  # 37
    "SOULSHIELD",  # 38
    "SILENCE",  # 39
    "PROTECT_FIRE",  # 40
    "PROTECT_COLD",  # 41
    "PROTECT_AIR",  # 42
    "PROTECT_EARTH",  # 43
    "FIRESHIELD",  # 44
    "COLDSHIELD",  # 45
    "MINOR_GLOBE",  # 46
    "MAJOR_GLOBE",  # 47
    "HARNESS",  # 48
    "ON_FIRE",  # 49
    "FEAR",  # 50
    "TONGUES",  # 51
    "DISEASE",  # 52
    "INSANITY",  # 53
    "ULTRAVISION",  # 54
    "NEGATE_HEAT",  # 55
    "NEGATE_COLD",  # 56
    "NEGATE_AIR",  # 57
    "NEGATE_EARTH",  # 58
    "REMOTE_AGGRO",  # 59   /* Your aggro action won't remove invis/bless etc. */
    "UNUSED",  # 60
    "UNUSED",  # 61
    "UNUSED",  # 62
    "UNUSED",  # 63
    "AWARE",  # 64
    "REDUCE",  # 65
    "ENLARGE",  # 66
    "VAMPIRIC_TOUCH",  # 67
    "RAY_OF_ENFEEBLEMENT",  # 68
    "ANIMATED",  # 69
    "EXPOSED",  # 70
    "SHADOWING",  # 71
    "CAMOUFLAGED",  # 72
    "SPIRIT_WOLF",  # 73
    "SPIRIT_BEAR",  # 74
    "WRATH",  # 75
    "MISDIRECTION",  # 76   /* Capable of performing misdirection */
    "MISDIRECTING",  # 77   /* Currently actually moving but misdirecting */
    "BLESS",  # 78   /* When blessed,# our barehand attacks hurt ether chars */
    "HEX",  # 79   /* The evil side of blessing,# o hurt ether chars */
    "DETECT_POISON",  # 80   /* Char is sensitive to poison */
    "SONG_OF_REST",  # 81
    "DISPLACEMENT",  # 82
    "GREATER_DISPLACEMENT",  # 83
    "FIRE_WEAPON",  # 84
    "ICE_WEAPON",  # 85
    "POISON_WEAPON",  # 86
    "ACID_WEAPON",  # 87
    "SHOCK_WEAPON",  # 88
    "RADIANT_WEAPON",  # 89
]

DAMAGE_TYPES = [
    "HIT",
    "STING",
    "WHIP",
    "SLASH",
    "BITE",
    "BLUDGEON",
    "CRUSH",
    "POUND",
    "CLAW",
    "MAUL",
    "THRASH",
    "PIERCE",
    "BLAST",
    "PUNCH",
    "STAB",
    "FIRE",
    "COLD",
    "ACID",
    "SHOCK",
    "POISON",
    "ALIGN",
]

LIQUIDS = [
    "WATER",  # 0
    "BEER",  # 1
    "WINE",  # 2
    "ALE",  # 3
    "DARKALE",  # 4
    "WHISKY",  # 5
    "LEMONADE",  # 6
    "FIREBRT",  # 7
    "LOCALSPC",  # 8
    "SLIME",  # 9
    "MILK",  # 10
    "TEA",  # 11
    "COFFEE",  # 12
    "BLOOD",  # 13
    "SALTWATER",  # 14
    "RUM",  # 15
    "NECTAR",  # 16
    "SAKE",  # 17
    "CIDER",  # 18
    "TOMATOSOUP",  # 19
    "POTATOSOUP",  # 20
    "CHAI",  # 21
    "APPLEJUICE",  # 22
    "ORNGJUICE",  # 23
    "PNAPLJUICE",  # 24
    "GRAPEJUICE",  # 25
    "POMJUICE",  # 26
    "MELONAE",  # 27
    "COCOA",  # 28
    "ESPRESSO",  # 29
    "CAPPUCCINO",  # 30
    "MANGOLASSI",  # 31
    "ROSEWATER",  # 32
    "GREENTEA",  # 33
    "CHAMOMILE",  # 34
    "GIN",  # 35
    "BRANDY",  # 36
    "MEAD",  # 37
    "CHAMPAGNE",  # 38
    "VODKA",  # 39
    "TEQUILA",  # 40
    "ABSINTHE",  # 41
]

# Mobile flags: used by char_data.char_specials.act
MOB_FLAGS = [
    "SPEC",  # 0          /* Mob has a callable spec-proc       */
    "SENTINEL",  # 1      /* Mob should not move                */
    "SCAVENGER",  # 2     /* Mob picks up stuff on the ground   */
    "IS_NPC",  # 3         /* (R) Automatically set on all Mobs  */
    "AWARE",  # 4         /* Mob can't be backstabbed           */
    "AGGRESSIVE",  # 5    /* Mob hits players in the room       */
    "STAY_ZONE",  # 6     /* Mob shouldn't wander out of zone   */
    "WIMPY",  # 7         /* Mob flees if severely injured      */
    "AGGRO_EVIL",  # 8    /* auto attack evil PC's              */
    "AGGRO_GOOD",  # 9    /* auto attack good PC's              */
    "AGGRO_NEUTRAL",  # 10 /* auto attack neutral PC's          */
    "MEMORY",  # 11       /* remember attackers if attacked     */
    "HELPER",  # 12       /* attack PCs fighting other NPCs     */
    "NO_CHARM",  # 13     /* Mob can't be charmed               */
    "NO_SUMMON",  # 14    /* Mob can't be summoned              */
    "NO_SLEEP",  # 15     /* Mob can't be slept                 */
    "NO_BASH",  # 16      /* Mob can't be bashed (e.g. trees)   */
    "NO_BLIND",  # 17     /* Mob can't be blinded               */
    "MOUNTABLE",  # 18
    "NO_EQ_RESTRICT",  # 19
    "FAST_TRACK",  # 20
    "SLOW_TRACK",  # 21
    "CASTING",  # 22        /* mob casting            (not used)  */
    "SUMMONED_MOUNT",  # 23 /* resets CD_SUMMON_MOUNT when extracted */
    "AQUATIC",  # 24        /* Mob can't enter non-water rooms    */
    "AGGRO_EVIL_RACE",  # 25
    "AGGRO_GOOD_RACE",  # 26
    "NO_SILENCE",  # 27
    "NO_VICIOUS",  # 28
    "TEACHER",  # 29
    "ANIMATED",  # 30        /* mob is animated - die if no anim effect */
    "PEACEFUL",  # 31        /* mob can't be attacked.             */
    "NO_POISON",  # 32        /* Mob cannot be poisoned.            */
    "ILLUSORY",  # 33        /* is an illusion: does no harm, leaves no corpse */
    "PLAYER_PHANTASM",  # 34 /* illusion of player; mobs are aggro to */
    "NO_CLASS_AI",  # 35     /* Mob does not execute class AI      */
    "NO_SCRIPT",  # 36        /* Mob does not execute triggers or specprocs */
    "PEACEKEEPER",  # 37     /* Attacks mobs with over 1350 align diff. Assists other PEACEKEEPERs */
    "PROTECTOR",  # 38       /* Assists players under attack, but not against PEACEKEEPER/PROTECTOR mobs */
    "PET",  # 39             /* Mob was purchased or tamed and is now a pet to a player. */
]

ROOM_FLAGS = [
    "DARK",  # 0         /* Dark                           */
    "DEATH",  # 1        /* Death trap                     */
    "NO_MOB",  # 2        /* MOBs not allowed               */
    "INDOORS",  # 3      /* Indoors                        */
    "PEACEFUL",  # 4     /* Violence not allowed           */
    "SOUNDPROOF",  # 5   /* Shouts, gossip blocked         */
    "NO_TRACK",  # 6      /* Track won't go through         */
    "NO_MAGIC",  # 7      /* Magic not allowed              */
    "TUNNEL",  # 8       /* room for only 2 pers           */
    "PRIVATE",  # 9      /* Can't teleport in              */
    "GODROOM",  # 10     /* LVL_GOD+ only allowed          */
    None,  # 11       /* (R) Room is a house            */
    None,  # 12 /* (R) House needs saving         */
    None,  # 13      /* (R) The door to a house        */
    None,  # 14         /* (R) Modifyable/!compress       */
    None,  # 15    /* (R) breadth-first srch mrk     */
    "NO_WELL",  # 16      /* No spell portals like moonwell */
    "NO_RECALL",  # 17    /* No recalling                   */
    "UNDERDARK",  # 18   /*                   (not used)   */
    "NO_SUMMON",  # 19    /* Can't summon to or from. Can't banish here. */
    "NO_SHIFT",  # 20     /* no plane shift    (not used)   */
    "GUILDHALL",  # 21   /*                   (not used)   */
    "NO_SCAN",  # 22      /* Unable to scan to/from rooms   */
    "ALT_EXIT",  # 23    /* Room's exits are altered       */
    "MAP",  # 24         /* Room on surface map (unused)   */
    "ALWAYS_LIT",  # 25   /* Makes the room lit             */
    "ARENA",  # 26       /* (safe) PK allowed in room      */
    "OBSERVATORY",  # 27 /* see into adjacent ARENA rooms  */
]

EXIT_FLAGS = [
    "IS_DOOR",  # 0    /* Exit is a door             */
    "CLOSED",  # 1    /* The door is closed         */
    "LOCKED",  # 2    /* The door is locked         */
    "PICKPROOF",  # 3 /* Lock can't be picked       */
    "HIDDEN",  # 4    /* exit is hidden             */
    "DESCRIPTION",  # 5  /* Just an extra description  */
]

# Shop Related
SHOP_FLAGS = [
    "WILL_START_FIGHT",  # 1
    "WILL_BANK_MONEY",  # 2
]

SHOP_TRADES_WITH = [
    "NO_GOOD",  # 1
    "NO_EVIL",  # 2
    "NO_NEUTRAL",  # 3
    "NO_MAGIC_USER",  # 4
    "NO_CLERIC",  # 5
    "NO_THIEF",  # 6
    "NO_WARRIOR",  # 7
]

TRIGGER_TYPES = [
    "GLOBAL",  # 0 - check even if zone empty
    "RANDOM",  # 1 - checked randomly
    "COMMAND",  # 2 - character types a command
    "SPEECH",  # 3 - a char says a word/phrase
    "ACT",  # 4 - word or phrase sent to act
    "DEATH",  # 5 - character dies
    "GREET",  # 6 - something enters room seen
    "GREET_ALL",  # 7 - anything enters room
    "ENTRY",  # 8 - the mob enters a room
    "RECEIVE",  # 9 - character is given obj
    "FIGHT",  # 10 - each pulse while fighting
    "HIT_PERCENTAGE",  # 11 - fighting and below some hp
    "BRIBE",  # 12 - coins are given to mob
    "SPEECH_TO",  # 13 - ask/whisper/tell
    "LOAD",  # 14 - the mob is loaded
    "CAST",  # 15 - mob is target of cast
    "LEAVE",  # 16 - someone leaves room seen
    "DOOR",  # 17 - door manipulated in room
    "LOOK",  # 18 - the mob is looked at
    "TIME",  # 19 - the mud hour changes
]

PLAYER_FLAGS = [
    "KILLER",  # 0     /* a player-killer                           */
    "THIEF",  # 1      /* a player-thief                            */
    "FROZEN",  # 2     /* is frozen                                 */
    "DONTSET",  # 3    /* Don't EVER set (ISNPC bit)                */
    "WRITING",  # 4    /* writing (board/mail/olc)                  */
    "MAILING",  # 5    /* is writing mail                           */
    "AUTOSAVE",  # 6   /* needs to be autosaved                     */
    "SITEOK",  # 7     /* has been site-cleared                     */
    "NO_SHOUT",  # 8    /* not allowed to shout/goss                 */
    "NO_TITLE",  # 9    /* not allowed to set title       (not used) */
    "DELETED",  # 10   /* deleted - space reusable       (not used) */
    "LOADROOM",  # 11  /* uses nonstandard loadroom      (not used) */
    "NO_WIZLIST",  # 12 /* shouldn't be on wizlist        (not used) */
    "NO_DELETE",  # 13  /* shouldn't be deleted           (may be used outside the server) */
    "INVSTART",  # 14  /* should enter game wizinvis     (not used) */
    "CRYO",  # 15      /* is cryo-saved (purge prog)     (not used) */
    "MEDITATE",  # 16  /* meditating - improves spell memorization  */
    "CASTING",  # 17   /* currently casting a spell      (not used) */
    "BOUND",  # 18     /* tied up                        (not used) */
    "SCRIBE",  # 19    /* scribing                       (not used) */
    "TEACHING",  # 20  /* teaching a skill/spell         (not used) */
    "NAME_NOT_APPROVED",  # 21  /* name not approved yet                     */
    "NEW_NAME",  # 22   /* needs to choose a new name                */
    "REMOVING",  # 23  /* player is being removed and doesn't need emergency save */
    "SAVING",  # 24    /* player is being saved to file and effect changes are not relevant */
    "GOT_STARS",  # 25  /* player has achieved ** already            */
]

PREFERENCE_FLAGS = [
    "BRIEF",  # 0       /* Room descs won't normally be shown */
    "COMPACT",  # 1     /* No extra CRLF pair before prompts  */
    "DEAF",  # 2        /* Can't hear shouts                  */
    "NO_TELL",  # 3      /* Can't receive tells                */
    "OLC_COMM",  # 4     /* Can hear communication in OLC      */
    "LINE_NUMBERS",  # 5    /* Autodisplay linenums in stringedit */
    "AUTO_LOOT",  # 6    /* Auto loot corpses when you kill    */
    "AUTO_EXIT",  # 7    /* Display exits in a room            */
    "NO_HASSLE",  # 8    /* Aggr mobs won't attack             */
    "QUEST",  # 9       /* On quest                           */
    "SUMMONABLE",  # 10 /* Can be summoned                    */
    "NO_REPEAT",  # 11   /* No repetition of comm commands     */
    "HOLY_LIGHT",  # 12  /* Can see in dark                    */
    "COLOR_1",  # 13    /* Color (low bit)                    */
    "COLOR_2",  # 14    /* Color (high bit)                   */
    "NO_WIZ",  # 15      /* Can't hear wizline                 */
    "LOG_1",  # 16       /* On-line System Log (low bit)       */
    "LOG_2",  # 17       /* On-line System Log (high bit)      */
    "AFK",  # 18        /* away from keyboard                 */
    "NO_GOSSIP",  # 19     /* Can't hear gossip channel          */
    "NO_HINTS",  # 20    /* No hints when mistyping commands   */
    "ROOM_FLAGS",  # 21  /* Can see room flags (ROOM_x)        */
    "NO_PETITION",  # 22     /* Can't hear petitions               */
    "AUTO_SPLIT",  # 23  /* Auto split coins from corpses      */
    "NO_CLAN_COMM",  # 24 /* Can't hear clan communication      */
    "ANON",  # 25       /* Anon flag                          */
    "SHOW_IDS",  # 26  /* Show Virtual Numbers               */
    "NICE_AREA",  # 27
    "VICIOUS",  # 28
    "PASSIVE",  # 29 /* char will not engage upon being cast on */
    "ROOM_VISIBILITY",  # 30
    "NO_FOLLOW",  # 31  /* Cannot follow / well to this player*/
    "AUTO_TREASURE",  # 32 /* Automatically loots treasure from corpses */
    "EXPAND_OBJECTS",  # 33
    "EXPAND_MOBS",  # 34
    "SACRIFICIAL",  # 35 /* Sacrificial spells autotarget self */
    "PET_ASSIST",  # 36   /* Should your pet assist you as you fight */
]

PRIVILEGE_FLAGS = [
    "CLAN_ADMIN",  # 0  /* clan administrator */
    "TITLE",  # 1       /* can change own title */
    "ANON_TOGGLE",  # 2 /* can toggle anon */
    "AUTO_GAIN",  # 3   /* don't need to level gain */
]

# Room Sectors
SECTORS = [
    "STRUCTURE",  # 0  - A building of some kind
    "CITY",  # 1       - In a city
    "FIELD",  # 2      - In a field
    "FOREST",  # 3     - In a forest
    "HILLS",  # 4      - In the hills
    "MOUNTAIN",  # 5   - On a mountain
    "SHALLOWS",  # 6   - Easily passable water
    "WATER",  # 7      - Water - need a boat
    "UNDERWATER",  # 8 - Underwater
    "AIR",  # 9        - Wheee!
    "ROAD",  # 10
    "GRASSLANDS",  # 11
    "CAVE",  # 12
    "RUINS",  # 13
    "SWAMP",  # 14
    "BEACH",  # 15
    "UNDERDARK",  # 16
    "ASTRALPLANE",  # 17
    "AIRPLANE",  # 18
    "FIREPLANE",  # 19
    "EARTHPLANE",  # 20
    "ETHEREALPLANE",  # 21
    "AVERNUS",  # 22
]

# Zone Reset Modes
RESET_MODES = [
    "NEVER",  # 0 - Never reset
    "EMPTY",  # 1 - Reset when empty
    "NORMAL",  # 2 - Normal reset
]

# Zone Hemispheres
HEMISPHERES = [
    "NORTHWEST",  # 0
    "NORTHEAST",  # 1
    "SOUTHWEST",  # 2
    "SOUTHEAST",  # 3
]

# Zone Climates
CLIMATES = [
    "NONE",  # 0       - do not report weather
    "SEMIARID",  # 1   - plains
    "ARID",  # 2       - deserts
    "OCEANIC",  # 3    - ocean
    "TEMPERATE",  # 4  - mediterranean climate
    "SUBTROPICAL",  # 5 - florida
    "TROPICAL",  # 6   - equatorial / jungle
    "SUBARCTIC",  # 7  - high elevation
    "ARCTIC",  # 8     - extreme polar
    "ALPINE",  # 9     - mountain
]
