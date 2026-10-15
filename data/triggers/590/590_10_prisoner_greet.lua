-- Trigger: prisoner_greet
-- Zone: 590, ID: 10
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #59010

-- Converted from DG Script #59010: prisoner_greet
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 100%
wait(0.4)
if actor:get_quest_stage("sacred_haven") >= 2 and actor.is_player and actor.level < 100 then
    self:command("look " .. tostring(actor.name))
    wait(0.4)
    self:command("consider " .. tostring(actor.name))
    wait(0.7)
    self:whisper(actor.name, "Did my dark friend send you?")
else
    if actor.level < 100 and actor.is_player then
        wait(0.5)
        local rndm = random(1, 10)
        -- switch on rndm
        do
            local _sw1 = string.lower(tostring(rndm or ""))
            if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 or tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                self.room:send_except(self, tostring(self.name) .. " quietly mumbles, 'Please, don't hurt me.'")
            elseif tonumber(_sw1) == 5 or tonumber(_sw1) == 6 or tonumber(_sw1) == 7 then
                self:command("groan")
            else
                self.room:send_except(actor, tostring(self.name) .. " pleads with " .. tostring(actor.name) .. " in hopes he will spare his life.")
                actor:send(tostring(self.name) .. " pleads with you to spare him his life.")
            end
        end
    end
end