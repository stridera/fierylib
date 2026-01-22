-- Trigger: Phase mace Sexton speech upgrade
-- Zone: 185, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: 18528 - Sexton upgrade speech
--   Complex nesting: 6 if statements
--   Large script: 5970 chars
--
-- Original DG Script: #18528

-- Converted from DG Script #18528: Phase mace Sexton speech upgrade
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: upgrade upgrades upgrading mace improvement improvements improving
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "upgrade") or string.find(string.lower(speech), "upgrades") or string.find(string.lower(speech), "upgrading") or string.find(string.lower(speech), "mace") or string.find(string.lower(speech), "improvement") or string.find(string.lower(speech), "improvements") or string.find(string.lower(speech), "improving")) then
    return true  -- No matching keywords
end
-- UNCONVERTED: 18528 - Sexton upgrade speech
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local minlevel = macestep * 10
    if actor:get_quest_stage("phase_mace") == "macestep" then
        if actor.level >= minlevel then
            actor:set_quest_var("phase_mace", "greet", 1)
            self.room:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
            wait(1)
            self:say("You'll need to use your mace " .. tostring(maceattack) .. " times.")
            -- (empty room echo)
            self:say("I'll also need the following:")
            self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem3%]%</>, for its spiritual protection.")
            if macestep ~= 2 then
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem2%]%</>, as a model for the new mace.")
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem3%]%</>, for its power in fighting the undead.")
                self.room:send("- <b:cyan>" .. "%get.obj_shortdesc[%maceitem4%]%</>, for its guiding light.")
            else
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'And finally, you'll need to make a pilgrimage to four burial")
                self.room:send("</>grounds to see what lies ahead on your journey:'")
                self.room:send("- <magenta>the necropolis near Anduin</>")
                self.room:send("- <magenta>the pyramid in the Gothra desert</>")
                self.room:send("- <magenta>the ancient barrow in the Iron Hills</>")
                self.room:send("- <magenta>the cemetary outside the Cathedral of Betrayal</>")
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>  All you")
                self.room:send("</>have to do is <b:cyan>[dig]</> up a handful of dirt from each place and bring it")
                self.room:send("</>back to me.'")
            end
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at")
            self.room:send("</>any time.'")
        else
            self.room:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I")
            self.room:send("</>can improve your bond with your weapon.'")
        end
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    elseif actor:get_quest_stage("phase_mace") < macestep then
        self:say("Your mace isn't ready for improvement yet.")
    elseif actor:get_quest_stage("phase_mace") > macestep then
        self:say("I've done all I can already.")
        wait(1)
        -- switch on actor:get_quest_stage("phase_mace")
        if actor:get_quest_stage("phase_mace") == 3 then
            self.room:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous")
            self.room:send("</>crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle")
            self.room:send("</>and talk to High Priest Zalish.  He should be able to help you.'")
        elseif actor:get_quest_stage("phase_mace") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in")
            self.room:send("</>with the High Priestess in the City of Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 5 then
            self.room:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their")
            self.room:send("</>own dark natures against them.  Few are as knowledgeable about the dark")
            self.room:send("</>arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("phase_mace") == 6 then
            self.room:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out")
            self.room:send("</>Silania.  Her mastry of spiritual matters will be necessary to improve")
            self.room:send("</>this mace any further.'")
        elseif actor:get_quest_stage("phase_mace") == 7 then
            self.room:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your")
            self.room:send("</>mace, one is a priest of a god most foul.  Find Ruin Wormheart, that")
            self.room:send("</>most heinous of Blackmourne's servators.'")
        elseif actor:get_quest_stage("phase_mace") == 8 then
            self.room:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead")
            self.room:send("</>is the sun itself.  Consult with the sun's Oracle in the ancient pyramid")
            self.room:send("</>near Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 9 then
            self.room:send(tostring(self.name) .. " says, 'With everything prepared, return to the very")
            self.room:send("</>beginning of your journey.  The High Priestess of Mielikki, the very")
            self.room:send("</>center of the Cleric Guild, will know what to do.'")
        end
    end
end