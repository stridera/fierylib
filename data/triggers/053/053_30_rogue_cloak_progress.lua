-- Trigger: Rogue Cloak Progress
-- Zone: 53, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): same as 053_19 progress trigger: `_return_value` referenced but never defined. Full rewrite
-- from DG #5330.
--
-- Original DG Script: #5330

-- Converted from DG Script #5330: Rogue Cloak Progress
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Treasure Hunters</>")
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif actor:get_quest_stage("treasure_hunter") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
elseif actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("treasure_hunter")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("treasure_hunter") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
end
local cloak, gem
if actor.class == "rogue" or actor.class == "bard" or actor.class == "thief" then
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
        actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
        return _return_value
    end
    -- switch on cloakstage
    local place, hint
    do
        local _sw2 = string.lower(tostring(cloakstage or ""))
        if tonumber(_sw2) == 1 then
            cloak = 58801
            gem = 55585
            place = "A Storage Room"
            hint = "in the house on the hill."
        elseif tonumber(_sw2) == 2 then
            cloak = 17307
            gem = 55593
            place = "A Small Alcove"
            hint = "in the holy library."
        elseif tonumber(_sw2) == 3 then
            cloak = 10308
            gem = 55619
            place = "either Treasure Room"
            hint = "in the paladin fortress."
        elseif tonumber(_sw2) == 4 then
            cloak = 12325
            gem = 55659
            place = "The Treasure Room"
            hint = "beyond the Tower in the Wastes."
        elseif tonumber(_sw2) == 5 then
            cloak = 43022
            gem = 55663
            place = "Treasury"
            hint = "in the ghostly fortress."
        elseif tonumber(_sw2) == 6 then
            cloak = 23810
            gem = 55674
            place = "either Treasure Room with a chest"
            hint = "lost in the sands."
        elseif tonumber(_sw2) == 7 then
            cloak = 51013
            gem = 55714
            place = "Mesmeriz's Secret Treasure Room"
            hint = "hidden deep underground."
        elseif tonumber(_sw2) == 8 then
            cloak = 58410
            gem = 55740
            place = "Treasure Room"
            hint = "sunken in the swamp."
        elseif tonumber(_sw2) == 9 then
            cloak = 52009
            gem = 55741
            place = "Treasure Room"
            hint = "buried with an ancient king."
        end
    end
    local attack = cloakstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(cloak))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
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
        local remaining = attack - (actor:get_quest_var("rogue_cloak:attack_counter") or 0)
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. proto_short(cloak) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end