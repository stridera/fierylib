-- Trigger: Major Globe progress journal
-- Zone: 4, ID: 19
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--   Large script: 5129 chars
--
-- Original DG Script: #419

-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "major") globe or string.find(arg, "globe") or string.find(arg, "major_globe") or string.find(arg, "major_globe_spell") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if actor.level >= 50 and string.find(relocateclasses, "actor.class") then
        _return_value = false
        local stage = actor:get_quest_stage("major_globe_spell")
        actor:send("<b:green>&uMajor Globe</>")
        actor:send("Minimum Level: 57")
        if actor:get_has_completed("major_globe_spell") then
            local status = "Completed!"
        elseif actor:get_quest_stage("major_globe_spell") then
            local status = "In Progress"
        else
            local status = "Not Started"
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
                local task = Bring master the salve Earle prepared.
            elseif stage == 6 then
                local master = mobiles.template(534, 50).name
                local task = "&6&bSearch&0 in each &2&blibrary&0 or &2&bstack&0 to find the lost spellbook."
            elseif stage == 7 then
                local master = mobiles.template(534, 50).name
                local task = Bring objects.template(534, 52).name to master.
            elseif stage == 8 then
                local master = mobiles.template(534, 50).name
                local plant = actor:get_quest_var("major_globe_spell:ward_53453")
                local mist = actor:get_quest_var("major_globe_spell:ward_53454")
                local water = actor:get_quest_var("major_globe_spell:ward_53455")
                local flame = actor:get_quest_var("major_globe_spell:ward_53456")
                local ice = actor:get_quest_var("major_globe_spell:ward_53457")
                local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
                local task = Bring master &3&bwards_left more elemental wards&0, one each from a mist, a water, an ice, a flame, and a plant elemental.
            elseif stage == 9 then
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                if final_item == 53458 then
                    local place = "in a border keep"
                elseif final_item == 53459 then
                    local place = "on an emerald isle"
                elseif final_item == 53460 then
                    local place = "within a misty fortress"
                else
                    local place = "in an underground city"
                end
                local task = Find get.obj_shortdesc[final_item] in place.
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                local task = Deliver get.obj_shortdesc[final_item] to master.
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