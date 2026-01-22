-- Trigger: phase wand and phase mace upgrade general speech
-- Zone: 3, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--   Large script: 10354 chars
--
-- Original DG Script: #307

-- Converted from DG Script #307: phase wand and phase mace upgrade general speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: upgrade upgrading craft crafting improve improving improvements upgrades
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "upgrade") or string.find(string.lower(speech), "upgrading") or string.find(string.lower(speech), "craft") or string.find(string.lower(speech), "crafting") or string.find(string.lower(speech), "improve") or string.find(string.lower(speech), "improving") or string.find(string.lower(speech), "improvements") or string.find(string.lower(speech), "upgrades")) then
    return true  -- No matching keywords
end
wait(2)
if self.id == 18581 or self.id == 48412 then
    if actor.class == "cleric" or actor.class == "priest" then
        local minlevel = macestep * 10
        if actor:get_quest_stage("phase_mace") == "macestep" then
            if actor.level >= minlevel then
                actor:set_quest_var("phase_mace", "greet", 1)
                actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%maceitem2%]%</>, for its spiritual protection.")
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%maceitem3%]%</>, as a model for the new mace.")
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%maceitem4%]%</>, for its power in fighting the undead.")
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%maceitem5%]%</>, for its guiding light.")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve the blessings on your mace.'")
            end
        elseif actor:get_has_completed("phase_mace") then
            actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
        elseif actor:get_quest_stage("phase_mace") < macestep then
            actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
        elseif actor:get_quest_stage("phase_mace") > macestep then
            actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
            wait(1)
            -- switch on actor:get_quest_stage("phase_mace")
            if actor:get_quest_stage("phase_mace") == 3 then
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
        end
    end
end
if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "necromancer" then
    local minlevel = (wandstep - 1) * 10
    if actor.quest_stage[type_wand] == "wandstep" then
        if actor.level >= minlevel then
            actor:set_quest_var("%type%_wand", "greet", 1)
            if actor.quest_stage[type_wand] < 7 then
                if string.find(speech, "staff") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a staff but I can help improve your wand's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your wand's strength.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            elseif actor.quest_stage[type_wand] == 7 then
                actor:send(tostring(self.name) .. " says, 'Your wand has reached its maximum potential.  You're ready for a staff instead.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your current wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            else
                if string.find(speech, "wand") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a wand but I can help improve your staff's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your staff's power.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your staff <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            end
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandgem%]%</>")
            if wandstep ~= 7 and wandstep ~= 10 then
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandtask3%]%</>, for its resonance with %type% energies.")
                if wandstep == 4 then
                    actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if self.id == 58601 then
                        actor:send("</>    Search the far eastern edge of the continent.")
                    elseif self.id == 10306 then
                        actor:send("</>    Search the south point beyond Anlun Vale.")
                    elseif self.id == 2337 then
                        actor:send("</>    Search the surrounding forest.")
                    elseif self.id == 62504 then
                        actor:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    actor:send("</>    The phrase to call the blessing is:")
                    actor:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            end
            if wandstep == 4 then
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandtask4%]%</> for its sheer magical potential.")
                actor:send("</>    Be careful, thawkinixa is extremely dangerous!")
            elseif wandstep == 5 then
                actor:send("</>")
                actor:send("Plus you'll need to imbue your wand in " .. tostring(wandtask4) .. ".")
            elseif wandstep == 6 then
                actor:send("</>")
                actor:send("This next wandstep also requires balancing harmonic frequencies.")
                actor:send("</>")
                actor:send("Go find <b:yellow>" .. "%get.obj_shortdesc[%wandtask4%]%</>.")
            elseif wandstep == 7 then
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandtask3%]%</>, which will form the body of your new staff.")
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandtask4%]%</>, as a fine head for your new staff.")
            elseif wandstep == 8 then
                actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%wandtask4%]%</>, which can be harvested from those kinds of elementals.")
            elseif wandstep == 9 then
                actor:send("- proof of your mastery over " .. tostring(type) .. " by slaying <b:cyan>" .. "%get.mob_shortdesc[%wandtask4%]%</>.")
            elseif wandstep == 10 then
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " says, 'Energize your staff by slaying <b:cyan>" .. "%get.mob_shortdesc[%wandtask3%]%</> in Templace, then return to me.'")
            end
            actor:send("</>")
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[wand progress]</> at any time.'")
        else
            actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
        end
    elseif actor.quest_stage[type_wand] < wandstep then
        actor:send(tostring(self.name) .. " says, 'Your " .. tostring(weapon) .. " isn't ready for improvement yet.'")
    elseif actor.quest_stage[type_wand] > wandstep then
        actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
    end
end