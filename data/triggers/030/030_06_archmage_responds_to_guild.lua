-- Trigger: Archmage responds to 'guild'
-- Zone: 30, ID: 6
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3006

-- Converted from DG Script #3006: Archmage responds to 'guild'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "Sorcerer") then
    self:command("smirk")
    wait(3)
    self:command("ruffle " .. tostring(actor.name))
elseif string.find(actor.class, "Cryomancer") or string.find(actor.class, "Pyromancer") then
    self:say("Silly bun!  It's right outside!")
    wait(3)
    self:command("pat " .. tostring(actor.name))
elseif string.find(actor.class, "Necromancer") then
    self:say("Why, you're looking for creepy old Asiri!")
    wait(2)
    self:command("nod")
    wait(3)
    self:say("I suppose he's around here somewhere.  Somewhere creepy!  I don't really know.")
elseif string.find(actor.class, "Illusionist") then
    self:say("Oh dear.  You're asking the wrong spellcaster.  You illusionists, so good at hiding.")
    wait(4)
    self:say("But there is one thing.  Old Eamus - Ermie?  What was his name?")
    wait(3)
    self:command("ponder")
    wait(3)
    self:say("Well anyway, he'd always head to the bank after tea.  But he didn't go into the bank.")
    wait(4)
    self:say("Come to think of it, you illusionists are always sneaking off to the bank.   Or not.")
    self:say("Oh, I'm so confused!")
else
    self:command("sigh")
    wait(3)
    self:say("I'm so sorry, dearie, I've no earthly idea where your guild is.")
end