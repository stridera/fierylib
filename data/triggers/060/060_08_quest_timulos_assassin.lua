-- Trigger: quest_timulos_assassin
-- Zone: 60, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #6008

-- Converted from DG Script #6008: quest_timulos_assassin
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: assassin
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "assassin")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Rogue") then
    -- switch on actor.race
    -- case ADD NEW RESTRICTED RACES HERE
    -- if %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to assassin.&0
    -- halt
    -- endif
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        if actor.alignment <= -350 then
            if use_subclass then
                actor:send(tostring(self.name) .. " says, 'One moment, I'm getting someone else set up.'")
                actor:send(tostring(self.name) .. " ushers you into the corner.")
                self.room:send_except(actor, tostring(self.name) .. " ushers " .. tostring(actor.name) .. " into the corner.")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Wait there.'")
            else
                actor:send(tostring(self.name) .. " says, 'So, you wish to become an assassin do you?'")
                local use_subclass = "Ass"
                globals.use_subclass = globals.use_subclass or true
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't nearly evil enough yet.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Go kill some more people.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Really good, really innocent people.'")
        end
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
    else
        actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
    end
else
    actor:send(tostring(self.name) .. " says, 'I do not know how to train you to be one, sorry, go away.'")
end