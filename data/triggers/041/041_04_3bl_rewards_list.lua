-- Trigger: 3bl_rewards_list
-- Zone: 41, ID: 4
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- 3bl recruiter: when a Black Legion recruit asks about "reward"/"rewards"
-- the mob lists which 3bl gem -> reward exchanges are available based on
-- the player's bl_faction standing. Item shortdescs are resolved from the
-- objects.template catalog at runtime (replacing the broken DG-Script
-- `%get.obj_shortdesc[...]%` interpolation produced by the converter).
--
-- NOTE: Reward and gem item IDs in this file ARE 3bl-specific (5517..5557
-- for rewards, 55566..55584 for gems) -- these zone-55 ids differ from the
-- short ids used in 041_03's reward lookup table on purpose: 041_03 spawns
-- via the `id_3bl_*` short ids (17..58), this list-only trigger references
-- the corresponding catalog entries by their actual zone-55 ids.
--
-- Original DG Script: #4104

-- Speech keywords: reward rewards
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "reward") or string.find(speech_lower, "rewards")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- Resolve a (zone, id) prototype's short name, falling back to the id.
local function shortdesc(zone, id)
    local proto = objects.template(zone, id)
    if proto and proto.name then
        return tostring(proto.name)
    end
    return "item " .. tostring(id)
end
local function reward_line(reward_id, gem_id)
    return "- <b:yellow>" .. shortdesc(55, reward_id) .. "</> for <magenta>" .. shortdesc(55, gem_id) .. "</>"
end
-- gems for this faction (zone 55)
local id_gem_3bl_cap     = 55570
local id_gem_3bl_neck    = 55571
local id_gem_3bl_arm     = 55572
local id_gem_3bl_wrist   = 55573
local id_gem_3bl_staff   = 55581
local id_gem_3bl_ssword  = 55582
local id_gem_3bl_whammer = 55583
local id_gem_3bl_flail   = 55584
local id_gem_3bl_food    = 55566
local id_gem_3bl_drink   = 55567
-- rewards (zone 55)
local id_3bl_cap     = 5517
local id_3bl_neck    = 5519
local id_3bl_arm     = 5521
local id_3bl_wrist   = 5523
local id_3bl_staff   = 5539
local id_3bl_ssword  = 5540
local id_3bl_whammer = 5541
local id_3bl_flail   = 5542
local id_3bl_food    = 5555
local id_3bl_drink   = 5557
-- Check faction and react accordingly.
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    local bl_faction = actor:get_quest_var("black_legion:bl_faction")
    if bl_faction < 20 then
        actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
        actor:send("</>when you have defeated more of the Eldorian villainy.'")
    end
    if bl_faction >= 20 then
        actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
        actor:send("</>suppose we can trust you with some of our goods.'")
        actor:send("</>You have access to:")
        actor:send(reward_line(id_3bl_food,   id_gem_3bl_food))
        actor:send(reward_line(id_3bl_drink,  id_gem_3bl_drink))
        actor:send(reward_line(id_3bl_cap,    id_gem_3bl_cap))
        actor:send(reward_line(id_3bl_ssword, id_gem_3bl_ssword))
    end
    if bl_faction >= 40 then
        actor:send(reward_line(id_3bl_neck,  id_gem_3bl_neck))
        actor:send(reward_line(id_3bl_staff, id_gem_3bl_staff))
    end
    if bl_faction >= 55 then
        actor:send(reward_line(id_3bl_arm,     id_gem_3bl_arm))
        actor:send(reward_line(id_3bl_whammer, id_gem_3bl_whammer))
    end
    if bl_faction >= 70 then
        actor:send(reward_line(id_3bl_wrist, id_gem_3bl_wrist))
        actor:send(reward_line(id_3bl_flail, id_gem_3bl_flail))
    end
    if bl_faction < 70 then
        actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black Legion")
        actor:send("</>improves I will show you more rewards.'")
    end
end