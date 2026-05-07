-- Trigger: norisent speech
-- Zone: 85, ID: 51
-- Type: MOB, Flags: SPEECH, SPEECH_TO
--
-- Norisent's main quest dialogue. For cleric/priest/diabolist players in
-- the right quest stages, drives the resurrection_quest from "ask about
-- resurrection" through accepting payment, and on completion of stage 2
-- (torturer dead, bishop freed) hands out the death talisman and the
-- next batch of objectives.
--
-- TODO(parity): legacy DG declared this at probability 1%, which would
-- almost never trigger. Earlier passes preserved the gate; restore the
-- intended probability once verified against the ASCII source.
--
-- Original DG Script: #8551

-- Converted from DG Script #8551: norisent speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger (preserved from legacy; see TODO(parity) above)
if not percent_chance(1) then
    return true
end

-- Speech keywords: resurrection teach resurrect yes payment how please useful souls
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "resurrection") or string.find(speech_lower, "teach") or string.find(speech_lower, "resurrect") or string.find(speech_lower, "yes") or string.find(speech_lower, "payment") or string.find(speech_lower, "how") or string.find(speech_lower, "please") or string.find(speech_lower, "useful") or string.find(speech_lower, "command") or string.find(speech_lower, "souls")) then
    return true  -- No matching keywords
end
if not actor.is_player then
    return true
end
if actor.class ~= "cleric" and actor.class ~= "priest" and actor.class ~= "diabolist" then
    return true
end

local stage = actor:get_quest_stage("resurrection_quest")
if (stage <= 1 or actor.level >= 81) and string.find(speech_lower, "resurrection") then
    actor:start_quest("resurrection_quest")
    wait(1)
    self:emote("smirks ever so slightly, with a creepy glint of foreboding.")
    self:say("So it's happened.  I knew someday your order would forget how.  Though, it's happened much sooner than I would have thought.  It only took a thousand years.")
    self:emote("furrows his brow.")
    wait(1)
    self:say("Is this true?  Have you come hoping that I will teach you how to resurrect your allies?")
    return true
end
if stage ~= 1 then
    if string.find(speech_lower, "teach") or string.find(speech_lower, "resurrect") or string.find(speech_lower, "yes") then
        wait(1)
        self:say("And what could you possibly offer me as payment?  I require nothing of food or drink.  Riches and knowledge are mine.  Glory and honor are lost on me.  I owe no living man my loyalty.")
        wait(3)
        self:say("'I know of only one thing that would please me more than your death that I might consider payment.")
        return true
    elseif string.find(speech_lower, "payment") or string.find(speech_lower, "please") then
        wait(1)
        self:say("There is an emissary from the Abbey of St. George, a bishop, being held in the dungeon.  Ziijhan would have her tortured and killed.  He's always trying to settle an old score with his brother, Barak.")
        wait(3)
        self:say("The old knight is being a petty child, but what could you possibly do to upset him?  Be gone, and trouble me no more.")
        actor:advance_quest("resurrection_quest")
        return true
    end
elseif stage ~= 3 then
    if string.find(speech_lower, "useful") or string.find(speech_lower, "how") then
        actor:advance_quest("resurrection_quest")
        wait(1)
        self:say("Yes, there is something more you could do for me.")
        wait(1)
        self:say("A beastly dark mage left an experiment... unresolved.  Very unprofessional of him.")
        wait(3)
        self:say("In his attempts to reunite a body and soul, he left them each alive, severed from one another.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'You must go and find Lajon's two severed halves, loose them of their undead states, then destroy them both.  The soul must be rebuked with the words of power <b:blue>Dhewsost Konre</>, before purging him.'")
        wait(5)
        self:say("To purge the rogue body, however, you'll need to give him this to help you finalize his death.")
        wait(4)
        self.room:spawn_object(85, 50)
        self:command("give death " .. tostring(actor.name))
        wait(3)
        self:say("And as for the old mage...")
        self:command("chuckle")
        wait(2)
        self:say("That talisman should aid his passing as well.  The ring of souls is the source of his power.  Bring it to me when you're finished.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'And if you forget, you can ask about your <b:white>[progress]</>.  Maybe I'll consider reminding you.'")
    end
end