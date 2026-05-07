-- Trigger: phase mace progress
-- Zone: 2, ID: 116
-- Type: MOB, Flags: SPEECH
--
-- "[mace progress]" / "mace" status report shared by every phase-mace
-- questmaster. Lists what the player has completed for this stage and
-- what's still required, or gives the next breadcrumb if they have
-- moved past this priest.
--
-- TODO(parity): Same DG-interpolation pattern as 002_113 — the per-mob
-- maceitem ids are exported via globals by 002_118, but
-- `%get.obj_shortdesc[%maceitemN%]%` strings are kept literal here
-- because the (zone, id) lookup helpers haven't been wired up yet. Also
-- removes a converter `percent_chance(0)` synthetic gate.

local lower = string.lower(speech or "")
if not (string.find(lower, "mace", 1, true) or string.find(lower, "progress", 1, true)) then
    return true
end
wait(2)
if actor.class ~= "cleric" and actor.class ~= "priest" then
    actor:send(tostring(self.name) .. " says, 'This weapon is only for servants of the gods.'")
    return true
end
local macestep = globals.macestep
if not macestep then return true end
local maceattack = globals.maceattack
local stage = actor:get_quest_stage("phase_mace")
local job1 = actor:get_quest_var("phase_mace:macetask1")
local job2 = actor:get_quest_var("phase_mace:macetask2")
local job3 = actor:get_quest_var("phase_mace:macetask3")
local job4 = actor:get_quest_var("phase_mace:macetask4")
local job5 = actor:get_quest_var("phase_mace:macetask5")
local job6 = actor:get_quest_var("phase_mace:macetask6")
if actor:get_has_completed("phase_mace") then
    actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
elseif stage == macestep and actor.level >= macestep * 10 then
    if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
        actor:send(tostring(self.name) .. " says, 'Tell me why you're here first.'")
    else
        actor:send(tostring(self.name) .. " says, 'I'm improving your mace.'")
        if job1 or job2 or job3 or job4 or job5 then
            actor:send(tostring(self.name) .. " says, 'You've done the following:'")
            if job1 then actor:send("- attacked " .. tostring(maceattack) .. " times") end
            if job2 then actor:send("- found %get.obj_shortdesc[%maceitem2%]%") end
            if job3 then actor:send("- found %get.obj_shortdesc[%maceitem3%]%") end
            if job4 then actor:send("- found %get.obj_shortdesc[%maceitem4%]%") end
            if job5 then actor:send("- found %get.obj_shortdesc[%maceitem5%]%") end
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 and job5 then
            if macestep ~= 2 then
                actor:send("Just give me your mace.")
                return true
            else
                if job6 then
                    actor:send("Just give me your mace.")
                    return true
                end
            end
        end
        if not job1 then
            local remaining = (stage * 50) - (actor:get_quest_var("phase_mace:attack_counter") or 0)
            if remaining > 1 then
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
            else
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
            end
        end
        if not job2 then actor:send("- <b:yellow>find %get.obj_shortdesc[%maceitem2%]%</>") end
        if not job3 then actor:send("- <b:yellow>find %get.obj_shortdesc[%maceitem3%]%</>") end
        if not job4 then actor:send("- <b:yellow>find %get.obj_shortdesc[%maceitem4%]%</>") end
        if not job5 then actor:send("- <b:yellow>find %get.obj_shortdesc[%maceitem5%]%</>") end
        if macestep == 2 and not job6 then
            actor:send("- <b:yellow>find %get.obj_shortdesc[%maceitem6%]%</>")
        end
    end
elseif stage and stage > macestep then
    if stage == 2 then     actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
    elseif stage == 3 then actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
    elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
    elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
    elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
    elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne''s servators.'")
    elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun''s Oracle in the ancient pyramid near Anduin.'")
    elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
    end
elseif (stage or 0) < macestep then
    actor:send(tostring(self.name) .. " says, 'You need to make more improvements to your mace before I can work with it.'")
elseif actor.level < macestep * 10 then
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end
return true
