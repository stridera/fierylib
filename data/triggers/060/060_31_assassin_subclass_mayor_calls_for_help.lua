-- Trigger: assassin_subclass_mayor_calls_for_help
-- Zone: 60, ID: 31
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #6031

-- Converted from DG Script #6031: assassin_subclass_mayor_calls_for_help
-- Original: MOB trigger, flags: FIGHT, probability: 100%
wait(0.2)
-- DG global `round`: fight rounds seen by this mob so far (unset reads as 0)
local round = globals.round or 0
-- switch on round
do
    local _sw1 = string.lower(tostring(round or ""))
    if tonumber(_sw1) == 1 then
        self.room:send(tostring(self.name) .. " cries out in surprise!")
        self.room:send(tostring(self.name) .. " shouts, 'Help!  Help!!  Someone is trying to kill me!!'")
    elseif tonumber(_sw1) == 3 then
        self.room:send("A commotion echoes from downstairs!")
        self.room:send("The guards are coming to the Mayor's rescue!")
        wait(0.2)
        self.room:send("Quick footsteps begin to approach the room!")
    elseif tonumber(_sw1) == 5 then
        self.room:send("Someone shouts, 'Quickly, rescue the Mayor!!'")
        wait(0.2)
        self.room:send("The footsteps speed up!")
    elseif tonumber(_sw1) == 8 then
        self.room:send(tostring(self.name) .. " gurgles, 'Someone help!!!'")
        wait(0.2)
        self.room:send("The sound of footsteps gets louder!")
    elseif tonumber(_sw1) == 10 then
        self.room:send(tostring(self.name) .. " gurgles, 'Hurry!  I'm dying!!!'")
        wait(0.2)
        self.room:send("Someone shouts, 'I'm coming Mr. Mayor!'")
        self.room:send("The footsteps are almost here!")
    elseif tonumber(_sw1) == 13 then
        self.room:send("The footsteps are right outside the door!")
    elseif tonumber(_sw1) == 15 then
        self.room:send("One of the City Hall guards bursts into the room!")
        self.room:send("The City Hall guard cries, 'I'll save you Mr. Mayor!!'")
        self.room:send_except(actor, "The City Hall guard leaps on " .. tostring(actor.name) .. " and drags " .. tostring(actor.himher) .. " from the building!")
        actor:send("The City Hall guard throws himself on you and breaks up the fight.")
        actor:send("You are dragged out of the building and thrown out of town!")
        -- teleport the player anywhere in the farmlands other than the fields*
        actor:teleport(get_room(80, random(1, 225)))
        wait(0.2)
        -- actor looks around
        wait(0.2)
        actor:send("The City Hall guard tells you, 'And don't you come back!'")
        globals.round = nil
        actor:fail_quest("merc_ass_thi_subclass")
        actor:send("<b:yellow>You have failed your quest!</>")
        actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
        return _return_value
    end
end
round = round + 1
globals.round = round