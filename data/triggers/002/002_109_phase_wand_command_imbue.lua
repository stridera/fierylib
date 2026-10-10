-- Trigger: phase wand command imbue
-- Zone: 2, ID: 109
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): This trigger needs a from-scratch rewrite — the converted
-- form is rife with DG-Script remnants that can't be safely transformed
-- mechanically:
--   * `actor.room == "place"` compares a Room object to a literal string
--     instead of looking up the destination room by id (`place` is a
--     numeric room vnum loaded by 002_111's globals export).
--   * Branch-scoped `local type/place/ward/wardname/nextname/crafter/color`
--     never escape their elseif blocks, so the body that uses them sees
--     nil for every variable.
--   * Embedded interpolations like `%get.obj_shortdesc[%wandgem%]%` and
--     `world.destroy(wardname)` (passing a string) need rewrites against
--     the Lua bindings (`objects.template(z, id).name`, `actor:has_item`).
--   * `person.class` is referenced in the exp-multiplier block but
--     `person` is never defined; should be `actor.class`.
--   * `actor.inventory[ward]` / `actor.wearing[wandnum]` are DG indexing
--     patterns; replace with `actor:has_item(z, id)` / `actor:get_worn(slot)`.
--   * The 3% probability filter is a converter artifact for COMMAND
--     triggers — `imbue` should fire deterministically when the wand is
--     held; the percent_chance gate must be removed.
--
-- The full fix requires re-deriving the place/ward/crafter table for
-- each wand/staff id and matching it to the room composite key. Until the
-- engine binding for that lookup is in place, this trigger is a no-op so
-- the wand quest cannot be soft-locked by a partial conversion.

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "imbue" then
    return true
end
return true
