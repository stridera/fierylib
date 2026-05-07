-- Trigger: DoRemortQuest
-- Zone: 188, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18889
-- Converted from DG Script #18889: DoRemortQuest
-- Original: MOB trigger, flags: SPEECH, probability: 0%
--
-- The legacy 0% probability was a "manual only" marker; SPEECH triggers fire
-- when keywords match regardless. Synthetic `percent_chance(0)` gate removed.
-- Keyword matching tightened to require the full confirmation phrase.

local speech_lower = string.lower(speech or "")
if not string.find(speech_lower, "yes, i am sure i want to remort", 1, true) then
    return true  -- No matching phrase
end
if actor.level == 99 then
    actor:send("Your remort will take effect in 30 seconds.")
    actor:command("petition I am committing a REMORT!")
    actor:command("petition After this completes, I will need my class reset to my base class.")
    actor:command("petition The deleveling will begin in 30 seconds.")
    actor:command("petition Kill the RemortQuestHandler before then to cancel the remort.")
    wait(30)
    wizard_notify("Now starting!")
    while actor.level > 1 do
        local count = 99
        while (actor.level > 1) and (count > 2) do
            actor:award_exp(-500000)
            count = count - 1
        end
        actor:command("forget all")
    end
    world.destroy(self)
else
    actor:send("You do not have enough experience to remort!")
end