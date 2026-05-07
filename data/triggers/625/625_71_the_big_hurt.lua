-- Trigger: the BIG hurt
-- Zone: 625, ID: 71
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62571
--
-- TODO(parity): The legacy DG had four nested switches gating the smash on
-- (wielder.size, target.size) and a single `random(1, 16)` switch picking
-- one of ~12 attack vignettes. Five of those vignettes ("sailing
-- north/south/east/west/down") teleported the target through that exit.
-- The converter scrambled both switches into per-line re-rolls of
-- `random(1, 16) == N`, generated bogus comparisons (`target.flags ~= not bash`),
-- and used exit math (`rm.down / 100`) that doesn't match the room API.
-- Below we keep the size-gate plus the 7 in-room flavor vignettes from the
-- original (cases 6-12). The directional knockback variants need a
-- proper rewrite once the room exit / cross-zone teleport API is settled.
local wielder = self.worn_by
if not wielder then return true end
local target = wielder.is_fighting
if not target then return true end
-- Size gate: only triggers for non-medium wielders (giants, etc.).
if wielder.size == "medium" then
    return true
end
local pick = random(1, 16)
if pick == 6 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("You send " .. tostring(target.name) .. " skidding on " .. tostring(target.possessive) .. " back, with your power-swing from " .. tostring(self.shortdesc) .. "! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(target.name) .. " goes skidding on " .. tostring(target.possessive) .. " back after a powerful blow from " .. tostring(wielder.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 7 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: pierce
    wielder:send("A branch of your oak tree catches " .. tostring(target.name) .. ", goring him! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, "A branch of " .. tostring(wielder.name) .. "'s oak tree catches " .. tostring(target.name) .. ", goring him! (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 8 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("Your blow catches " .. tostring(target.name) .. " in the back of the head! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " in the back of the head! (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 9 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("Your blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 10 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("You stand " .. tostring(self.shortdesc) .. " on end directly on top of " .. tostring(target.name) .. "'s little body. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. " brings " .. tostring(self.shortdesc) .. " down end-first on top of " .. tostring(target.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 11 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: pierce
    wielder:send("You jab " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ", puncturing " .. tostring(target.possessive) .. " side. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. " jabs " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
end
