-- Trigger follow-ups: event-typed RANDOM+SPEECH wrappers (30:40, 30:140), 556 word tests and status bodies, 22:44. Needs the engine that binds the `event` global (fierymud-rs 1f5188f).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/022/022_44_belial_combat_ai_script.lua
  (22, 44, $trig$-- Converted from DG Script #2244: belial_combat_ai_script
-- Original: MOB trigger, flags: SPEECH, FIGHT, num_arg: 20 (FIGHT: 20% chance per round; SPEECH: word list, not a probability)

-- num_arg 20: FIGHT = 20% roll per round; SPEECH = the word "test" (DG word list, num_arg
-- non-zero), no chance roll.
if event == "SPEECH" then
    -- DG word list (num_arg 20): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"test"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(20) then
    return true
end
-- random combat events
local timer = random(1, 4)
local belial_ai = tonumber(self:getvar("belial_ai")) or 0  -- DG: `global belial_ai`
local action = 0  -- DG never set it (see header)
if belial_ai > 0 then
    -- switch on action
    if action == 1 then
        -- Deadly Spell
        -- line 10
        run_room_trigger(22, 46)
    elseif action == 2 then
        -- Severe Spell
        run_room_trigger(22, 47)
    elseif action == 3 then
        -- Severe Spell
        run_room_trigger(22, 48)
        -- line 20
    elseif action == 4 then
        self.room:send("Belial says in common, 'Fear my wrath, puny mortal!'")
    elseif action == 5 then
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        -- line 30
        if which == 1 then
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- line 40
        -- Show random caster Fun Lovin's!
        if self:get_mexists(1000, 15) < 1 then
            run_room_trigger(22, 49)
        end
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- line 50
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- Random Banter
        -- line 60
        -- Severe Spell
        run_room_trigger(22, 48)
        -- Severe Spell
        run_room_trigger(22, 47)
        -- line 70
        -- Deadly Spell
        run_room_trigger(22, 46)
        self:say("Your soul belongs to the Nines!")
        skills.execute(self, "kick", self.fighting)
        -- line 80
    end
end  -- auto-close block
if belial_ai >= 1 then
    belial_ai = belial_ai - 1
else
    belial_ai = timer
end
self:setvar("belial_ai", belial_ai)$trig$, 'c7fdd33f9fa2ce9b0f2df4b3d5b9565f'),
  -- data/triggers/030/030_140_freddy_random_load_doll.lua
  (30, 140, $trig$-- Converted from DG Script #3140: Freddy random load doll
-- Original: MOB trigger, flags: RANDOM, SPEECH, num_arg: 1 (word list and random chance)

-- RANDOM + SPEECH trigger (num_arg 1): a spoken word list when someone speaks (event is SPEECH,
-- speech is the text), a 1% roll on the random pulse (event is RANDOM).
if event == "SPEECH" then
    -- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"refresh"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(1) then
    return true
end
-- Generate a random number
local p = random(1, 15)
-- If this is being triggered by an imm as a speech trig, ensure something loads
if actor and actor.level > 100 then
    p = 15
end
if p ~= 15 then
    return true
end
-- Figure out which object to load.  Better chance for lower IDs.
p = random(1, 100)
if p < 31 then
    p = 139 + random(1, 7)
elseif p < 82 then
    p = 146 + random(1, 35)
elseif p < 93 then
    p = 181 + random(1, 10)
else
    p = 191 + random(1, 7)
end
-- In case one of the randoms returned 0 somehow
if p == 139 then
    p = 140 + random(1, 58)
end
self.room:spawn_object(30, p)
-- Special handling for certain dolls:
-- Imanhotep's sarcophagus
if p == 182 then
    self.room:spawn_object(30, 199)
    get_room(11, 0):at(function()
        self:command("open sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("put imanhotep sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("close sarcophagus")
    end)
    -- The Chosen boxed set
elseif p == 198 then
    self.room:spawn_object(30, 175)
    self.room:spawn_object(30, 176)
    self.room:spawn_object(30, 177)
    self.room:spawn_object(30, 178)
    self.room:spawn_object(30, 179)
    get_room(11, 0):at(function()
        self:command("open boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("close boxed-set")
    end)
end$trig$, '909db29ea7c51f510f35c1e28b76a5fc'),
  -- data/triggers/030/030_40_blob-to-pawnbroker.lua
  (30, 40, $trig$-- Converted from DG Script #3040: blob-to-pawnbroker
-- Original: MOB trigger, flags: RANDOM, SPEECH, num_arg: 1 (word list and random chance)

-- RANDOM + SPEECH trigger (num_arg 1): a spoken word list when someone speaks (event is SPEECH,
-- speech is the text), a 1% roll on the random pulse (event is RANDOM).
if event == "SPEECH" then
    -- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"drop", "off", "the", "junk"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(1) then
    return true
end
self:teleport(get_room(61, 72))
self:destroy_item("all.key")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(61, 72))
self:command("remove all")
self:command("drop all")
self.room:find_actor("pawnbroker"):command("get all")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(60, 34))
local randmielrm = random(1, 18)
self:teleport(get_room(30, 51 + randmielrm))$trig$, 'f158d0fc1364d699831094016996f774'),
  -- data/triggers/556/556_03_phase_1_where.lua
  (556, 3, $trig$-- Converted from DG Script #55603: phase_1_where
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 100 (DG word-list mode, not a probability)
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and'")
actor:send(tostring(self.name) .. " tells you, 'adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level 1 to 20, so'")
actor:send(tostring(self.name) .. " tells you, 'the items I desire can be found in areas of that'")
actor:send(tostring(self.name) .. " tells you, 'difficulty.  Once you have agreed to take on my'")
actor:send(tostring(self.name) .. " tells you, 'quests you can seek another like me for tasks a'")
actor:send(tostring(self.name) .. " tells you, 'bit more difficult.'")$trig$, '70b9e8d47d8de5b8255de4339a0b3d2d'),
  -- data/triggers/556/556_04_phase_2_where.lua
  (556, 4, $trig$-- Converted from DG Script #55604: phase_2_where
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 100 (DG word-list mode, not a probability)
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and'")
actor:send(tostring(self.name) .. " tells you, 'adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level 21 to 40, so'")
actor:send(tostring(self.name) .. " tells you, 'the items I desire can be found in areas of that'")
actor:send(tostring(self.name) .. " tells you, 'difficulty.  Once you have agreed to take on my'")
actor:send(tostring(self.name) .. " tells you, 'quests you can seek another like me for tasks a'")
actor:send(tostring(self.name) .. " tells you, 'bit more difficult.'")$trig$, '8d1ed196457540f125dd79423bde704e'),
  -- data/triggers/556/556_05_phase_3_where.lua
  (556, 5, $trig$-- Converted from DG Script #55605: phase_3_where
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 100 (DG word-list mode, not a probability)
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
actor:send(tostring(self.name) .. " tells you, 'You can find the items I seek by playing and'")
actor:send(tostring(self.name) .. " tells you, 'adventuring in areas appropriate to your level.'")
actor:send(tostring(self.name) .. " tells you, 'My quests are for those from level 41 to 60, so'")
actor:send(tostring(self.name) .. " tells you, 'the items I desire can be found in areas of that'")
actor:send(tostring(self.name) .. " tells you, 'difficulty.'")$trig$, 'fe73dc22eaa7a746d10ee1b98d8685e4'),
  -- data/triggers/556/556_06_phase_1_warrior_status.lua
  (556, 6, $trig$-- Converted from DG Script #55606: phase_1_warrior_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"warrior", "anti-paladin", "paladin", "ranger", "monk"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 1
local quest_stage = 1
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- armors for this class
        local id_destroyed_gloves = 55300
        local id_destroyed_boots = 55304
        local id_destroyed_bracer = 55308
        local id_destroyed_helm = 55312
        local id_destroyed_arm = 55316
        local id_destroyed_legs = 55320
        local id_destroyed_chest = 55324
        -- gems for this class
        local id_gem_gloves = 55569
        local id_gem_boots = 55573
        local id_gem_bracer = 55577
        local id_gem_helm = 55581
        local id_gem_arm = 55585
        local id_gem_legs = 55589
        local id_gem_chest = 55593
        -- rewards for this class
        local id_reward_helm = 55384
        local id_reward_arms = 55385
        local id_reward_chest = 55386
        local id_reward_legs = 55387
        local id_reward_boots = 55388
        local id_reward_bracer = 55389
        local id_reward_gloves = 55390
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'c73837e98062272ca7caacf90424fe82'),
  -- data/triggers/556/556_07_phase_1_sorcerer_status.lua
  (556, 7, $trig$-- Converted from DG Script #55607: phase_1_sorcerer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"sorcerer", "necromancer", "cryomancer", "pyromancer", "conjurer"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 1
local quest_stage = 1
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- armors for this class
        local id_destroyed_gloves = 55302
        local id_destroyed_boots = 55306
        local id_destroyed_bracer = 55310
        local id_destroyed_helm = 55314
        local id_destroyed_arm = 55318
        local id_destroyed_legs = 55322
        local id_destroyed_chest = 55326
        -- gems for this class
        local id_gem_gloves = 55567
        local id_gem_boots = 55571
        local id_gem_bracer = 55575
        local id_gem_helm = 55579
        local id_gem_arm = 55583
        local id_gem_legs = 55587
        local id_gem_chest = 55591
        -- rewards for this class
        local id_reward_helm = 55398
        local id_reward_arms = 55399
        local id_reward_chest = 55400
        local id_reward_legs = 55401
        local id_reward_boots = 55402
        local id_reward_bracer = 55403
        local id_reward_gloves = 55404
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '80818568a87f95e453fdd6b4acb39501'),
  -- data/triggers/556/556_08_phase_1_rogue_status.lua
  (556, 8, $trig$-- Converted from DG Script #55608: phase_1_rogue_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"rogue", "assassin", "thief", "mercenary"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 1
local quest_stage = 1
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55301
        local id_destroyed_chest = 55325
        local id_destroyed_boots = 55305
        local id_destroyed_bracer = 55309
        local id_destroyed_helm = 55313
        local id_destroyed_arm = 55317
        local id_destroyed_legs = 55321
        -- gems for this class
        local id_gem_gloves = 55568
        local id_gem_boots = 55572
        local id_gem_bracer = 55576
        local id_gem_helm = 55580
        local id_gem_arm = 55584
        local id_gem_legs = 55588
        local id_gem_chest = 55592
        -- rewards for this class
        local id_reward_helm = 55405
        local id_reward_arms = 55406
        local id_reward_chest = 55407
        local id_reward_legs = 55408
        local id_reward_boots = 55409
        local id_reward_bracer = 55410
        local id_reward_gloves = 55411
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '10195bb7b1723e033d6627ecd87180c8'),
  -- data/triggers/556/556_09_phase_1_cleric_status.lua
  (556, 9, $trig$-- Converted from DG Script #55609: phase_1_cleric_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"cleric", "priest", "diabolist", "druid"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 1
local quest_stage = 1
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55300
        local id_destroyed_boots = 55304
        local id_destroyed_bracer = 55308
        local id_destroyed_helm = 55312
        local id_destroyed_arm = 55316
        local id_destroyed_legs = 55320
        local id_destroyed_chest = 55324
        -- gems for this class
        local id_gem_gloves = 55566
        local id_gem_boots = 55570
        local id_gem_bracer = 55574
        local id_gem_helm = 55578
        local id_gem_arm = 55582
        local id_gem_legs = 55586
        local id_gem_chest = 55590
        -- rewards for this class
        local id_reward_helm = 55391
        local id_reward_arms = 55392
        local id_reward_chest = 55393
        local id_reward_legs = 55394
        local id_reward_boots = 55395
        local id_reward_bracer = 55396
        local id_reward_gloves = 55397
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '916ba49093a40701f7b526e01ae6226f'),
  -- data/triggers/556/556_10_phase_2_cleric_status.lua
  (556, 10, $trig$-- Converted from DG Script #55610: phase_2_cleric_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"cleric", "priest"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55328
        local id_destroyed_boots = 55332
        local id_destroyed_bracer = 55336
        local id_destroyed_helm = 55340
        local id_destroyed_arm = 55344
        local id_destroyed_legs = 55348
        local id_destroyed_chest = 55352
        -- gems for this class
        local id_gem_gloves = 55601
        local id_gem_boots = 55612
        local id_gem_bracer = 55623
        local id_gem_helm = 55634
        local id_gem_arm = 55645
        local id_gem_legs = 55656
        local id_gem_chest = 55667
        -- rewards for this class
        local id_reward_helm = 55433
        local id_reward_arms = 55434
        local id_reward_chest = 55435
        local id_reward_legs = 55436
        local id_reward_boots = 55437
        local id_reward_bracer = 55438
        local id_reward_gloves = 55439
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'ae7ad1a52a86bcbbc0d86d5928ddfb34'),
  -- data/triggers/556/556_11_phase_2_druid_status.lua
  (556, 11, $trig$-- Converted from DG Script #55611: phase_2_druid_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"druid"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55330
        local id_destroyed_boots = 55334
        local id_destroyed_bracer = 55338
        local id_destroyed_helm = 55342
        local id_destroyed_arm = 55346
        local id_destroyed_legs = 55350
        local id_destroyed_chest = 55354
        -- gems for this class
        local id_gem_gloves = 55596
        local id_gem_boots = 55607
        local id_gem_bracer = 55618
        local id_gem_helm = 55629
        local id_gem_arm = 55640
        local id_gem_legs = 55651
        local id_gem_chest = 55662
        -- rewards for this class
        local id_reward_helm = 55447
        local id_reward_arms = 55448
        local id_reward_chest = 55449
        local id_reward_legs = 55450
        local id_reward_boots = 55451
        local id_reward_bracer = 55452
        local id_reward_gloves = 55453
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '6e91ec74a737d7eb8a67ca8371c02329'),
  -- data/triggers/556/556_12_phase_2_sorcerer_status.lua
  (556, 12, $trig$-- Converted from DG Script #55612: phase_2_sorcerer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55331
        local id_destroyed_boots = 55335
        local id_destroyed_bracer = 55338
        local id_destroyed_helm = 55343
        local id_destroyed_arm = 55347
        local id_destroyed_legs = 55351
        local id_destroyed_chest = 55355
        -- gems for this class
        local id_gem_gloves = 55602
        local id_gem_boots = 55613
        local id_gem_bracer = 55624
        local id_gem_helm = 55631
        local id_gem_arm = 55646
        local id_gem_legs = 55657
        local id_gem_chest = 55668
        -- rewards for this class
        local id_reward_helm = 55475
        local id_reward_arms = 55476
        local id_reward_chest = 55477
        local id_reward_legs = 55478
        local id_reward_boots = 55479
        local id_reward_bracer = 55480
        local id_reward_gloves = 55481
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '61b6ccb341c7375f749099f943003199'),
  -- data/triggers/556/556_13_phase_2_paladin_status.lua
  (556, 13, $trig$-- Converted from DG Script #55613: phase_2_paladin_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"paladin"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55328
        local id_destroyed_boots = 55332
        local id_destroyed_bracer = 55336
        local id_destroyed_helm = 55340
        local id_destroyed_arm = 55344
        local id_destroyed_legs = 55348
        local id_destroyed_chest = 55352
        -- gems for this class
        local id_gem_gloves = 55599
        local id_gem_boots = 55610
        local id_gem_bracer = 55621
        local id_gem_helm = 55632
        local id_gem_arm = 55643
        local id_gem_legs = 55654
        local id_gem_chest = 55665
        -- rewards for this class
        local id_reward_helm = 55419
        local id_reward_arms = 55420
        local id_reward_chest = 55421
        local id_reward_legs = 55422
        local id_reward_boots = 55423
        local id_reward_bracer = 55424
        local id_reward_gloves = 55425
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'a70781b67a92d33c3984799d7ac8cc46'),
  -- data/triggers/556/556_14_phase_2_monk_status.lua
  (556, 14, $trig$-- Converted from DG Script #55614: phase_2_monk_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"monk"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55330
        local id_destroyed_boots = 55334
        local id_destroyed_bracer = 55338
        local id_destroyed_helm = 55342
        local id_destroyed_arm = 55346
        local id_destroyed_legs = 55350
        local id_destroyed_chest = 55354
        -- gems for this class
        local id_gem_gloves = 55597
        local id_gem_boots = 55608
        local id_gem_bracer = 55619
        local id_gem_helm = 55630
        local id_gem_arm = 55641
        local id_gem_legs = 55652
        local id_gem_chest = 55663
        -- rewards for this class
        local id_reward_helm = 55461
        local id_reward_arms = 55462
        local id_reward_chest = 55463
        local id_reward_legs = 55464
        local id_reward_boots = 55465
        local id_reward_bracer = 55466
        local id_reward_gloves = 55467
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '638f48e9d28217a0afc669f13c029c67'),
  -- data/triggers/556/556_15_phase_2_necromancer_status.lua
  (556, 15, $trig$-- Converted from DG Script #55615: phase_2_necromancer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"necromancer"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55331
        local id_destroyed_boots = 55335
        local id_destroyed_bracer = 55339
        local id_destroyed_helm = 55343
        local id_destroyed_arm = 55347
        local id_destroyed_legs = 55351
        local id_destroyed_chest = 55355
        -- gems for this class
        local id_gem_gloves = 55598
        local id_gem_boots = 55609
        local id_gem_bracer = 55620
        local id_gem_helm = 55631
        local id_gem_arm = 55642
        local id_gem_legs = 55653
        local id_gem_chest = 55664
        -- rewards for this class
        local id_reward_helm = 55454
        local id_reward_arms = 55455
        local id_reward_chest = 55456
        local id_reward_legs = 55457
        local id_reward_boots = 55458
        local id_reward_bracer = 55459
        local id_reward_gloves = 55460
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'b25e0fc42b8b4082b427f1a21e1cd2d6'),
  -- data/triggers/556/556_16_phase_2_ranger_status.lua
  (556, 16, $trig$-- Converted from DG Script #55616: phase_2_ranger_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"ranger"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55329
        local id_destroyed_boots = 55333
        local id_destroyed_bracer = 55337
        local id_destroyed_helm = 55341
        local id_destroyed_arm = 55345
        local id_destroyed_legs = 55349
        local id_destroyed_chest = 55353
        -- gems for this class
        local id_gem_gloves = 55600
        local id_gem_boots = 55611
        local id_gem_bracer = 55622
        local id_gem_helm = 55633
        local id_gem_arm = 55644
        local id_gem_legs = 55655
        local id_gem_chest = 55666
        -- rewards for this class
        local id_reward_helm = 55440
        local id_reward_arms = 55441
        local id_reward_chest = 55442
        local id_reward_legs = 55443
        local id_reward_boots = 55444
        local id_reward_bracer = 55445
        local id_reward_gloves = 55446
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '59fac09c6c6ba86894fc2679c88eea06'),
  -- data/triggers/556/556_17_phase_3_anti-paladin_status.lua
  (556, 17, $trig$-- Converted from DG Script #55617: phase_3_anti-paladin_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if string.find(string.lower(actor.class or ""), "anti", 1, true) then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55671
        local id_gem_boots = 55682
        local id_gem_bracer = 55693
        local id_gem_helm = 55704
        local id_gem_arm = 55715
        local id_gem_legs = 55726
        local id_gem_chest = 55737
        -- rewards for this class
        local id_reward_helm = 55503
        local id_reward_arms = 55504
        local id_reward_chest = 55505
        local id_reward_legs = 55506
        local id_reward_boots = 55507
        local id_reward_bracer = 55508
        local id_reward_gloves = 55509
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '698d6ada0ae37b789b89383083c6d707'),
  -- data/triggers/556/556_18_phase_3_monk_status.lua
  (556, 18, $trig$-- Converted from DG Script #55618: phase_3_monk_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"monk"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55358
        local id_destroyed_boots = 55362
        local id_destroyed_bracer = 55366
        local id_destroyed_helm = 55370
        local id_destroyed_arm = 55374
        local id_destroyed_legs = 55378
        local id_destroyed_chest = 55382
        -- gems for this class
        local id_gem_gloves = 55674
        local id_gem_boots = 55685
        local id_gem_bracer = 55696
        local id_gem_helm = 55707
        local id_gem_arm = 55718
        local id_gem_legs = 55729
        local id_gem_chest = 55740
        -- rewards for this class
        local id_reward_helm = 55538
        local id_reward_arms = 55539
        local id_reward_chest = 55540
        local id_reward_legs = 55541
        local id_reward_boots = 55542
        local id_reward_bracer = 55543
        local id_reward_gloves = 55544
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '9aae147908c47024faabc47ffa07037b'),
  -- data/triggers/556/556_19_phase_3_druid_status.lua
  (556, 19, $trig$-- Converted from DG Script #55619: phase_3_druid_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"druid"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55358
        local id_destroyed_boots = 55362
        local id_destroyed_bracer = 55366
        local id_destroyed_helm = 55370
        local id_destroyed_arm = 55374
        local id_destroyed_legs = 55378
        local id_destroyed_chest = 55382
        -- gems for this class
        local id_gem_gloves = 55673
        local id_gem_boots = 55684
        local id_gem_bracer = 55695
        local id_gem_helm = 55706
        local id_gem_arm = 55717
        local id_gem_legs = 55728
        local id_gem_chest = 55739
        -- rewards for this class
        local id_reward_helm = 55524
        local id_reward_arms = 55525
        local id_reward_chest = 55526
        local id_reward_legs = 55527
        local id_reward_boots = 55528
        local id_reward_bracer = 55529
        local id_reward_gloves = 55530
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '50848739398b500ca2b67f5646389b29'),
  -- data/triggers/556/556_20_phase_3_paladin_status.lua
  (556, 20, $trig$-- Converted from DG Script #55620: phase_3_paladin_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"paladin"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55676
        local id_gem_boots = 55687
        local id_gem_bracer = 55698
        local id_gem_helm = 55709
        local id_gem_arm = 55720
        local id_gem_legs = 55731
        local id_gem_chest = 55742
        -- rewards for this class
        local id_reward_helm = 55496
        local id_reward_arms = 55497
        local id_reward_chest = 55498
        local id_reward_legs = 55499
        local id_reward_boots = 55500
        local id_reward_bracer = 55501
        local id_reward_gloves = 55502
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '090c5a62ac7442d61fde6557346df422'),
  -- data/triggers/556/556_21_phase_2_warrior_status.lua
  (556, 21, $trig$-- Converted from DG Script #55621: phase_2_warrior_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"warrior"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55328
        local id_destroyed_boots = 55332
        local id_destroyed_bracer = 55336
        local id_destroyed_helm = 55340
        local id_destroyed_arm = 55344
        local id_destroyed_legs = 55348
        local id_destroyed_chest = 55352
        -- gems for this class
        local id_gem_gloves = 55604
        local id_gem_boots = 55615
        local id_gem_bracer = 55626
        local id_gem_helm = 55637
        local id_gem_arm = 55648
        local id_gem_legs = 55659
        local id_gem_chest = 55670
        -- rewards for this class
        local id_reward_helm = 55412
        local id_reward_arms = 55413
        local id_reward_chest = 55414
        local id_reward_legs = 55415
        local id_reward_boots = 55416
        local id_reward_bracer = 55417
        local id_reward_gloves = 55418
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'f5620e4d665b891974a4a56061b27362'),
  -- data/triggers/556/556_22_phase_2_anti-paladin_status.lua
  (556, 22, $trig$-- Converted from DG Script #55622: phase_2_anti-paladin_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if string.find(string.lower(actor.class or ""), "anti", 1, true) then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55328
        local id_destroyed_boots = 55332
        local id_destroyed_bracer = 55336
        local id_destroyed_helm = 55340
        local id_destroyed_arm = 55344
        local id_destroyed_legs = 55348
        local id_destroyed_chest = 55352
        -- gems for this class
        local id_gem_gloves = 55594
        local id_gem_boots = 55605
        local id_gem_bracer = 55616
        local id_gem_helm = 55627
        local id_gem_arm = 55638
        local id_gem_legs = 55649
        local id_gem_chest = 55660
        -- rewards for this class
        local id_reward_helm = 55426
        local id_reward_arms = 55427
        local id_reward_chest = 55428
        local id_reward_legs = 55429
        local id_reward_boots = 55430
        local id_reward_bracer = 55431
        local id_reward_gloves = 55432
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '11b9956d6318cfb82fe702e66dc80e28'),
  -- data/triggers/556/556_23_phase_2_diabolist_status.lua
  (556, 23, $trig$-- Converted from DG Script #55623: phase_2_diabolist_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 100 (DG word-list mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"diabolist"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55328
        local id_destroyed_boots = 55332
        local id_destroyed_bracer = 55336
        local id_destroyed_helm = 55340
        local id_destroyed_arm = 55344
        local id_destroyed_legs = 55348
        local id_destroyed_chest = 55352
        -- gems for this class
        local id_gem_gloves = 55595
        local id_gem_boots = 55606
        local id_gem_bracer = 55617
        local id_gem_helm = 55628
        local id_gem_arm = 55639
        local id_gem_legs = 55650
        local id_gem_chest = 55661
        -- rewards for this class
        local id_reward_helm = 55468
        local id_reward_arms = 55469
        local id_reward_chest = 55470
        local id_reward_legs = 55471
        local id_reward_boots = 55472
        local id_reward_bracer = 55473
        local id_reward_gloves = 55474
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '2aeeec8a9f6fd170b4a27b19a6529b67'),
  -- data/triggers/556/556_24_phase_2_rogue_status.lua
  (556, 24, $trig$-- Converted from DG Script #55624: phase_2_rogue_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"rogue", "assassin", "mercenary", "thief"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55329
        local id_destroyed_boots = 55333
        local id_destroyed_bracer = 55337
        local id_destroyed_helm = 55341
        local id_destroyed_arm = 55345
        local id_destroyed_legs = 55349
        local id_destroyed_chest = 55353
        -- gems for this class
        local id_gem_gloves = 55603
        local id_gem_boots = 55614
        local id_gem_bracer = 55625
        local id_gem_helm = 55636
        local id_gem_arm = 55647
        local id_gem_legs = 55658
        local id_gem_chest = 55669
        -- rewards for this class
        local id_reward_helm = 55482
        local id_reward_arms = 55483
        local id_reward_chest = 55484
        local id_reward_legs = 55485
        local id_reward_boots = 55486
        local id_reward_bracer = 55487
        local id_reward_gloves = 55488
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'cf3b8f987540a047985f8d012cdf755e'),
  -- data/triggers/556/556_25_phase_3_warrior_status.lua
  (556, 25, $trig$-- Converted from DG Script #55625: phase_3_warrior_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"warrior"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55681
        local id_gem_boots = 55692
        local id_gem_bracer = 55703
        local id_gem_helm = 55714
        local id_gem_arm = 55725
        local id_gem_legs = 55736
        local id_gem_chest = 55747
        -- rewards for this class
        local id_reward_helm = 55489
        local id_reward_arms = 55490
        local id_reward_chest = 55491
        local id_reward_legs = 55492
        local id_reward_boots = 55493
        local id_reward_bracer = 55494
        local id_reward_gloves = 55495
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '5b272627286455843253117310766047'),
  -- data/triggers/556/556_26_phase_3_ranger_status.lua
  (556, 26, $trig$-- Converted from DG Script #55626: phase_3_ranger_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"ranger"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55357
        local id_destroyed_boots = 55361
        local id_destroyed_bracer = 55365
        local id_destroyed_helm = 55369
        local id_destroyed_arm = 55373
        local id_destroyed_legs = 55377
        local id_destroyed_chest = 55381
        -- gems for this class
        local id_gem_gloves = 55677
        local id_gem_boots = 55688
        local id_gem_bracer = 55699
        local id_gem_helm = 55710
        local id_gem_arm = 55721
        local id_gem_legs = 55732
        local id_gem_chest = 55743
        -- rewards for this class
        local id_reward_helm = 55517
        local id_reward_arms = 55518
        local id_reward_chest = 55519
        local id_reward_legs = 55520
        local id_reward_boots = 55521
        local id_reward_bracer = 55522
        local id_reward_gloves = 55523
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'fb4ac07fa007eb53032ec0a1763f5e1f'),
  -- data/triggers/556/556_28_phase_3_necromancer_status.lua
  (556, 28, $trig$-- Converted from DG Script #55628: phase_3_necromancer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"necromancer"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55359
        local id_destroyed_boots = 55363
        local id_destroyed_bracer = 55367
        local id_destroyed_helm = 55371
        local id_destroyed_arm = 55375
        local id_destroyed_legs = 55379
        local id_destroyed_chest = 55383
        -- gems for this class
        local id_gem_gloves = 55675
        local id_gem_boots = 55686
        local id_gem_bracer = 55697
        local id_gem_helm = 55708
        local id_gem_arm = 55719
        local id_gem_legs = 55730
        local id_gem_chest = 55741
        -- rewards for this class
        local id_reward_helm = 55531
        local id_reward_arms = 55532
        local id_reward_chest = 55533
        local id_reward_legs = 55534
        local id_reward_boots = 55535
        local id_reward_bracer = 55536
        local id_reward_gloves = 55537
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '7889bdc4b9677df67a6effb86290a880'),
  -- data/triggers/556/556_29_phase_3_sorcerer_status.lua
  (556, 29, $trig$-- Converted from DG Script #55629: phase_3_sorcerer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"sorcerer", "pyromancer", "cryomancer"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55359
        local id_destroyed_boots = 55363
        local id_destroyed_bracer = 55367
        local id_destroyed_helm = 55371
        local id_destroyed_arm = 55375
        local id_destroyed_legs = 55379
        local id_destroyed_chest = 55383
        -- gems for this class
        local id_gem_gloves = 55679
        local id_gem_boots = 55690
        local id_gem_bracer = 55701
        local id_gem_helm = 55712
        local id_gem_arm = 55723
        local id_gem_legs = 55734
        local id_gem_chest = 55745
        -- rewards for this class
        local id_reward_helm = 55552
        local id_reward_arms = 55553
        local id_reward_chest = 55554
        local id_reward_legs = 55555
        local id_reward_boots = 55556
        local id_reward_bracer = 55557
        local id_reward_gloves = 55558
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '3c4f08b3ece19c995b8bc8cc32f615f5'),
  -- data/triggers/556/556_30_phase_3_diabolist_status.lua
  (556, 30, $trig$-- Converted from DG Script #55630: phase_3_diabolist_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"diabolist"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55672
        local id_gem_boots = 55683
        local id_gem_bracer = 55694
        local id_gem_helm = 55705
        local id_gem_arm = 55716
        local id_gem_legs = 55727
        local id_gem_chest = 55738
        -- rewards for this class
        local id_reward_helm = 55545
        local id_reward_arms = 55546
        local id_reward_chest = 55547
        local id_reward_legs = 55548
        local id_reward_boots = 55549
        local id_reward_bracer = 55550
        local id_reward_gloves = 55551
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '387679ec706308a298457226a043e4ec'),
  -- data/triggers/556/556_31_phase_3_rogue_status.lua
  (556, 31, $trig$-- Converted from DG Script #55631: phase_3_rogue_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"rogue", "assassin", "mercenary", "thief"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55357
        local id_destroyed_boots = 55361
        local id_destroyed_bracer = 55365
        local id_destroyed_helm = 55369
        local id_destroyed_arm = 55373
        local id_destroyed_legs = 55377
        local id_destroyed_chest = 55381
        -- gems for this class
        local id_gem_gloves = 55680
        local id_gem_boots = 55691
        local id_gem_bracer = 55702
        local id_gem_helm = 55713
        local id_gem_arm = 55724
        local id_gem_legs = 55735
        local id_gem_chest = 55746
        -- rewards for this class
        local id_reward_helm = 55559
        local id_reward_arms = 55560
        local id_reward_chest = 55561
        local id_reward_legs = 55562
        local id_reward_boots = 55563
        local id_reward_bracer = 55564
        local id_reward_gloves = 55565
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '952b4213e8412484b13778c9b812ee84')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
