-- Race display names carry their legacy colours (Refs fierymud-rs #159).
--
-- "Races"."name" is the display name shown by `who` (and, with the colour tags, anywhere a race is
-- named for players). The import had stripped the legacy colour codes, so `who` printed the enum
-- spelling ("Dragonborn-Lightning"). Legacy printed each race's coloured name (races.cpp
-- `displayname`): the five Dragonborn are all spelt "Dragonborn" but coloured per subrace, so the
-- colours tell the subraces apart. This sets the coloured name from data/races.json.
--
-- Guarded and idempotent: a row changes only while its name is still the plain, uncoloured text
-- (a builder who edited the name in Muditor wins); a second run changes nothing.

BEGIN;

UPDATE "Races" r
SET name = v.coloured, updated_at = now()
FROM (VALUES
    ('HUMAN', 'Human', '<cyan>Human</>'),
    ('ELF', 'Elf', 'Elf'),
    ('GNOME', 'Gnome', '<b:dim:red>Gnome</>'),
    ('DWARF', 'Dwarf', '<yellow>Dwarf</>'),
    ('TROLL', 'Troll', '<dim:green>Troll</>'),
    ('DROW', 'Drow', '<magenta>Drow</>'),
    ('DUERGAR', 'Duergar', '<red>Duergar</>'),
    ('OGRE', 'Ogre', '<blue>Ogre</>'),
    ('ORC', 'Orc', '<b:black>Orc</>'),
    ('HALF_ELF', 'Half-Elf', '<b:cyan>Half-</><dim:cyan>Elf</>'),
    ('GOLIATH', 'Goliath', 'Goliath'),
    ('HALFLING', 'Halfling', '<dim:yellow>Halfling</>'),
    ('PLANT', 'Plant', '<green>Plant</>'),
    ('HUMANOID', 'Humanoid', '<white>Humanoid</>'),
    ('ANIMAL', 'Animal', '<green>Animal</>'),
    ('DRAGON_GENERAL', 'Dragon', '<b:magenta>Dragon</>'),
    ('GIANT', 'Giant', '<b:green>Giant</>'),
    ('OTHER', 'Other', '<b:blue>Other</>'),
    ('GOBLIN', 'Goblin', '<b:blue>Goblin</>'),
    ('DEMON', 'Demon', '<b:red>Demon</>'),
    ('BROWNIE', 'Brownie', '<yellow>Brownie</>'),
    ('DRAGON_FIRE', 'Dragon', '<b:red>Dragon</>'),
    ('DRAGON_FROST', 'Dragon', '<b:white>Dragon</>'),
    ('DRAGON_ACID', 'Dragon', '<b:black>Dragon</>'),
    ('DRAGON_LIGHTNING', 'Dragon', '<b:blue>Dragon</>'),
    ('DRAGON_GAS', 'Dragon', '<b:green>Dragon</>'),
    ('DRAGONBORN_FIRE', 'Dragonborn', '<red>Dr</><b:red>a</><b:yellow>g</><b:red>on</><red>b</><b:red>o</><b:yellow>r</><b:red>n</>'),
    ('DRAGONBORN_FROST', 'Dragonborn', '<b:white>Dr</><b:blue>ag</><b:white>onb</><b:blue>or</><b:white>n</>'),
    ('DRAGONBORN_ACID', 'Dragonborn', '<b:black>Dr</><b:green>a</><green>g</><b:green>o</><b:black>nb</><b:green>o</><green>r</><b:black>n</>'),
    ('DRAGONBORN_LIGHTNING', 'Dragonborn', '<b:blue>Dr</><b:cyan>a</><b:blue>go</><b:cyan>n</><b:blue>b</><b:cyan>or</><b:blue>n</>'),
    ('DRAGONBORN_GAS', 'Dragonborn', '<b:green>Dra</><b:yellow>g</><b:green>onb</><b:yellow>or</><b:green>n</>'),
    ('SVERFNEBLIN', 'Sverfneblin', '<b:dim:black>Sverfneblin</>'),
    ('FAERIE_SEELIE', 'Faerie', '<b:white>F</><b:yellow>aeri</><b:white>e</>'),
    ('FAERIE_UNSEELIE', 'Faerie', '<b:black>F</><magenta>aeri</><b:black>e</>'),
    ('NYMPH', 'Nymph', '<b:yellow>N</><green>ym</><b:yellow>ph</>'),
    ('ARBOREAN', 'Arborean', '<green>Arborean</>')
) AS v(race, plain, coloured)
WHERE r.race::text = v.race
  AND r.name = v.plain
  AND v.coloured <> v.plain;

COMMIT;
