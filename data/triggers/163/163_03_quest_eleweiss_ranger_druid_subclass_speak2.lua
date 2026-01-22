-- Trigger: quest_eleweiss_ranger_druid_subclass_speak2
-- Zone: 163, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #16303

-- Converted from DG Script #16303: quest_eleweiss_ranger_druid_subclass_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes? yes! no no? no!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?") or string.find(string.lower(speech), "yes!") or string.find(string.lower(speech), "no") or string.find(string.lower(speech), "no?") or string.find(string.lower(speech), "no!")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("ran_dru_subclass") == 0 then
    if string.find(actor.class, "Cleric") then
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 35
        -- msend %actor% &1Your race may not subclass to druid.&0
        -- halt
        -- endif
        -- break
        if actor.level >= 10 and actor.level <= 35 then
            local classquest = "yes"
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
        elseif actor.level > 35 then
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    elseif string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD NEW RESTRICTED RACES HERE
        -- if %actor.level% >= 10 && %actor.level% <= 25
        -- msend %actor% &1Your race may not subclass to ranger.&0
        -- halt
        -- endif
        -- break
        if actor.level >= 10 and actor.level <= 25 then
            local classquest = "yes"
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
        elseif actor.level > 25 then
            actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
        end
    end
end
wait(2)
if classquest == "yes" then
    if string.find(speech, "yes") then
        if not use_subclass then
            actor:send(tostring(self.name) .. " says, 'I cannot help until we talk about the ways of the woods.'")
            return _return_value
        end
        actor.name:start_quest("ran_dru_subclass", use_subclass)
        actor:send(tostring(self.name) .. " says, 'Only the most dedicated to the forests shall complete the <b:cyan>quest</> I set upon you.  You may inquire about your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
    else
        actor:send(tostring(self.name) .. " says, 'Leave my sight, you tire me.'")
        self:command("wave " .. tostring(actor.name))
        actor:send("Eleweiss calls upon the air and moves you away.")
        self.room:send_except(actor, "Eleweiss removes " .. tostring(actor.name) .. " from his presence.")
        actor:teleport(get_room(163, 74))
    end
    use_subclass = nil
end