-- Trigger: heavens_gate_starlight_status_checker
-- Zone: 133, ID: 31
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 36 if statements
--   Large script: 9547 chars
--
-- Original DG Script: #13331

-- Converted from DG Script #13331: heavens_gate_starlight_status_checker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: commune
if not (cmd == "commune") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "c" or cmd == "co" or cmd == "com" or cmd == "comm" then
    _return_value = false
    return _return_value
end
local stage = actor:get_quest_stage("heavens_gate")
if stage > 0 or actor:get_has_completed("heavens_gate") then
    actor:send("You extend your awareness to the stars above.")
    self.room:send_except(actor, tostring(actor.name) .. " begins to commune with the beam of starlight.")
    wait(2)
    if stage == 1 then
        actor:send("<b:white>You receive a vision of a silver prayer bowl brought to this cavern and <b:cyan>[put] <b:white>on the <b:cyan>[pedestal]<b:white>.</>")
    elseif stage == 2 then
        local key1 = actor:get_quest_var("heavens_gate:4005")
        local key2 = actor:get_quest_var("heavens_gate:12142")
        local key3 = actor:get_quest_var("heavens_gate:23709")
        local key4 = actor:get_quest_var("heavens_gate:47009")
        local key5 = actor:get_quest_var("heavens_gate:49008")
        local key6 = actor:get_quest_var("heavens_gate:52012")
        local key7 = actor:get_quest_var("heavens_gate:52013")
        actor:send("You receive a vision of seven keys to seven gates brought to the pedestal.")
        -- (empty room echo)
        if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
            actor:send("You have returned:")
            if key1 then
                actor:send(tostring(objects.template(40, 5).name))
            end
            if key2 then
                actor:send(tostring(objects.template(121, 42).name))
            end
            if key3 then
                actor:send(tostring(objects.template(237, 9).name))
            end
            if key4 then
                actor:send(tostring(objects.template(470, 9).name))
            end
            if key5 then
                actor:send(tostring(objects.template(490, 8).name))
            end
            if key6 then
                actor:send(tostring(objects.template(520, 12).name))
            end
            if key7 then
                actor:send(tostring(objects.template(520, 13).name))
            end
        end
        -- (empty room echo)
        actor:send("In your mind, you see images of:")
        if not key1 then
            actor:send("<b:cyan>A small skeleton key forged of night and shadow</>")
            actor:send("</>hidden deep in a twisted labyrinth.</>")
            -- (empty send to actor)
        end
        if not key2 then
            actor:send("<b:cyan>A key made from a piece of the black and pitted wood</>")
            actor:send("</>typical of trees in the Twisted Forest near Mielikki.</>")
            -- (empty send to actor)
        end
        if not key3 then
            actor:send("<b:cyan>A large, black key humming with magical energy</>")
            actor:send("</>from a twisted cruel city in a huge underground cavern.</>")
            -- (empty send to actor)
        end
        if not key4 then
            actor:send("<b:cyan>A key covered in oil</>")
            actor:send("</>kept by a long-dead caretaker in a necropolis.</>")
            -- (empty send to actor)
        end
        if not key5 then
            actor:send("<b:cyan>A rusted but well cared for key</>")
            actor:send("</>carried by an enormous griffin.</>")
            -- (empty send to actor)
        end
        if not key7 then
            actor:send("<b:cyan>A golden plated, wrought-iron key</>")
            actor:send("</>held at the gates to a desecrated city.</>")
            -- (empty send to actor)
        end
        if not key6 then
            actor:send("<b:cyan>One nearly impossible to see</>")
            actor:send("</>guarded by a fiery beast with many heads.</>")
        end
    elseif stage == 3 then
        local sealed = actor:get_quest_var("heavens_gate:sealed")
        local seal1 = actor:get_quest_var("heavens_gate:51077")
        local seal2 = actor:get_quest_var("heavens_gate:16407")
        local seal3 = actor:get_quest_var("heavens_gate:16094")
        local seal4 = actor:get_quest_var("heavens_gate:55735")
        local seal5 = actor:get_quest_var("heavens_gate:49024")
        local seal6 = actor:get_quest_var("heavens_gate:55126")
        local seal7 = actor:get_quest_var("heavens_gate:55112")
        actor:send("Visions of seven rifts in the fabric of reality which you must <b:cyan>seal</> float up in your mind.")
        if seal1 or seal2 or seal3 or seal4 or seal5 or seal6 or seal7 then
            -- (empty send to actor)
            actor:send("You have already sealed the rifts in:")
            if seal1 then
                -- Nordus
                local room = get_room("51077")
                actor:send(tostring(room.name))
            end
            if seal2 then
                -- Mystwatch demon
                local room = get_room("16407")
                actor:send(tostring(room.name))
            end
            if seal3 then
                -- Mystwatch fortress
                local room = get_room("16094")
                actor:send(tostring(room.name))
            end
            if seal4 then
                -- Black rock trail
                local room = get_room("55735")
                actor:send(tostring(room.name))
            end
            if seal5 then
                -- Griffin
                local room = get_room("49024")
                actor:send(tostring(room.name))
            end
            if seal6 then
                -- Huitzipia - war
                local room = get_room("55126")
                actor:send(tostring(room.name))
            end
            if seal7 then
                -- Xapizo - death
                local room = get_room("55112")
                actor:send(tostring(room.name))
            end
        end
        -- (empty send to actor)
        actor:send("You see visions of:")
        if not seal1 then
            actor:send("<b:cyan>An arch hidden in another plane</>")
            actor:send("</>granting demons access to an enchanted village of mutants.</>")
        end
        if not seal2 then
            -- (empty send to actor)
            actor:send("<b:cyan>An archway that delivers demons</>")
            actor:send("</>to the fortress of the dead.</>")
        end
        if not seal3 then
            -- (empty send to actor)
            actor:send("<b:cyan>A portal from a fortress of the undead</>")
            actor:send("</>to a realm of demons.</>")
        end
        if not seal4 then
            -- (empty send to actor)
            actor:send("<b:cyan>A portal from black rock</>")
            actor:send("</>to black ice.</>")
        end
        if not seal5 then
            -- (empty send to actor)
            actor:send("<b:cyan>A pool hidden under a well</>")
            actor:send("</>on an island filled with ferocious beasts.</>")
        end
        if not seal6 then
            -- (empty send to actor)
            actor:send("<b:cyan>A pool in a temple of ice and stone</>")
            actor:send("</>leading to the realm of a war god.</>")
        end
        if not seal7 then
            -- (empty send to actor)
            actor:send("<b:cyan>A pool in a temple of ice and stone</>")
            actor:send("</>leading to the realm of a death god.</>")
        end
        -- switch on sealed
        if sealed == 0 then
            _return_value = false
        elseif sealed == 1 then
            local phrase = "yamo lv"
        elseif sealed == 2 then
            local phrase = "yamo lv soeeiy"
        elseif sealed == 3 then
            local phrase = "yamo lv soeeiy vrtvln"
        elseif sealed == 4 then
            local phrase = "yamo lv soeeiy vrtvln eau okia khz"
        elseif sealed == 5 then
            local phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp"
        elseif sealed == 6 then
            local phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj"
        elseif sealed == 7 then
            local phrase = "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie"
        else
            _return_value = false
            return _return_value
        end
        if sealed then
            -- (empty send to actor)
            actor:send("Words float up in your mind: <b:cyan>" .. tostring(phrase) .. "</>")
        end
        -- (empty room echo)
        actor:send("If you need a new Key, beseech the starlight, <b:cyan>\"Grant me a new key\"</>.")
    elseif stage == 4 then
        actor:send("The starlight manifests as the heavenly raven again.")
        actor:send("This time, at last, it speaks:_")
        actor:send("<b:cyan>'I I I I am the book.  Open me prophet; read; decypher.</>")
        actor:send("<b:cyan>On you, in you, in your blood, they write, have written.</>")
        actor:send("<b:cyan>Speak it but aloud to know the path of heaven for I I I I am the final key.</>")
        actor:send("<b:cyan>I I I I have shown you visions, and through me you shall read.'</>_")
        actor:send("<yellow>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
    elseif actor:get_has_completed("heavens_gate") then
        actor:send("<b:cyan>You feel you have learned all you can from this place.</>")
    end
else
    _return_value = false
end
return _return_value