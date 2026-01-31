# Phantom References Report

Generated from legacy CircleMUD data import analysis.

## Summary

The legacy data contains references to triggers and objects that don't exist. These are "phantom references" - `T <vnum>` lines in mob/object files that point to non-existent triggers.

| Category | Count | Impact |
|----------|-------|--------|
| Missing Triggers | ~50 unique | 502 broken references |
| Missing Objects | 10 unique | 10 broken references |
| Missing Mobs | 10 unique | 10 broken references |

## Most Impactful Missing Triggers

These phantom triggers are referenced by many entities and may represent planned but unimplemented features:

| Trigger | Referenced By | Notes |
|---------|---------------|-------|
| 3155 (31:55) | 58 mobs | Zone 30 mobs (guildmasters, etc.) |
| 3159 (31:59) | 58 mobs | Zone 30 mobs (guildmasters, etc.) |
| 307 (3:7) | 32 mobs | Various zones |
| 308 (3:8) | 32 mobs | Various zones |
| 311 (3:11) | 32 mobs | Various zones |
| 314 (3:14) | 32 mobs | Various zones |
| 306 (3:6) | 17 mobs | Various zones |

## Missing Trigger Files

These zone trigger files don't exist in the legacy `lib/world/trg/` directory:

- `3.trg` - Triggers 300-327 referenced but file missing
- `5.trg` - Triggers 500-505 referenced but file missing
- `31.trg` - Triggers 3115, 3155, 3159, 3180-3184 referenced but file missing
- `140.trg` - Trigger 14008 referenced but file missing
- `432.trg` - Triggers 43250-43256 referenced but file missing
- `482.trg` - Triggers 48259-48262 referenced but file missing
- `581.trg` - Triggers 58102-58107 referenced but file missing

## Missing Object Files

- `3.obj` - File exists but is empty (only contains `$~`)
- `124.obj` - File doesn't exist (objects 12407, 12408, 12420 referenced)

## Detailed Reference List

### Zone 0 Triggers (should these be zone 1000?)
- **Trigger 6**: Referenced by objects 517, 6423
- **Trigger 40**: Referenced by object 40
- **Trigger 97**: Referenced by object 49040

### Zone 3 Triggers (file missing)
- **Trigger 300-302**: Referenced by mob 3013
- **Trigger 306**: Referenced by 17 mobs across multiple zones
- **Trigger 307, 308, 311, 314**: Referenced by 32 mobs each
- **Trigger 312**: Referenced by 8 mobs (4013, 23803, 52001, etc.)
- **Trigger 313**: Referenced by mob 3013
- **Trigger 315, 316, 318, 326**: Referenced by 6-9 mobs each
- **Trigger 310**: Referenced by objects 2334, 2339, 2340
- **Trigger 320**: Referenced by object 18526
- **Trigger 327**: Referenced by objects 16107, 17309, 32412, 59040

### Zone 31 Triggers (file missing - these may have been intended for zone 30)
- **Trigger 3115**: Referenced by mob 3066
- **Trigger 3155**: Referenced by 58 mobs (3018, 3020, 3021, etc.)
- **Trigger 3159**: Referenced by 58 mobs (3018, 3020, 3021, etc.)
- **Trigger 3180**: Referenced by mobs 3010, 3069, 6016, 30009
- **Trigger 3181-3184**: Referenced by mob 3098

### Zone 5 Triggers (file missing)
- **Trigger 500, 501, 505**: All referenced by object 299

### Zone 432 Triggers (file missing)
- **Trigger 43250**: Referenced by mobs 43006, 43007, 43008
- **Trigger 43252**: Referenced by mob 43011
- **Trigger 43253**: Referenced by mob 43009
- **Trigger 43256**: Referenced by mob 43004

### Zone 482 Triggers (file missing)
- **Trigger 48259**: Referenced by mob 5223
- **Trigger 48260, 48262**: Referenced by mob 23800

### Zone 581 Triggers (file missing)
- **Trigger 58102-58105**: Referenced by mobs 58014, 58102
- **Trigger 58106**: Referenced by mob 58003
- **Trigger 58107**: Referenced by mob 58014

## Recommended Actions

1. **High Priority**: Create triggers 3155 and 3159 for zone 30 guildmasters (58 mobs affected)
2. **Medium Priority**: Create zone 3 triggers 306-314 (referenced by 30+ mobs each)
3. **Low Priority**: Remove phantom `T` lines from mob/object files for truly unused references
4. **Investigation**: Check if zone 31 triggers were intended for zone 30 (expanded ID range)

## Notes

- The resolver now correctly handles expanded zone ID ranges (e.g., zone 30 can have IDs > 99)
- Zone 0 stays as zone 0 (not converted to 1000)
- Some phantom triggers may represent features that were planned but never implemented
