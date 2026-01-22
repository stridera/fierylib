-- Trigger: shaman trainer speech
-- Zone: 31, ID: 70
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: Let's talk about improving a skill you actually know.'
--   Complex nesting: 14 if statements
--   Large script: 8832 chars
--
-- Original DG Script: #3170

-- Converted from DG Script #3170: shaman trainer speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: training yes spell sphere chant scribe meditate vampiric breathe perform
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "sphere") or string.find(string.lower(speech), "chant") or string.find(string.lower(speech), "scribe") or string.find(string.lower(speech), "meditate") or string.find(string.lower(speech), "vampiric") or string.find(string.lower(speech), "breathe") or string.find(string.lower(speech), "perform")) then
    return true  -- No matching keywords
end
wait(2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3170") < 1 then
    actor.name:start_quest("trainer_3170")
else
    actor.name:erase_quest("trainer_3170")
    actor.name:start_quest("trainer_3170")
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
    if speech == "spell knowledge" then
        local word2 = "knowledge"
        local skill = actor:has_skill("spell knowledge")
    elseif string.find(speech, "sphere") then
        if string.find(speech, "air") then
            local word2 = "air"
            local skill = actor:has_skill("sphere of air")
        elseif string.find(speech, "death") then
            local word2 = "death"
            local skill = actor:has_skill("sphere of death")
        elseif string.find(speech, "divination") then
            local word2 = "divination"
            local skill = actor:has_skill("sphere of divination")
        elseif string.find(speech, "earth") then
            local word2 = "earth"
            local skill = actor:has_skill("sphere of earth")
        elseif string.find(speech, "enchantment") then
            local word2 = "enchantment"
            local skill = actor:has_skill("sphere of enchantment")
        elseif string.find(speech, "fire") then
            local word2 = "fire"
            local skill = actor:has_skill("sphere of fire")
        elseif string.find(speech, "generic") then
            local word2 = "generic"
            local skill = actor:has_skill("sphere of generic")
        elseif string.find(speech, "healing") then
            local word2 = "healing"
            local skill = actor:has_skill("sphere of healing")
        elseif string.find(speech, "protection") then
            local word2 = "protection"
            local skill = actor:has_skill("sphere of protection")
        elseif string.find(speech, "summoning") then
            local word2 = "summoning"
            local skill = actor:has_skill("sphere of summoning")
        elseif string.find(speech, "water") then
            local word2 = "water"
            local skill = actor:has_skill("sphere of water")
        else
            self:say("I've never heard of that sphere of magic before.")
        end
    elseif string.find(speech, "breathe") then
        if string.find(speech, "fire") then
            local word2 = "fire"
            local skill = actor:has_skill("breathe fire")
        elseif string.find(speech, "frost") then
            local word2 = "frost"
            local skill = actor:has_skill("breathe frost")
        elseif string.find(speech, "lightning") then
            local word2 = "lightning"
            local skill = actor:has_skill("breathe lightning")
        elseif string.find(speech, "acid") then
            local word2 = "acid"
            local skill = actor:has_skill("breathe acid")
        elseif string.find(speech, "gas") then
            local word2 = "gas"
            local skill = actor:has_skill("breathe gas")
        else
            self:say("Whatever that is, you can't breathe it!")
        end
    elseif speech == "quick chant" then
        local word2 = "chant"
        local skill = actor:has_skill("quick chant")
    elseif speech == "chant" then
        local skill = actor:has_skill("chant")
    elseif speech == "scribe" then
        local skill = actor:has_skill("scribe")
    elseif speech == "meditate" then
        local skill = actor:has_skill("meditate")
    elseif speech == "vampiric touch" then
        local word2 = "touch"
        local skill = actor:has_skill("vampiric touch")
    elseif speech == "perform" then
        local skill = actor:has_skill("perform")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    local skill = 10 * skill
    local maxskill = (actor.level * 10) + 60
    -- check for capped skills
    local cap = 1000
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        -- UNCONVERTED: Let's talk about improving a skill you actually know.'
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
    self:say("Just get me the money, and I'll get started.")
    actor.name:set_quest_var("trainer_3170", "skill_name", speech)
    if word2 then
        actor.name:set_quest_var("trainer_3170", "word2", word2)
    end
    actor.name:set_quest_var("trainer_3170", "skill_level", skill)
    actor.name:set_quest_var("trainer_3170", "price", price)
    actor.name:set_quest_var("trainer_3170", "actor_level", actor.level)
end