-- Trigger: Resurrection Death Talisman Give
-- Zone: 85, ID: 54
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN (reviewed)
--
-- Original DG Script: #8554

-- Converted from DG Script #8554: Resurrection Death Talisman Give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- As mobs are handed this object, they are recorded on the object itself as a global,
-- Then when it's turned in to Norisent, he checks the object for the appropriate global variables.
--
-- If the item has been assigned to a quester, it does its tricks, otherwise it skips to the bottom.

-- Check if actor is on the resurrection quest
if actor:get_quest_stage("resurrection_quest") <= 10 then
    -- Track that this mob received the talisman
    local mob_vnum = tostring(victim.vnum)
    if actor:get_quest_var("resurrection_quest:" .. mob_vnum) then
        local count = actor:get_quest_var("resurrection_quest:" .. mob_vnum) + 1
        actor:set_quest_var("resurrection_quest", mob_vnum, count)
    else
        actor:set_quest_var("resurrection_quest", mob_vnum, 1)
    end
    wait(1)
    self.room:send(tostring(victim.name) .. " feels compelled by " .. tostring(self.shortdesc) .. ".")
    victim:command("hold " .. tostring(self.name))
    victim:command("wear " .. tostring(self.name) .. " neck")
    return _return_value
end

-- switch on victim.id - Norisent is mob 8550
if victim.vnum == 8550 then
    self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " bursts into flame and is gone.")
    world.destroy(self)
    return _return_value
end

-- switch on actor:get_quest_stage("resurrection_quest")
local stage = actor:get_quest_stage("resurrection_quest")

if stage == 4 then
    if not actor:get_quest_var("resurrection_quest:4003") then
        victim:say("You have not banished Lajon's Soul.")
    elseif not actor:get_quest_var("resurrection_quest:4004") then
        victim:say("You have not destroyed Lajon's Corruption.")
    elseif not actor:get_quest_var("resurrection_quest:4016") then
        self.room:send(tostring(victim.name) .. " says, 'You must still stop the one responsible, the Tres Keeper, and return his ring of souls.'")
    else
        actor:advance_quest("resurrection_quest")
        victim:say("Well done.  Now the ring?")
    end
elseif stage == 5 then
    victim:say("I need to have that ring.")
elseif stage == 6 then
    if not actor:get_quest_var("resurrection_quest:53411") or actor:get_quest_var("resurrection_quest:53411") < 2 then
        victim:say("You have not yet removed enough of the Xeg-Yi from this realm.")
    elseif not actor:get_quest_var("resurrection_quest:53308") then
        self.room:send(tostring(victim.name) .. " says, 'Aelfric is still out there, with the white robes.  Go finish the job!'")
    else
        actor:advance_quest("resurrection_quest")
        victim:say("Well done.  Now the robes?")
    end
elseif stage == 7 then
    victim:say("Before we may continue, I must have the dragon robes.")
elseif stage == 8 then
    if not actor:get_quest_var("resurrection_quest:53001") then
        victim:say("The spectral man is still out there.  Why are you here?")
    elseif not actor:get_quest_var("resurrection_quest:51005") then
        victim:say("The poor man's bloody remains must be dispelled.  Go now!")
    elseif not actor:get_quest_var("resurrection_quest:51014") then
        self.room:send(tostring(victim.name) .. " says, 'Go stop Luchiaans, and bring the source of power before he finds it.'")
    else
        actor:advance_quest("resurrection_quest")
        self.room:send(tostring(victim.name) .. " says, 'Excellent.  And the object of power, do you have it?  Give it to me.'")
    end
elseif stage == 9 then
    victim:say("Luchiaans' object of power, do you have it?  Give it to me.")
elseif stage == 10 then
    if not actor:get_quest_var("resurrection_quest:52015") then
        victim:say("The weaponsmith's spirit still dwells.  Go set her free.")
    elseif not actor:get_quest_var("resurrection_quest:52003") then
        self.room:send(tostring(victim.name) .. " says, 'The crazed mage must be destroyed.  Go, end this.  Return with his ring.'")
    else
        actor:advance_quest("resurrection_quest")
        self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " vanishes into flames, the smoke drifting into " .. tostring(victim.name) .. "'s nostrils.")
        wait(1)
        self.room:send(tostring(victim.name) .. " says, 'We are nearly finished.  Do you have the mage's artifact of longevity?'")
        world.destroy(self)
        return _return_value
    end
else
    victim:emote("briskly refuses.")
    victim:say("I don't want this from you.  Do not lose that talisman.")
end

_return_value = false
victim:emote("returns the death talisman to you.")
return _return_value
