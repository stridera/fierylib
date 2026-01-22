-- Trigger: Treasure Hunter progress journal
-- Zone: 4, ID: 96
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #496

-- Converted from DG Script #496: Treasure Hunter progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "treasure") or string.find(arg, "hunter") or string.find(arg, "treasure") hunter then
    _return_value = false
    local stage = actor:get_quest_stage("treasure_hunter")
    local master = mobiles.template(53, 7).name
    local hunt = actor:get_quest_var("treasure_hunter:hunt")
    local target1 = actor:get_quest_var("treasure_hunter:treasure1")
    actor:send("<b:green>&uTreasure Hunt</>")
    -- switch on stage
    if stage == 1 then
        local treasure1 = "a singing chain"
    elseif stage == 2 then
        local treasure1 = "a true fire ring"
    elseif stage == 3 then
        local treasure1 = "a sandstone ring"
    elseif stage == 4 then
        local treasure1 = "a crimson-tinged electrum hoop"
    elseif stage == 5 then
        local treasure1 = "a Rainbow Shell"
    elseif stage == 6 then
        local treasure1 = "the Stormshield"
    elseif stage == 7 then
        local treasure1 = "the Snow Leopard Cloak"
    elseif stage == 8 then
        local treasure1 = "a coiled rope ladder"
    elseif stage == 9 then
        local treasure1 = "a glowing phoenix feather"
    elseif stage == 10 then
        local treasure1 = "a piece of sleet armor"
    end
    if stage == 1 or not stage then
        local level = 1
    else
        local level = (stage - 1) * 10
    end
    if not actor:get_has_completed("treasure_hunter") then
        actor:send("Minimum Level: " .. tostring(level))
    end
    if actor:get_has_completed("treasure_hunter") then
        local status = "Completed!"
    elseif stage then
        local status = "In Progress"
    else
        local status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if stage > 0 and not actor:get_has_completed("bounty_hunt") then
        if actor.level >= level then
            actor:send("Quest Master: " .. tostring(master))
            if hunt == "running" or hunt == "found" or hunt == "returned" then
                actor:send("You have an order to find " .. tostring(treasure1) .. ".")
                if actor:get_quest_var("treasure_hunter:hunt") == "found" then
                    actor:send("You have found the treasure.")
                    actor:send("Return it and your order to Honus for your reward!")
                elseif actor:get_quest_var("treasure_hunter:hunt") == "returned" then
                    actor:send("You have returned the treasure to Honus.")
                    actor:send("Return your order to him for your reward!")
                end
            end
        end
    end
end
return _return_value