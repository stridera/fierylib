-- Trigger: corpse retrieval price set
-- Zone: 31, ID: 82
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 5606 chars
--
-- Original DG Script: #3182

-- Converted from DG Script #3182: corpse retrieval price set
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: corpse retrieval services yes help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "corpse") or string.find(string.lower(speech), "retrieval") or string.find(string.lower(speech), "services") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    wait(2)
    local cha = actor.real_cha
    -- make sure they have a quest record for saving variables
    if actor:get_quest_stage("corpse_retrieval") < 1 then
        actor.name:start_quest("corpse_retrieval")
    end
    self:say("We can certainly help you with that...")
    wait(1)
    self:say("For a price.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But understand, if you don't have a corpse out there, this spell")
    self.room:send("</>will fail and you won't get your money back.'")
    wait(2)
    self:command("eye " .. tostring(actor))
    -- This portion is for smooth speech indicating the effects of a player's cha and level.
    if actor.level < 10 then
        self:say("You're still a fresh-faced adventurer...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... and you're a sweet kid.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self:say("... but your face is just so punchable.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... and we all need a little help from time to time.")
        end
    elseif actor.level < 30 then
        self:say("Be careful, things are tougher out there for you now...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you are pretty charming.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and you probably had it coming.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... but we all get into tight scrapes now and then.")
        end
    elseif actor.level < 50 then
        self:say("You've seen your fair share of action...")
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're still pretty likable.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and you probably asked for most of it.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so take more precautions.")
        end
    elseif actor.level < 70 then
        self:say("You really should know how to survive better by now...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're pretty likable.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and it must be hard when people dislike you so much.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so try harder in the future.")
        end
    elseif actor.level < 90 then
        self:say("Seasoned heroes like you are hard to help...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're very friendly.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and plenty of people hate you.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so don't rely on me too much.")
        end
    else
        self:say("Helping a legend like you is extremely difficult...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you have a way with people.'")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and every creature in the world wants you dead.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so you won't get much sympathy from me.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local price = (actor.level * actor.level * ((actor.level * 2) / 3) * (100 - (cha / 10))) / 100
    -- now the price in copper has to be divided into coinage.
    local plat = price / 1000
    local gold = price / 100 - plat * 10
    local silv = price / 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("My fee is " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money and I'll cast the appropriate spells.")
    actor.name:set_quest_var("corpse_retrieval", "price", price)
    actor.name:set_quest_var("corpse_retrieval", "actor_level", actor.level)
end