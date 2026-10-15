-- Trigger: shaman trainer speech
-- Zone: 30, ID: 170
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3170

-- Converted from DG Script #3170: shaman trainer speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: training yes spell sphere chant scribe meditate vampiric breathe perform
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "sphere") or string.find(string.lower(speech), "chant") or string.find(string.lower(speech), "scribe") or string.find(string.lower(speech), "meditate") or string.find(string.lower(speech), "vampiric") or string.find(string.lower(speech), "breathe") or string.find(string.lower(speech), "perform")) then
    return true  -- No matching keywords
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3170") < 1 then
    actor:start_quest("trainer_3170")
else
    actor:erase_quest("trainer_3170")
    actor:start_quest("trainer_3170")
end
-- introductions: lists the skills available
if speech == "training?" or speech == "training" or speech == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary magical")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>breathe acid, breathe fire, breathe frost, breathe gas, breathe lightning,")
    self.room:send("</>chant, meditate, perform, scribe, spell knowledge, sphere of air,")
    self.room:send("</>sphere of death, sphere of divination, sphere of earth, sphere of enchantment,")
    self.room:send("</>sphere of fire, sphere of generic, sphere of healing, sphere of protection,")
    self.room:send("</>sphere of summoning, sphere of water, quick chant.")
    return _return_value
else
    -- defining variables for this script
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local word2, skill
    if speech == "spell knowledge" then
        word2 = "knowledge"
        skill = actor:get_skill("spell knowledge")
    elseif string.find(speech, "sphere") then
        if string.find(speech, "air") then
            word2 = "air"
            skill = actor:get_skill("sphere of air")
        elseif string.find(speech, "death") then
            word2 = "death"
            skill = actor:get_skill("sphere of death")
        elseif string.find(speech, "divination") then
            word2 = "divination"
            skill = actor:get_skill("sphere of divination")
        elseif string.find(speech, "earth") then
            word2 = "earth"
            skill = actor:get_skill("sphere of earth")
        elseif string.find(speech, "enchantment") then
            word2 = "enchantment"
            skill = actor:get_skill("sphere of enchantment")
        elseif string.find(speech, "fire") then
            word2 = "fire"
            skill = actor:get_skill("sphere of fire")
        elseif string.find(speech, "generic") then
            word2 = "generic"
            skill = actor:get_skill("sphere of generic")
        elseif string.find(speech, "healing") then
            word2 = "healing"
            skill = actor:get_skill("sphere of healing")
        elseif string.find(speech, "protection") then
            word2 = "protection"
            skill = actor:get_skill("sphere of protection")
        elseif string.find(speech, "summoning") then
            word2 = "summoning"
            skill = actor:get_skill("sphere of summoning")
        elseif string.find(speech, "water") then
            word2 = "water"
            skill = actor:get_skill("sphere of water")
        else
            self:say("I've never heard of that sphere of magic before.")
        end
    elseif string.find(speech, "breathe") then
        if string.find(speech, "fire") then
            word2 = "fire"
            skill = actor:get_skill("breathe fire")
        elseif string.find(speech, "frost") then
            word2 = "frost"
            skill = actor:get_skill("breathe frost")
        elseif string.find(speech, "lightning") then
            word2 = "lightning"
            skill = actor:get_skill("breathe lightning")
        elseif string.find(speech, "acid") then
            word2 = "acid"
            skill = actor:get_skill("breathe acid")
        elseif string.find(speech, "gas") then
            word2 = "gas"
            skill = actor:get_skill("breathe gas")
        else
            self:say("Whatever that is, you can't breathe it!")
            return _return_value
        end
    elseif speech == "quick chant" then
        word2 = "chant"
        skill = actor:get_skill("quick chant")
    elseif speech == "chant" then
        skill = actor:get_skill("chant")
    elseif speech == "scribe" then
        skill = actor:get_skill("scribe")
    elseif speech == "meditate" then
        skill = actor:get_skill("meditate")
    elseif speech == "vampiric touch" then
        word2 = "touch"
        skill = actor:get_skill("vampiric touch")
    elseif speech == "perform" then
        skill = actor:get_skill("perform")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = (actor.level * 10) + 60
    -- check for capped skills
    local cap = 1000
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
        self:say("You're a charming person.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you are very quick witted.")
            self.room:send("</>I'll be delighted to give you a good rate.'")
        elseif int < 50 then
            self:say("...but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you aren't the smartest.")
            self.room:send("</>So this is going to cost you.'")
        else
        end
    else
        self:say("I wouldn't mind working with you.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...but you aren't the smartest.")
            self.room:send("</>So, this is going to cost a bit more than usual.'")
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
    actor:set_quest_var("trainer_3170", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3170", "word2", word2)
    end
    actor:set_quest_var("trainer_3170", "skill_level", skill)
    actor:set_quest_var("trainer_3170", "max_skill", maxskill)
    actor:set_quest_var("trainer_3170", "price", price)
    actor:set_quest_var("trainer_3170", "actor_level", actor.level)
end