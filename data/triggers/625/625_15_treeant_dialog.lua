-- Trigger: treeant dialog
-- Zone: 625, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #62515

-- Converted from DG Script #62515: treeant dialog
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"pests", "pest", "trees"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("growl")
self.room:send(tostring(self.name) .. " says, 'In the Month of the Stranger I first started seeing the feral")
self.room:send("</>dogs.  They make tunnels under the trees to eat their roots.'")
wait(1)
self:command("mutter")
self.room:send(tostring(self.name) .. " says, 'I'd like to tear them out of there and...  But I can't get to")
self.room:send("</>them.  If you kill them all, and bring me their pelts...  I'll make it worth")
self.room:send("</>your time.'")
self:command("wink")