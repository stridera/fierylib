-- Trigger: Calken trainer speech
-- Zone: 30, ID: 165
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3165

-- Converted from DG Script #3165: Calken trainer speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "2h", "dodge", "parry", "riposte", "hitall", "barehand", "bash", "disarm", "first", "guard", "kick", "mount", "rescue", "riding", "safefall", "springleap", "tame", "tantrum", "maul", "berserk", "ground", "battle", "roundhouse"}) do
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
if actor:get_quest_stage("trainer_3165") < 1 then
    actor:start_quest("trainer_3165")
else
    actor:erase_quest("trainer_3165")
    actor:start_quest("trainer_3165")
end
-- introductions: lists the skills available
if speech == "training?" or speech == "training" or speech == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary martial")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>2H bludgeoning weapons, 2H piercing weapons, 2H slashing weapons, barehand,")
    self.room:send("</>bash, battle howl, berserk, disarm, dodge, first aid, ground shaker, guard,")
    self.room:send("</>hitall, kick, maul, mount, parry, rescue, riding, riposte, roundhouse, safefall,")
    self.room:send("</>springleap, tame, tantrum.")
    wait(2)
    self:say("Feel free to ask me about one of them and I'll give you a price.")
    return _return_value
else
    -- defining variables for this script
    speech = speech
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if speech == "bash" then
        skill = actor:get_skill("bash")
    elseif string.find(speech, "2h") then
        if string.find(speech, "bludgeoning") then
            word2 = "bludgeoning"
            skill = actor:get_skill("2H bludgeoning weapons")
        elseif string.find(speech, "piercing") then
            word2 = "piercing"
            skill = actor:get_skill("2H piercing weapons")
        elseif string.find(speech, "slashing") then
            word2 = "slashing"
            skill = actor:get_skill("2H slashing weapons")
        else
            self:say("Not sure that I've heard of that one.  What was it again?")
            return _return_value
        end
    elseif speech == "disarm" then
        skill = actor:get_skill("disarm")
    elseif speech == "dodge" then
        skill = actor:get_skill("dodge")
    elseif speech == "parry" then
        skill = actor:get_skill("parry")
    elseif speech == "riposte" then
        skill = actor:get_skill("riposte")
    elseif speech == "hitall" then
        skill = actor:get_skill("hitall")
    elseif speech == "barehand" then
        skill = actor:get_skill("barehand")
    elseif speech == "springleap" then
        skill = actor:get_skill("springleap")
    elseif speech == "safefall" then
        skill = actor:get_skill("safefall")
    elseif speech == "bash" then
        skill = actor:get_skill("bash")
    elseif speech == "guard" then
        skill = actor:get_skill("guard")
    elseif speech == "rescue" then
        skill = actor:get_skill("rescue")
    elseif speech == "kick" then
        skill = actor:get_skill("kick")
    elseif speech == "first aid" then
        word2 = "aid"
        skill = actor:get_skill("first aid")
    elseif speech == "mount" then
        skill = actor:get_skill("mount")
    elseif speech == "riding" then
        skill = actor:get_skill("riding")
    elseif speech == "tame" then
        skill = actor:get_skill("tame")
    elseif speech == "ground shaker" then
        word2 = "shaker"
        skill = actor:get_skill("ground shaker")
    elseif speech == "battle howl" then
        word2 = "howl"
        skill = actor:get_skill("battle howl")
    elseif speech == "maul" then
        skill = actor:get_skill("maul")
    elseif speech == "tantrum" then
        skill = actor:get_skill("tantrum")
    elseif speech == "berserk" then
        skill = actor:get_skill("berserk")
    elseif speech == "roundhouse" then
        skill = actor:get_skill("roundhouse")
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
        self:say("There is nothing left to teach you - you've mastered " .. tostring(speech) .. "!")
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
            self.room:send("I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
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
    self:say("Just get me the money, and I'll get started.")
    actor:set_quest_var("trainer_3165", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3165", "word2", word2)
    end
    actor:set_quest_var("trainer_3165", "skill_level", skill)
    actor:set_quest_var("trainer_3165", "max_skill", maxskill)
    actor:set_quest_var("trainer_3165", "price", price)
    actor:set_quest_var("trainer_3165", "actor_level", actor.level)
end