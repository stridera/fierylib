-- Trigger: Phase Mace Templar speech upgrade
-- Zone: 30, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3031

-- Converted from DG Script #3031: Phase Mace Templar speech upgrade
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrades", "upgrading", "improvement", "improvements", "blessing", "blessings"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor.level > 9 then
    if actor:get_quest_stage("phase_mace") == 1 or (actor:get_quest_stage("phase_mace") == 0 and (actor:has_equipped(2, 140) or actor:has_item(2, 140))) then
        if actor:get_quest_stage("phase_mace") == 0 then
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
        actor:send("Also attack with " .. tostring(objects.template(2, 140).name) .. " <b:yellow>50</> times to fully bond with it.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[mace progress]</> at any time.'")
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    else
        actor:send(tostring(self.name) .. " says, 'I've already done all I can.  If you want to further improve your mace, you'll have to seek out a different master crafter.'")
        wait(1)
        -- switch on actor:get_quest_stage("phase_mace")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("phase_mace") or ""))
            if tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end