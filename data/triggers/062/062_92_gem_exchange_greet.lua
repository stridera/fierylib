-- Trigger: Gem Exchange greet
-- Zone: 62, ID: 92
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #6292

-- Converted from DG Script #6292: Gem Exchange greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.id == -1 then
    local item = actor:get_quest_var("gem_exchange:gem_vnum")
    if actor:get_quest_stage("gem_exchange") == 1 then
        self:say("Welcome back!")
        self:command("bow " .. tostring(actor))
        wait(2)
        if item == 0 then
            actor:send(tostring(self.name) .. " says, 'Tell me, what gemstone are you interested in trading for")
            actor:send("</>today?'")
        else
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. "%get.obj_shortdesc[%item%]%?'")
        end
    else
        self:say("Greetings!  Welcome to the Soltan Gem Exchange!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'We specialize in exchanging your less useful gemstones")
        self.room:send("</>for ones you might need.  Our reserves are fully stocked.  All you have to do")
        self.room:send("</>is tell us what kind of gem you're looking for.'")
        wait(4)
        self:say("So what can I help you find today?")
    end
end