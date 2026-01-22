-- Trigger: 3bl_qm_initiate
-- Zone: 41, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #4102

-- Converted from DG Script #4102: 3bl_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: quest emissary elven scum hi hello yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "emissary") or string.find(string.lower(speech), "elven") or string.find(string.lower(speech), "scum") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- This is for neutrals and evils only.
if actor.alignment <= 150 and actor.level > 9 then
    wait(2)
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor.name:start_quest("Black_Legion")
        actor.name:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor.name:set_quest_var("Black_Legion", "EG_FACTION", 0)
        actor.name:set_quest_var("Black_Legion", "bl_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("Black_Legion") > 0 and actor:get_quest_var("black_legion:bl_faction") > 99 then
        -- (empty send to actor)
        actor:send(tostring(self.name) .. " tells you, 'Yes, your service to the Legion has been")
        actor:send("</>acceptable.  Perhaps you can help on the front lines in our assault in Eldoria.")
        -- (empty send to actor)
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the")
        actor:send("</>Third Black Legion Recruiter for further instructions!'")
        return _return_value
    end
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Yes, You will need to assist us in order to")
    actor:send("</>curry our favor.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'We have word the monks of the western vales")
    actor:send("</>are harboring agents of the Eldorian guard.  Go, raid the Abbey and lay waste")
    actor:send("</>to them and their ilk!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
end