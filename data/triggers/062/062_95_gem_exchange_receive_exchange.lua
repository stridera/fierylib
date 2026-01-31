-- Trigger: Gem Exchange receive exchange
-- Zone: 62, ID: 95
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--   Complex nesting: 25 if statements
--
-- Original DG Script: #6295

-- Converted from DG Script #6295: Gem Exchange receive exchange
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local item = actor:get_quest_var("gem_exchange:gem_vnum")
if item ~= 0 then
    if item <= 55569 then
        if object.id >= 55566 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55573 then
        if object.id >= 55570 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55577 then
        if object.id >= 55574 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55581 then
        if object.id >= 55578 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55585 then
        if object.id >= 55582 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55589 then
        if object.id >= 55586 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55593 then
        if object.id >= 55590 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55604 then
        if object.id >= 55594 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55615 then
        if object.id >= 55605 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55626 then
        if object.id >= 55616 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55637 then
        if object.id >= 55627 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55648 then
        if object.id >= 55638 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55659 then
        if object.id >= 55649 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55670 then
        if object.id >= 55660 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55681 then
        if object.id >= 55671 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55692 then
        if object.id >= 55682 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55703 then
        if object.id >= 55693 and object.id <=55751 then
            local found = 1
        end
    elseif item <= 55714 then
        if object.id >= 55704 and object.id <=55747 then
            local found = 1
        end
    elseif item <= 55725 then
        if object.id >= 55715 and object.id <=55747 then
            local found = 1
        end
    elseif item <= 55736 then
        if object.id >= 55726 and object.id <=55747 then
            local found = 1
        end
    elseif item <= 55747 then
        if object.id >= 55737 and object.id <=55747 then
            local found = 1
        end
    end
    if found == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Here you are, as requested!'")
        world.destroy(object)
        local item_zone, item_local = item // 100, item % 100
        self.room:spawn_object(item_zone, item_local)
        self:command("give all " .. tostring(actor))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'A pleasure doing business with you!'")
        actor:set_quest_var("gem_exchange", "gem_vnum", 0)
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses to perform the exchange.")
        wait(1)
        if object.id >= 55566 and object.id <=55751 then
            actor:send(tostring(self.name) .. " says, 'I'm afraid " .. tostring(object.shortdesc) .. " isn't of high enough rarity")
            actor:send("</>to exchange for " .. "%get.obj_shortdesc[%item%]%.'")
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing")
            actor:send("</>we trade around here...'")
        end
    end
else
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I don't have any exchange orders listed for you at the")
    actor:send("</>moment...'")
end
return _return_value