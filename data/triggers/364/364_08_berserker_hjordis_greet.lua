-- Trigger: berserker_hjordis_greet
-- Zone: 364, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36408

-- Converted from DG Script #36408: berserker_hjordis_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
-- switch on actor:get_quest_stage("berserker_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("berserker_subclass") or ""))
    if tonumber(_sw1) == 1 then
        actor:send(tostring(self.name) .. " says, 'You return!'")
        wait(0.4)
        actor:send(tostring(self.name) .. " says, 'Let us discuss your <b:cyan>Wild Hunt</>!'")
    elseif tonumber(_sw1) == 2 then
        actor:send(tostring(self.name) .. " says, 'Will you answer the call?'")
        wait(0.4)
        actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
    elseif tonumber(_sw1) == 3 then
        actor:send(tostring(self.name) .. " says, 'You return!'")
        wait(0.4)
        actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
    elseif tonumber(_sw1) == 4 then
        actor:send(tostring(self.name) .. " says, 'Why are you here when you should be out hunting your prey?'")
    else
        if string.find(actor.class, "warrior") then
            -- TODO(parity): legacy DG had `case ADD RESTRICTED RACES HERE` left as
-- a placeholder; restricted races for berserker are still TBD.
            do
                if actor.level >= 10 and actor.level <= 25 then
                    actor:send(tostring(self.name) .. " says, 'Hail and well met!'")
                    actor:send(tostring(self.name) .. " claps you on the back.")
                    self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back.")
                    wait(1)
                    actor:send(tostring(self.name) .. " says, 'Only the most ferocious souls find their way here.'")
                    wait(2)
                    self:command("peer " .. tostring(actor.name))
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'I see you could be <b:cyan>among</> our number!'")
                end
            end
        end
    end
end
