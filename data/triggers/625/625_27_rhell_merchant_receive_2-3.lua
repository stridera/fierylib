-- Trigger: Rhell Merchant receive 2-3
-- Zone: 625, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62527

-- Converted from DG Script #62527: Rhell Merchant receive 2-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: ring of stolen life is returned, merchant asks for the golden druidstaff
if actor:get_quest_stage("ursa_quest") == 2 then
    if actor:get_quest_var("ursa_quest:choice") == 3 then
        if object.id == 12538 then
            wait(2)
            world.destroy(object)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at the ring.")
            self:say("Incredible!  I can feel it's magic working!")
            wait(2)
            self:say("Now I need the... gothen droolstall?  I can't read his chicken scratch!  But he says it's in the Highlands, with \"their\" leader.")
            wait(1)
            self:command("blink")
            wait(2)
            -- Orphaned text: Who's leader?!
            wait(1)
            self:command("grumble")
            self:say("I guess you'll just have to search the Highlands.  Let me know when you figure out what the hermit meant.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I don't think this is the ring...")
        end
    end
end
return _return_value