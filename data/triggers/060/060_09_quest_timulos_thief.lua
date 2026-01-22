-- Trigger: quest_timulos_thief
-- Zone: 60, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6009

-- Converted from DG Script #6009: quest_timulos_thief
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: thief
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "thief")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to thief.&0
    -- halt
    -- endif
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if use_subclass then
            actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
            actor:send(tostring(self.name) .. " ushers you into the corner.")
            self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Wait there.'")
        else
            actor:send(tostring(self.name) .. " says, 'So, you wish to become a thief do you?'")
            local use_subclass = "Thi"
            globals.use_subclass = globals.use_subclass or true
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you too subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end