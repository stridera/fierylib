-- Trigger: 3eg_qm_initiate
-- Zone: 41, ID: 6
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Initiates a player into the Eldorian Guard side of the black_legion quest
-- (3eg variant -- raid Split Skull to curry favor). Players already pledged
-- to the Black Legion (bl_ally) are turned away.
--
-- Original DG Script: #4106

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "sod", "undead", "masses", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This is for neutrals and goods only.
wait(0.2)
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        actor:set_quest_var("black_legion", "eg_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("black_legion") > 0 and (actor:get_quest_var("black_legion:eg_faction") or 0) > 99 then
        actor:send(tostring(self.name) .. " tells you, 'Your help to us has not gone unnoticed.  I")
        actor:send("</>wonder...  Perhaps you can help on the front lines in our assault in Eldoria.'")
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the Third")
        actor:send("</>Eldorian Guard Recruiter for further instructions!")
        return true
    end
    actor:send(tostring(self.name) .. " tells you, 'Hrm, you will need to go assist us in our")
    actor:send("efforts in thwarting the Black Legion's influence.'")
    actor:send(tostring(self.name) .. " tells you, 'We understand that the Legion is in cahoots")
    actor:send("</>with the trolls of Split Skull.  If you wish to gain favor with the Eldorian")
    actor:send("</>Court then raid Split Skull.  Lay waste to their ranks!'")
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
end