-- Trigger: phase mace speech upgrade
-- Zone: 2, ID: 115
-- Type: MOB, Flags: SPEECH
--
-- "Upgrade" handler for the phase-mace questmaster mobs (loaded by
-- 002_118). Lists the items the priest needs, the attack-counter
-- requirement, and the breadcrumb to the next priest if the player has
-- already moved past this one.
--
-- TODO(parity): `%get.obj_shortdesc[%maceitemN%]%` interpolations are
-- preserved as literal text in the response strings — the per-mob
-- maceitem ids are exported via globals by 002_118, but the right-side
-- lookup helper (`objects.template(z, id).name`) needs the items
-- normalised to (zone, local) pairs first.
local lower = string.lower(speech or "")
local function has(word) return string.find(lower, word, 1, true) ~= nil end
if not (has("upgrade") or has("upgrades") or has("upgrading")
        or has("improvement") or has("improvements") or has("improving")) then
    return true
end
if self.id == 18502 then
    self:set_flag("sentinel", true)
end
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local macestep = globals.macestep
    if macestep then
        local minlevel = macestep * 10
        local stage = actor:get_quest_stage("phase_mace")
        local maceattack = globals.maceattack
        if stage == macestep then
            if actor.level >= minlevel then
                actor:set_quest_var("phase_mace", "greet", 1)
                actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
                actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
                actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
                actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem2%]%</>, for its spiritual protection.")
                if macestep ~= 2 then
                    actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem3%]%</>, as a model for the new mace.")
                    actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem4%]%</>, for its power in fighting the undead.")
                    actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem5%]%</>, for its guiding light.")
                else
                    actor:send(tostring(self.name) .. " says, 'And you'll need to make a pilgrimage to four burial grounds to see what lies ahead on your journey:'")
                    actor:send("- <b:yellow>the necropolis near Anduin</>")
                    actor:send("- <b:yellow>the pyramid in the Gothra desert</>")
                    actor:send("- <b:yellow>the ancient barrow in the Iron Hills</>")
                    actor:send("- <b:yellow>the cemetary outside the Cathedral of Betrayal</>")
                    actor:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>'")
                    wait(2)
                    self.room:spawn_object(185, 26)
                    self:command("give grave-spade " .. tostring(actor.name))
                    actor:send(tostring(self.name) .. " says, 'Holding this spade, <b:cyan>[dig]</> up a handful of dirt from each of these places and bring it back to me as a token of your journey.'")
                end
                actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
            end
        elseif actor:get_has_completed("phase_mace") then
            actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
        elseif (stage or 0) < macestep then
            actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
        elseif stage > macestep then
            actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
            wait(1)
            if stage == 3 then     actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
            elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
            elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
            elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
            elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne''s servators.'")
            elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun''s Oracle in the ancient pyramid near Anduin.'")
            elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
            end
        end
    end
end
if self.id == 18502 then
    self:set_flag("sentinel", false)
end
return true
