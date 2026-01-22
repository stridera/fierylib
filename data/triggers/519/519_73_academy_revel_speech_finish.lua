-- Trigger: academy_revel_speech_finish
-- Zone: 519, ID: 73
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51973

-- Converted from DG Script #51973: academy_revel_speech_finish
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: finish
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "finish")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 6 then
    actor:complete_quest("school")
    if actor.level == 1 then
        -- switch on actor.class
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            local goal = 6323
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "bard" then
            local goal = 6599
        elseif actor.class == "monk" or actor.class == "necromancer" then
            local goal = 7149
        elseif actor.class == "warrior" or actor.class == "berserker" then
            local goal = 6049
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" or actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" then
        else
            local goal = 5499
        end
        local cap = (goal / 5)
        local reward = (goal - actor.exp)
        local loops = (reward / cap)
        local diff = (reward - (loops * cap))
        local lap = 1
        while lap <= loops do
            actor:award_exp(cap)
            local lap = lap + 1
        end
        actor:award_exp(diff)
        -- switch on actor.class
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "warrior" or actor.class == "monk" or actor.class == "berserker" or actor.class == "paladin" then
            local direction = "the Warrior's Guild"
            local direction2 = "south&_ south&_ south&_ east&_ east&_ north&_ east&_ north&_"
            local master = "Warrior Coach"
        elseif actor.class == "rogue" or actor.class == "thief" or actor.class == "mercenary" or actor.class == "assassin" or actor.class == "bard" then
            local direction = "the Rogue's Guild"
            local direction2 = "south&_ south&_ south&_ west&_ south&_ east&_ down&_"
            local master = "the Master Rogue"
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
            local direction = "the Mage's Guild"
            local direction2 = "south&_ south&_ south&_ west&_ west&_ south&_ south&_ east&_"
            local master = "the Archmage"
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "druid" or actor.class == "diabolist" then
            local direction = "the Cleric's Guild"
            local direction2 = "west&_ north&_"
            local master = "the High Priestess"
        else
            self:say("Oops, you broke, find a god.")
            return _return_value
        end
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Now that you're ready to level, it's time to find your Guild Master!")
        actor:send("They are waiting in your guild's Inner Sanctum, just beyond the entrance room to your guild.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>Look</> at the <b:cyan>map</> in your inventory.")
        actor:send("It will show you a layout of town.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:green>East</> is the Forest Temple of Mielikki.")
        actor:send("Your guild is <b:magenta>" .. tostring(direction) .. "</>.")
        actor:send("From the Temple of Mielikki it is:")
        actor:send("<b:yellow> " .. tostring(direction2) .. "</>")
        actor:send("Your Guild Master is <b:magenta>" .. tostring(master) .. "</>.")
        actor:send("</>")
        actor:send("Type <b:cyan>LEVEL</> when you find them to advance to the next level.")
        actor:send("You won't be able to gain any more experience until you do!")
        actor:send("If you ever forget anything you can always consult the <b:cyan>HELP</> file.'")
        wait(3)
    end
    actor:send(tostring(self.name) .. " tells you, 'Your Guild Master here in the Town of Mielikki will grant you your first quest.")
    actor:send("They will ask you for <b:yellow>gems</> and <b:yellow>armor</> which drop randomly from creatures across the world.")
    actor:send("Bring back what they ask for and you'll be well rewarded!'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'Congratulations again, graduate!  May you climb to ever greater fortune!'")
end