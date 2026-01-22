-- Trigger: Rogue Cloak Progress
-- Zone: 53, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 8172 chars
--
-- Original DG Script: #5330

-- Converted from DG Script #5330: Rogue Cloak Progress
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
actor:send("<b:green>Treasure Hunters</>")
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif not actor:get_quest_stage("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
elseif actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("treasure_hunter")
        if actor:get_quest_stage("treasure_hunter") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
        elseif actor:get_quest_stage("treasure_hunter") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
        elseif actor:get_quest_stage("treasure_hunter") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
        elseif actor:get_quest_stage("treasure_hunter") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
        elseif actor:get_quest_stage("treasure_hunter") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
        elseif actor:get_quest_stage("treasure_hunter") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
        elseif actor:get_quest_stage("treasure_hunter") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
        elseif actor:get_quest_stage("treasure_hunter") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
        elseif actor:get_quest_stage("treasure_hunter") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
        elseif actor:get_quest_stage("treasure_hunter") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
end
if actor.class == "Rogue" or actor.class == "Bard" or actor.class == "Thief" then
    actor:send("</>")
    actor:send("<b:green>Cloak and Shadow</>")
    local huntstage = actor:get_quest_stage("treasure_hunter")
    local cloakstage = actor:get_quest_stage("rogue_cloak")
    local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
    local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
    local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
    local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for an promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (cloakstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
        return _return_value
    end
    if cloakstage == 0 then
        self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
        return _return_value
    elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Find some more treasures and then we can talk.'")
        return _return_value
    end
    -- switch on cloakstage
    if cloakstage == 1 then
        local cloak = 58801
        local gem = 55585
        local place = "A Storage Room"
        local hint = "in the house on the hill."
    elseif cloakstage == 2 then
        local cloak = 17307
        local gem = 55593
        local place = "A Small Alcove"
        local hint = "in the holy library."
    elseif cloakstage == 3 then
        local cloak = 10308
        local gem = 55619
        local place = "either Treasure Room"
        local hint = "in the paladin fortress."
    elseif cloakstage == 4 then
        local cloak = 12325
        local gem = 55659
        local place = "The Treasure Room"
        local hint = "beyond the Tower in the Wastes."
    elseif cloakstage == 5 then
        local cloak = 43022
        local gem = 55663
        local place = "Treasury"
        local hint = "in the ghostly fortress."
    elseif cloakstage == 6 then
        local cloak = 23810
        local gem = 55674
        local place = "either Treasure Room with a chest"
        local hint = "lost in the sands."
    elseif cloakstage == 7 then
        local cloak = 51013
        local gem = 55714
        local place = "Mesmeriz's Secret Treasure Room"
        local hint = "hidden deep underground."
    elseif cloakstage == 8 then
        local cloak = 58410
        local gem = 55740
        local place = "Treasure Room"
        local hint = "sunken in the swamp."
    elseif cloakstage == 9 then
        local cloak = 52009
        local gem = 55741
        local place = "Treasure Room"
        local hint = "buried with an ancient king."
    end
    local attack = cloakstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- searched in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old cloak.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("rogue_cloak:attack_counter")
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end