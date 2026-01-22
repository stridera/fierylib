-- Trigger: Block player exit
-- Zone: 535, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #53500

-- Converted from DG Script #53500: Block player exit
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 100 then
        _return_value = false
        actor:send("<blue>A mysterious powerful force pushes you back.</>")
    else
        _return_value = true
        actor:send("<blue>The room you are entering is part of the past elven tower illusion.</>")
        actor:send("<blue>It should not be reachable by any player. Look BUILDNOTE for more info.</>")
    end
end
return _return_value