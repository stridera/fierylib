-- Trigger: Major Globe progress journal
-- Zone: 4, ID: 19
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
-- TODO(parity): the switch on stage lost its `elseif stage == 10` (the "Deliver" task follows the
-- stage 9 "Find" task in the same branch), and the final send block sits inside that last branch,
-- so stages 1-8 never print their task. Rebuild from DG #419.
--
-- Original DG Script: #419

-- Converted from DG Script #419: Major Globe progress journal
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
            if stage == 1 then
                local master = mobiles.template(534, 50).name
                local task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                local master = mobiles.template(490, 8).name
                local task = "Find shale on Fiery Island."
            elseif stage == 3 then
                local master = mobiles.template(490, 8).name
                local task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                local master = mobiles.template(490, 8).name
                local task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                local master = mobiles.template(534, 50).name
                local task = "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."
            elseif stage == 7 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                local master = mobiles.template(534, 50).name
                plant = actor:get_quest_var("major_globe_spell:ward_53453")
                mist = actor:get_quest_var("major_globe_spell:ward_53454")
                water = actor:get_quest_var("major_globe_spell:ward_53455")
                flame = actor:get_quest_var("major_globe_spell:ward_53456")
                ice = actor:get_quest_var("major_globe_spell:ward_53457")
                wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                local task = "Bring " .. tostring(master) .. " <b:yellow>" .. tostring(wards_left) .. " more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if (final_item or 0) == 53458 then
                    place = "in a border keep"
                elseif (final_item or 0) == 53459 then
                    place = "on an emerald isle"
                elseif (final_item or 0) == 53460 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                local task = "Find " .. proto_short(final_item) .. " " .. tostring(place) .. "."
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                local task = "Deliver " .. proto_short(final_item) .. " to " .. tostring(master) .. "."
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
    end
end  -- auto-close block
return _return_value