-- Trigger: torch hold
-- Zone: 43, ID: 42
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #4342

-- Converted from DG Script #4342: torch hold
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local room = actor.room
if room:find_actor("pippin") then
    local leader
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local member = actor.group_member[a]
        if member and member.room == room then
            if member:get_quest_stage("theatre") == 6 then
                member:advance_quest("theatre")
                member:send("<b:white>You have advanced the quest!</>")
                leader = member
            elseif member:get_quest_stage("theatre") >= 6 then
                if not leader then
                    leader = member
                end
            end
        elseif member then
            i = i + 1
        end
        a = a + 1
    end
    if leader then
        room:find_actor("pippin"):set_flag("sentinel", true)
        wait(1)
        room:send("The <red>F<b:yellow>i<b:red>r</><red>e G<b:yellow>o<b:red>dd</><b:yellow>e</><red>ss<b:red>'s</> Torch erupts to life and spews a shower of sparks and flame!")
        wait(1)
        room:send("Pippin watches the flames, completely entranced.")
        if actor:get_quest_stage("theatre") > 6 then
            room:find_actor("pippin"):follow(actor.name)
            room:find_actor("pippin"):command("consent " .. tostring(actor.name))
        else
            room:find_actor("pippin"):follow(leader.name)
            room:find_actor("pippin"):command("consent " .. tostring(leader.name))
        end
    end
end