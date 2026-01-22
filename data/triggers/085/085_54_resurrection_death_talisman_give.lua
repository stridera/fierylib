-- Trigger: Resurrection Death Talisman Give
-- Zone: 85, ID: 54
-- Type: OBJECT, Flags: GIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 5156 chars
--
-- Original DG Script: #8554

-- Converted from DG Script #8554: Resurrection Death Talisman Give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- As mobs are handed this object, they are recorded on the object itself as a global,
-- Then when it's turned in to Norisent, he checks the object for the appropriate global variables.
-- 
-- If the item has been assigned to a quester, it does its tricks, otherwise it skips to the bottom.
-- switch on victim.id
if actor:get_quest_stage("resurrection_quest") > 10 then
    if victim.id == 8550 then
        self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " bursts into flame and is gone.")
        world.destroy(self)
        return _return_value
    end
    -- switch on actor:get_quest_stage("resurrection_quest")
    if not actor:get_quest_var("resurrection_quest:4003") then
        if actor:get_quest_stage("resurrection_quest") == 4 then
            victim:say("You have not banished Lajon's Soul.")
        elseif actor:get_quest_var("resurrection_quest:4004") == 0 then
            victim:say("You have not destroyed Lajon's Corruption.")
        elseif actor:get_quest_var("resurrection_quest:4016") == 0 then
            self.room:send(tostring(victim.name) .. " says, 'You must still stop the one responsible, the Tres Keeper, and return his ring of souls.'")
        else
            actor:advance_quest("resurrection_quest")
            victim:say("Well done.  Now the ring?")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 5 then
        victim:say("I need to have that ring.")
        if actor:get_quest_var("resurrection_quest:53411") < 2 then
        elseif actor:get_quest_stage("resurrection_quest") == 6 then
            victim:say("You have not yet removed enough of the Xeg-Yi from this realm.")
        elseif actor:get_quest_var("resurrection_quest:53308") == 0 then
            self.room:send(tostring(victim.name) .. " says, 'Aelfric is still out there, with the white robes.  Go finish the job!'")
        else
            actor:advance_quest("resurrection_quest")
            victim:say("Well done.  Now the robes?")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 7 then
        victim:say("Before we may continue, I must have the dragon robes.")
        if actor:get_quest_var("resurrection_quest:53001") == 0 then
        elseif actor:get_quest_stage("resurrection_quest") == 8 then
            victim:say("The spectral man is still out there.  Why are you here?")
        elseif actor:get_quest_var("resurrection_quest:51005") == 0 then
            victim:say("The poor man's bloody remains must be dispelled.  Go now!")
        elseif actor:get_quest_var("resurrection_quest:51014") == 0 then
            self.room:send(tostring(victim.name) .. " says, 'Go stop Luchiaans, and bring the source of power before he finds it.'")
        else
            actor:advance_quest("resurrection_quest")
            self.room:send(tostring(victim.name) .. " says, 'Excellent.  And the object of power, do you have it?  Give it to me.'")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 9 then
        victim:say("Luchiaans' object of power, do you have it?  Give it to me.")
        if actor:get_quest_var("resurrection_quest:52015") == 0 then
        elseif actor:get_quest_stage("resurrection_quest") == 10 then
            victim:say("The weaponsmith's spirit still dwells.  Go set her free.")
        elseif actor:get_quest_var("resurrection_quest:52003") == 0 then
            self.room:send(tostring(victim.name) .. " says, 'The crazed mage must be destroyed.  Go, end this.  Return with his ring.'")
        else
            actor:advance_quest("resurrection_quest")
            self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " vanishes into flames, the smoke drifting into " .. tostring(victim.name) .. "'s nostrils.")
            wait(1)
            self.room:send(tostring(victim.name) .. " says, 'We are nearly finished.  Do you have the mage's artifact of longevity?'")
            world.destroy(self.room:find_object("self"))
            return _return_value
        end
    else
        victim:emote("briskly refuses.")
        victim:say("I don't want this from you.  Do not lose that talisman.")
    end
    _return_value = false
    victim:emote("returns the death talisman to you.")
    return _return_value
    actor:set_quest_var("resurrection_quest", "%victim.vnum%", 1)
    if actor:get_quest_var("resurrection_quest:53411") then
        local count = actor:get_quest_var("resurrection_quest:53411") + 1
        actor:set_quest_var("resurrection_quest", "%victim.vnum%", count)
    else
        actor:set_quest_var("resurrection_quest", "%victim.vnum%", 1)
    end
    return _return_value
    wait(1)
    self.room:send(tostring(victim.name) .. " feels compelled by " .. tostring(self.shortdesc) .. ".")
    victim:command("hold " .. tostring(self))
    victim:command("wear " .. tostring(self) .. " neck")
end  -- auto-close block
return _return_value