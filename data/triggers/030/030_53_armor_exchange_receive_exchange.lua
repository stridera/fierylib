-- Trigger: Armor Exchange receive exchange
-- Zone: 30, ID: 53
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 25 if statements
--
-- Original DG Script: #3053

-- Converted from DG Script #3053: Armor Exchange receive exchange
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local item = actor:get_quest_var("armor_exchange:armor_vnum")
if item ~= 0 then
    if item <= 55303 then
        if object.id >= 55300 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55307 then
        if object.id >= 55304 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55311 then
        if object.id >= 55308 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55315 then
        if object.id >= 55312 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55319 then
        if object.id >= 55316 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55323 then
        if object.id >= 55320 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55327 then
        if object.id >= 55324 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55331 then
        if object.id >= 55328 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55335 then
        if object.id >= 55332 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55339 then
        if object.id >= 55336 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55343 then
        if object.id >= 55340 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55347 then
        if object.id >= 55344 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55351 then
        if object.id >= 55348 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55355 then
        if object.id >= 55352 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55359 then
        if object.id >= 55356 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55363 then
        if object.id >= 55360 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55367 then
        if object.id >= 55364 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55371 then
        if object.id >= 55368 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55375 then
        if object.id >= 55372 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55379 then
        if object.id >= 55376 and object.id <=55383 then
            local found = 1
        end
    elseif item <= 55783 then
        if object.id >= 55380 and object.id <=55383 then
            local found = 1
        end
    end
    if found == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Here you are my dear!'")
        world.destroy(object)
        self.room:spawn_object(vnum_to_zone(item), vnum_to_local(item))
        self:command("give all " .. tostring(actor))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'A pleasure connecting lost things to their owners!'")
        actor:set_quest_var("armor_exchange", "armor_vnum", 0)
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses to perform the exchange.")
        wait(1)
        if object.id >= 55300 and object.id <=55383 then
            actor:send(tostring(self.name) .. " says, 'That's not rare enough!  I won't take " .. tostring(object.shortdesc) .. " for " .. "%get.obj_shortdesc[%item%]%!'")
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing I keep around here...'")
        end
    end
else
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I don't have any lost treasures for you dearie.'")
end
return _return_value