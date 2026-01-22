-- Trigger: Phase Mace Templar speech upgrade
-- Zone: 30, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #3031

-- Converted from DG Script #3031: Phase Mace Templar speech upgrade
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: upgrade upgrades upgrading improvement improvements blessing blessings
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "upgrade") or string.find(string.lower(speech), "upgrades") or string.find(string.lower(speech), "upgrading") or string.find(string.lower(speech), "improvement") or string.find(string.lower(speech), "improvements") or string.find(string.lower(speech), "blessing") or string.find(string.lower(speech), "blessings")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level > 9 then
    if actor:get_quest_stage("phase_mace") == 1 or (not actor:get_quest_stage("phase_mace") and (actor:has_equipped("340") or actor:has_item("340"))) then
        if not actor:get_quest_stage("phase_mace") then
            actor:start_quest("phase_mace")
        end
        actor:set_quest_var("phase_mace", "greet", 1)
        actor:send(tostring(self.name) .. " says, 'I could bless your mace against the undead, if I had the proper materials.'")
        actor:send("</>")
        actor:send("Bring me the following:")
        actor:send("- <b:yellow>" .. tostring(objects.template(552, 11).name) .. "</> to use as a model")
        actor:send("- <b:yellow>" .. tostring(objects.template(555, 77).name) .. "</> and")
        actor:send("- <b:yellow>" .. tostring(objects.template(136, 14).name) .. "</> for their protection against malevolent spirits")
        actor:send("- <b:yellow>" .. tostring(objects.template(588, 9).name) .. "</> as a flame to ward against the dark")
        actor:send("</>")
        actor:send("Also attack with " .. tostring(objects.template(3, 40).name) .. " <b:yellow>50</> times to fully bond with it.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[mace progress]</> at any time.'")
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    else
        actor:send(tostring(self.name) .. " says, 'I've already done all I can.  If you want to further improve your mace, you'll have to seek out a different master crafter.'")
        wait(1)
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
            actor:send(tostring(self.name) .. " says, 'I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
        elseif actor:get_quest_stage("phase_mace") == 8 then
            actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 9 then
            actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end