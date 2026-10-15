-- Trigger: Dragon Slayers Isilynor Speech
-- Zone: 30, ID: 81
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REWRITE
--
-- TODO(parity): converter produced a malformed nested if/elseif chain inside
-- the `if actor:get_quest_var("dragon_slayer:hunt") == "running" then` block.
-- Each stage check is wrapped in a no-op `if ... running then end` followed
-- by an unreachable `elseif ... stage == N`, so only stage 1 ever fires.
-- Restructure to a single switch on quest stage with the running/idle guard
-- evaluated once at the top.
--
-- Original DG Script: #3081

-- Converted from DG Script #3081: Dragon Slayers Isilynor Speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hunt", "dragon", "dragons"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif actor.level < 5 then
    actor:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
elseif (actor:get_quest_stage("dragon_slayer") == 0 and actor.level >= 5) or (actor:get_quest_stage("dragon_slayer") == 1 and (actor:get_quest_var("dragon_slayer:hunt") or 0) == 0) then
    actor:send(tostring(self.name) .. " says, 'Before you go slaying any real dragons, let's start with a test kill.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'The hedges in the topiary have been brought to life somehow.  We don't know exactly what's causing it, but that's also not our concern at the moment.'")
    wait(0.4)
    actor:send(tostring(self.name) .. " says, 'Some of the dragon hedges have become a real problem!  They're big, nasty, and put up one hell of a fight.  They might only be shrubbery, but they'll be a great way to prove you're ready for the real thing.'")
    wait(0.4)
    actor:send(tostring(self.name) .. " says, 'Are you up to the challenge?'")
elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
        -- switch on actor:get_quest_stage("dragon_slayer")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("dragon_slayer") or ""))
            if tonumber(_sw1) == 1 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
                end
            elseif tonumber(_sw1) == 2 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
                else
                    actor:send(tostring(self.name) .. " says, 'We've heard there's a green dragon who's taken up residence below the old house on Morgan Hill.  Our scouts say it's still just a wyrmling, so now is the best time to take it out.  Big dragons come from little dragons afterall.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'But don't let your guard down!  A baby dragon is still a dragon!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Are you ready for your first real kill?'")
                end
            elseif tonumber(_sw1) == 3 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I've been interested in the stories around Wug the Fiery Drakling, a fierce and fearsome beast who used to terrorize Mielikki with a brood of other lesser drakes in ages past.  But they all suddenly and mysteriously disappeared.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'I hear the Templar Magistrate has uncovered some new information around the Wug legend.  Ask him about Wug and see what he knows.  You can become a legend by slaying a legend!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Are you up for a little legendary discovery?'")
                end
            elseif tonumber(_sw1) == 4 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Another juvenile dragon has been spotted out near the old abandoned tower off the Black Rock Trail.  This one seems to be a lot more powerful than the little wyrmling under Morgan Hill though.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'This one is a blue dragon with considerable spellcasting power.  So be ready for lightning!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'So what do you think?  You ready to bring the thunder?'")
                end
            elseif tonumber(_sw1) == 5 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I just got news of something wild!  Apparently there's a section of forest in South Caelia that's just packed with magical beasts!  Incredibly rare faerie dragons can be found there in great numbers!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'While faerie dragons themselves aren't terribly strong, the other creatures that fill the forest are incredibly deadly.  Plus faerie dragons breathe a special kind of euphoric gas that confuses and disables anyone who breathes it.  It'll be a very nasty combo.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Think you can hold your own against all manner of beasts?'")
                end
            elseif tonumber(_sw1) == 6 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Since you've been able to hold out against the great beasts of the southern forest, I've got something closer to home to deal with.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Out past the Gothra Desert is a stretch of highlands.  A very nasty wyvern has long haunted that region.  So many innocent travelers have met their end and this creature's claws.  Other knights have tried and failed to slay it but none have succeeded.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Do you think you can finally fell the beast?'")
                end
            elseif tonumber(_sw1) == 7 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
                else
                    actor:send(tostring(self.name) .. " says, 'A whole brood of giant ice reptiles slither through Frost Valley.  They seem to be somewhere between true dragons and just really huge lizards.")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'That said, they seem like a great challenge for a well-experienced dragon slayer like yourself.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'You ready to brave the cold?'")
                end
            elseif tonumber(_sw1) == 8 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I have a great mission for you.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'The ancient kingdom of Layveran fell to unholy forces in ages long past.  Its exact location is actually unknown.  But a strange planar rift out west takes you to the blasted ice desert surrounding the fallen castle.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Rumors say some kind of unholy two-headed draconic abomination dwells in the depths of the ruins.  Reaching it, let alone slaying it, will be a mighty challenge fit for a true champion!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'You in?'")
                end
            elseif tonumber(_sw1) == 9 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
                else
                    actor:send(tostring(self.name) .. " says, 'You're ready for a very high profile, high risk kill.  Up north is a cult dedicated to worshipping the white dragon Tri-Aszp.  Ending this cult is a high priority item and the only way to do that is the slay Tri-Aszp.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'But that's easier said than done.  Not only is Tri-Aszp a fully grown dragon with full command of ice and frost, the cult is heavily militarized and heavily armed, with powerful priests and magicians to boot.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'And to make matters worse, they're buried deep in the ice, surrounded by all manner of absolutely unstoppable monsters.'")
                    wait(0.4)
                    self:command("grin")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'It's going to be a thrill a minute!  Are you up to the challenge?'")
                end
            elseif tonumber(_sw1) == 10 then
                if actor:get_quest_var("dragon_slayer:hunt") == "running" then
                    actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
                else
                    actor:send(tostring(self.name) .. " says, 'I have one last great dragon for you to hunt down.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'The demon dragon Sagece has called to her several other deadly threats.  Among them is a massive Hydra - a many-headed monstrosity which Sagece entrusted with one of the keys to her lair.  Before one can even think about driving Sagece from Templace, the Hydra must fall.'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'I want you to be the one to fell the Hydra.  Do so and you'll be welcomed to the echelons of the Grand Master Dragon Slayers!'")
                    wait(0.4)
                    actor:send(tostring(self.name) .. " says, 'Ready for the fight of your life?'")
                end
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
    end
end