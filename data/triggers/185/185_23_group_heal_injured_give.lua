-- Trigger: group_heal_injured_give
-- Zone: 185, ID: 23
-- Type: OBJECT, Flags: GIVE
--
-- Stage 6 of group_heal: player gives a medical packet (185,21) to an
-- injured/sick/wounded NPC. Each unique recipient (tracked by quest var
-- "group_heal:<zone>_<id>") increments total. After 5 deliveries, the
-- player learns the Group Heal spell.
--
-- Eligible targets (legacy vnums -> (zone, id)):
--   18506 -> (185,  6)   abbey injured
--   46414 -> (464, 14)
--   43020 -> (430, 20)
--   12513 -> (125, 13)
--   36103 -> (361,  3)
--   58803 -> (588,  3)
--   30054 -> (300, 54)
-- Refused targets (Lirne and one other):
--   62506 -> (625,  6)
--   53450 -> (534, 50)
--
-- TODO(parity): legacy 5-digit vnums above need verification. Also the
-- legacy `mskillset %actor% group heal` command path is reproduced as a
-- raw command string; if the rs runtime exposes a typed
-- actor:learn_spell(name) API, prefer that instead.

if actor:get_quest_stage("group_heal") ~= 6 then
    return true
end

if victim.is_player then
    return true
end

local function vnum_match(zone, id)
    return victim.zone_id == zone and victim.local_id == id
end

local key = "group_heal:" .. tostring(victim.zone_id) .. "_" .. tostring(victim.local_id)
if actor:get_quest_var(key) then
    actor:send("you have already helped " .. tostring(victim.name))
    return true
end

local eligible_recipients = {
    {185,  6}, {464, 14}, {430, 20}, {125, 13},
    {361,  3}, {588,  3}, {300, 54},
}
local refused_recipients = { {625, 6}, {534, 50} }

local is_eligible = false
for _, t in ipairs(eligible_recipients) do
    if vnum_match(t[1], t[2]) then is_eligible = true; break end
end
local is_refused = false
for _, t in ipairs(refused_recipients) do
    if vnum_match(t[1], t[2]) then is_refused = true; break end
end

if is_eligible then
    actor:set_quest_var("group_heal", tostring(victim.zone_id) .. "_" .. tostring(victim.local_id), 1)
    local heal = (actor:get_quest_var("group_heal:total") or 0) + 1
    actor:set_quest_var("group_heal", "total", heal)

    actor:send("You give " .. tostring(self.shortdesc) .. " to " .. tostring(victim.name) .. " and apply the medicine to " .. tostring(victim.himher) .. ".")
    wait(1)
    self.room:send(tostring(victim.name) .. "'s wounds begin to heal as they consume the magical feast.")
    wait(2)

    -- Animal recipients (46414/36103) get a "nuzzle" rather than a thanks/bow.
    if vnum_match(464, 14) or vnum_match(361, 3) then
        victim:command("nuzzle " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(victim.name) .. " turns and departs.")
    else
        self.room:send(tostring(victim.name) .. " says, 'Thank you so much for coming to my aid!'")
        wait(1)
        self.room:send(tostring(victim.name) .. " bows and departs.")
    end

    if heal >= 5 then
        victim:command("mskillset " .. tostring(actor.name) .. " group heal")
        world.destroy(victim)
        wait(1)
        actor:send("The miraculous power of St. George washes over you!")
        actor:send("The appropriate prayers to beseech the gods for group heal well up in your soul.")
        actor:complete_quest("group_heal")
        actor:send("<b:white>You have learned Group Heal</>!")
    else
        world.destroy(victim)
    end
    world.destroy(self)
elseif is_refused then
    wait(1)
    actor:send("It is not possible to help " .. tostring(victim.name) .. ".")
else
    wait(1)
    actor:send(tostring(victim.name) .. " does not appear to be hurt.")
end

return true
