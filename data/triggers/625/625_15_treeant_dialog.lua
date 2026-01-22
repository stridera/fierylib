-- Trigger: treeant dialog
-- Zone: 625, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #62515

-- Converted from DG Script #62515: treeant dialog
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: pests pest trees
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "pests") or string.find(string.lower(speech), "pest") or string.find(string.lower(speech), "trees")) then
    return true  -- No matching keywords
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