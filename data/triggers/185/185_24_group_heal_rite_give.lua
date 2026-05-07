-- Trigger: group_heal_rite_give
-- Zone: 185, ID: 24
-- Type: OBJECT, Flags: GIVE
--
-- Permission gate: at stage 5, the rite (185,14) may only be given to
-- the chefs/cooks (see 185_22). At stage 6, only to the doctor
-- (185,21). All other recipients are refused.
--
-- TODO(parity): chef vnum splits below match those in 185_22; verify.
-- 50203 -> (502, 3) zombified pirate cook
-- 51007 -> (510, 7) crazy chef
--  8307 -> ( 83, 7) Frakati chef
-- 18512 -> (185,12) scruffy cook
-- 10308 -> (103, 8) extra chef referenced in 185_99 status check
-- 30003 -> (300, 3) Dugrik
-- 18521 -> (185,21) the doctor

local stage = actor:get_quest_stage("group_heal")

local function vnum_match(zone, id)
    return victim.zone_id == zone and victim.local_id == id
end

if stage == 5 then
    local chefs = {
        {502, 3}, {510, 7}, {83, 7}, {185, 12}, {103, 8}, {300, 3},
    }
    for _, t in ipairs(chefs) do
        if vnum_match(t[1], t[2]) then
            actor:send("You show " .. tostring(victim.name) .. " " .. tostring(self.shortdesc) .. ".")
            self.room:send_except(actor, tostring(actor.name) .. " shows " .. tostring(victim.name) .. " " .. tostring(self.shortdesc) .. ".")
            return true
        end
    end
    actor:send("You should not give away something so precious!")
    return true
elseif stage == 6 then
    if vnum_match(185, 21) then
        return true
    end
    actor:send("You should not give away something so precious!")
    return true
end

return true
