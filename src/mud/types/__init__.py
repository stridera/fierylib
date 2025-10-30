import re
from dataclasses import dataclass
from enum import Enum, auto

from mud.bitflags import BitFlags
from mud.flags import DAMAGE_TYPES, LIQUIDS, SPELLS


class MudTypes(Enum):
    """
    Enum for the different types of mud objects
    """

    ZONE = auto()
    MOB = auto()
    OBJECT = auto()
    SHOP = auto()
    TRIGGER = auto()
    WORLD = auto()

    PLAYER = auto()
    QUESTS = auto()
    PET = auto()
    NOTES = auto()

    @classmethod
    def from_ext(cls, ext: str):
        """
        Gets the MudType from the file extension
        :param ext: The file extension
        :return: The MudType
        """
        match ext:
            case "mob":
                return cls.MOB
            case "obj":
                return cls.OBJECT
            case "shp":
                return cls.SHOP
            case "trg":
                return cls.TRIGGER
            case "zon":
                return cls.ZONE
            case "wld":
                return cls.WORLD

            case "plr":
                return cls.PLAYER
            case "objs":
                return cls.OBJECT
            case "pet":
                return cls.PET
            case "quest":
                return cls.QUESTS
            case "notes":
                return cls.NOTES
            case _:
                raise ValueError(f"Invalid file extension: {ext}")

    def cls(self):
        """
        Gets the class for the MudType
        :return: The class
        """
        match self:
            case MudTypes.MOB:
                from mud.types.mob import Mob

                return Mob
            case MudTypes.OBJECT:
                from mud.types.object import Object

                return Object
            case MudTypes.SHOP:
                from mud.types.shop import Shop

                return Shop
            case MudTypes.TRIGGER:
                from mud.types.trigger import Trigger

                return Trigger
            case MudTypes.WORLD:
                from mud.types.world import World

                return World
            case MudTypes.ZONE:
                from mud.types.zone import Zone

                return Zone
            case MudTypes.PLAYER:
                from mud.types.player import Player

                return Player
            case MudTypes.PET:
                from mud.types.pet import Pet

                return Pet
            case MudTypes.QUESTS:
                from mud.types.quests import Quests

                return Quests
            case MudTypes.NOTES:
                from mud.types.notes import Notes

                return Notes
            case _:
                raise ValueError(f"Invalid MudType: {self}")

    def get_json_id(self):
        match self:
            case MudTypes.MOB:
                return "mobs"
            case MudTypes.OBJECT:
                return "objects"
            case MudTypes.SHOP:
                return "shops"
            case MudTypes.TRIGGER:
                return "triggers"
            case MudTypes.WORLD:
                return "rooms"
            case MudTypes.ZONE:
                return "zone"
            case MudTypes.PLAYER:
                return "player"
            case MudTypes.PET:
                return "pet"
            case MudTypes.QUESTS:
                return "quests"
            case MudTypes.NOTES:
                return "notes"
            case _:
                raise ValueError(f"Invalid MudType: {self}")


@dataclass
class Extras:
    keywords: list[str]
    text: str


@dataclass
class CurrentMax:
    current: int
    max: int


@dataclass
class Stats:
    strength: int
    intelligence: int
    wisdom: int
    dexterity: int
    constitution: int
    charisma: int


@dataclass
class Money:
    copper: int
    silver: int
    gold: int
    platinum: int

    # Create a constructor to make sure we have valid money amounts and that we parse as ints
    def __init__(self, copper: int, silver: int, gold: int, platinum: int):
        self.copper = max(0, copper)
        self.silver = max(0, silver)
        self.gold = max(0, gold)
        self.platinum = max(0, platinum)


@dataclass
class SavingThrows:
    paralysis: int
    rod: int
    petrification: int
    breath: int
    spell: int


@dataclass
class Dice:
    num: int
    size: int
    bonus: int

    @staticmethod
    def from_string(dice_string):
        num, size, bonus = re.split(r"[+d]", dice_string)
        return Dice(int(num), int(size), int(bonus))

    def __str__(self):
        return f"{self.num}d{self.size}+{self.bonus}"

    def __repr__(self):
        return f"{self.num}d{self.size}+{self.bonus}"

    def to_json(self):
        return {"num": self.num, "size": self.size, "bonus": self.bonus}


class Direction(Enum):
    NORTH = 0
    EAST = 1
    SOUTH = 2
    WEST = 3
    UP = 4
    DOWN = 5


