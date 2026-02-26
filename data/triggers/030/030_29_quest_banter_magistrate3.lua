-- Trigger: quest_banter_magistrate3
-- Zone: 30, ID: 29
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #3029

-- Converted from DG Script #3029: quest_banter_magistrate3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
if actor.is_player then
    wait(1)
    -- If any of the quest guys have spawned in Mystwatch don't give another totem.
    if world.count_mobiles(160, 8) > 0 or world.count_mobiles(160, 10) > 0 or world.count_mobiles(160, 11) > 0 or world.count_mobiles(160, 15) > 0 or world.count_mobiles(160, 16) > 0 or world.count_mobiles(160, 17) > 0 or world.count_mobiles(160, 18) > 0 or world.count_mobiles(160, 19) > 0 then
        self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
        actor:send(tostring(self.name) .. " says to you, 'Splendid, however, someone is currently after the Demon Lord's hide.  You will have to wait until they are finished or if they fail you can finish for them.'")
    else
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
                if not person:get_quest_stage("mystwatch_quest") then
                    person.name:start_quest("mystwatch_quest")
                    person:send("<b:white>You have begun the Mystwatch quest!</>")
                end
                actor.name:set_quest_var("mystwatch_quest", "step", "totem")
            elseif person then
                i = i + 1
            end
            a = a + 1
        end
        self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
        actor:send(tostring(self.name) .. " says to you, 'Splendid, Mielikki be praised that one valiant enough has come amongst us to help rid us of this nuisance.'")
        wait(2)
        self:command("think")
        actor:send(tostring(self.name) .. " says to you, 'Here.  Give this to that rat general in Mystwatch and it should start you on your way.'")
        self.room:spawn_object(30, 26)
        self:command("give totem " .. tostring(actor.name))
    end
end