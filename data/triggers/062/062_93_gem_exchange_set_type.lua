-- Trigger: Gem Exchange set type
-- Zone: 62, ID: 93
-- Type: MOB, Flags: SPEECH
--
-- Soltan Gem Exchange order taker. Player names a gemstone (and optionally a
-- quality grade); we look up the corresponding object vnum in the gem table,
-- store it on the gem_exchange quest, and confirm the order.
--
-- The legacy gem ids are 5-digit vnums (zone*100+id) into zone 555. They are
-- preserved here verbatim so 062_94 / 062_95 (which decode the class/tier from
-- the numeric value) keep working.
--
-- Original DG Script: #6293

-- Speech keywords trigger any gem-related word
local s = string.lower(speech)
local gems = {
    "amber", "agate", "amethyst", "aquamarine", "beryl", "bloodstone", "blood",
    "carnelian", "citrine", "diamond", "emerald", "garnet", "hematite", "jade",
    "jasper", "labradorite", "lapis", "lazuli", "lapis-lazuli", "malachite",
    "moonstone", "moon", "onyx", "opal", "pearl", "peridot", "sapphire", "ruby",
    "topaz", "tourmaline", "turquoise",
}
local matched = false
for _, g in ipairs(gems) do
    if string.find(s, g) then matched = true; break end
end
if not matched then
    return true
end

wait(2)
if not actor:get_quest_stage("gem_exchange") or actor:get_quest_stage("gem_exchange") == 0 then
    actor:start_quest("gem_exchange")
end

-- Quality grade selectors. Order matters: more-specific words first so
-- "crushed amber" doesn't get classified as plain "amber".
local function grade()
    if string.find(s, "crushed") then return "crushed"
    elseif string.find(s, "dust") then return "dust"
    elseif string.find(s, "uncut") then return "uncut"
    elseif string.find(s, "flawed") then return "flawed"
    elseif string.find(s, "shard") then return "shard"
    elseif string.find(s, "enchanted") then return "enchanted"
    elseif string.find(s, "radiant") then return "radiant"
    elseif string.find(s, "perfect") then return "perfect"
    end
    return "polished"
end

-- gem_table[stone_keyword][grade] -> legacy vnum.
-- A nil value means that grade is not stocked for that gemstone.
local gem_table = {
    amber = { crushed=55575, dust=55567, uncut=55602, flawed=55624, shard=55583, enchanted=55723, radiant=55701, perfect=55679, polished=55646 },
    agate = { uncut=55599, flawed=55621, perfect=55676, radiant=55698, enchanted=55720, polished=55643 },
    amethyst = { crushed=55574, dust=55566, uncut=55601, flawed=55623, shard=55582, enchanted=55722, radiant=55700, perfect=55678, polished=55645 },
    aquamarine = { crushed=55579, dust=55571, uncut=55613, flawed=55635, shard=55587, enchanted=55734, radiant=55712, perfect=55690, polished=55657 },
    beryl = { uncut=55606, flawed=55628, shard=55605, enchanted=55727, radiant=55705, perfect=55683, polished=55650 },
    bloodstone = { uncut=55598, flawed=55620, perfect=55675, radiant=55697, enchanted=55719, polished=55642 },
    carnelian = { uncut=55595, flawed=55617, perfect=55672, radiant=55694, enchanted=55716, polished=55639 },
    citrine = { crushed=55577, dust=55569, uncut=55604, flawed=55626, shard=55585, enchanted=55725, radiant=55703, perfect=55681, polished=55648 },
    diamond = { crushed=55591, uncut=55665, flawed=55664, enchanted=55741, radiant=55742, perfect=55745, polished=55668 },
    emerald = { crushed=55593, uncut=55663, flawed=55660, enchanted=55737, radiant=55740, perfect=55747, polished=55670 },
    garnet = { crushed=55578, dust=55570, uncut=55612, flawed=55634, shard=55586, enchanted=55733, radiant=55711, perfect=55689, polished=55656 },
    hematite = { uncut=55594, flawed=55616, perfect=55671, radiant=55693, enchanted=55715, polished=55638 },
    jade = { uncut=55608, flawed=55630, shard=55610, enchanted=55729, radiant=55707, perfect=55685, polished=55652 },
    labradorite = { uncut=55611, flawed=55633, perfect=55688, radiant=55710, enchanted=55732, polished=55655 },
    lapis = { uncut=55600, flawed=55622, enchanted=55721, radiant=55699, perfect=55677, polished=55644 },
    malachite = { dust=55568, crushed=55576, shard=55584, uncut=55603, flawed=55625, perfect=55680, radiant=55702, enchanted=55724, polished=55647 },
    moonstone = { uncut=55596, flawed=55618, perfect=55673, radiant=55695, enchanted=55717, polished=55640 },
    onyx = { uncut=55609, flawed=55631, perfect=55686, radiant=55708, enchanted=55730, polished=55653 },
    opal = { uncut=55610, flawed=55632, enchanted=55731, radiant=55709, perfect=55687, polished=55654 },
    pearl = { uncut=55607, flawed=55629, enchanted=55728, radiant=55706, perfect=55684, polished=55651 },
    peridot = { uncut=55615, crushed=55581, dust=55573, shard=55589, flawed=55637, perfect=55692, radiant=55714, enchanted=55736, polished=55659 },
    ruby = { crushed=55590, uncut=55662, flawed=55661, enchanted=55738, radiant=55739, perfect=55744, polished=55667 },
    sapphire = { crushed=55592, uncut=55666, flawed=55689, radiant=55743, perfect=55746, polished=55669 },
    topaz = { uncut=55605, flawed=55627, enchanted=55726, radiant=55704, perfect=55682, polished=55649 },
    tourmaline = { crushed=55580, dust=55572, uncut=55614, flawed=55636, shard=55588, enchanted=55735, radiant=55713, perfect=55691, polished=55658 },
    turquoise = { uncut=55597, flawed=55619, enchanted=55718, radiant=55696, perfect=55674, polished=55641 },
}

-- Pick the gemstone keyword matched in the speech. Earlier multi-word
-- patterns like "lapis lazuli" / "moonstone" are normalized below.
local stone
if string.find(s, "lapis") or string.find(s, "lazuli") then stone = "lapis"
elseif string.find(s, "moonstone") or string.find(s, "moon") then stone = "moonstone"
elseif string.find(s, "bloodstone") or string.find(s, "blood") then stone = "bloodstone"
else
    for k, _ in pairs(gem_table) do
        if string.find(s, k) then stone = k; break end
    end
end

-- Special cases the exchange refuses outright.
if string.find(s, "jasper") then
    actor:send(tostring(self.name) .. " says, 'I'm sorry, we don't stock jasper.'")
    self:command("half")
    return true
end
if stone == "malachite" and string.find(s, "chunk") then
    actor:send(tostring(self.name) .. " says, 'That is not an item we trade in the gem exchange.'")
    self:command("half")
    return true
end

if not stone then
    return true
end

local g = grade()
local gem_id = gem_table[stone] and gem_table[stone][g]
if not gem_id then
    actor:send(tostring(self.name) .. " says, 'I'm sorry, we don't stock that grade of " .. stone .. ".'")
    return true
end

local gem_name = tostring(objects.template(math.floor(gem_id / 100), gem_id % 100).name)
actor:send(tostring(self.name) .. " asks you, 'You want " .. gem_name .. "?'")
actor:set_quest_var("gem_exchange", "gem_id", gem_id)
return true
