-- Trigger: three_lever_pull
-- Zone: 590, ID: 18
-- Type: WORLD, Flags: GLOBAL, COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #59018
--
-- Three levers (left / center / right) must be pulled in the order chosen by 590_22 (set_levers,
-- same room). That trigger and this one share the room's DG globals: `first`, `secnd`, `last`
-- (which lever number is pulled first/second/last, 1 = left .. 3 = right), the per-step latches
-- `first_pin`, `secnd_pin`, `last_pin` (3 = done) and `first_kill` (2 = order already rolled).
-- A wrong lever shocks the puller. The final lever opens the door and clears the state so
-- 590_22 rolls a fresh order.
--
-- TODO(parity): the damage line (`actor:damage`) and the door flag change (`set_state({has_door
-- = true})`) are carried over from the earlier conversion; the original set exit flag `a`
-- (door, open) with `wdoor ... flags a`. Exercise in-game before trusting.

-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local lever = ({left = 1, center = 2, right = 3})[arg]
-- check to see if levers are pulled in right order. Legacy ran set_levers (590_22) synchronously
-- here; m_run_room_trig is queued until this trigger returns, so the order is rolled inline
-- (same permutations as 590_22) and this very pull is judged against it.
if globals.first_kill ~= 2 and lever then
    local orders = {{1, 2, 3}, {1, 3, 2}, {2, 3, 1}, {2, 1, 3}, {3, 2, 1}, {3, 1, 2}}
    local o = orders[random(1, 6)]
    globals.first, globals.secnd, globals.last = o[1], o[2], o[3]
    globals.first_kill = 2
    globals.first_pin = 1
    globals.secnd_pin = 1
    globals.last_pin = 1
end
if world.count_objects(590, 35) == 1 then
    local dmg = 0
    if actor.level <= 40 then
        dmg = (2 * actor.level) + random(1, 70)
    elseif actor.level >= 41 and actor.level <= 70 then
        dmg = (3 * actor.level) + random(1, 100)
    elseif actor.level >= 71 and actor.level <= 100 then
        dmg = (4 * actor.level) + random(1, 130)
    end
    local already = function()
        actor:send("The lever seems to have already been pulled.")
        self.room:send_except(actor, tostring(actor.name) .. " tries to pull the lever that has already been pulled.")
    end
    if not lever then
        actor:send("Pull what?")
    elseif globals.last == lever and globals.first_pin == 3 and globals.secnd_pin == 3 then
        if globals.last_pin == 3 then
            already()
        else
            actor:send("You pull the lever, which puts into motion what sounds like chains behind the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which leads to the noise of chains moving behind the door.")
            wait(0.5)
            self.room:send("*Click*")
            wait(0.5)
            self.room:send("The large stone door slowly slides open.")
            get_room(590, 55):at(function()
                self.room:send("The large stone door slowly slides open.")
            end)
            get_room(590, 56):exit("south"):set_state({has_door = true})
            get_room(590, 55):exit("north"):set_state({has_door = true})
            world.destroy(self.room:find_actor("large-silver-levers"))
            globals.first_kill = nil
            globals.last_pin = nil
            globals.secnd_pin = nil
            globals.first_pin = nil
        end
    elseif globals.secnd == lever and globals.first_pin == 3 then
        if globals.secnd_pin == 3 then
            already()
        else
            actor:send("You pull the lever, which leads to a series of loud clicks behind the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever, which causes a series of loud clicks to reverberate from the door.")
            wait(0.5)
            self.room:send("You hear something in the doors locking mechanism drop.")
            globals.secnd_pin = 3
        end
    elseif globals.first == lever then
        if globals.first_pin == 3 then
            already()
        else
            actor:send("As you pull the lever, the faint sound of gears turning echo out from the door.")
            self.room:send_except(actor, tostring(actor.name) .. " pulls the lever and the faint sound of gears turning echo from the door.")
            wait(0.5)
            self.room:send("You hear something in the doors locking mechanism drop.")
            globals.first_pin = 3
        end
    elseif lever == 1 then
        self.room:send_except(actor, tostring(actor.name) .. " reaches over and pulls the left lever.")
        actor:send("You pull the left lever.")
        self.room:send_except(actor, tostring(actor.name) .. " bends over in agony as a searing jolt of pain grasps " .. tostring(actor.object) .. " body.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("You bend over in extreme anguish as a jolt of pain tears through your body.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    elseif lever == 2 then
        self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the center lever.")
        actor:send("You pull the center lever.")
        self.room:send_except(actor, "A sudden rush of a smoky grey air blasts " .. tostring(actor.name) .. ", hitting " .. tostring(actor.object) .. " squre in the chest and knocking " .. tostring(actor.object) .. " back.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("A sudden rush of a smoky grey air comes from nowhere and plows into your chest with the force of a war hammer.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    else
        self.room:send_except(actor, tostring(actor.name) .. " reaches out and pulls the right lever.")
        actor:send("You pull the right lever.")
        self.room:send_except(actor, "Blue arcs of electricity flow out of the lever and travel up " .. tostring(actor.name) .. "'s arm, sending " .. tostring(actor.object) .. " reeling with a jolt.  (<blue>" .. tostring(dmg) .. "</>)")
        actor:send("A blue arc of electricity jumps out of the lever and travels through your body, giving you quite a jolt.  (<b:red>" .. tostring(dmg) .. "</>)")
        local damage_dealt = actor:damage(dmg)  -- type: physical
    end
else
    _return_value = true
end
return _return_value