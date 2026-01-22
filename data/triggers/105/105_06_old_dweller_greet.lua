-- Trigger: Old_Dweller_greet
-- Zone: 105, ID: 6
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #10506

-- Converted from DG Script #10506: Old_Dweller_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- A level checking greet trig.
wait(1)
actor:send("</><b:cyan>The old man tells you, '</>Ahh Welcome my friend.<b:cyan>'</>")
if actor.level > 25 then
    if actor.level < 71 then
        actor:send("</><b:cyan>The old man tells you, '</>This is just a happy little forest.<b:cyan>'</>")
        actor:send("</><b:cyan>The old man tells you, '</>Not worth such a mighty one as you even entering.<b:cyan>'</>")
        actor:send("</><b:cyan>The old man tells you, '</>Please leave.<b:cyan>'</>")
    end
end
if actor.level > 70 then
    self:command("bow " .. tostring(actor.name))
    actor:send("</><b:cyan>The old man says 'It's a pleasure " .. tostring(actor.name) .. ". Always welcome into my home.'")
end
if actor.level > 5 then
    if actor.level < 26 then
        actor:send("</><b:cyan>The old man tells you, '</>Hmm You are welcome here, but please don't hurt anything within.<b:cyan>'</>")
    end
end
if actor.level < 6 then
    actor:send("</><b:cyan>The old man tells you, '</>Hello there! Welcome to my forest.<b:cyan>'</>")
    actor:send("</><b:cyan>The old man tells you, '</>Its a beautiful, safe little place that I call home.<b:cyan>'</>")
end