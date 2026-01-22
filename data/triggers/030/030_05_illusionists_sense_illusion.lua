-- Trigger: Illusionists sense illusion
-- Zone: 30, ID: 5
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #3005

-- Converted from DG Script #3005: Illusionists sense illusion
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(1)
if string.find(actor.class, "Illusionist") then
    actor:send("<magenta>You sense the magic of illusion at work upon your senses.</>")
end