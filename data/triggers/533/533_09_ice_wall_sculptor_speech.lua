-- Trigger: ice_wall_sculptor_speech
-- Zone: 533, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53309

-- Converted from DG Script #53309: ice_wall_sculptor_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Yes okay wall? How? Ice? supplies? ice supplies how
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "wall?") or string.find(string.lower(speech), "how?") or string.find(string.lower(speech), "ice?") or string.find(string.lower(speech), "supplies?") or string.find(string.lower(speech), "ice") or string.find(string.lower(speech), "supplies") or string.find(string.lower(speech), "how")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("wall_ice") == 0 then
    if string.find(actor.class, "Cryomancer") and actor.level > 56 then
        actor.name:start_quest("wall_ice")
        if actor.gender == "female" then
            self:say("Thank you so much ma'am!")
        elseif actor.gender == "male" then
            self:say("Thank you so much sir!")
        else
            self:say("Thank you so much!")
        end
        wait(1)
        self:say("What I need are blocks of living ice.  Using Wall of Ice I can fuse them together so they make a permanent barrier.  I chewed through my stock pile of living ice faster than I anticipated, so I need more.")
        wait(2)
        self:emote("writes some notes down on a piece of paper.")
        self.room:spawn_object(533, 26)
        self:command("give notes " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'This spell has a chance to capture animated energies of ice creatures in their remains.  Have the spell on you and say <b:cyan>'crystalize'</> in the presence of an ice creature before you defeat it.'")
        wait(4)
        self:say("The more powerful the creature, the more likely this spell will create a block of living ice from it.  But be careful, it only works on creatures actually made of ice!!")
        wait(4)
        self:say("Though there are a number of ice creatures in Frost Valley, any ice creature is fine.  I need 20 more blocks to finish this wall.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'You can check your <b:white>[spell progress]</> at any time.'")
    elseif actor:get_quest_stage("wall_ice") == 1 then
        self:say("Hand 'em on over then!")
    end
end