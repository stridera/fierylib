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
-- Which topic was asked about?  The player may wrap it in other words ("dodge please"), so look for the
-- longest known topic named as a whole word or phrase; the greeting words rank last.
local topic
for _, name in ipairs({"bludgeoning weapons", "piercing weapons", "slashing weapons", "double attack", "group retreat", "instant kill", "sneak attack", "dual wield", "cartwheel", "eye gouge", "pick lock", "throatcut", "backstab", "bandage", "conceal", "retreat", "riposte", "corner", "shadow", "switch", "dodge", "douse", "parry", "sneak", "steal", "track", "hide", "lure", "rend", "training", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(name, "%p", "%%%0") .. "[%s%p]") then
        topic = name
        break
    end
end
-- introductions: lists the skills available
if topic == "training" or topic == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary stealthy")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    self.room:send("</>")
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    self.room:send("</>")
    self.room:send("</>backstab, bandage, bludgeoning weapons, cartwheel, conceal, corner,")
    self.room:send("</>double attack, douse, dual wield, eye gouge, group retreat, hide, lure,")
    self.room:send("</>pick lock, piercing weapons, rend, retreat, shadow, slashing weapons, sneak,")
    self.room:send("</>sneak attack, steal, switch, throatcut, track.")
    return _return_value
else
    -- defining variables for this script
    speech = topic or speech  -- canonical topic name: it is echoed and saved as the skill below
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if topic == "backstab" then
        skill = actor:get_skill("backstab")
    elseif topic == "bludgeoning weapons" then
        skill = actor:get_skill("bludgeoning weapons")
        word2 = "weapons"
    elseif topic == "cartwheel" then
        skill = actor:get_skill("cartwheel")
    elseif topic == "conceal" then
        skill = actor:get_skill("conceal")
    elseif topic == "corner" then
        skill = actor:get_skill("corner")
    elseif topic == "double attack" then
        skill = actor:get_skill("double attack")
        word2 = "attack"
    elseif topic == "dual wield" then
        skill = actor:get_skill("dual wield")
        word2 = "wield"
    elseif topic == "eye gouge" then
        word2 = "gouge"
        skill = actor:get_skill("eye gouge")
    elseif topic == "group retreat" then
        word2 = "retreat"
        skill = actor:get_skill("group retreat")
    elseif topic == "hide" then
        skill = actor:get_skill("hide")
    elseif topic == "instant kill" then
        skill = actor:get_skill("instant kill")
        word2 = "kill"
    elseif topic == "lure" then
        skill = actor:get_skill("lure")
    elseif topic == "pick lock" then
        skill = actor:get_skill("pick lock")
        word2 = "lock"
    elseif topic == "piercing weapons" then
        skill = actor:get_skill("piercing weapons")
        word2 = "weapons"
    elseif topic == "rend" then
        skill = actor:get_skill("rend")
    elseif topic == "retreat" then
        skill = actor:get_skill("retreat")
    elseif topic == "shadow" then
        skill = actor:get_skill("shadow")
    elseif topic == "slashing weapons" then
        skill = actor:get_skill("slashing weapons")
        word2 = "weapons"
    elseif topic == "sneak" then
        skill = actor:get_skill("sneak")
    elseif topic == "sneak attack" then
        skill = actor:get_skill("sneak attack")
        word2 = "attack"
    elseif topic == "steal" then
        skill = actor:get_skill("steal")
    elseif topic == "switch" then
        skill = actor:get_skill("switch")
    elseif topic == "throatcut" then
        skill = actor:get_skill("throatcut")
    elseif topic == "track" then
        skill = actor:get_skill("track")
    elseif topic == "bandage" then
        skill = actor:get_skill("bandage")
    elseif topic == "douse" then
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
    if topic == "track" then
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
    elseif topic == "dodge" or topic == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif topic == "riposte" then
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