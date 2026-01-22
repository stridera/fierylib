-- Trigger: heavens_gate_starlight_look
-- Zone: 133, ID: 26
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #13326

-- Converted from DG Script #13326: heavens_gate_starlight_look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
if string.find(actor.class, "Priest") and actor.level > 80 and actor:get_quest_stage("heavens_gate") == 0 then
    self.room:send_except(actor, tostring(actor.name) .. " stands completely still, staring intently at nothing.")
    wait(1)
    actor:send("<b:white>Your mind is suddenly overwhelmed by the vision of a swirling vortex of stars above the formation.</>")
    actor:send("<b:white>It opens a gateway through the heavens!</>")
    wait(4)
    actor:send("<b:white>Swirls of galaxies and flares of stars begin to meld within the vortex.</>")
    actor:send("<b:white>They form a cosmic raven, which soars down to greet you.</>")
    wait(4)
    actor:send("<b:white>In dance-like flight, it mimics a priest, bent over the rock pedestal in prayer.</>")
    actor:send("<b:white>The starlight glistens in the shape of a bowl on the rock.</>")
    wait(4)
    actor:send("<b:white>The raven finishes the dance and melds with the bowl.</>")
    actor:send("<b:white>You find yourself gazing into a bowl with the symbol of a raven outlined in silver.</>")
    actor:send("<b:white>Its wings outstretched with feathers and talons marked with thin lines.</>")
    wait(4)
    actor:send("<b:white>The bowl seems to promise ancient sacred knowledge if only it could be brought to this place!</>")
    wait(4)
    actor:send("<b:white>The raven invites you to <b:cyan>[commune] <b:white>to receive visions of your progress.</>")
    wait(2)
    actor:send("Returning to reality, you find yourself staring at the rock pedestal.")
    actor.name:start_quest("heavens_gate")
end