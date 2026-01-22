-- Trigger: globe_get
-- Zone: 188, ID: 44
-- Type: OBJECT, Flags: GLOBAL, GET
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #18844

-- Converted from DG Script #18844: globe_get
-- Original: OBJECT trigger, flags: GLOBAL, GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.quest_variable[quest_items:self.vnum] then
    if owner then
        if owner == actor.name then
            if not (actor:get_worn("held")) and not (actor:get_worn("wield")) and not (actor:get_worn("2hwield")) then
                local last_use = actor.quest_variable[quest_items:globeself.vnum_time]
                local now = time.stamp
                if last_use then
                    if now - last_use >= 1 then
                        local can_use = "yes"
                    else
                        _return_value = true
                        self.room:send(tostring(self.shortdesc) .. " flares brightly, but then fades.")
                    end
                else
                    local can_use = "yes"
                end
                if can_use == "yes" then
                    _return_value = false
                    self.room:spawn_object(vnum_to_zone(self.id), vnum_to_local(self.id))
                    actor:command("get globe")
                    actor:command("hold globe")
                    actor:command("use globe")
                    actor.name:set_quest_var("quest_items", "globe%self.vnum%_time", now)
                    world.destroy(self)
                end
            else
                _return_value = true
                actor:send("You must have your primary hand free to activate " .. tostring(self.shortdesc) .. ".")
            end
        else
            _return_value = false
            actor:send(tostring(self.shortdesc) .. ": you can't take that!")
        end
    else
        _return_value = true
    end
else
    _return_value = false
    actor:send(tostring(self.shortdesc) .. ": you can't take that!")
end
return _return_value