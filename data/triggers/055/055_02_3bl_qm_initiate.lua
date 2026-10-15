-- Trigger: 3bl_qm_initiate
-- Zone: 55, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #5502

-- Converted from DG Script #5502: 3bl_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "recruit", "elven", "scum", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
-- This is for neutrals and evils only.
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 then
    wait(0.2)
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
        actor:set_quest_var("black_legion", "bl_ally", 1)
        -- being added 2-18-2021 to prevent team switching
    end
    actor:send(tostring(self.name) .. " tells you, 'Yes, You need to go assist our")
    actor:send("</>fighters.  Go, invade the 3rd Eldorian Guard and lay waste to their ranks!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of")
    actor:send("your victories, I will <b:white>[reward]</> you!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your")
    actor:send("</><b:white>[faction status]</>.'")
    -- (empty send to actor)
end