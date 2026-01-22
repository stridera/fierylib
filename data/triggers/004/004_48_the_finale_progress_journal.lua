-- Trigger: The Finale progress journal
-- Zone: 4, ID: 48
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #448

-- Converted from DG Script #448: The Finale progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "pippin") or string.find(arg, "theatre") or string.find(arg, "theater") or string.find(arg, "finale") then
    _return_value = false
    local stage = actor:get_quest_stage("theatre")
    actor:send("<b:green>&uThe Finale</>")
    actor:send("Defeat wild monkeys, recover keys, and help the theatre troupe perform their fiery Finale!")
    actor:send("Recommended Level: 10")
    if stage then
        actor:send("<cyan>Status: Repeatable</>")
        -- switch on stage
        if stage == 1 then
            local master = mobiles.template(43, 51).name
        elseif stage == 2 then
            local master = mobiles.template(43, 45).name
        elseif stage == 3 then
            local master = mobiles.template(43, 53).name
        elseif stage == 4 then
            local master = mobiles.template(43, 52).name
        elseif stage == 5 then
            local master = mobiles.template(43, 11).name
        elseif stage == 6 then
            local master = mobiles.template(43, 12).name
        elseif stage == 7 then
            local master = mobiles.template(43, 99).name
        end
        actor:send("Quest Master: " .. tostring(master))
        actor:send("</>")
        -- switch on stage
        if stage == 1 then
            actor:send("Get back Catherine's dressing room key from the ceiling monkeys, then bring her her eyelashes from her dressing room.")
            if not actor.quest_variable[theatre .. ":lashes"] then
                actor:send("Give Catherine her eyelashes.")
            elseif actor.quest_variable[theatre .. ":lashes"] == 1 then
                actor:send("Give Catherine her dressing room key.")
            end
        elseif stage == 2 then
            actor:send("Give Lewis his dressing room key.")
        elseif stage == 3 then
            actor:send("Give Fastrada her dressing room key.")
        elseif stage == 4 then
            local item1 = 4320
            local item2 = 4301
            actor:send("Give Charlemagne his dressing room key and his missing sash.")
            if actor:get_quest_var("theatre:sash") or actor:get_quest_var("theatre:charles") then
                actor:send("</>")
                actor:send("You have brought him:")
                if actor:get_quest_var("theatre:sash") then
                    actor:send("%get.obj_shortdesc[%item1%]%")
                end
                if actor:get_quest_var("theatre:charles") then
                    actor:send("%get.obj_shortdesc[%item2%]%")
                end
            end
            actor:send("</>")
            actor:send("You still need:")
            if not actor:get_quest_var("theatre:sash") then
                actor:send("%get.obj_shortdesc[%item1%]%")
            end
            if not actor:get_quest_var("theatre:charles") then
                actor:send("%get.obj_shortdesc[%item2%]%")
            end
        elseif stage == 5 then
            actor:send("Give the Fire Goddess her skirt.")
        elseif stage == 6 then
            actor:send("The Fire Goddess told you:")
            actor:send("We need to find our Pippin in order to perform the grand Finale.  He's somewhere out in the world, trying to find his corner of the sky.")
            actor:send("</>")
            actor:send("I want you to bring him to us.")
            actor:send("</>")
            actor:send("Take " .. tostring(objects.template(43, 18).name) .. ".")
            actor:send("</>")
            actor:send("Hold it in your hand when you find him.  He won't be able to resist the beauty of one perfect flame.")
            actor:send("</>")
            actor:send("Now, when you get him back here, <b:cyan>[order]</> him to <b:cyan>[enter]</> the Fire Box.  We've prepared and hidden it upstage center just for him.")
            actor:send("</>")
            actor:send("<b:red>Be careful not to get inside it yourself!</>")
            actor:send("</>")
            actor:send("It's only for an extraordinary person like Pippin.")
        elseif stage == 7 then
            actor:send("Lead Pippin back to the theatre and order him to get in the Fire Box.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value