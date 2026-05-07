-- Trigger: globe_get
-- Zone: 188, ID: 44
-- Type: OBJECT, Flags: GLOBAL, GET
-- Status: CLEAN
--
-- Original DG Script: #18844
-- Converted from DG Script #18844: globe_get
-- Original: OBJECT trigger, flags: GLOBAL, GET, probability: 100%
local _return_value = true  -- Default: allow action
local globe_key = "globe_" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id) .. "_time"
if actor:get_quest_var("quest_items:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
    if globals.owner then
        if globals.owner == actor.name then
            if not (actor:get_worn("held")) and not (actor:get_worn("wield")) and not (actor:get_worn("2hwield")) then
                local last_use = actor:get_quest_var("quest_items:" .. globe_key)
                local now = timestamp()
                local can_use = false
                if last_use then
                    if now - last_use >= 1 then
                        can_use = true
                    else
                        _return_value = false
                        self.room:send(tostring(self.shortdesc) .. " flares brightly, but then fades.")
                    end
                else
                    can_use = true
                end
                if can_use then
                    _return_value = true
                    self.room:spawn_object(self.zone_id, self.id)
                    actor:command("get globe")
                    actor:command("hold globe")
                    actor:command("use globe")
                    actor:set_quest_var("quest_items", globe_key, now)
                    world.destroy(self)
                end
            else
                _return_value = false
                actor:send("You must have your primary hand free to activate " .. tostring(self.shortdesc) .. ".")
            end
        else
            _return_value = true
            actor:send(tostring(self.shortdesc) .. ": you can't take that!")
        end
    else
        _return_value = false
    end
else
    _return_value = true
    actor:send(tostring(self.shortdesc) .. ": you can't take that!")
end
return _return_value