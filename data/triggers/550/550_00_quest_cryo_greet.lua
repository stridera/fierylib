-- Trigger: quest_cryo_greet
-- Zone: 550, ID: 0
-- Type: MOB, Flags: SPEECH, GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #55000

-- Converted from DG Script #55000: quest_cryo_greet
-- Original: MOB trigger, flags: SPEECH, GREET, probability: 100%

-- Speech keywords: hi hello
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello")) then
    return true  -- No matching keywords
end
wait(2)
if actor.quest_stage[type_wand] == "wandstep" then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor.quest_variable["type_wand:greet"] == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            if actor.quest_variable["type_wand:wandtask1"] and actor.quest_variable["type_wand:wandtask2"] and actor.quest_variable["type_wand:wandtask3"] then
                actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
            end
        end
    end
end
-- switch on actor:get_quest_stage("subclass")
if actor:get_quest_stage("subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Welcome back.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
elseif actor:get_quest_stage("subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'I see you return.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Recall, what Emmath and I battled over may still be <b:cyan>suffering</>.'")
elseif actor:get_quest_stage("subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Why have you returned already?  The shrub still suffers!'")
elseif actor:get_quest_stage("subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Does the shrub still suffer?'")
else
    if string.find(actor.class, "sorcerer") then
        -- switch on actor.race
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            return _return_value
        else
            if actor.level >= 10 and actor.level <= 45 then
                self:command("grin " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'Greetings " .. tostring(actor.name) .. ", have you come to me for a specific <b:cyan>reason</>?'")
                self:command("eye " .. tostring(actor.name))
            elseif actor.level < 10 then
                self:command("grin " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " says, 'Greetings " .. tostring(actor.name) .. ".  I fear we are meeting before you are ready.  Gain some more experience, then seek me out again.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I look forward to our next encounter.'")
            end
        end
    end
end  -- auto-close block