class WearFlags(Enum):
    TAKE = 0  # Item can be taken
    FINGER = 1  # Can be worn on finger
    NECK = 2  # Can be worn around neck
    BODY = 3  # Can be worn on body
    HEAD = 4  # Can be worn on head
    LEGS = 5  # Can be worn on legs
    FEET = 6  # Can be worn on feet
    HANDS = 7  # Can be worn on hands
    ARMS = 8  # Can be worn on arms
    SHIELD = 9  # Can be used as a shield
    ABOUT = 10  # Can be worn about body
    WAIST = 11  # Can be worn around waist
    WRIST = 12  # Can be worn on wrist
    WIELD = 13  # Can be wielded
    HOLD = 14  # Can be held
    TWO_HAND_WIELD = 15  # Can be wielded two handed
    EYES = 16  # Can be worn on eyes
    FACE = 17  # Can be worn upon face
    EAR = 18  # Can be worn in ear
    BADGE = 19  # Can be worn as badge
    BELT = 20  # Can be worn on belt
    HOVER = 21  # Hovers above you


class ScriptType(Enum):
    MOB = 0
    OBJECT = 1
    WORLD = 2


class Gender(Enum):
    NEUTRAL = 0
    MALE = 1
    FEMALE = 2
    NON_BINARY = 3


class Class(Enum):
    SORCERER = 0
    CLERIC = 1
    THIEF = 2
    WARRIOR = 3
    PALADIN = 4
    ANTI_PALADIN = 5
    RANGER = 6
    DRUID = 7
    SHAMAN = 8
    ASSASSIN = 9
    MERCENARY = 10
    NECROMANCER = 11
    CONJURER = 12
    MONK = 13
    BERSERKER = 14
    PRIEST = 15
    DIABOLIST = 16
    MYSTIC = 17
    ROGUE = 18
    BARD = 19
    PYROMANCER = 20
    CRYOMANCER = 21
    ILLUSIONIST = 22
    HUNTER = 23
    LAYMAN = 24


class Position(Enum):
    PRONE = 0
    SITTING = 1
    KNEELING = 2
    STANDING = 3
    FLYING = 4


class Stance(Enum):
    DEAD = 0  # dead
    MORT = 1  # mortally wounded
    INCAPACITATED = 2  # incapacitated
    STUNNED = 3  # stunned
    SLEEPING = 4  # sleeping
    RESTING = 5  # resting
    ALERT = 6  # alert
    FIGHTING = 7  # fighting


class Race(Enum):
    HUMAN = 0
    ELF = 1
    GNOME = 2
    DWARF = 3
    TROLL = 4
    DROW = 5
    DUERGAR = 6
    OGRE = 7
    ORC = 8
    HALF_ELF = 9
    BARBARIAN = 10
    HALFLING = 11
    PLANT = 12
    HUMANOID = 13
    ANIMAL = 14
    DRAGON_GENERAL = 15
    GIANT = 16
    OTHER = 17
    GOBLIN = 18
    DEMON = 19
    BROWNIE = 20
    DRAGON_FIRE = 21
    DRAGON_FROST = 22
    DRAGON_ACID = 23
    DRAGON_LIGHTNING = 24
    DRAGON_GAS = 25
    DRAGONBORN_FIRE = 26
    DRAGONBORN_FROST = 27
    DRAGONBORN_ACID = 28
    DRAGONBORN_LIGHTNING = 29
    DRAGONBORN_GAS = 30
    SVERFNEBLIN = 31
    FAERIE_SEELIE = 32
    FAERIE_UNSEELIE = 33
    NYMPH = 34
    ARBOREAN = 35


class LifeForce(Enum):
    LIFE = 0
    UNDEAD = 1
    MAGIC = 2
    CELESTIAL = 3
    DEMONIC = 4
    ELEMENTAL = 5


class Composition(Enum):
    FLESH = 0
    EARTH = 1
    AIR = 2
    FIRE = 3
    WATER = 4
    ICE = 5
    MIST = 6
    ETHER = 7
    METAL = 8
    STONE = 9
    BONE = 10
    LAVA = 11
    PLANT = 12


class QuitReason(Enum):
    Undef = 0
    Rent = 1
    Cryo = 2
    Timeout = 3
    Hotboot = 4
    QuitMort = 5
    QuitImmortal = 6
    Camp = 7
    WRent = 8  # World Triggered Rent
    Purge = 9
    Autosave = 10


class Cooldown(Enum):
    Backstab = 0
    Bash = 1
    InstantKill = 2
    Disarm = 3
    FumblingPrimary = 4
    DroppedPrimary = 5
    FumblingSecondary = 6
    DroppedSecondary = 7
    SummonMount = 8
    LayHands = 9
    FirstAid = 10
    EyeGouge = 11
    ThroatCut = 12
    ShapeChange = 13
    DefenseChant = 14
    InnateInvisible = 15
    InnateChaz = 16
    InnateDarkness = 17
    InnateFeatherFall = 18
    InnateSyll = 19
    InnateTren = 20
    InnateTass = 21
    InnateBrill = 22
    InnateAscen = 23
    InnateHarness = 24
    Breathe = 25
    InnateCreate = 26
    InnateIllumination = 27
    InnateFaerieStep = 28
    Music1 = 29
    Music2 = 30
    Music3 = 31
    Music4 = 32
    Music5 = 33
    Music6 = 34
    Music7 = 35
    InnateBlindingBeauty = 36
    InnateStatue = 37
    InnateBarkSkin = 38
    OffenseChant = 39


