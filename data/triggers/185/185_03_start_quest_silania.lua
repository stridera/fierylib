-- Trigger: start_quest_silania
-- Zone: 185, ID: 3
-- Type: MOB, Flags: SPEECH
--
-- After Silania has offered the priest/paladin subclass quest (see
-- 185_02 which sets globals.use_subclass), saying yes starts the quest;
-- saying no teleports the player out (room 185,66).

local s = string.lower(speech)
if not (string.find(s, "yes") or string.find(s, "no")) then
    return true
end

local classquest = false
if string.find(actor.class, "Cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        classquest = true
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        return true
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        return true
    end
elseif string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        classquest = true
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I appreciate your virtue.  Come and see me once you've gained more experience.'")
        return true
    else
        actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
        return true
    end
end

wait(2)

if not classquest then
    return true
end

if string.find(s, "yes") then
    if actor.alignment > 349 and not actor:get_quest_stage("pri_pal_subclass") then
        if not globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'First, we must discuss your destiny.'")
        else
            actor:start_quest("pri_pal_subclass", globals.use_subclass)
            self:command("smile " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'You may check your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'It is necessary to make a quest such as this quite tough to ensure ensure you really want to do this.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I am sure you will complete the <b:cyan>quest</> though.'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good little one.'")
    end
else
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'It is a shame we have so few willing to join us these days, but I cannot compel you.  Farewell, and I hope you come to reconsider your decision sometime.'")
    wait(2)
    actor:send("Silania makes a gesture with her hand and you are blinded for a second.")
    self.room:send_except(actor, "Silania makes a gesture with her hand and " .. tostring(actor.name) .. " disappears.")
    actor:teleport(get_room(185, 66))
end

globals.use_subclass = nil
