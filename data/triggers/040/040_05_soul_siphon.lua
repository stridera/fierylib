-- Trigger: soul siphon
-- Zone: 40, ID: 5
-- Type: OBJECT, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #4005

-- Converted from DG Script #4005: soul siphon
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
if self.worn_by then
    local actor = self.worn_by
    if actor.is_fighting then
        if count then
            local count = count + 1
            globals.count = globals.count or true
            if count == 4 then
                self.room:send("<magenta>The ring of souls <blue>glows <red>radiantly!</>")
            end
        else
            self.room:send("<magenta>The ring of souls begins <blue>glowing.</>")
            local count = 1
            globals.count = globals.count or true
        end
    else
        if count then
            if count > 100 then
                local heal = 100 * 3 + random(1, 20)
            elseif count > 50 then
                local heal = count * 4 + random(1, 20)
            elseif count > 30 then
                local heal = count * 6 + random(1, 20)
            elseif count > 20 then
                local heal = count * 8 + random(1, 20)
            elseif count > 10 then
                local heal = count * 10 + random(1, 20)
            elseif count > 3 then
                local heal = count * 11 + random(1, 20)
            else
                count = nil
                return _return_value
            end
            actor:heal(heal)
            actor:send("<magenta>Your ring of souls captures the essence of death and channels strength into you!</> (<b:green>" .. tostring(heal) .. "</>)")
            self.room:send_except(actor, "<b:magenta>" .. tostring(actor.name) .. "'s ring of souls captures the essence of death and channels strength into its master!</> (<b:green>" .. tostring(heal) .. "</>)")
            count = nil
        end
    end
end