-- Trigger: DoRemortQuest
-- Zone: 188, ID: 89
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18889

-- Converted from DG Script #18889: DoRemortQuest
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Yes, I am sure I want to remort.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes,") or string.find(string.lower(speech), "i") or string.find(string.lower(speech), "am") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "i") or string.find(string.lower(speech), "want") or string.find(string.lower(speech), "to") or string.find(string.lower(speech), "remort.")) then
    return true  -- No matching keywords
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
            local count = count - 1
        end
        actor:command("forget all")
    else
        actor:send("You do not have enough experience to remort!")
    end
    world.destroy(self)
end  -- auto-close block