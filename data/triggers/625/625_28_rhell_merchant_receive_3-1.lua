-- Trigger: Rhell Merchant receive 3-1
-- Zone: 625, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62528

-- Converted from DG Script #62528: Rhell Merchant receive 3-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after the plant, comes the thorny staff, from The Citadel of Betrayal.
if actor:get_quest_stage("ursa_quest") == 3 then
    if actor:get_quest_var("ursa_quest:choice") == 1 then
        if object.id == 11810 then
            wait(2)
            actor.name:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at " .. tostring(object.shortdesc) .. ".")
            world.destroy(object)
            wait(1)
            self:say("What an odd item to have rooted itself to.")
            self:command("chuckle")
            wait(1)
            self:say("Now, I need a particular thorny wood.  Because of it's unpleasant nature there are some unpleasant people that make staves and walking sticks out of it.")
            wait(1)
            self:say("Please find one, and bring it back here.  I have almost everything called for on these instructions.")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't it.  What I'm after right now is a plant from the Blue-Fog Trail that binds itself to just about anything.")
        end
    end
end
return _return_value