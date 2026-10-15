-- Trigger: 3eg_rewards_list
-- Zone: 55, ID: 8
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: TODO(parity)
--
-- Mirror of 3bl_rewards_list (055_04) for the Eldorian Guard side; reward and gem
-- names resolve through proto_short().
--
-- Original DG Script: #5508

-- Converted from DG Script #5508: 3eg_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local id_gem_3eg_cap = 55570
local id_gem_3eg_neck = 55571
local id_gem_3eg_arm = 55572
local id_gem_3eg_wrist = 55573
local id_gem_3eg_gloves = 55574
local id_gem_3eg_jerkin = 55575
local id_gem_3eg_robe = 55589
local id_gem_3eg_belt = 55576
local id_gem_3eg_legs = 55577
local id_gem_3eg_boots = 55578
local id_gem_3eg_mask = 55579
local id_gem_3eg_symbol = 55580
local id_gem_3eg_staff = 55581
local id_gem_3eg_ssword = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail = 55584
local id_gem_3eg_shiv = 55585
local id_gem_3eg_lsword = 55586
local id_gem_3eg_smace = 55587
local id_gem_3eg_light = 55588
local id_gem_3eg_food = 55566
local id_gem_3eg_drink = 55567
-- rewards
local id_3eg_cap = 5518
local id_3eg_neck = 5520
local id_3eg_arm = 5522
local id_3eg_wrist = 5524
local id_3eg_gloves = 5526
local id_3eg_jerkin = 5528
local id_3eg_belt = 5530
local id_3eg_legs = 5532
local id_3eg_boots = 5534
local id_3eg_mask = 5536
local id_3eg_robe = 5538
local id_3eg_symbol = 5516
local id_3eg_staff = 5546
local id_3eg_ssword = 5547
local id_3eg_whammer = 5548
local id_3eg_flail = 5549
local id_3eg_shiv = 5550
local id_3eg_lsword = 5551
local id_3eg_smace = 5552
local id_3eg_light = 5554
local id_3eg_food = 5556
local id_3eg_drink = 5558
-- 
-- Check faction and react accordingly
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a")
            actor:send("</>recruit, come back when you have defeated more of the Black Legion hordes.'")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor:get_quest_var("black_legion:eg_faction")%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit")
            actor:send("</>wet behind the ears I suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_food) .. "</> for <magenta>" .. proto_short(id_gem_3eg_food) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_drink) .. "</> for <magenta>" .. proto_short(id_gem_3eg_drink) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_cap) .. "</> for <magenta>" .. proto_short(id_gem_3eg_cap) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_ssword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_ssword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_neck) .. "</> for <magenta>" .. proto_short(id_gem_3eg_neck) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_staff) .. "</> for <magenta>" .. proto_short(id_gem_3eg_staff) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_arm) .. "</> for <magenta>" .. proto_short(id_gem_3eg_arm) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_whammer) .. "</> for <magenta>" .. proto_short(id_gem_3eg_whammer) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_wrist) .. "</> for <magenta>" .. proto_short(id_gem_3eg_wrist) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_flail) .. "</> for <magenta>" .. proto_short(id_gem_3eg_flail) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_gloves) .. "</> for <magenta>" .. proto_short(id_gem_3eg_gloves) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_symbol) .. "</> for <magenta>" .. proto_short(id_gem_3eg_symbol) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_light) .. "</> for <magenta>" .. proto_short(id_gem_3eg_light) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_belt) .. "</> for <magenta>" .. proto_short(id_gem_3eg_belt) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_shiv) .. "</> for <magenta>" .. proto_short(id_gem_3eg_shiv) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_boots) .. "</> for <magenta>" .. proto_short(id_gem_3eg_boots) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_lsword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_lsword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_legs) .. "</> for <magenta>" .. proto_short(id_gem_3eg_legs) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_robe) .. "</> for <magenta>" .. proto_short(id_gem_3eg_robe) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_3eg_jerkin) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_mask) .. "</> for <magenta>" .. proto_short(id_gem_3eg_mask) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_smace) .. "</> for <magenta>" .. proto_short(id_gem_3eg_smace) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with")
            actor:send("</>the 3rd Eldorian Guard improves I will show you more rewards.'")
        end
    end
end