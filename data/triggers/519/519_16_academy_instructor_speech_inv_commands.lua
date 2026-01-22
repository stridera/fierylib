-- Trigger: academy_instructor_speech_inv_commands
-- Zone: 519, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Large script: 6651 chars
--
-- Original DG Script: #51916

-- Converted from DG Script #51916: academy_instructor_speech_inv_commands
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: inventory wear equipment light remove get drop junk give put examine
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "inventory") or string.find(string.lower(speech), "wear") or string.find(string.lower(speech), "equipment") or string.find(string.lower(speech), "light") or string.find(string.lower(speech), "remove") or string.find(string.lower(speech), "get") or string.find(string.lower(speech), "drop") or string.find(string.lower(speech), "junk") or string.find(string.lower(speech), "give") or string.find(string.lower(speech), "put") or string.find(string.lower(speech), "examine")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("school:gear") == 16 then
    -- switch on speech
    if speech == "inventory" then
        actor:send(tostring(self.name) .. " tells you, 'You have two places you keep items:")
        actor:send("Your <b:cyan>(I)NVENTORY</> and your <b:cyan>(EQ)UIPMENT</>.")
        actor:send("</>")
        actor:send("Your <b:cyan>(I)NVENTORY</> is all the items you're currently carrying but not actively wearing or using.")
        actor:send("You must equip an item to receive benefits from it.'")
    elseif speech == "wear" then
        actor:send(tostring(self.name) .. " tells you, 'There are three commands to equip items:")
        actor:send("</><b:cyan>(WEA)R</>, <b:cyan>(WI)ELD</>, and <b:cyan>(HO)LD</>.")
        actor:send("</>")
        actor:send("<b:cyan>WEAR</> will equip something from your inventory.")
        actor:send("You can equip most objects by typing <b:cyan>WEAR [object]</>.")
        actor:send("Weapons can be equipped with either <b:cyan>WEAR</> or <b:cyan>WIELD</>.")
        actor:send("</><b:cyan>WEAR ALL</> will equip everything in your inventory at once.")
        actor:send("</>")
        actor:send("Some items can only be equipped with the <b:cyan>HOLD</> command.")
        actor:send("That includes instruments, wands, staves, magic orbs, etc.")
        actor:send("They will not be equipped with the <b:cyan>wear all</> command.")
        actor:send("Once you are holding them they can be activated with the <b:cyan>USE</> command.'")
    elseif speech == "equipment" then
        actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(EQ)UIPMENT</> command shows what gear you're using.")
        actor:send("You are gaining active benefits from these items.")
        actor:send("They will not show up in your inventory.'")
    elseif speech == "light" then
        actor:send(tostring(self.name) .. " tells you, 'Lights are necessary to see in dark spaces or outside at night.")
        actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
        actor:send("You can just type <b:cyan>light torch</> to light it up.")
        actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.")
        actor:send("</>")
        actor:send("Remember, most lights have a limited duration.")
        actor:send("It's best to turn them off when not using them.")
        actor:send("</>")
        actor:send("Lights don't have to be equipped for you to see.")
        actor:send("They work just fine from your inventory.'")
    elseif speech == "remove" then
        actor:send(tostring(self.name) .. " tells you, 'You can stop using items with <b:cyan>(REM)OVE [object]</>.'")
    elseif speech == "get" then
        actor:send(tostring(self.name) .. " tells you, 'During your adventures, you can pick up stuff using the <b:cyan>(G)ET</> command.'")
        actor:send("</>")
        actor:send(tostring(self.name) .. " tells you, 'If there's more than one thing with the same keyword in the room, you can target a specific one by adding a number and a \".\" before the keyword like \"2.stick\" or \"4.bread\".")
        actor:send("</>")
        actor:send("You can also pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
        actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
        actor:send("</>")
        actor:send("<b:cyan>GET</> is the command to take things out of containers.")
        actor:send("You can type <b:cyan>GET [object] [container]</> for one thing, or <b:cyan>GET ALL [container]</> to get everything out.'")
    elseif speech == "drop" then
        actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(DRO)P</> items in your inventory to get rid of them.")
        actor:send("Type <b:cyan>DROP [object]</> to drop them.")
        actor:send("You can also also drop everything with the same keywords by typing <b:cyan>DROP all.[object]</> or you can drop your whole inventory with <b:cyan>DROP ALL</>.")
        actor:send("</>")
        actor:send("Dropping items leaves them for others to pick up.'")
    elseif speech == "give" then
        actor:send(tostring(self.name) .. " tells you, 'Another way to deal with items is to <b:cyan>(GI)VE</> them away.")
        actor:send("You can do that by typing <b:cyan>GIVE [object] [person]</>.'")
    elseif speech == "junk" then
        actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(J)UNK</> command permanently destroys items in your inventory.")
        actor:send("You can drop and junk everything with the same keywords by typing <b:cyan>all.[object]</> as well.")
        actor:send("But <b:yellow>be careful</>!")
        actor:send("You might end up junking something with a surprising keyword by accident!'")
    elseif speech == "examine" then
        actor:send(tostring(self.name) .. " tells you, 'To see what's inside something, use the <b:cyan>(EXA)MINE</>.")
        actor:send("<b:cyan>EXAMINE [target]</> will also show if something is open or closed.")
        actor:send("You can check different bags by typing 2.bag, 3.bag, etc.'")
    elseif speech == "put" then
        actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(P)UT</> objects in containers to get them out of your inventory.")
        actor:send("The command is <b:cyan>PUT [object] [container]</>.")
        actor:send("After that use <b:cyan>(G)ET</> to take the item back out.")
        actor:send("You can type <b:cyan>GET [object] [container]</> to get a specific thing, or you can type <b:cyan>GET ALL [container]</> to get everything out of the container.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review anything else?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end