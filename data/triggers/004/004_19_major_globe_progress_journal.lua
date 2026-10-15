-- Trigger: Major Globe progress journal
-- Zone: 4, ID: 19
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #419

-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- final_item is a local id in zone 534; nil (never picked) reads as a missing description.
local function final_item_name(local_id)
    local name = local_id and objects.template(534, local_id).name
    if not name or name == "" then return "[no description for object " .. tostring(local_id) .. "]" end
    return name
end
local wards_left, plant, mist, water, flame, ice
local _return_value = true  -- Default: allow action
if string.find(arg, "major globe") or string.find(arg, "globe") or string.find(arg, "major_globe") or string.find(arg, "major_globe_spell") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("major_globe_spell")
        actor:send("<b:u:green>Major Globe</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("major_globe_spell") then
            status = "Completed!"
        elseif actor:get_quest_stage("major_globe_spell") > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("major_globe_spell") then
            -- switch on stage
            local master, task
            if stage == 1 then
                master = mobiles.template(534, 50).name
                task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                master = mobiles.template(490, 8).name
                task = "Find shale on Fiery Island."
            elseif stage == 3 then
                master = mobiles.template(490, 8).name
                task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                master = mobiles.template(490, 8).name
                task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                master = mobiles.template(534, 50).name
                task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                master = mobiles.template(534, 50).name
                task = "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."
            elseif stage == 7 then
                master = mobiles.template(534, 50).name
                task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                master = mobiles.template(534, 50).name
                plant = actor:get_quest_var("major_globe_spell:ward_53")
                mist = actor:get_quest_var("major_globe_spell:ward_54")
                water = actor:get_quest_var("major_globe_spell:ward_55")
                flame = actor:get_quest_var("major_globe_spell:ward_56")
                ice = actor:get_quest_var("major_globe_spell:ward_57")
                wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                task = "Bring " .. tostring(master) .. " <b:yellow>" .. tostring(wards_left) .. " more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                master = mobiles.template(534, 50).name
                -- final_item holds the chosen object's local id within zone 534 (58-61), see 534_67
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if (final_item or 0) == 58 then
                    place = "in a border keep"
                elseif (final_item or 0) == 59 then
                    place = "on an emerald isle"
                elseif (final_item or 0) == 60 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                task = "Find " .. final_item_name(final_item) .. " " .. tostring(place) .. "."
            elseif stage == 10 then
                master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                task = "Deliver " .. final_item_name(final_item) .. " to " .. tostring(master) .. "."
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            actor:send(tostring(task))
            if stage == 8 then
                if wards_left < 5 then
                    actor:send("You have found:")
                    if plant == 2 then
                        actor:send(tostring(objects.template(534, 53).name))
                    end
                    if mist == 2 then
                        actor:send(tostring(objects.template(534, 54).name))
                    end
                    if water == 2 then
                        actor:send(tostring(objects.template(534, 55).name))
                    end
                    if flame == 2 then
                        actor:send(tostring(objects.template(534, 56).name))
                    end
                    if ice == 2 then
                        actor:send(tostring(objects.template(534, 57).name))
                    end
                end
            end
        end
    end
end  -- auto-close block
return _return_value