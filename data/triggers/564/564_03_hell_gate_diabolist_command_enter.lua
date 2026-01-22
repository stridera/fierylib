-- Trigger: hell_gate_diabolist_command_enter
-- Zone: 564, ID: 3
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #56403

-- Converted from DG Script #56403: hell_gate_diabolist_command_enter
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" then
    _return_value = false
    return _return_value
end
-- switch on arg
if string.find(actor.class, "Diabolist") and actor:get_quest_stage("hell_gate") == 0 then
    if arg == "c" or arg == "ci" or arg == "cir" or arg == "circ" or arg == "circl" or arg == "circle" then
        local priest = mobiles.template(564, 0).name
        if actor.level > 80 then
            actor:send("The circle of <red>fire</> burns hotly, enclosing you within.")
            self.room:send_except(actor, "The circle of <red>fire</> burns hotly, enclosing " .. tostring(actor.name) .. " within.")
            wait(1)
            self.room:send("A rumbling voice as deep as the pits of hell groans out of the fiery earth!")
            self.room:send("'<red>Delightful supplicants, I bid you welcome.  Open the door to Garl'lixxil and bring me to the world.  I will teach you powerful secrets so you may join me in slaughter.</>'")
            wait(5)
            self.room:send("'<red>To begin, find a dagger shaped like an arachnid.  You, " .. tostring(actor.name) .. ", shall seek it out and return here.  The other shall remain here and ensure the island is not disturbed.</>'")
            wait(4)
            self.room:send("The fires die down as the voice grows silent.")
            wait(3)
            actor:send(tostring(priest) .. " says, 'I will do my part.  I count on you to do yours.  If you need a reminder of your <b:cyan>[progress]</> you can ask me at any time.'")
            actor.name:start_quest("hell_gate")
        else
            actor:send("Your lack of experience prevents you from entering the circle of flames!")
            actor:send("</>")
            actor:send(tostring(priest) .. " says, 'Your will is strong but you lack knowledge.  Return after you have grown more.'")
        end
    else
        actor:send("There is no " .. tostring(arg) .. " here.")
    end
else
    _return_value = false
    return _return_value
end