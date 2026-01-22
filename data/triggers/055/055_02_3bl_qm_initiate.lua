-- Trigger: 3bl_qm_initiate
-- Zone: 55, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #5502

-- Converted from DG Script #5502: 3bl_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: quest recruit elven scum hi hello yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "recruit") or string.find(string.lower(speech), "elven") or string.find(string.lower(speech), "scum") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
-- This is for neutrals and evils only.
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 then
    wait(2)
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor.name:start_quest("Black_Legion")
        actor.name:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor.name:set_quest_var("Black_Legion", "EG_FACTION", 0)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
        actor.name:set_quest_var("Black_Legion", "bl_ally", 1)
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