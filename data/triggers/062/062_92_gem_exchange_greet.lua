-- Trigger: Gem Exchange greet
-- Zone: 62, ID: 92
-- Type: MOB, Flags: GREET_ALL
--
-- Soltan Gem Exchange greeter. New customers get the welcome speech; returning
-- customers (gem_exchange quest stage 1) get a callback to their pending order
-- if they have one.
--
-- Original DG Script: #6292

wait(2)
if actor.is_player then
    local item = actor:get_quest_var("gem_exchange:gem_id")
    if actor:get_quest_stage("gem_exchange") == 1 then
        self:say("Welcome back!")
        self:command("bow " .. tostring(actor))
        wait(2)
        if item == 0 or item == nil then
            actor:send(tostring(self.name) .. " says, 'Tell me, what gemstone are you interested in trading for")
            actor:send("</>today?'")
        else
            -- item is the legacy 5-digit vnum (zone*100 + id) of the requested gem
            local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. item_name .. "?'")
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