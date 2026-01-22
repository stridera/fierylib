-- Trigger: berserker_hjordis_greet
-- Zone: 364, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36408

-- Converted from DG Script #36408: berserker_hjordis_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("berserker_subclass")
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You return!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Let us discuss your <b:cyan>Wild Hunt</>!'")
elseif actor:get_quest_stage("berserker_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Will you answer the call?'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
elseif actor:get_quest_stage("berserker_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'You return!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
elseif actor:get_quest_stage("berserker_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Why are you here when you should be out hunting your prey?'")
else
    if string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- break
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'Hail and well met!'")
            actor:send(tostring(self.name) .. " claps you on the back.")
            self.room:send_except(actor, tostring(self.name) .. " claps " .. tostring(actor.name) .. " on the back.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Only the most ferocious souls find their way here.'")
            wait(2)
            self:command("peer " .. tostring(actor))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I see you could be <b:cyan>among</> our number!'")
        end
    end
end  -- auto-close block