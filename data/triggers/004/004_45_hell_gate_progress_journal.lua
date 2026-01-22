-- Trigger: Hell Gate progress journal
-- Zone: 4, ID: 45
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 29 if statements
--   Large script: 7834 chars
--
-- Original DG Script: #445

-- Converted from DG Script #445: Hell Gate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hell") gate or string.find(arg, "hell_gate") then
    if string.find(actor.class, "Diabolist") and actor.level >= 75 then
        _return_value = false
        local stage = actor:get_quest_stage("hell_gate")
        local master = mobiles.template(564, 0).name
        actor:send("<b:green>&uHell Gate</>")
        actor:send("Minimum Level: 81")
        if actor:get_has_completed("hell_gate") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hell_gate") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            if stage == 1 then
                actor:send("You are preparing to open a door to Garl'lixxil and release one of the demon lords.  Find " .. tostring(objects.template(32, 13).name) .. ".")
            elseif stage == 2 then
                local key1 = actor:get_quest_var("hell_gate:8303")
                local key2 = actor:get_quest_var("hell_gate:23709")
                local key3 = actor:get_quest_var("hell_gate:49008")
                local key4 = actor:get_quest_var("hell_gate:52012")
                local key5 = actor:get_quest_var("hell_gate:52013")
                local key6 = actor:get_quest_var("hell_gate:53402")
                local key7 = actor:get_quest_var("hell_gate:58109")
                actor:send("Find seven keys to seven gates.")
                if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
                    actor:send("</>")
                    actor:send("You have already found:")
                    if key1 then
                        actor:send("<red>" .. tostring(objects.template(83, 3).name) .. "</>")
                    end
                    if key2 then
                        actor:send("<red>" .. tostring(objects.template(237, 9).name) .. "</>")
                    end
                    if key3 then
                        actor:send("<red>" .. tostring(objects.template(490, 8).name) .. "</>")
                    end
                    if key4 then
                        actor:send("<red>" .. tostring(objects.template(520, 12).name) .. "</>")
                    end
                    if key5 then
                        actor:send("<red>" .. tostring(objects.template(520, 13).name) .. "</>")
                    end
                    if key6 then
                        actor:send("<red>" .. tostring(objects.template(534, 2).name) .. "</>")
                    end
                    if key7 then
                        actor:send("<red>" .. tostring(objects.template(581, 9).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You must still find:")
                if not key1 then
                    actor:send("<b:red>A small, well-crafted key made of wood with the smell of rich sap</>")
                    actor:send("<b:red>Kept at the gate of a tribe's home.</>")
                    actor:send("</>")
                end
                if not key6 then
                    actor:send("<b:red>A key made of light silvery metal which only elves can work</>")
                    actor:send("<b:red>Deep in a frozen valley.</>")
                    actor:send("</>")
                end
                if not key2 then
                    actor:send("<b:red>A large, black key humming with magical energy</>")
                    actor:send("<b:red>From a twisted cruel city in a huge underground cavern.</>")
                    actor:send("</>")
                end
                if not key7 then
                    actor:send("<b:red>A simple lacquered iron key</>")
                    actor:send("<b:red>In the care of a radiant bird on an emerald island.</>")
                    actor:send("</>")
                end
                if not key3 then
                    actor:send("<b:red>A rusted but well cared for key</>")
                    actor:send("<b:red>Held by a winged captain on an island of magical beasts.</>")
                    actor:send("</>")
                end
                if not key5 then
                    actor:send("<b:red>A golden plated, wrought-iron key</>")
                    actor:send("<b:red>held at the gates to a desacrated city.</>")
                    actor:send("</>")
                end
                if not key4 then
                    actor:send("<b:red>One nearly impossible to see</>")
                    actor:send("<b:red>guarded by a fiery beast with many heads.</>")
                end
            elseif stage == 3 then
                local blood1 = actor:get_quest_var("hell_gate:56400")
                local blood2 = actor:get_quest_var("hell_gate:56401")
                local blood3 = actor:get_quest_var("hell_gate:56402")
                local blood4 = actor:get_quest_var("hell_gate:56403")
                local blood5 = actor:get_quest_var("hell_gate:56404")
                local blood6 = actor:get_quest_var("hell_gate:56405")
                local blood7 = actor:get_quest_var("hell_gate:56406")
                actor:send("Sacrifice seven different <b:red>children</>.")
                actor:send("</><b:white>[Drop]</> their <b:red>blood</> before " .. tostring(master) .. " to defile the keys.")
                if blood1 or blood2 or blood3 or blood4 or blood5 or blood6 or blood7 then
                    actor:send("</>")
                    actor:send("You have already found:")
                    if blood1 then
                        actor:send("<red>" .. tostring(objects.template(564, 0).name) .. "</>")
                    end
                    if blood2 then
                        actor:send("<red>" .. tostring(objects.template(564, 1).name) .. "</>")
                    end
                    if blood3 then
                        actor:send("<red>" .. tostring(objects.template(564, 2).name) .. "</>")
                    end
                    if blood4 then
                        actor:send("<red>" .. tostring(objects.template(564, 3).name) .. "</>")
                    end
                    if blood5 then
                        actor:send("<red>" .. tostring(objects.template(564, 4).name) .. "</>")
                    end
                    if blood6 then
                        actor:send("<red>" .. tostring(objects.template(564, 5).name) .. "</>")
                    end
                    if blood7 then
                        actor:send("<red>" .. tostring(objects.template(564, 6).name) .. "</>")
                    end
                end
                actor:send("</>")
                local total = (7 - (blood1 + blood2 + blood3 + blood4 + blood5 + blood6 + blood7))
                if total == 1 then
                    actor:send("Sacrifice the last child!")
                else
                    actor:send("Bring the blood of <red>" .. tostring(total) .. "</> more children.")
                end
                actor:send("</>")
                actor:send("If you need a new dagger, return to " .. tostring(master) .. " and say, <b:red>\"I need a new dagger\"</>.")
            elseif stage == 4 then
                actor:send("Give the spider-shaped dagger back to " .. tostring(master) .. ".")
            elseif stage == 5 then
                actor:send("Slay Larathiel and release the demon lord!")
            end
        end
    end
end
return _return_value