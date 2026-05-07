-- Trigger: GoT recall 1401
-- Zone: 14, ID: 2
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1402
--
-- Intent: When a player rubs the Eyes of Truth amulet (this object)
-- with a keyword like "truth" / "eye" / "eyes", a 1% chance per
-- attempt opens a white portal that whisks them into the Guards-of-
-- Truth hall (room 14/1). They get a teleport, a look, and a small
-- flavor sequence on both ends.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: rub
if cmd ~= "rub" then
    return true  -- Not our command
end

if arg and (string.find(arg, "truth") or string.find(arg, "eye") or string.find(arg, "eyes")) then
    actor:send("You gently rub " .. self.shortdesc)
    self.room:send_except(actor, actor.name .. " gently rubs " .. self.shortdesc)
    wait(1)
    self.room:send_except(actor, "A bright white portal appears, and draws " .. actor.name .. ", in.")
    actor:send("A white light appears and embraces you, to your very soul.")
    wait(2)
    actor:teleport(get_room(14, 1))
    actor:send("The bright lights embrace you only for a moment before setting you back into your world.")
    actor:send("The words \"Guard the Truth well\" repeat in your mind.")
    self.room:send_except(actor, "A bright white portal flashes into view as " .. actor.name .. ", steps out of it.")
    actor:send("You blink and realize you are not where you started.")
    wait(1)
    actor:command("look")
    actor:send("Huh?!?")
end
