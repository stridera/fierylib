-- Trigger: Wielding an emblazoned flint knife
-- Zone: 615, ID: 13
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #61513

-- Converted from DG Script #61513: Wielding an emblazoned flint knife
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.room == 61549 or actor.room == 61566 then
        _return_value = false
        -- If you wield the emblazoned flint knife in a room that
        -- could have webs, it gets excited and flies out of your hand.
        wait(2)
        self.room:send_except(actor, tostring(self.shortdesc) .. " suddenly wriggles, and " .. tostring(actor.name) .. " drops it!")
        actor:send(tostring(self.shortdesc) .. " suddenly wriggles, and you drop it!")
        actor:command("drop emblazoned-flint-knife")
        -- Now a drop trigger in the room will determine if some webs
        -- get cut, and so forth.
    end
end
return _return_value