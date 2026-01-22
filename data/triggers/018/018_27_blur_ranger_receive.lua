-- Trigger: blur_ranger_receive
-- Zone: 18, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #1827

-- Converted from DG Script #1827: blur_ranger_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 58420 then
    if actor:get_quest_stage("blur") == 3 then
        actor.name:advance_quest("blur")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Thank you for ending his suffering.  That was a")
        self.room:send("</>truly heroic effort.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'But this test is about more than just strength.")
        self.room:send("</>The true signature of a ranger is speed.'")
        wait(2)
        self:emote("whistles a complex tune to the sky and listens.")
        wait(8)
        self.room:send("A breeze rustles the leaves of the trees.")
        wait(3)
        self:emote("smiles.")
        wait(1)
        self:command("nod")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Your true teachers will be the four winds.  I have")
        self.room:send("</>called out to them.  They have agreed to teach you the spell if you can pass")
        self.room:send("</>the test we all have passed.'")
        wait(5)
        self:say("You must best them in a race.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'The four winds are notoriously difficult to locate.")
        self.room:send("</>The North Wind blows through the frozen town of Ickle.")
        self.room:send("</>The South Wind blows around the hidden standing stones in South Caelia.")
        self.room:send("</>The East Wind blows through an enormous volcano in the sea.")
        self.room:send("</>The West Wind blows through ruins across the vast Gothra plains.'")
        wait(7)
        self.room:send(tostring(self.name) .. " says, 'You may challenge them in any order, but even if")
        self.room:send("</>you find where the winds blow, there may be additional challenges to connecting")
        self.room:send("</>with them.'")
        wait(5)
        self:command("give forgotten-kings " .. tostring(actor))
        self:say("You may need this.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Are you ready to try?'")
    elseif actor:get_quest_stage("blur") == 2 then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'It seems the Warder still roams.  Please go back and")
        self.room:send("</>destroy him.'")
    elseif actor:get_quest_stage("blur") > 3 then
        _return_value = false
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'You have already brought me " .. tostring(object.name) .. ".")
        self.room:send("</>Please, keep it.'")
    end
elseif actor:get_quest_stage("blur") == 3 then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("This is not the proper blade.")
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("I have no need for this at the moment.")
end
return _return_value