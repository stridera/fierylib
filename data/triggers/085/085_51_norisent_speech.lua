-- Trigger: norisent speech
-- Zone: 85, ID: 51
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN (reviewed)
--
-- Original DG Script: #8551

-- Converted from DG Script #8551: norisent speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: resurrection teach resurrect yes  payment how how? please useful command souls
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "resurrection") or string.find(string.lower(speech), "teach") or string.find(string.lower(speech), "resurrect") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "payment") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "how?") or string.find(string.lower(speech), "please") or string.find(string.lower(speech), "useful") or string.find(string.lower(speech), "command") or string.find(string.lower(speech), "souls")) then
    return true  -- No matching keywords
end
local speech = speech
if actor.id ~= -1 then
    if actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" then
        if actor:get_quest_stage("resurrection_quest") <= 1 or actor.level >= 81 then
            if string.find(speech, "resurrection") then
                actor:start_quest("resurrection_quest")
                wait(1)
                self:emote("smirks ever so slightly, with a creepy glint of foreboding.")
                self:say("So it's happened.  I knew someday your order would forget how.  Though, it's happened much sooner than I would have thought.  It only took a thousand years.")
                self:emote("furrows his brow.")
                wait(1)
                self:say("Is this true?  Have you come hoping that I will teach you how to resurrect your allies?")
                return _return_value
            end
        end
        if actor:get_quest_stage("resurrection_quest") ~= 1 then
            if string.find(speech, "teach") or string.find(speech, "resurrect") or string.find(speech, "yes") then
                wait(1)
                self:say("And what could you possibly offer me as payment?  I require nothing of food or drink.  Riches and knowledge are mine.  Glory and honor are lost on me.  I owe no living man my loyalty.")
                wait(3)
                self:say("'I know of only one thing that would please me more than your death that I might consider payment.")
                return _return_value
            elseif string.find(speech, "payment") or string.find(speech, "please") then
                wait(1)
                self:say("There is an emissary from the Abbey of St. George, a bishop, being held in the dungeon.  Ziijhan would have her tortured and killed.  He's always trying to settle an old score with his brother, Barak.")
                wait(3)
                self:say("The old knight is being a petty child, but what could you possibly do to upset him?  Be gone, and trouble me no more.")
                actor:advance_quest("resurrection_quest")
                return _return_value
            end
        elseif actor:get_quest_stage("resurrection_quest") ~= 3 then
            if string.find(speech, "useful") or string.find(speech, "how") then
                actor:advance_quest("resurrection_quest")
                wait(1)
                self:say("Yes, there is something more you could do for me.")
                wait(1)
                self:say("A beastly dark mage left an experiment... unresolved.  Very unprofessional of him.")
                wait(3)
                self:say("In his attempts to reunite a body and soul, he left them each alive, severed from one another.")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'You must go and find Lajon's two severed halves, loose them of their undead states, and then destroy them both.  The soul must be rebuked with the words of power <b:blue>Dhewsost Konre</>, before purging him.'")
                wait(5)
                self:say("To purge the rogue body, however, you'll need to give him this to help you finalize his death.")
                wait(4)
                self.room:spawn_object(85, 50)
                self:command("give death " .. tostring(actor))
                wait(3)
                self:say("And as for the old mage...")
                self:command("chuckle")
                wait(2)
                self:say("That talisman should aid his passing as well.  The ring of souls is the source of his power.  Bring it to me when you're finished.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'And if you forget, you can ask about your <b:white>[progress]</>.  Maybe I'll consider reminding you.'")
            end
        end
    end
end