-- Trigger: drag the handcart
-- Zone: 87, ID: 2
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #8702

-- Converted from DG Script #8702: drag the handcart
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(1)
if string.find(arg, "cart") or string.find(arg, "wagon") then
    actor:send("The handcart creaks along behind you.")
    self.room:send_except(actor, "The handcart creaks along behind " .. tostring(actor.name) .. ".")
    if actor.room == 8711 then
        wait(1)
        self.room:find_actor("blacksmith"):command("blink " .. tostring(actor.name))
        self.room:find_actor("blacksmith"):emote("rubs his eyes in disbelief.")
        actor.name:send("The blacksmith says, 'Oh it's you, you found the handcart, thank the gods!'")
        wait(1)
        self.room:find_actor("blacksmith"):spawn_object(87, 0)
        actor.name:send("The blacksmith says, 'I must reward such heroism, and I know just the thing.'")
        self.room:find_actor("blacksmith"):command("give axe " .. tostring(actor.name))
        self.room:find_actor("blacksmith"):emote("moves the handcart into a bay near his tools.")
        world.destroy(self)
    elseif random(1, 6) == 3 then
        actor:send("<green>You hear a rustling in the grass nearby.</>")
        wait(1)
        self.room:spawn_mobile(87, 13)
        self.room:find_actor("bandit"):command("kill %actor%")
        self.room:spawn_mobile(87, 13)
        self.room:find_actor("bandit"):command("kill %actor%")
    end
end
return _return_value