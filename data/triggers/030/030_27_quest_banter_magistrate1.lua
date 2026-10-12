-- Trigger: quest_banter_magistrate1
-- Zone: 30, ID: 27
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3027

-- Converted from DG Script #3027: quest_banter_magistrate1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quests", "quest", "assist", "help"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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