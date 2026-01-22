-- Trigger: 3eg_qm_initiate
-- Zone: 41, ID: 6
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #4106

-- Converted from DG Script #4106: 3eg_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: quest sod undead masses hi hello yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "sod") or string.find(string.lower(speech), "undead") or string.find(string.lower(speech), "masses") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
-- This is for neutrals and goods only.
-- 
wait(2)
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor.name:start_quest("Black_Legion")
        actor.name:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor.name:set_quest_var("Black_Legion", "EG_FACTION", 0)
        actor.name:set_quest_var("Black_Legion", "eg_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("Black_Legion") > 0 and actor:get_quest_var("black_legion:eg_faction") > 99 then
        -- (empty send to actor)
        actor:send(tostring(self.name) .. " tells you, 'Your help to us has not gone unnoticed.  I")
        actor:send("</>wonder...  Perhaps you can help on the front lines in our assault in Eldoria.'")
        -- (empty send to actor)
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the Third")
        actor:send("</>Eldorian Guard Recruiter for further instructions!")
        return _return_value
    end
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Hrm, you will need to go assist us in our")
    actor:send("efforts in thwarting the Black Legion's influence.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'We understand that the Legion is in cahoots")
    actor:send("</>with the trolls of Split Skull.  If you wish to gain favor with the Eldorian")
    actor:send("</>Court then raid Split Skull.  Lay waste to their ranks!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
    -- (empty send to actor)
end