-- Trigger: torch hold
-- Zone: 43, ID: 42
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #4342

-- Converted from DG Script #4342: torch hold
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local room = actor.room
if room:get_people("4312") then
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == "room" then
            if person:get_quest_stage("theatre") == 6 then
                person:advance_quest("theatre")
                person:send("<b:white>You have advanced the quest!</>")
                local leader = person
            elseif person:get_quest_stage("theatre") >= 6 then
                if not leader then
                    local leader = person
                end
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    if leader then
        self.room:find_actor("pippin"):command("mmobflag pippin sentinel on")
        wait(1)
        self.room:send("The <red>F<b:yellow>i<b:red>r</><red>e G<b:yellow>o<b:red>dd</><b:yellow>e</><red>ss<b:red>'s</> Torch erupts to life and spews a shower of sparks and flame!")
        wait(1)
        self.room:send("Pippin watches the flames, completely entranced.")
        if actor:get_quest_stage("theatre") > 6 then
            self.room:find_actor("pippin"):follow(actor.name)
            self.room:find_actor("pippin"):command("consent " .. tostring(actor.name))
        else
            self.room:find_actor("pippin"):follow(leader.name)
            self.room:find_actor("pippin"):command("consent " .. tostring(leader.name))
        end
    end
end