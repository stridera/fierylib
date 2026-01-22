-- Trigger: mage_speak2
-- Zone: 238, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23812

-- Converted from DG Script #23812: mage_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: question? question ice? ice
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "question?") or string.find(string.lower(speech), "question") or string.find(string.lower(speech), "ice?") or string.find(string.lower(speech), "ice")) then
    return true  -- No matching keywords
end
-- Start the quest and give the Tempest a blue flame
if not world.count_mobiles("23803") then
    get_room(238, 90):at(function()
        self.room:spawn_mobile(238, 3)
    end)
end
if world.count_mobiles("23803") then
    get_room(238, 90):at(function()
        run_room_trigger(23813)
    end)
end
wait(1)
self:command("nod")
wait(2)
self:say("It is surely the revenge of the elemental that Lord Dargentan keeps imprisoned here.  The Tempest Manifest ensures that the Keep stays afloat, but such creatures are never happy about being kept in servitude.")
wait(1)
self:emote("thinks a moment.")
wait(2)
self:say("Such beings can never truly be destroyed, but perhaps if you banished his form from this realm for a while, the ice would clear up and the question would become visible.")
wait(2)
self:emote("nods confidently.")
self:say("Yes, perhaps that would be best.  If you would destroy the Tempest's mortal form and return to me with the remains, perhaps we could find the answer to this riddle.")
wait(1)
self:command("frown")
wait(2)
self:say("But just in case I have not found all the correct clues, be sure to look for them throughout the keep.")
self:emote("points to a gently glowing inscribed pentagram.")
wait(1)
self:say("Look at the pentagrams scattered around.  I believe there are fifteen of them.  You will need to look at all of them to get the clues.")
wait(2)
self:command("bow " .. tostring(actor.name))
self:say("Good luck, and thank you for helping!")