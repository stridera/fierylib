-- Trigger: seagulls, stop it now
-- Zone: 625, ID: 74
-- Type: OBJECT, Flags: DEFEND
-- Status: CLEAN
--
-- Original DG Script: #62574
--
-- TODO(parity): Defensive companion to triggers 72/73. The legacy script
-- ramps a `count` global based on incoming `damage`, casts minor
-- paralysis on the attacker via the wearer (`worn_on`), and gates on a
-- shared charge counter. The converter left bare references to `count`,
-- `damage`, `worn_on`, `victim`, and `actor` that don't all exist in
-- DEFEND-trigger scope here. Needs porting as a unit with 72/73. Left
-- as a no-op until then.

-- Converted from DG Script #62574: seagulls, stop it now
-- Original: OBJECT trigger, flags: DEFEND, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
return true
