-- Deleting an object or mob prototype must not delete players' own copies.
--
-- "CharacterItems" -> "Objects" and "CharacterPets" -> "Mobs" were ON DELETE CASCADE, so deleting a prototype in
-- Muditor (or clearing a zone before a re-import) silently destroyed every player's copy of that item / pet.
-- They are now ON DELETE RESTRICT; the Muditor API turns the FK failure into a clear "N player items / pets
-- still reference it" error.
--
-- This is exactly what `prisma db push` produces for `onDelete: Restrict` in schema.prisma (constraint names and
-- ON UPDATE CASCADE unchanged), so applying this file first leaves db push with nothing to do for these two FKs.
--
-- Idempotent: each constraint is only dropped/re-added while it is not already ON DELETE RESTRICT
-- (pg_constraint.confdeltype = 'r'), so a second run is a no-op and takes no locks.

BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'CharacterItems_object_zone_id_object_id_fkey'
          AND conrelid = '"CharacterItems"'::regclass
          AND confdeltype = 'r'
    ) THEN
        ALTER TABLE "CharacterItems" DROP CONSTRAINT IF EXISTS "CharacterItems_object_zone_id_object_id_fkey";
        ALTER TABLE "CharacterItems" ADD CONSTRAINT "CharacterItems_object_zone_id_object_id_fkey"
            FOREIGN KEY ("object_zone_id", "object_id") REFERENCES "Objects"("zone_id", "id")
            ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'CharacterPets_mob_prototype_zone_id_mob_prototype_id_fkey'
          AND conrelid = '"CharacterPets"'::regclass
          AND confdeltype = 'r'
    ) THEN
        ALTER TABLE "CharacterPets" DROP CONSTRAINT IF EXISTS "CharacterPets_mob_prototype_zone_id_mob_prototype_id_fkey";
        ALTER TABLE "CharacterPets" ADD CONSTRAINT "CharacterPets_mob_prototype_zone_id_mob_prototype_id_fkey"
            FOREIGN KEY ("mob_prototype_zone_id", "mob_prototype_id") REFERENCES "Mobs"("zone_id", "id")
            ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
END $$;

COMMIT;
