-- Trigger: Calken trainer speech
-- Zone: 31, ID: 65
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--   Large script: 9416 chars
--
-- Original DG Script: #3165

-- Converted from DG Script #3165: Calken trainer speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: training yes 2H dodge parry riposte hitall barehand bash disarm first guard kick mount rescue riding safefall springleap tame tantrum maul berserk ground battle roundhouse
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "training") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "2h") or string.find(string.lower(speech), "dodge") or string.find(string.lower(speech), "parry") or string.find(string.lower(speech), "riposte") or string.find(string.lower(speech), "hitall") or string.find(string.lower(speech), "barehand") or string.find(string.lower(speech), "bash") or string.find(string.lower(speech), "disarm") or string.find(string.lower(speech), "first") or string.find(string.lower(speech), "guard") or string.find(string.lower(speech), "kick") or string.find(string.lower(speech), "mount") or string.find(string.lower(speech), "rescue") or string.find(string.lower(speech), "riding") or string.find(string.lower(speech), "safefall") or string.find(string.lower(speech), "springleap") or string.find(string.lower(speech), "tame") or string.find(string.lower(speech), "tantrum") or string.find(string.lower(speech), "maul") or string.find(string.lower(speech), "berserk") or string.find(string.lower(speech), "ground") or string.find(string.lower(speech), "battle") or string.find(string.lower(speech), "roundhouse")) then
    return true  -- No matching keywords
end
wait(2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3165") < 1 then
    actor.name:start_quest("trainer_3165")
else
    actor.name:erase_quest("trainer_3165")
    actor.name:start_quest("trainer_3165")
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
    local speech = speech
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    if speech == "bash" then
        local skill = actor:has_skill("bash")
    elseif string.find(speech, "2H") then
        if string.find(speech, "bludgeoning") then
            local word2 = "bludgeoning"
            local skill = actor:has_skill("2H bludgeoning weapons")
        elseif string.find(speech, "piercing") then
            local word2 = "piercing"
            local skill = actor:has_skill("2H piercing weapons")
        elseif string.find(speech, "slashing") then
            local word2 = "slashing"
            local skill = actor:has_skill("2H slashing weapons")
        else
            self:say("Not sure that I've heard of that one.  What was it again?")
            return _return_value
        end
    elseif speech == "disarm" then
        local skill = actor:has_skill("disarm")
    elseif speech == "dodge" then
        local skill = actor:has_skill("dodge")
    elseif speech == "parry" then
        local skill = actor:has_skill("parry")
    elseif speech == "riposte" then
        local skill = actor:has_skill("riposte")
    elseif speech == "hitall" then
        local skill = actor:has_skill("hitall")
    elseif speech == "barehand" then
        local skill = actor:has_skill("barehand")
    elseif speech == "springleap" then
        local skill = actor:has_skill("springleap")
    elseif speech == "safefall" then
        local skill = actor:has_skill("safefall")
    elseif speech == "bash" then
        local skill = actor:has_skill("bash")
    elseif speech == "guard" then
        local skill = actor:has_skill("guard")
    elseif speech == "rescue" then
        local skill = actor:has_skill("rescue")
    elseif speech == "kick" then
        local skill = actor:has_skill("kick")
    elseif speech == "first aid" then
        local word2 = "aid"
        local skill = actor:has_skill("first aid")
    elseif speech == "mount" then
        local skill = actor:has_skill("mount")
    elseif speech == "riding" then
        local skill = actor:has_skill("riding")
    elseif speech == "tame" then
        local skill = actor:has_skill("tame")
    elseif speech == "ground shaker" then
        local word2 = "shaker"
        local skill = actor:has_skill("ground shaker")
    elseif speech == "battle howl" then
        local word2 = "howl"
        local skill = actor:has_skill("battle howl")
    elseif speech == "maul" then
        local skill = actor:has_skill("maul")
    elseif speech == "tantrum" then
        local skill = actor:has_skill("tantrum")
    elseif speech == "berserk" then
        local skill = actor:has_skill("berserk")
    elseif speech == "roundhouse" then
        local skill = actor:has_skill("roundhouse")
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
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you - you've mastered " .. tostring(speech) .. "!")
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
    actor.name:set_quest_var("trainer_3165", "skill_name", speech)
    if word2 then
        actor.name:set_quest_var("trainer_3165", "word2", word2)
    end
    actor.name:set_quest_var("trainer_3165", "skill_level", skill)
    actor.name:set_quest_var("trainer_3165", "price", price)
    actor.name:set_quest_var("trainer_3165", "actor_level", actor.level)
end