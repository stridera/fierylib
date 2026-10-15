-- Trigger: Phase Armor - Status
-- Zone: 557, ID: 4
-- Type: MOB, Flags: SPEECH_TO
--
-- Speech handler: prints the player's progress against the
-- phase_armor quest -- which slots are pending, the gem counts, and
-- the rewards already earned. The legacy DG was tagged probability
-- 0% because SPEECH_TO triggers ignore the probability roll; the
-- converter's synthetic gate is removed so this script runs.
--
-- Original DG Script: #55704

-- Converted from DG Script #55704: Phase Armor - Status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%
-- Speech phrase: armor progress (DG num_arg 0 = the speech contains the phrase, not a chance)
local said = string.lower(speech)
if not string.find(said, "armor progress", 1, true) and not string.find(said, "progress", 1, true) then
    return true  -- Not the phrase (`ask <master> progress` is accepted too)
end
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local anti = "Anti-Paladin"
wait(0.2)
if not actor or not actor.can_be_seen then
    self:command("peer")
    self:say("I can't help you if I can't see you.")
    return true
elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
    if string.find(classes, "and") then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>classes only.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the")
        actor:send("</>" .. tostring(classes))
        actor:send("</>class only.'")
    end
    return true
elseif actor.level <= 20 * (phase - 1) then
    actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've")
    actor:send("</>gained more experience?'")
    return true
elseif actor:get_quest_stage("phase_armor") < phase then
    actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my quests yet.'")
    return true
end
-- Progress is keyed by the legacy vnum, as in 557:3 (`<vnum>_armor_acquired` /
-- `<vnum>_gems_acquired`).
local function acquired(vnum, suffix)
    return tonumber(actor:get_quest_var("phase_armor:" .. tostring(vnum) .. suffix)) or 0
end
local slots = {
    {armor = hands_armor, gem = hands_gem, reward = hands_reward},
    {armor = feet_armor, gem = feet_gem, reward = feet_reward},
    {armor = wrist_armor, gem = wrist_gem, reward = wrist_reward},
    {armor = head_armor, gem = head_gem, reward = head_reward},
    {armor = arms_armor, gem = arms_gem, reward = arms_reward},
    {armor = legs_armor, gem = legs_gem, reward = legs_reward},
    {armor = body_armor, gem = body_gem, reward = body_reward},
}
local given, unrewarded = 0, 0
local any_done = false
for _, slot in ipairs(slots) do
    slot.got = acquired(slot.armor, "_armor_acquired")
    slot.count = acquired(slot.gem, "_gems_acquired")
    slot.done = slot.got == 1 and slot.count == 3
    any_done = any_done or slot.done
    given = given + slot.got + slot.count
    if slot.got + slot.count ~= 4 then unrewarded = unrewarded + 1 end
end
actor:send(tostring(self.name) .. " tells you, 'Look for treasures from creatures:")
if phase == 1 then
    actor:send("<b:cyan>below level 20</>.'_")
elseif phase == 2 then
    actor:send("<b:cyan>level 20 to 40</>.'_")
elseif phase == 3 then
    actor:send("<b:cyan>level 40 to 70</>.'_")
end
if given == 0 then
    actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
    return true
elseif unrewarded > 0 then
    actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
end
for _, slot in ipairs(slots) do
    if slot.got > 0 and not slot.done then
        actor:send("</>  " .. proto_short(slot.armor))
    end
    if slot.count > 0 and not slot.done then
        actor:send("</>  " .. tostring(slot.count) .. " of " .. proto_short(slot.gem))
    end
end
if any_done then
    actor:send("_")
    actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
end
for _, slot in ipairs(slots) do
    if slot.done then
        actor:send("</>  " .. proto_short(slot.reward))
    end
end
