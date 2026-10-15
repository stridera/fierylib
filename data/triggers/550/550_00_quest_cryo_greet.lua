-- Trigger: quest_cryo_greet
-- Zone: 550, ID: 0
-- Type: MOB, Flags: SPEECH, GREET
--
-- Suralla's greet/speech "hi/hello" handler. Branches on the cryomancer
-- subclass quest stage and (for sorcerers) gives a level-gated welcome.
-- Suralla is the ice wand's step 10 crafter: the wand branch reads the step, element and weapon
-- the LOAD trigger 002_111 stores in `globals`.
--
-- Original DG Script: #55000

-- Converted from DG Script #55000: quest_cryo_greet
-- Original: MOB trigger, flags: SPEECH, GREET, probability: 100%

-- DG word list (num_arg 100): a SPEECH must contain one of these as a whole word or phrase; the
-- greet part of the trigger (GREET, no speech) is not gated.
if event == "SPEECH" or event == "SPEECH_TO" then
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"hi", "hello"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
end
wait(0.2)
local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
-- switch on actor:get_quest_stage("subclass")
if actor:get_quest_stage("subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Welcome back.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
elseif actor:get_quest_stage("subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'I see you return.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Recall, what Emmath and I battled over may still be <b:cyan>suffering</>.'")
elseif actor:get_quest_stage("subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Why have you returned already?  The shrub still suffers!'")
elseif actor:get_quest_stage("subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Does the shrub still suffer?'")
else
    if string.find(string.lower(actor.class), "sorcerer") then
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            return true
        end
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