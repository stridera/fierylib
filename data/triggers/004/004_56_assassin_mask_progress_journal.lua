-- Trigger: Assassin Mask progress journal
-- Zone: 4, ID: 56
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #456

-- Converted from DG Script #456: Assassin Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "deadly") or string.find(arg, "promotion") or string.find(arg, "deadly_promotion or arg ~=assassin_mask") then
    if string.find(actor.class, "assassin") then
        _return_value = true
        local bountystage = actor:get_quest_stage("bounty_hunt")
        local maskstage = actor:get_quest_stage("assassin_mask")
        local master = mobiles.template(60, 51).name
        local job1 = actor:get_quest_var("assassin_mask:masktask1")
        local job2 = actor:get_quest_var("assassin_mask:masktask2")
        local job3 = actor:get_quest_var("assassin_mask:masktask3")
        local job4 = actor:get_quest_var("assassin_mask:masktask4")
        actor:send("<b:u:green>Deadly Promotion</>")
        local level
        if (maskstage or 0) == 0 then
            level = 10
        else
            level = maskstage * 10
        end
        if not actor:get_has_completed("assassin_mask") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif (maskstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if maskstage == 0 then
                actor:send("You have to do a <b:cyan>[job]</> for " .. tostring(master) .. " first though.")
                return _return_value
            elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
                actor:send("You need to complete some more Contract Killer jobs before you can receive another promotion.")
                return _return_value
            end
            -- switch on maskstage
            local mask
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(maskstage or ""))
                if tonumber(_sw1) == 1 then
                    mask = 4500
                    gem = 55592
                    place = "The Shadowy Lair"
                    hint = "in the Misty Caverns."
                elseif tonumber(_sw1) == 2 then
                    mask = 17809
                    gem = 55594
                    place = "The Dark Chamber"
                    hint = "behind a desert door."
                elseif tonumber(_sw1) == 3 then
                    mask = 59023
                    gem = 55620
                    place = "A Dark Tunnel"
                    hint = "on the way to a dark, hidden city."
                elseif tonumber(_sw1) == 4 then
                    mask = 10304
                    gem = 55638
                    place = "Dark Chamber"
                    hint = "hidden below a ghostly fortress."
                elseif tonumber(_sw1) == 5 then
                    mask = 16200
                    gem = 55666
                    place = "Darkness......"
                    hint = "inside an enchanted closet."
                elseif tonumber(_sw1) == 6 then
                    mask = 43017
                    gem = 55675
                    place = "Surrounded by Darkness"
                    hint = "in a volcanic shaft."
                elseif tonumber(_sw1) == 7 then
                    mask = 51075
                    gem = 55693
                    place = "Dark Indecision"
                    hint = "before an altar in a fallen maze."
                elseif tonumber(_sw1) == 8 then
                    mask = 49062
                    gem = 55719
                    place = "Heart of Darkness"
                    hint = "buried deep in an ancient tomb."
                elseif tonumber(_sw1) == 9 then
                    mask = 48427
                    gem = 55743
                    place = "A Dark Room"
                    hint = "under the ruins of a shop in an ancient city."
                end
            end
            local attack = maskstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(mask))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- hidden in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old mask.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("assassin_mask:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your mask.")
            end
            if not job2 then
                actor:send("- find <b:black>" .. proto_short(mask) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:black>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:black>hide in a place called \"<b:black>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:black>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value