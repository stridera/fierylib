-- Trigger: Dancer_quest_ASK2
-- Zone: 584, ID: 13
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58413

-- Converted from DG Script #58413: Dancer_quest_ASK2
-- Original: MOB trigger, flags: SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
-- This is to confirm the quest and advance more
if actor.id == -1 then
    if actor:get_quest_stage("major_spell_quest") == 1 then
        wait(1)
        actor:send(tostring(self.name) .. " says to you, 'Oh thank you!'")
        actor:send(tostring(self.name) .. " says to you, 'You must gain the princes favor..'")
        actor:send(tostring(self.name) .. " says to you, 'then maybe he will give me to you so you can set me free.'")
        self.room:send_except(actor, tostring(self.name) .. " whispers something to " .. tostring(actor.name))
        actor.name:advance_quest("major_spell_quest")
        -- this sets the player to level 2 in the quest
        wait(5)
        self.room:find_actor("prince"):say("Hey, what are you talking to them about?!")
        self.room:find_actor("prince"):command("sigh")
        wait(2)
        self.room:find_actor("prince"):say("You can't get good help now days...")
    else
    end
else
end