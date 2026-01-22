-- Trigger: hold_good_parchment
-- Zone: 481, ID: 4
-- Type: OBJECT, Flags: WEAR
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #48104

-- Converted from DG Script #48104: hold_good_parchment
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor.id == -1 then
    wait(5)
    actor:send("You feel a slight tickling sensation as the parchment draws strength from you to activate.")
    actor:damage(20)  -- type: physical
    actor:send("You gasp in surprise and drop the paper.")
    self.room:send_except(actor, tostring(actor.name) .. " gasps in surprise and drops the paper.")
    actor:command("rem parchment-paper")
    actor:command("drop parchment-paper")
    wait(2)
    self.room:send("The parchment glows more and more brightly until you almost have to shield your eyes.")
    if actor.room == 48197 then
        local room = self.room
        if room:get_people("48127") then
            self.room:find_actor("rock-monster"):say("I can feel the magic working!")
            local stage = 5
            local person = actor
            local i = person.group_size
            if i then
                local a = 1
            else
                local a = 0
            end
            while i >= a do
                local person = actor.group_member[a]
                if person.room == self.room then
                    if person:get_quest_stage("fieryisle_quest") == "stage" then
                        person.name:advance_quest("fieryisle_quest")
                        person:send("<b:white>You have advanced your quest!</>")
                    end
                elseif person and person.id == -1 then
                    local i = i + 1
                end
                local a = a + 1
            end
        end
    end
    wait(2)
    self.room:send("The parchment suddenly stops glowing.")
end