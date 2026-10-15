-- Trigger: ***skill trainer speach***
-- Zone: 30, ID: 160
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3160

-- Converted from DG Script #3160: ***skill trainer speach***
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "backstab", "bludgeoning", "shadow", "slashing", "sneak", "steal", "switch", "throatcut", "track", "conceal", "corner", "double", "dual", "eye", "retreat", "hide", "pick", "piercing", "bandage", "douse", "lure", "cartwheel", "rend"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3160") < 1 then
    actor:start_quest("trainer_3160")
else
    actor:erase_quest("trainer_3160")
    actor:start_quest("trainer_3160")
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
    local skill, word2
    if speech == "backstab" then
        skill = actor:get_skill("backstab")
    elseif speech == "bludgeoning weapons" then
        skill = actor:get_skill("bludgeoning weapons")
        word2 = "weapons"
    elseif speech == "cartwheel" then
        skill = actor:get_skill("cartwheel")
    elseif speech == "conceal" then
        skill = actor:get_skill("conceal")
    elseif speech == "corner" then
        skill = actor:get_skill("corner")
    elseif speech == "double attack" then
        skill = actor:get_skill("double attack")
        word2 = "attack"
    elseif speech == "dual wield" then
        skill = actor:get_skill("dual wield")
        word2 = "wield"
    elseif speech == "eye gouge" then
        word2 = "gouge"
        skill = actor:get_skill("eye gouge")
    elseif speech == "group retreat" then
        word2 = "retreat"
        skill = actor:get_skill("group retreat")
    elseif speech == "hide" then
        skill = actor:get_skill("hide")
    elseif speech == "instant kill" then
        skill = actor:get_skill("instant kill")
        word2 = "kill"
    elseif speech == "lure" then
        skill = actor:get_skill("lure")
    elseif speech == "pick lock" then
        skill = actor:get_skill("pick lock")
        word2 = "lock"
    elseif speech == "piercing weapons" then
        skill = actor:get_skill("piercing weapons")
        word2 = "weapons"
    elseif speech == "rend" then
        skill = actor:get_skill("rend")
    elseif speech == "retreat" then
        skill = actor:get_skill("retreat")
    elseif speech == "shadow" then
        skill = actor:get_skill("shadow")
    elseif speech == "slashing weapons" then
        skill = actor:get_skill("slashing weapons")
        word2 = "weapons"
    elseif speech == "sneak" then
        skill = actor:get_skill("sneak")
    elseif speech == "sneak attack" then
        skill = actor:get_skill("sneak attack")
        word2 = "attack"
    elseif speech == "steal" then
        skill = actor:get_skill("steal")
    elseif speech == "switch" then
        skill = actor:get_skill("switch")
    elseif speech == "throatcut" then
        skill = actor:get_skill("throatcut")
    elseif speech == "track" then
        skill = actor:get_skill("track")
    elseif speech == "bandage" then
        skill = actor:get_skill("bandage")
    elseif speech == "douse" then
        skill = actor:get_skill("douse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if speech == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif speech == "dodge" or speech == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif speech == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you. You've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
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
    local price = math.floor(change * opinion * actor.level * actor.level / (skill * 20))
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price // 1000
    local gold = price // 100 - plat * 10
    local silv = price // 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just bring me the money when you're ready to practice.")
    actor:set_quest_var("trainer_3160", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3160", "word2", word2)
    end
    actor:set_quest_var("trainer_3160", "skill_level", skill)
    actor:set_quest_var("trainer_3160", "max_skill", maxskill)
    actor:set_quest_var("trainer_3160", "price", price)
    actor:set_quest_var("trainer_3160", "actor_level", actor.level)
end