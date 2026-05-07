-- Trigger: priest_paladin_subclass_quest_silania_status
-- Zone: 185, ID: 9
-- Type: MOB, Flags: SPEECH
--
-- Status response for the priest/paladin subclass quest: tells the
-- player where they are in the quest, or whether they are eligible.
--
-- TODO(parity): legacy DG marked this prob 0%. It must fire on speech
-- to report status, so the gate is removed; confirm with rs design
-- whether legacy intended a manual invocation path instead.

local s = string.lower(speech)
if not (string.find(s, "subclass") or string.find(s, "progress")) then
    return true
end

wait(2)

local stage = actor:get_quest_stage("pri_pal_subclass")
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You want to join the holy ranks of priests and paladins.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure you really want to do this.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
    return
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'This is your quest to join the ranks of priests and paladins.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'One of our guests made off with our most sacred bronze chalice.'")
    self:command("steam")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We have reason to believe it was a ruse by the filthy diabolists to try and weaken us.  Our Prior has offered to try and retrieve it for us, but...'")
    wait(2)
    self:command("think")
    actor:send(tostring(self.name) .. " says, 'I think perhaps that would be a bad idea and that you should find it instead.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck, your quest has begun!'")
    self:command("bow")
    return
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you found the bronze chalice the diabolists stole?'")
    return
end

-- No active quest: assess eligibility.
local check = false
if string.find(actor.class, "Cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        check = true
    end
elseif string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        check = true
    end
end

if check then
    actor:send(tostring(self.name) .. " says, 'You are not working to join the holy order.'")
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
else
    actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
end
