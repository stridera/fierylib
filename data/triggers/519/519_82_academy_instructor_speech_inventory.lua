-- Trigger: academy_instructor_speech_inventory
-- Zone: 519, ID: 82
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51982

-- Converted from DG Script #51982: academy_instructor_speech_inventory
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gear"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 1 then
    if actor:get_quest_var("school:gear") ~= "complete" then
        if (actor:get_quest_var("school:speech") and actor:get_quest_var("school:speech") ~= "complete") or (actor:get_quest_var("school:explore") and actor:get_quest_var("school:explore") ~= "complete") then
            actor:send(tostring(self.name) .. " tells you, 'You have to finish your other lesson first.'")
            return true
        end
        if actor:get_quest_var("school:gear") then
            actor:send(tostring(self.name) .. " tells you, 'Let's resume your <b:yellow>GEAR</> lessons.'")
        end
        -- switch on actor:get_quest_var("school:gear")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_var("school:gear") or ""))
            if tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'In order to gain benefits from items, you have to equip them.'")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'There are three commands to equip items:")
                actor:send("<b:cyan>(WEA)R</>, <b:cyan>(WI)ELD</>, and <b:cyan>(HO)LD</>.'</>")
                -- (empty send to actor)
                actor:send("<b:cyan>WEAR</> will equip something from your inventory.")
                actor:send("You can equip most objects by typing <b:cyan>WEAR [object]</>.")
                actor:send("Weapons can be equipped with either <b:cyan>WEAR</> or <b:cyan>WIELD</>.")
                actor:send("<b:cyan>WEAR ALL</> will equip everything in your inventory at once.")
                -- (empty send to actor)
                actor:send("Some items can only be equipped with the <b:cyan>HOLD</> command.")
                actor:send("That includes instruments, wands, staves, magic orbs, etc.")
                actor:send("They will not be equipped with the <b:cyan>WEAR ALL</> command.")
                actor:send("Once you are holding them they can be activated with the <b:cyan>USE</> command.")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Go ahead and type <b:green>wear all</> and see what happens.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(EQ)UIPMENT</> command shows what gear you're using.")
                actor:send("You are gaining active benefits from these items.")
                actor:send("They will not show up in your inventory.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>equipment</> or just <b:green>eq</> to try it out.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " tells you, 'Another way to equip things is with the <b:cyan>(HO)LD</> command.")
                actor:send("Here, take this torch for example.'")
                self.room:spawn_object(0, 23)
                self:command("give torch " .. tostring(actor))
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold torch</> to equip it.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(LI)GHT</> command turns lights on and off.")
                actor:send("You can just type <b:cyan>light torch</> to light it up.")
                actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Give it a try and type <b:green>light torch</>.'</>")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " tells you, 'Remember, most lights have a limited duration.")
                actor:send("It's best to turn them off when not using them.")
                actor:send("</>")
                actor:send("Lights don't have to be equipped for you to see.")
                actor:send("They work just fine from your inventory.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'You can stop using items by typing <b:cyan>REMOVE [object]</>.'")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " tells you, 'Stop wearing that torch by typing <b:green>remove torch</>.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " tells you, 'During your adventures, you can pick up stuff using the <b:cyan>(G)ET</> command.'")
                wait(1)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self:command("drop all.stick")
                actor:send(tostring(self.name) .. " tells you, 'Pick up one of those sticks by typing <b:green>get stick</>.'")
            elseif tonumber(_sw1) == 8 then
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self:command("drop all.stick")
                actor:send(tostring(self.name) .. " tells you, 'If you don't want to pick up the first one, you can target a different one by adding a number and a \".\" before the name.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>get 2.stick</> and see what happens.'")
            elseif tonumber(_sw1) == 9 then
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self:command("drop all.stick")
                actor:send(tostring(self.name) .. " tells you, 'You can pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
                actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
                actor:send("That will pick up everything in the room.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>get all</> with nothing after it.'")
            elseif tonumber(_sw1) == 10 then
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self.room:spawn_object(519, 2)
                self:command("give all.stick " .. tostring(actor))
                actor:send(tostring(self.name) .. " tells you, 'Now it's possible your inventory might get full.")
                actor:send("You can only carry so many items in your inventory at once but there are a few ways to deal with that.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'First, you can <b:cyan>(DRO)P</> items with the command <b:cyan>DROP [object]</>.'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " tells you, 'Drop one of those sticks by typing <b:green>drop stick</>.'")
            elseif tonumber(_sw1) == 11 then
                actor:send(tostring(self.name) .. " tells you, 'You can permanently destroy objects with the <b:cyan>(J)UNK</> command.'</>")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Try junking a stick by typing <b:green>junk stick</>.'</>")
            elseif tonumber(_sw1) == 12 then
                actor:send(tostring(self.name) .. " tells you, 'Another way to deal with items is to <b:cyan>(GI)VE</> them away.")
                actor:send("You can do that by typing <b:cyan>GIVE [object] [person]</>.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Give me a stick by typing <b:green>give stick instructor</>.'")
            elseif tonumber(_sw1) == 13 then
                actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(P)UT</> objects in containers.")
                actor:send("The command is <b:cyan>PUT [object] [container]</>.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'You started with a bag.")
                actor:send("Put a stick in it by typing <b:green>put stick bag</>.'")
            elseif tonumber(_sw1) == 14 then
                actor:send(tostring(self.name) .. " tells you, 'To see what's inside something, use <b:cyan>(EXA)MINE [target]</>.")
                actor:send("<b:cyan>EXAMINE</> will also show if something is open or closed.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Go ahead and <b:green>examine bag</> and see what you find.'")
            elseif tonumber(_sw1) == 15 then
                actor:send(tostring(self.name) .. " tells you, 'You can type <b:cyan>GET [object] [container]</> to take one thing out of a container, or <b:cyan>GET ALL [container]</> to get everything out.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Take a stick out of a bag by typing <b:green>get stick bag</>.'")
            elseif tonumber(_sw1) == 16 then
                actor:send(tostring(self.name) .. " tells you, 'Would you like to review equipment management?")
                actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
            else
                actor:set_quest_var("school", "gear", 1)
                actor:send(tostring(self.name) .. " tells you, 'Then let's talk about <b:yellow>GEAR</>!'")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Your <b:cyan>(I)NVENTORY</> is all the items you're currently carrying but not actively wearing or using.")
                actor:send("You do not gain any bonuses from items in your inventory.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'Type <b:green>inventory</> or just <b:green>i</> to check what you currently have.")
                actor:send("Go ahead and try it out!'</>")
            end
        end
    end
end