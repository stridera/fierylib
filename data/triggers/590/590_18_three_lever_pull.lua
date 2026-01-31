-- Trigger: three_lever_pull
-- Zone: 590, ID: 18
-- Type: WORLD, Flags: GLOBAL, COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 11496 chars
--
-- Original DG Script: #59018

-- Converted from DG Script #59018: three_lever_pull
-- Original: WORLD trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- check to see if levers are pulled in right order
if first_kill ~= 2 and (arg == "left" or arg == "center" or arg == "right") then
    get_room(590, 91):at(function()
        self.room:find_actor("sacred-haven-ai"):command("mat 59056 m_run_room_trig 59022")
    end)
end
if world.count_objects("59035") == 1 then
    if actor.level <=40 then
        local dmg = (2 * actor.level) +  random(1, 70)
    elseif actor.level >=41 and actor.level <=70 then
        local dmg = (3 * actor.level) +  random(1, 100)
    elseif actor.level >=71 and actor.level <=100 then
        local dmg = (4 * actor.level) +  random(1, 130)
    end
    -- switch on arg
    if last == 1 and first_pin == 3 and secnd_pin == 3 then
        if last_pin == 3 then
            if arg == "left" then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which puts into motion what sounds like chains behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which leads to the noise of chains moving behind the door.")
                wait(5)
                self.room:send("*Click*")
                wait(5)
                self.room:send("The large stone door slowly slides open.")
                get_room(590, 55):at(function()
                    self.room:send("The large stone door slowly slides open.")
                end)
                get_room(590, 56):exit("south"):set_state({has_door = true})
                get_room(590, 55):exit("north"):set_state({has_door = true})
                world.destroy(self.room:find_actor("large-silver-levers"))
                first_kill = nil
                last_pin = nil
                secnd_pin = nil
                first_pin = nil
            end
        elseif secnd == 1 and first_pin == 3 then
            if secnd_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which leads to a series of loud clicks behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which causes a series of loud clicks to reverberate from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local secnd_pin = 3
                globals.secnd_pin = globals.secnd_pin or true
            end
        elseif first == 1 then
            if first_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("As you pull the lever, the faint sound of gears turning echo out from the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever and the faint sound of gears turning echo from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local first_pin = 3
                globals.first_pin = globals.first_pin or true
            end
        else
            self.room:send_except(actor, tostring(actor.name) .. " reaches over and pulls the left lever.")
            actor:send("You pull the left lever.")
            self.room:send_except(actor, tostring(actor.name) .. " bends over in agony as a searing jolt of pain grasps " .. tostring(actor.object) .. " body.  (<blue>" .. tostring(dmg) .. "</>)")
            actor:send("You bend over in extreme anguish as a jolt of pain tears through your body.  (<b:red>" .. tostring(dmg) .. "</>)")
            local damage_dealt = actor:damage(dmg)  -- type: physical
        end
        if last == 2 and first_pin == 3 and secnd_pin == 3 then
            if last_pin == 3 then
            elseif arg == "center" then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which puts into motion what sounds like chains behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which leads to the noise of chains moving behind the door.")
                wait(5)
                self.room:send("*Click*")
                wait(5)
                self.room:send("The large stone door slowly slides open.")
                get_room(590, 55):at(function()
                    self.room:send("The large stone door slowly slides open.")
                end)
                get_room(590, 56):exit("south"):set_state({has_door = true})
                get_room(590, 55):exit("north"):set_state({has_door = true})
                world.destroy(self.room:find_actor("large-silver-levers"))
                first_kill = nil
                last_pin = nil
                secnd_pin = nil
                first_pin = nil
            end
        elseif secnd == 2 and first_pin == 3 then
            if secnd_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which leads to a series of loud clicks behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which causes a series of loud clicks to reverberate from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local secnd_pin = 3
                globals.secnd_pin = globals.secnd_pin or true
            end
        elseif first == 2 then
            if first_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("As you pull the lever, the faint sound of gears turning echo out from the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever and the faint sound of gears turning echo from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local first_pin = 3
                globals.first_pin = globals.first_pin or true
            end
        else
            self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the center lever.")
            actor:send("You pull the center lever.")
            self.room:send_except(actor, "A sudden rush of a smoky grey air blasts " .. tostring(actor.name) .. ", hitting " .. tostring(actor.object) .. " squre in the chest and knocking " .. tostring(actor.object) .. " back.  (<blue>" .. tostring(dmg) .. "</>)")
            actor:send("A sudden rush of a smoky grey air comes from nowhere and plows into your chest with the force of a war hammer.  (<b:red>" .. tostring(dmg) .. "</>)")
            local damage_dealt = actor:damage(dmg)  -- type: physical
        end
        if last == 3 and first_pin == 3 and secnd_pin == 3 then
            if last_pin == 3 then
            elseif arg == "right" then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which puts into motion what sounds like chains behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which leads to the noise of chains moving behind the door.")
                wait(5)
                self.room:send("*Click*")
                wait(5)
                self.room:send("The large stone door slowly slides open.")
                get_room(590, 55):at(function()
                    self.room:send("The large stone door slowly slides open.")
                end)
                get_room(590, 56):exit("south"):set_state({has_door = true})
                get_room(590, 55):exit("north"):set_state({has_door = true})
                world.destroy(self.room:find_actor("large-silver-levers"))
                first_kill = nil
                last_pin = nil
                secnd_pin = nil
                first_pin = nil
            end
        elseif secnd == 3 and first_pin == 3 then
            if secnd_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("You pull the lever, which leads to a series of loud clicks behind the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which causes a series of loud clicks to reverberate from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local secnd_pin = 3
                globals.secnd_pin = globals.secnd_pin or true
            end
        elseif first == 3 then
            if first_pin == 3 then
                actor:send("The lever seems to have already been pulled.")
                self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
            else
                actor:send("As you pull the lever, the faint sound of gears turning echo out from the door.")
                self.room:send_except(actor, tostring(actor.name) .. " pulls the lever and the faint sound of gears turning echo from the door.")
                wait(5)
                self.room:send("You hear something in the doors locking mechanism drop.")
                local first_pin = 3
                globals.first_pin = globals.first_pin or true
            end
        else
            self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the right lever.")
            actor:send("You pull the right lever.")
            self.room:send_except(actor, "Blue arcs of electricity flow out of the lever and travel up " .. tostring(actor.name) .. "'s arm, sending " .. tostring(actor.object) .. " reeling with a jolt.  (<blue>" .. tostring(dmg) .. "</>)")
            actor:send("A blue arc of electricity jumps out of the lever and travels through your body, giving you quite a jolt.  (<b:red>" .. tostring(dmg) .. "</>)")
            local damage_dealt = actor:damage(dmg)  -- type: physical
        end
    else
        actor:send("Pull what?")
    end
else
    _return_value = false
end
return _return_value