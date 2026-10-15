-- Trigger: Phase Armor - Armor
-- Zone: 557, ID: 2
-- Type: MOB, Flags: SPEECH_TO
--
-- Speech handler: when an eligible adventurer asks the guildmaster
-- about a specific armor slot keyword (gloves/boots/sleeves/...),
-- describe the armor + gem ingredients and the level range. Reads
-- the per-slot globals seeded by the LOAD trigger (ids 10-39).
--
-- Original DG Script: #55702

-- Converted from DG Script #55702: Phase Armor - Armor
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"boots", "slippers", "sandals", "helm", "cap", "circlet", "coif", "turban", "gauntlets", "gloves", "fistwraps", "vambraces", "sleeves", "greaves", "pants", "leggings", "plate", "guard", "jerkin", "tunic", "robe", "bracer", "bracelet", "mittens", "crown", "doublet"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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
local feet_name = self:getvar("feet_name")
local head_name = self:getvar("head_name")
local hands_name = self:getvar("hands_name")
local arms_name = self:getvar("arms_name")
local legs_name = self:getvar("legs_name")
local body_name = self:getvar("body_name")
local wrist_name = self:getvar("wrist_name")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
wait(0.2)
local anti = "Anti-Paladin"
-- If you add more types of armor, you need to add their
-- keywords in the argument field for this trigger.
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
-- Original DG selected the slot whose `<slot>_name` contains the speech
-- (`%hands_name%? /= %speech%`: `/=` is a substring test, and the `?` lets
-- a trailing question mark in the speech still match).
local function slot_matches(slot_name)
    return slot_name ~= nil and string.find(string.lower(tostring(slot_name)) .. "?", string.lower(speech), 1, true) ~= nil
end
local name, gem_id, armor_id
if slot_matches(hands_name) then
    name = "pair of " .. tostring(hands_name)
    gem_id = hands_gem
    armor_id = hands_armor
elseif slot_matches(feet_name) then
    name = "pair of " .. tostring(feet_name)
    gem_id = feet_gem
    armor_id = feet_armor
elseif slot_matches(wrist_name) then
    name = wrist_name
    gem_id = wrist_gem
    armor_id = wrist_armor
elseif slot_matches(head_name) then
    name = head_name
    gem_id = head_gem
    armor_id = head_armor
elseif slot_matches(arms_name) then
    name = "pair of " .. tostring(arms_name)
    gem_id = arms_gem
    armor_id = arms_armor
elseif slot_matches(legs_name) then
    name = "pair of " .. tostring(legs_name)
    gem_id = legs_gem
    armor_id = legs_armor
elseif slot_matches(body_name) then
    name = body_name
    gem_id = body_gem
    armor_id = body_armor
end
if name then
    actor:send(tostring(self.name) .. " tells you, 'Well, I can make a fine " .. tostring(name) .. " for you, but")
    actor:send("</>I'll need <b:cyan>" .. proto_short(armor_id) .. "</> and <b:cyan>three " .. proto_plural(gem_id) .. "</>.")
    actor:send("</>Bring these things to me in any order, at any time, and I will reward you.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'You will find them on creatures across the world.")
    if phase == 1 then
        actor:send("</>Creatures <b:cyan>up to level 20</> will drop them.'")
    elseif phase == 2 then
        actor:send("</>Creatures <b:cyan>level 20 to 40</> will drop them.'")
    elseif phase == 3 then
        actor:send("</>Creatures <b:cyan>level 40 to 70</> will drop them.'")
    end
else
    actor:send(tostring(self.name) .. " peers at you oddly.")
    self.room:send_except(actor, tostring(self.name) .. " peers at " .. tostring(actor.name) .. " oddly.")
    actor:send(tostring(self.name) .. " tells you, 'I don't think I can make that for you.'")
end