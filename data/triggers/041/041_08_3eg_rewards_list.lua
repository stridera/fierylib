-- Trigger: 3eg_rewards_list
-- Zone: 41, ID: 8
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- 3eg recruiter: when an Eldorian Guard recruit asks about "reward"/"rewards"
-- the mob lists which 3eg gem -> reward exchanges are available based on
-- the player's eg_faction standing. Item shortdescs are resolved from the
-- objects.template catalog at runtime (replacing the broken DG-Script
-- `%get.obj_shortdesc[...]%` interpolation produced by the converter).
--
-- Original DG Script: #4108

-- Speech keywords: reward rewards
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "reward") or string.find(speech_lower, "rewards")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
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
    return "- <b:yellow>" .. shortdesc(55, reward_id) .. "</> for <magenta>" .. shortdesc(55, gem_id) .. ".</>"
end
-- gems for this faction (zone 55)
local id_gem_3eg_cap     = 55570
local id_gem_3eg_neck    = 55571
local id_gem_3eg_arm     = 55572
local id_gem_3eg_wrist   = 55573
local id_gem_3eg_staff   = 55581
local id_gem_3eg_ssword  = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail   = 55584
local id_gem_3eg_food    = 55566
local id_gem_3eg_drink   = 55567
-- rewards (zone 55)
local id_3eg_cap     = 5518
local id_3eg_neck    = 5520
local id_3eg_arm     = 5522
local id_3eg_wrist   = 5524
local id_3eg_staff   = 5546
local id_3eg_ssword  = 5547
local id_3eg_whammer = 5548
local id_3eg_flail   = 5549
local id_3eg_food    = 5556
local id_3eg_drink   = 5558
-- Check faction and react accordingly.
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    local eg_faction = actor:get_quest_var("black_legion:eg_faction")
    if eg_faction < 20 then
        actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
        actor:send("</>when you have defeated more of the Black Legion hordes.'")
    end
    if eg_faction >= 20 then
        actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
        actor:send("suppose we can trust you with some of our goods.'")
        actor:send("You have access to:")
        actor:send(reward_line(id_3eg_food,   id_gem_3eg_food))
        actor:send(reward_line(id_3eg_drink,  id_gem_3eg_drink))
        actor:send(reward_line(id_3eg_cap,    id_gem_3eg_cap))
        actor:send(reward_line(id_3eg_ssword, id_gem_3eg_ssword))
    end
    if eg_faction >= 40 then
        actor:send(reward_line(id_3eg_neck,  id_gem_3eg_neck))
        actor:send(reward_line(id_3eg_staff, id_gem_3eg_staff))
    end
    if eg_faction >= 55 then
        actor:send(reward_line(id_3eg_arm,     id_gem_3eg_arm))
        actor:send(reward_line(id_3eg_whammer, id_gem_3eg_whammer))
    end
    if eg_faction >= 70 then
        actor:send(reward_line(id_3eg_wrist, id_gem_3eg_wrist))
        actor:send(reward_line(id_3eg_flail, id_gem_3eg_flail))
    end
    if eg_faction < 70 then
        actor:send(tostring(self.name) .. " tells you, 'As your standing with the Eldorian Guard")
        actor:send("</>improves I will show you more rewards.'")
    end
end