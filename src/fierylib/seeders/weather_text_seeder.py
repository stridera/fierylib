"""Weather flavour lines (WeatherText table).

The ``weather`` command used to hard-code one line per zone climate and time of day.
``daypart`` is dawn / day / midday / evening / night / any: the game tries the exact hour band,
then its group (day = day+midday; night = night+evening+dawn), then "any". Only TEMPERATE has a
distinct dawn line; Climate NONE (and rooms with no climate) use the single "any" line.

Mirrored by ``data/sql/2026-10-12-weather-text.sql`` (a test keeps the two in sync). Existing
non-NULL texts are never overwritten, so builder edits in Muditor survive a reseed.
"""

# (Climate enum value, daypart, text)
WEATHER_TEXTS = [
    ("ARID", "day", "Heat shimmers off the parched ground; the air is dry as bone."),
    ("ARID", "night", "The desert chill cuts through cloaks; stars wheel sharply overhead."),
    ("SEMIARID", "day", "Dust dances on a warm wind; the sun bears down without mercy."),
    ("SEMIARID", "night", "The scrub cools rapidly; far-off coyotes call."),
    ("TROPICAL", "day", "Humid air clings to your skin; a green-tinted sun hangs heavy."),
    ("TROPICAL", "night", "Frogs and night-birds compete in the dripping dark."),
    ("SUBTROPICAL", "day", "Warm gusts carry distant rain; cumulus clouds tower in lazy stacks."),
    ("SUBTROPICAL", "night", "Crickets thicken the air; warm mist drifts through the night."),
    ("TEMPERATE", "dawn", "A cool breeze rustles the leaves; dew glistens on every blade."),
    ("TEMPERATE", "day", "Mild sun and a clean breeze; pleasant traveling weather."),
    ("TEMPERATE", "night", "Stars glitter through clear, cool air."),
    ("OCEANIC", "day", "Salt spray rides a steady wind; gulls wheel and complain."),
    ("OCEANIC", "night", "Distant surf and sea-mist mute the night."),
    ("SUBARCTIC", "day", "Pale sun glints off stubborn frost; your breath fogs the air."),
    ("SUBARCTIC", "night", "Bitter cold seeps through every seam; aurora flickers overhead."),
    ("ARCTIC", "day", "Wind-driven snow blurs the horizon; the sun is a pale disc."),
    ("ARCTIC", "night", "The cold is absolute; ice creaks in the dark."),
    ("ALPINE", "day", "Thin, sharp air bites at your lungs; the sun is fierce off the snow."),
    ("ALPINE", "night", "The wind howls down the slopes; stars are knife-bright at altitude."),
    ("NONE", "any", "The air is still and unremarkable."),
]


class WeatherTextSeeder:
    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_weather_text(self, verbose: bool = False) -> dict:
        """Create missing rows and fill NULL texts; returns {"changed": rows touched}.

        Raw SQL so it works with a Python Prisma client generated before the WeatherText
        model existed (the Python generator cannot parse the Prisma 7 schema).
        """
        changed = 0
        for climate, daypart, text in WEATHER_TEXTS:
            n = await self.prisma.execute_raw(
                'INSERT INTO "WeatherText" ("climate", "daypart", "text") '
                'VALUES ($1::"Climate", $2, $3) '
                'ON CONFLICT ("climate", "daypart") DO UPDATE SET "text" = EXCLUDED."text" '
                'WHERE "WeatherText"."text" IS NULL',
                climate,
                daypart,
                text,
            )
            changed += n
            if verbose:
                print(f"  {climate}/{daypart} ({n} row(s))")
        return {"changed": changed}
