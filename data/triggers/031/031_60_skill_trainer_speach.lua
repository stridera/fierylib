-- Trigger: ***skill trainer speach***
-- Zone: 31, ID: 60
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--   Large script: 9333 chars
--
-- Original DG Script: #3160

-- Converted from DG Script #3160: ***skill trainer speach***
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: training yes backstab bludgeoning shadow slashing sneak steal switch throatcut track conceal corner double dual eye switch retreat hide pick piercing bandage douse lure cartwheel rend
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "backstab") or string.find(string.lower(speech), "bludgeoning") or string.find(string.lower(speech), "shadow") or string.find(string.lower(speech), "slashing") or string.find(string.lower(speech), "sneak") or string.find(string.lower(speech), "steal") or string.find(string.lower(speech), "switch") or string.find(string.lower(speech), "throatcut") or string.find(string.lower(speech), "track") or string.find(string.lower(speech), "conceal") or string.find(string.lower(speech), "corner") or string.find(string.lower(speech), "double") or string.find(string.lower(speech), "dual") or string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "switch") or string.find(string.lower(speech), "retreat") or string.find(string.lower(speech), "hide") or string.find(string.lower(speech), "pick") or string.find(string.lower(speech), "piercing") or string.find(string.lower(speech), "bandage") or string.find(string.lower(speech), "douse") or string.find(string.lower(speech), "lure") or string.find(string.lower(speech), "cartwheel") or string.find(string.lower(speech), "rend")) then
    return true  -- No matching keywords
end
wait(2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3160") < 1 then
    actor.name:start_quest("trainer_3160")
else
    actor.name:erase_quest("trainer_3160")
    actor.name:start_quest("trainer_3160")
end
-- introductions: lists the skills available
if speech == "training?" or speech == "training" or speech == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary stealthy")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>backstab, bandage, bludgeoning weapons, cartwheel, conceal, corner")
    self.room:send("</>double attack, douse, dual wield, eye gouge, group retreat, hide, lure, pick lock,")
    self.room:send("</>piercing weapons, rend, retreat, shadow, slashing weapons, sneak, sneak attack,")
    self.room:send("</>steal, switch, throatcut, track.")
    return _return_value
else
    -- defining variables for this script
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    if speech == "backstab" then
        local skill = actor:has_skill("backstab")
    elseif speech == "bludgeoning weapons" then
        local skill = actor:has_skill("bludgeoning weapons")
        local word2 = "weapons"
    elseif speech == "cartwheel" then
        local skill = actor:has_skill("cartwheel")
    elseif speech == "conceal" then
        local skill = actor:has_skill("conceal")
    elseif speech == "corner" then
        local skill = actor:has_skill("corner")
    elseif speech == "double attack" then
        local skill = actor:has_skill("double attack")
        local word2 = "attack"
    elseif speech == "dual wield" then
        local skill = actor:has_skill("dual wield")
        local word2 = "wield"
    elseif speech == "eye gouge" then
        local word2 = "gouge"
        local skill = actor:has_skill("eye gouge")
    elseif speech == "group retreat" then
        local word2 = "retreat"
        local skill = actor:has_skill("group retreat")
    elseif speech == "hide" then
        local skill = actor:has_skill("hide")
    elseif speech == "instant kill" then
        local skill = actor:has_skill("instant kill")
        local word2 = "kill"
    elseif speech == "lure" then
        local skill = actor:has_skill("lure")
    elseif speech == "pick lock" then
        local skill = actor:has_skill("pick lock")
        local word2 = "lock"
    elseif speech == "piercing weapons" then
        local skill = actor:has_skill("piercing weapons")
        local word2 = "weapons"
    elseif speech == "rend" then
        local skill = actor:has_skill("rend")
    elseif speech == "retreat" then
        local skill = actor:has_skill("retreat")
    elseif speech == "shadow" then
        local skill = actor:has_skill("shadow")
    elseif speech == "slashing weapons" then
        local skill = actor:has_skill("slashing weapons")
        local word2 = "weapons"
    elseif speech == "sneak" then
        local skill = actor:has_skill("sneak")
    elseif speech == "sneak attack" then
        local skill = actor:has_skill("sneak attack")
        local word2 = "attack"
    elseif speech == "steal" then
        local skill = actor:has_skill("steal")
    elseif speech == "switch" then
        local skill = actor:has_skill("switch")
    elseif speech == "throatcut" then
        local skill = actor:has_skill("throatcut")
    elseif speech == "track" then
        local skill = actor:has_skill("track")
    elseif speech == "bandage" then
        local skill = actor:has_skill("bandage")
    elseif speech == "douse" then
        local skill = actor:has_skill("douse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    local skill = 10 * skill
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if speech == "track" then
        -- switch on actor.class
        if actor.class == "Mercenary" then
            local cap = 850
        elseif actor.class == "Rogue" then
            local cap = 650
        elseif actor.class == "Thief" then
            local cap = 600
        elseif actor.class == "Assassin" then
            local cap = 750
        end
    elseif speech == "dodge" or speech == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            local cap = 700
        end
    elseif speech == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            local cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        -- Fragment (possible truncation): Lets talk about improving a skill you actually know.'
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you. You've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        local maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("</>I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("..but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = change * opinion * actor.level * actor.level / (skill * 20)
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price / 1000
    local gold = price / 100 - plat * 10
    local silv = price / 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just bring me the money when you're ready to practice.")
    actor.name:set_quest_var("trainer_3160", "skill_name", speech)
    if word2 then
        actor.name:set_quest_var("trainer_3160", "word2", word2)
    end
    actor.name:set_quest_var("trainer_3160", "skill_level", skill)
    actor.name:set_quest_var("trainer_3160", "price", price)
    actor.name:set_quest_var("trainer_3160", "actor_level", actor.level)
end