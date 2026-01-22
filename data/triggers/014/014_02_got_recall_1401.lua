-- Trigger: GoT recall 1401
-- Zone: 14, ID: 2
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1402

-- Converted from DG Script #1402: GoT recall 1401
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: rub
if not (cmd == "rub") then
    return true  -- Not our command
end
if string.find(arg, "truth") or string.find(arg, "eye") or string.find(arg, "eyes") then
    actor:send("You gently rub " .. tostring(self.shortdesc))
    self.room:send_except(actor, tostring(actor.name) .. " gently rubs " .. tostring(self.shortdesc))
    wait(1)
    self.room:send_except(actor, "A bright white portal appears, and draws " .. tostring(actor.name) .. ", in.")
    actor:send("A white light appears and embraces you, to your very soul.")
    wait(2)
    actor:teleport(get_room(14, 1))
    actor:send("The bright lights embrace you only for a moment before setting you back into your world.")
    actor:send("The words \"Guard the Truth well\" repeat in your mind.")
    self.room:send_except(actor, "A bright white portal flashes into view as " .. tostring(actor.name) .. ", steps out of it.")
    actor:send("You blink and realize you are not where you started.")
    wait(1)
    actor:command("look")
    actor:send("Huh?!?")
end