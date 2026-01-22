-- Trigger: Monk Subclass progress journal
-- Zone: 4, ID: 63
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #463

-- Converted from DG Script #463: Monk Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local monkraces = "none"
    if string.find(arg, "Monk") and string.find(actor.class, "Warrior") and actor.level <= 25 and not (string.find(monkraces, "actor.race")) then
        _return_value = false
        actor:send("<yellow>Monk</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(51, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("monk_subclass") then
            actor:send(tostring(mobiles.template(51, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("monk_subclass")
            if actor:get_quest_stage("monk_subclass") == 1 then
                actor:send("It is wonderful to hear of others wanting to join the Brotherhood of the Monks._")
                actor:send("You will be rewarded for your success with wonderful training, but only those pure of mind will complete the quest.")
            elseif actor:get_quest_stage("monk_subclass") == 2 then
                actor:send("Usually people come in here promising me the return of something long lost of mine.")
                actor:send("The thing is, I have not always lead this life.  When I was young I was quite the rabble-rouser._")
                actor:send("Well, it is rather embarrassing, but...  I miss my old sash, and I want it back._")
                actor:send("I was told it looked wonderful on me._")
                actor:send(tostring(actor.name) .. ", can you recover it?_")
                actor:send("Please?_")
                actor:send("Long ago some ruthless fiends made off with it.")
            elseif actor:get_quest_stage("monk_subclass") == 3 or actor:get_quest_stage("monk_subclass") == 4 then
                actor:send("Have you recovered my sash from those thieves out west?_")
                actor:send("If you return my sash, I will complete your initiation as a monk.")
            end
        end
    end
end
return _return_value