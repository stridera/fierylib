-- Trigger: Phase mace progress
-- Zone: 3, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 23 if statements
--   Large script: 6257 chars
--
-- Original DG Script: #316

-- Converted from DG Script #316: Phase mace progress
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: mace progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "mace") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
if actor.class ~= "cleric" and actor.class ~= "priest" then
    actor:send(tostring(self.name) .. " says, 'This weapon is only for servants of the gods.'")
    return _return_value
end
local stage = actor:get_quest_stage("phase_mace")
local job1 = actor:get_quest_var("phase_mace:macetask1")
local job2 = actor:get_quest_var("phase_mace:macetask2")
local job3 = actor:get_quest_var("phase_mace:macetask3")
local job4 = actor:get_quest_var("phase_mace:macetask4")
local job5 = actor:get_quest_var("phase_mace:macetask5")
local job6 = actor:get_quest_var("phase_mace:macetask6")
if actor:get_has_completed("phase_mace") then
    actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
elseif stage == "macestep" and actor.level >= macestep * 10 then
    if actor:get_quest_var("phase_mace:greet") == 0 then
        actor:send(tostring(self.name) .. " says, 'Tell me why you're here first.'")
    else
        actor:send(tostring(self.name) .. " says, 'I'm improving your mace.'")
        if job1 or job2 or job3 or job4 or job5 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " says, 'You've done the following:'")
            if job1 then
                actor:send("- attacked " .. tostring(maceattack) .. " times")
            end
            if job2 then
                actor:send("- found " .. "%get.obj_shortdesc[%maceitem2%]%")
            end
            if job3 then
                actor:send("- found " .. "%get.obj_shortdesc[%maceitem3%]%")
            end
            if job4 then
                actor:send("- found " .. "%get.obj_shortdesc[%maceitem4%]%")
            end
            if job5 then
                actor:send("- found " .. "%get.obj_shortdesc[%maceitem5%]%")
            end
        end
        -- (empty send to actor)
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 and job5 then
            if macestep ~= 2 then
                actor:send("Just give me your mace.")
                return _return_value
            else
                if job6 then
                    actor:send("Just give me your mace.")
                    return _return_value
                end
            end
        end
        if not job1 then
            local remaining = (stage * 50) - actor:get_quest_var("phase_mace:attack_counter")
            if remaining > 1 then
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
            else
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
            end
        end
        if not job2 then
            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem2%]%</>")
        end
        if not job3 then
            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem3%]%</>")
        end
        if not job4 then
            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem4%]%</>")
        end
        if not job5 then
            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem5%]%</>")
        end
        if macestep == 2 then
            if not job6 then
                actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem6%]%</>")
            end
        end
    end
elseif stage > macestep then
    -- switch on actor:get_quest_stage("phase_mace")
    if actor:get_quest_stage("phase_mace") == 2 then
        actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
    elseif actor:get_quest_stage("phase_mace") == 3 then
        actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
    elseif actor:get_quest_stage("phase_mace") == 4 then
        actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
    elseif actor:get_quest_stage("phase_mace") == 5 then
        actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
    elseif actor:get_quest_stage("phase_mace") == 6 then
        actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further.'")
    elseif actor:get_quest_stage("phase_mace") == 7 then
        actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
    elseif actor:get_quest_stage("phase_mace") == 8 then
        actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
    elseif actor:get_quest_stage("phase_mace") == 9 then
        actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
    end
elseif stage < macestep then
    actor:send(tostring(self.name) .. " says, 'You need to make more improvements to your mace before I can work with it.'")
elseif actor.level < macestep * 10 then
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end