class WearLocation(Enum):
    Light = 0
    FingerRight = 1
    FingerLeft = 2
    Neck1 = 3
    Neck2 = 4
    Body = 5
    Head = 6
    Legs = 7
    Feet = 8
    Hands = 9
    Arms = 10
    Shield = 11
    About = 12
    Waist = 13
    WristRight = 14
    WristLeft = 15
    Wield = 16
    Wield2 = 17
    Hold = 18
    Hold2 = 19
    TwoHandWield = 20
    Eyes = 21
    Face = 22
    Lear = 23
    Rear = 24
    Badge = 25
    OnBelt = 26
    Hover = 27


class ObjectFlags(Enum):
    Glow = 0  #               Item is glowing (Can be seen in the dark)
    Hum = 1  #                Item is humming (Can be seen while blind)
    NoRent = 2  #             Item cannot be rented
    AntiBerserker = 3  #     Not usable by berserker
    NoInvisible = 4  #            Item cannot be made invis
    Invisible = 5  #          Item is invisible
    Magic = 6  #              Item is magical
    NoDrop = 7  #             Item can't be dropped
    Permanent = 8  #          Item doesn't decompose
    AntiGood = 9  #          Not usable by good people
    AntiEvil = 10  #         Not usable by evil people
    AntiNeutral = 11  #      Not usable by neutral people
    AntiSorcerer = 12  #     Not usable by sorcerers
    AntiCleric = 13  #       Not usable by clerics
    AntiRogue = 14  #        Not usable by rogues
    AntiWarrior = 15  #      Not usable by warriors
    NoSell = 16  #            Shopkeepers won't touch it
    AntiPaladin = 17  #      Not usable by paladins
    AntiAntiPaladin = 18  # Not usable by anti-paladins
    AntiRanger = 19  #       Not usable by rangers
    AntiDruid = 20  #        Not usable by druids
    AntiShaman = 21  #       Not usable by shamans
    AntiAssassin = 22  #     Not usable by assassins
    AntiMercenary = 23  #    Not usable by mercenaries
    AntiNecromancer = 24  #  Not usable by necromancers
    AntiConjurer = 25  #     Not usable by conjurers
    NoBurn = 26  #            Not destroyed by purge/fire
    NoLocate = 27  #          Cannot be found by locate obj
    Decomposing = 28  #            Item is currently decomposing
    Float = 29  #             Floats in water rooms
    NoFall = 30  #            Doesn't fall - unaffected by gravity
    WasDisarmed = 31  #      Disarmed from mob
    AntiMonk = 32  #         Not usable by monks
    AntiBard = 33  #
    Elven = 34  #   Item usable by Elves
    Dwarven = 35  # Item usable by Dwarves
    AntiThief = 36  #
    AntiPyromancer = 37  #
    AntiCryomancer = 38  #
    AntiIllusionist = 39  #
    AntiPriest = 40  #
    AntiDiabolist = 41  #
    AntiTiny = 42  #
    AntiSmall = 43  #
    AntiMedium = 44  #
    AntiLarge = 45  #
    AntiHuge = 46  #
    AntiGiant = 47  #
    AntiGargantuan = 48  #
    AntiColossal = 49  #
    AntiTitanic = 50  #
    AntiMountainous = 51  #
    AntiArborean = 52


class KillTypeFlags(Enum):
    Mob = 1
    Player = 2


class ApplyTypes(Enum):
    Str = 1  # Apply to strength
    Dex = 2  # Apply to dexterity
    Int = 3  # Apply to integer
    Wis = 4  # Apply to wisdom
    Con = 5  # Apply to constitution
    Cha = 6  # Apply to charisma
    Class = 7  # Reserved
    Level = 8  # Reserved
    Age = 9  # Apply to age
    CharacterWeight = 10  # Apply to weight
    CharacterHeight = 11  # Apply to height
    Mana = 12  # Apply to max mana @DEPRECATED
    Hit = 13  # Apply to max hit points
    Move = 14  # Apply to max move points
    Gold = 15  # Reserved
    Exp = 16  # Reserved
    AC = 17  # Apply to Armor Class
    HitRoll = 18  # Apply to hit roll
    DamRoll = 19  # Apply to damage roll
    SavingParalysis = 20  # Apply to save throw: paralysis
    SavingRod = 21  # Apply to save throw: rods
    SavingPetrification = 22  # Apply to save throw: petrification
    SavingBreath = 23  # Apply to save throw: breath
    SavingSpell = 24  # Apply to save throw: spells
    Size = 25  # Apply to size
    Regeneration = 26  # Restore hit points
    Focus = 27  # Apply to focus level
    Perception = 28
    Concealment = 29
    Composition = 30


