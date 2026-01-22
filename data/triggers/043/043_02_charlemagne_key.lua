-- Trigger: charlemagne_key
-- Zone: 43, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 20 if statements
--   Large script: 5235 chars
--
-- Original DG Script: #4302

-- Converted from DG Script #4302: charlemagne_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
local i = actor.group_size
local stage = 4
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if object.id == 4301 then
            if person:get_quest_stage("theatre") >= stage then
                if not person:get_quest_var("theatre:charles") then
                    person:set_quest_var("theatre", "charles", 1)
                    local accept = 1
                    if person:get_quest_stage("theatre") == "stage" then
                        person:send("<b:white>You have helped return Charlemagne's key.</>")
                    end
                else
                    local refuse = "key"
                end
            else
                local refuse = "person"
            end
        elseif object.id == 4320 then
            if person:get_quest_stage("theatre") <= stage then
                local accept = 3
                if person:get_quest_stage("theatre") == "stage" then
                    if not person:get_quest_var("theatre:sash") then
                        person:set_quest_var("theatre", "sash", 1)
                        person:send("<b:white>You have helped return Charlemagne's sash.</>")
                    end
                end
            else
                if accept ~= 3 then
                    local accept = 2
                end
            end
        else
            local refuse = "item"
        end
        if person:get_quest_stage("theatre") == 4 and person:get_quest_var("theatre:sash") and person:get_quest_var("theatre:charles") then
            person:advance_quest("theatre")
            person:set_quest_var("theatre", "charles", 0)
            person:set_quest_var("theatre", "sash", 0)
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if actor:get_quest_stage("theatre") == 4 then
    if not actor:get_quest_var("theatre:sash") then
        local outcome = 2
    elseif not actor:get_quest_var("theatre:charles") then
        local outcome = 3
    else
        local outcome = 1
    end
else
    local outcome = 1
end
if accept then
    wait(2)
    if accept == 1 then
        self:say("Ah marvelous!")
        wait(2)
    elseif accept > 1 then
        if accept == 2 then
            wait(2)
            self:say("Another?")
            wait(2)
            self:command("ponder")
            wait(2)
            self:say("Well I guess one never can be too prepared!")
        elseif accept == 3 then
            self:say("Where did you find this?  It must have been stolen in the scuffle this afternoon.  Thank you for returning it to me.")
        end
        self:command("remove sash")
        self:command("wear charlemagne's-fire-sash")
        self:destroy_item("sash")
        wait(5)
        self:command("bow")
        wait(2)
        self:say("Oh, since you seem to be so good at returning things, I think I might have something for you to do...")
        wait(2)
        self:emote("goes searching around through the room, tossing aside bedding and clothing.")
        wait(5)
        self:say("Ah ha!  Here it is!")
        self.room:spawn_object(43, 5)
        self:emote("pulls the <red>F<b:yellow>i<b:red>r</><red>e G<b:yellow>o<b:red>dd</><b:yellow>e</><red>ss<b:red>'s</> skirt from a pile of clothing.")
        wait(2)
        self:say("The actress, umm, left this here by accident last night...")
        wait(2)
        self:command("cough")
        wait(2)
        self:say("I've been meaning to return it to her, but I've been locked in here all day.  I'm sure she would be most happy to have it back.")
        wait(3)
        self:command("give skirt " .. tostring(actor.name))
        wait(2)
        self:say("Thank you kindly.")
        wait(2)
    end
    if outcome == 1 then
        self:say("Now be off!  I have to prepare for my performance!")
        wait(2)
        actor:send(tostring(self.name) .. " dismisses you.")
    elseif outcome == 2 then
        self:say("Now if only I could find my sash, I would be ready to go on tonight.")
    elseif outcome == 3 then
        self:say("If you have my dressing room key, please hand it over.")
    end
elseif refuse then
    if refuse == "item" then
        wait(2)
        self:command("roll " .. tostring(actor))
        wait(1)
        self:say("This isn't what I'm looking for.  Stop wasting time and help me look.")
    else
        _return_value = false
        if refuse == "person" then
            self:command("gasp")
            self:say("Are you a Ceiling Monkey in disguise?!")
            wait(1)
            self:command("point " .. tostring(actor.name))
        elseif refuse == "key" then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            self:say("You already gave me my key back, thank you.")
        end
    end
end
self:set_flag("sentinel", false)
return _return_value