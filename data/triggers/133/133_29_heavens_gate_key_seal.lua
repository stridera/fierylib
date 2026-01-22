-- Trigger: heavens_gate_key_seal
-- Zone: 133, ID: 29
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #13329

-- Converted from DG Script #13329: heavens_gate_key_seal
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: seal
if not (cmd == "seal") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "rift") or string.find(arg, "portal") or string.find(arg, "pool") or string.find(arg, "arch") then
    local seal = actor:get_quest_var("heavens_gate:sealed")
    if self.room == 51077 or self.room == 16407 or self.room == 16094 or self.room == 55735 or self.room == 49024 or self.room == 55126 or self.room == 55112 then
        if actor.quest_variable[heavens_gate:self.room] then
            actor:send("You have already sealed this anomaly.")
        else
            if actor:get_quest_stage("heavens_gate") == 3 then
                actor.name:set_quest_var("heavens_gate", "%self.room%", 1)
                actor:send("You begin to chant...")
                self.room:send_except(actor, tostring(actor.name) .. " begins to chant...")
                actor:send("The power of the heavens courses through " .. tostring(self.shortdesc) .. ".")
                wait(2)
                self.room:send(tostring(self.shortdesc) .. " begins to burn with a fierce energy!")
                wait(2)
                self.room:send("Brilliant rays of light shoot out of " .. tostring(self.shortdesc) .. ", sealing the dimensional portal!")
                if self.room == 51077 then
                    world.destroy(self.room:find_object("arch"))
                    self.room:teleport_all(get_room(510, 3))
                elseif self.room == 16407 then
                    world.destroy(self.room:find_object("arch"))
                elseif self.room == 49024 or self.room == 55126 or self.room == 55112 then
                    world.destroy(self.room:find_object("energy"))
                elseif self.room == 16094 or self.room == 55735 then
                    world.destroy(self.room:find_object("portal"))
                end
                local sealed = seal + 1
                actor.name:set_quest_var("heavens_gate", "sealed", sealed)
                wait(1)
                -- switch on sealed
                if sealed == 1 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv</>")
                elseif sealed == 2 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy</>")
                elseif sealed == 3 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy vrtvln</>")
                elseif sealed == 4 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy vrtvln eau okia khz</>")
                elseif sealed == 5 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy vrtvln eau okia khz lrrvzryp</>")
                elseif sealed == 6 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj</>")
                elseif sealed == 7 then
                    actor:send("As the rift collapses, words float up in your mind:")
                    actor:send("<b:white>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
                    wait(2)
                    local room = get_room("13358")
                    actor:send("<b:white>A vision of starlight beckons you back to " .. tostring(room.name) .. ".</>")
                    actor.name:advance_quest("heavens_gate")
                else
                    _return_value = false
                end
            end
        end
    else
        actor:send("There are no active rifts here to seal.")
    end
else
    _return_value = false
end
return _return_value