class Size(Enum):
    TINY = 0
    SMALL = 1
    MEDIUM = 2
    LARGE = 3
    HUGE = 4
    GIANT = 5
    GARGANTUAN = 6
    COLOSSAL = 7
    TITANIC = 8
    MOUNTAINOUS = 9


class DamageType(Enum):
    HIT = 1
    STING = 2
    WHIP = 3
    SLASH = 4
    BITE = 5
    BLUDGEON = 6
    CRUSH = 7
    POUND = 8
    CLAW = 9
    MAUL = 10
    THRASH = 11
    PIERCE = 12
    BLAST = 13
    PUNCH = 14
    STAB = 15
    FIRE = 16
    COLD = 17
    ACID = 18
    SHOCK = 19
    POISON = 20
    ALIGN = 21


def obj_val(item_type: str, *args):
    """Return the object values for the given item type."""
    results = {}
    match item_type:
        case "ARMOR" | "TREASURE":
            results = {"AC": int(args[0])}
        case "LIGHT":
            results = {
                "Is_Lit:": bool(int(args[0])),
                "Capacity": int(args[1]),
                "Remaining": int(args[2]),
            }
        case "CONTAINER":
            results = {
                "Capacity": int(args[0]),
                "Flags": BitFlags.build_flags(args[1], ["Closeable", "PickProof", "Closed", "Locked"]),
                "Key": int(args[2]),
                "IsCorpse": bool(int(args[3])),
                "Weight Reduction": float(args[4]),
            }
        case "DRINKCON" | "DRINKCONTAINER" | "DRINK_CONTAINER" | "FOUNTAIN":
            results = {
                "Capacity": int(args[0]),
                "Remaining": int(args[1]),
                "Liquid": BitFlags.get_flag(args[2], LIQUIDS),
                "Poisoned": bool(int(args[3])),
            }
        case "FOOD":
            results = {
                "Filling": int(args[0]),
                "Poisoned": bool(int(args[1])),
            }
        case "SPELLBOOK":
            results = {
                "Pages": int(args[0]),
            }
        case "SCROLL" | "POTION":
            spells = []
            if int(args[1]) > 0:
                spells.append(BitFlags.get_flag(args[1], SPELLS))
            if int(args[2]) > 0:
                spells.append(BitFlags.get_flag(args[2], SPELLS))
            if int(args[3]) > 0:
                spells.append(BitFlags.get_flag(args[3], SPELLS))
            results = {
                "Level": int(args[0]),
                "Spells": spells,
            }
        case "WAND" | "STAFF" | "INSTRUMENT":
            results = {
                "Level": int(args[0]),
                "Max_Charges": int(args[1]),
                "Charges_Left": int(args[2]),
                "Spell": BitFlags.get_flag(args[3], SPELLS),
            }

        case "MONEY":
            results = {
                "Platinum": int(args[0]),
                "Gold": int(args[1]),
                "Silver": int(args[2]),
                "Copper": int(args[3]),
            }
        case "PORTAL":
            results = {
                "Destination": int(args[0]),
                "Entry_Message": args[1],
                "Character_Message": args[2],
                "Exit_Message": args[3],
            }
        case "WALL":
            results = {
                "Direction": int(args[0]),
                "Dispellable": bool(int(args[1])),
                "HitPoints": int(args[2]),
                "Spell": int(args[3]),
            }
        case "BOARD":
            results = {
                "Pages": int(args[0]),
            }
        case "WEAPON":
            dice = int(args[1])
            dice_size = int(args[2])
            average = (float(dice + 1) / 2.0) * float(dice_size)
            results = {
                "HitRoll": int(args[0]),
                "Hit Dice": Dice(args[1], args[2], 0),
                "Average": average,
                "Damage Type": DAMAGE_TYPES[int(args[3])],
            }
        case "TRAP":
            results = {
                "Spell": BitFlags.get_flag(args[0], SPELLS),
                "Trap HitPoints": int(args[1]),
            }
        case "NOTE":
            results = {
                "Language": "Common",
            }
        case (
            "WORN"
            | "TRASH"
            | "NOTE"
            | "OTHER"
            | "KEY"
            | "NOTHING"
            | "PEN"
            | "BOAT"
            | "ROPE"
            | "TOUCHSTONE"
            | "MISSILE"
            | "FIREWEAPON"
        ):
            pass
        case _:
            raise ValueError(f"Unknown type {item_type} Flags: {args}")
    return results
