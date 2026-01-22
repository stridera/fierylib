-- Trigger: quest_relocate_speak_items
-- Zone: 492, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49252

-- Converted from DG Script #49252: quest_relocate_speak_items
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: items
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "items")) then
    return true  -- No matching keywords
end
wait(2)
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and (actor.class > 64) then
    actor:send("A lost mage asks you, 'Yes, please get me the items I need to get out of here!")
    actor:send("</>Do this for me and I'll share this great spell with you.'")
    self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    self:command("wink " .. tostring(actor.name))
    wait(10)
    self.room:send("A lost mage begins taking inventory of the items she needs.")
    wait(10)
    actor:send("A lost mage tells you, 'The first item I need...  A great mage once created a")
    actor:send("</>very powerful staff, but the druids stole it!'")
    wait(10)
    actor:send("A lost mage tells you, 'The first item I'll need will be the Staff of the")
    actor:send("</>Mystics.  That druid, having angered the mage, fled as far as he could go, all")
    actor:send("</>the way past the Vale of Anlun.'")
    wait(2)
    actor:send("A lost mage tells you, 'If you need to remember your <b:white>[progress]</> you can'")
    actor:send("</>come back and check with me.'")
    self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    wait(10)
    actor:send("A lost mage tells you, 'Please go, go get me the staff I require!'")
    actor.name:start_quest("relocate_spell_quest")
end