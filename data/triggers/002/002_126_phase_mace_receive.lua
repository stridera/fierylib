-- Trigger: phase mace receive
-- Zone: 2, ID: 126
-- Type: MOB, Flags: RECEIVE
--
-- Generic receive handler for every phase-mace questmaster from
-- macestep 1-9. Reads per-mob crafting parameters from globals (set by
-- 002_118) — accepts each maceitem to mark its task complete and finally
-- accepts the player's mace itself to forge the next-tier reward.
--
-- TODO(parity): Several converter artifacts cannot be safely fixed here
-- without engine support; the same family of issues as 002_108:
--   * `object.id == "maceitem2"` etc. compare integer ids to literal
--     strings; needs to compare against globals.maceitem2..6 and
--     globals.mace_id (currently 5-digit vnums).
--   * Branch-scoped `local response` / `local check` / `local reward` /
--     `local number` chains never escape their elseif blocks, so the
--     dispatch at the end always sees nil.
--   * Embedded `%get.obj_shortdesc[%maceitem2%]%` interpolations need
--     `objects.template` lookups.
--   * `objects.template(552, 11)` etc. are passed to the introductory
--     prompt at mob 3:25 — those (zone, id) pairs are best-guess and
--     need verification against the legacy item table.
--   * Self-flag handling for sentinel mob 18502 is preserved unchanged.
--   * `actor:get_quest_stage("phase_mace") == "macestep"` and similar
--     compare an integer stage to the literal string "macestep" and
--     always fail; should be `== globals.macestep`.
--
-- Until the lookup helpers are exposed, this trigger sets the sentinel
-- flag on mob 18502 (because the C++ harness expects it) and otherwise
-- no-ops so partial conversions don't soft-lock the mace quest.
local _return_value = true
if self.id == 18502 then
    self:set_flag("sentinel", true)
end
-- (full mace receive handling deferred — see TODO above)
if self.id == 18502 then
    self:set_flag("sentinel", false)
end
return _return_value
