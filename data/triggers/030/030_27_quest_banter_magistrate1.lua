-- Trigger: quest_banter_magistrate1
-- Zone: 30, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3027

-- Converted from DG Script #3027: quest_banter_magistrate1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: quests quest assist help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quests") or string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "assist") or string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level < 30 then
    actor:send(tostring(self.name) .. " tells you, 'There is a temple just outside the West Gate")
    actor:send("</>of town, dedicated to the Kaaz clan, the great heroes of the Rift Wars.")
    actor:send("Mystics from all around Caelia go there hoping to find some kind of special")
    actor:send("</>power.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'It seems they found something.'")
else
    actor:send(tostring(self.name) .. " tells you, 'I fear that I have little time to banter, for")
    actor:send("</>as you can see, I must prepare our defenses for yet another attack.'")
end