-- Trigger: 3bl_qm_initiate
-- Zone: 41, ID: 2
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Initiates a player into the Black Legion side of the Black_Legion quest
-- (3bl variant -- raid the Abbey to curry favor). Players already pledged
-- to the Eldorian Guard (eg_ally) are turned away.
--
-- Original DG Script: #4102

-- Speech keywords: quest emissary elven scum hi hello yes
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "quest") or string.find(speech_lower, "emissary") or string.find(speech_lower, "elven") or string.find(speech_lower, "scum") or string.find(speech_lower, "hi") or string.find(speech_lower, "hello") or string.find(speech_lower, "yes")) then
    return true  -- No matching keywords
end
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- This is for neutrals and evils only.
if actor.alignment <= 150 and actor.level > 9 then
    wait(2)
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor:start_quest("Black_Legion")
        actor:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor:set_quest_var("Black_Legion", "EG_FACTION", 0)
        actor:set_quest_var("Black_Legion", "bl_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("Black_Legion") > 0 and actor:get_quest_var("black_legion:bl_faction") > 99 then
        actor:send(tostring(self.name) .. " tells you, 'Yes, your service to the Legion has been")
        actor:send("</>acceptable.  Perhaps you can help on the front lines in our assault in Eldoria.")
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the")
        actor:send("</>Third Black Legion Recruiter for further instructions!'")
        return true
    end
    actor:send(tostring(self.name) .. " tells you, 'Yes, You will need to assist us in order to")
    actor:send("</>curry our favor.'")
    actor:send(tostring(self.name) .. " tells you, 'We have word the monks of the western vales")
    actor:send("</>are harboring agents of the Eldorian guard.  Go, raid the Abbey and lay waste")
    actor:send("</>to them and their ilk!'")
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
end