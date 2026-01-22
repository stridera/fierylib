-- Trigger: Giving a wisp heart to someone
-- Zone: 615, ID: 11
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #61511

-- Converted from DG Script #61511: Giving a wisp heart to someone
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if heart_inplace == 1 then
    -- Note: the mud appears to prevent this trigger from being activated
    -- again when it's in progress, so this really does nothing, but I've
    -- left it here just in case.
    _return_value = false
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'Hang on a minute!'</>")
else
    _return_value = true
    local heart_inplace = 1
    globals.heart_inplace = globals.heart_inplace or true
    wait(2)
    self:emote("looks over " .. tostring(object.shortdesc) .. " carefully.")
    wait(3)
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'Ok, let's see if this does any good.'</>")
    wait(3)
    self:emote("flutters up to the top of the menhir and puts " .. tostring(object.shortdesc) .. " in the depression.")
    if object.id == 61504 then
        self:destroy_item("fiery-wisp-heart")
        run_room_trigger(61512)
    else
        wait(5)
        self:emote("peers thoughtfully at " .. tostring(object.shortdesc) .. ", with her tiny chin held between her thumb and forefinger.")
        wait(3)
        self:emote("zips up to the top of the menhir and yanks " .. tostring(object.shortdesc) .. " out of the hole.")
        wait(2)
        self:say("I guess that wasn't it!")
        self:command("drop " .. tostring(object.name))
    end
    local heart_inplace = 0
    globals.heart_inplace = globals.heart_inplace or true
end
return _return_value