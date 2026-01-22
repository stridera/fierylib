-- Trigger: group_armor_forgemaster_receive
-- Zone: 590, ID: 46
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--   Large script: 12235 chars
--
-- Original DG Script: #59046

-- Converted from DG Script #59046: group_armor_forgemaster_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("group_armor")
-- switch on stage
if object.id == 6118 or object.id == 11704 or object.id == 11707 or object.id == 16906 then
    if actor.quest_variable["group_armor:" .. object.vnum] == 1 then
        if stage == 1 then
            _return_value = false
            self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
        else
            actor.name:set_quest_var("group_armor", "%object.vnum%", 1)
            wait(2)
            world.destroy(object.name)
            wait(2)
            self:say("Aye, this'll do.")
            local item1 = actor:get_quest_var("group_armor:6118")
            local item2 = actor:get_quest_var("group_armor:11704")
            local item3 = actor:get_quest_var("group_armor:11707")
            local item4 = actor:get_quest_var("group_armor:16906")
            if item1 and item2 and item3 and item4 then
                actor.name:advance_quest("group_armor")
                wait(2)
                self:say("That looks like everything!")
                self:emote("places the four objects near the altar.")
                wait(4)
                self:say("Bad news though.")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'The Haven was attacked by orcs from Bluebonnet Pass")
                self.room:send("</>while you were gone!'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Fortunately no one was killed, but I had to use")
                self.room:send("</>my consecrated forging hammer to defend myself.  It's no good for works of")
                self.room:send("</>holy creation now.'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Since I need to fix up the forge after the attack")
                self.room:send("</>would you be willing to find me another forging hammer?'")
            else
                local total = (item1 + item2 + item3 + item4)
                wait(2)
                if total <= 2 then
                    self:say("Do you have any of the other items?")
                elseif total == 3 then
                    self:say("Do you have the last one?")
                end
            end
        end
    else
        _return_value = false
        self:say(tostring(object.shortdesc) .. " doesn't cast Armor ya daffy spriggan!")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:command("laugh")
    end
    if object.id == 8701 then
    elseif stage == 2 then
        wait(2)
        self:emote("examines the hammer.")
        self:say("This will do!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'To consecrate the hammer again you'll need to")
        self.room:send("</>find a place where the light of the sun reaches deep into the bowels of")
        self.room:send("</>Ethilien and <b:white>[commune]</> with the spirits there.'")
        wait(2)
        self:command("give hammer " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Places where ore and stone are mined often become")
        self.room:send("</>sacred places for us dwarves.'")
        actor.name:advance_quest("group_armor")
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This isn't a forging hammer!")
    end
elseif stage == 3 then
    _return_value = false
    if object.id == 59039 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("Where did you find this?")
        wait(1)
        self:say("This can't be the same hammer you brought me before.")
    elseif object.id == 8701 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'You need to bring me the consecrated hammer.")
        self.room:send("</>Another mundane forging hammer is useless.'")
    end
    if object.id == 59039 then
    elseif stage == 4 then
        actor.name:advance_quest("group_armor")
        wait(2)
        world.destroy(object.name)
        wait(2)
        self:say("Moradin's flames, this is splendid!")
        wait(1)
        self.room:send(tostring(self.name) .. " gives the new hammer a few practice swings.")
        self:say("Aye, that's a fine hammer!")
        wait(3)
        self:say("Let us continue!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'This spell needs to be contained in a holy symbol of")
        self.room:send("</>some kind.  There is an amulet, an Aegis amulet, that would serve well for this")
        self.room:send("</>purpose.'")
        wait(3)
        self:say("Find it and bring it back here.")
    else
        _return_value = false
        self:say("What in the heck is this?")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
    if object.id == 12500 then
    elseif stage == 5 then
        wait(2)
        self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with a discerning glance.")
        world.destroy(object.name)
        wait(2)
        self:command("nod")
        self:say("Mmhmmm.  Mhmmm.")
        wait(1)
        self:say("Yes, this will be an excellent divine focus.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Finally, I need to capture the intangible protective")
        self.room:send("</>essence of ethereal armor to finish the amulet.  I know of three pieces:'")
        self.room:send("<b:white>a breastplate</>")
        self.room:send("<b:white>a ring</>")
        self.room:send("<b:white>a bracelet</>")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'See if you can find them.  Items like these are")
        self.room:send("</>often worn by the dead as they can interact with them.'")
        wait(2)
        self:say("Good luck and Moradin guard you!")
        actor.name:advance_quest("group_armor")
    else
        _return_value = false
        self:say("This won't be a very effective focus.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
    if object.id == 47004 or object.id == 47018 or object.id == 53003 then
        if actor.quest_variable["group_armor:" .. object.vnum] == 1 then
        elseif stage == 6 then
            _return_value = false
            self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
        else
            wait(2)
            actor.name:set_quest_var("group_armor", "%object.vnum%", 1)
            self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " near the altar.")
            world.destroy(object.name)
            wait(1)
            local item1 = actor:get_quest_var("group_armor:47004")
            local item2 = actor:get_quest_var("group_armor:47018")
            local item3 = actor:get_quest_var("group_armor:53003")
            if item1 and item2 and item3 then
                self:command("grin")
                self:say("With everything gathered, I can get to work!")
                wait(2)
                self.room:send(tostring(self.name) .. " lays the ethereal breastplate on the anvil.")
                wait(4)
                self.room:send(tostring(self.name) .. " thrusts his hammer into the forge.")
                self.room:send(tostring(self.name) .. " entones, 'Dwarffather, hear my prayer.'")
                wait(4)
                self.room:send(tostring(self.name) .. " raises the <b:red>glowing</> hamer.")
                wait(4)
                self.room:send(tostring(self.name) .. " entones, 'Bless my hammer in this act of Creation.'")
                wait(3)
                self.room:send("The hammer turns <b:white>white</> with holy energy.")
                wait(5)
                self.room:send(tostring(self.name) .. " brings the hammer down on the ethereal breastplate!")
                self.room:send("The breastplate ripples from the force of the hit like the surface of a lake struck by a drop of water.")
                wait(5)
                self:say("Now we add the extra magic!")
                wait(2)
                self.room:send(tostring(self.name) .. " grabs the broom and the hardened stick of leather.")
                self.room:send(tostring(self.name) .. " points them at the ethereal breastplate and releases their magic.")
                wait(4)
                self.room:send("The ethereal breastplate glows white-hot and starts to sizzle!")
                wait(4)
                self.room:send(tostring(self.name) .. " takes a pair of tongs and lays the ethereal bracelet on the radiating breastplate.")
                wait(5)
                self.room:send(tostring(self.name) .. " uncorks the violet potion and pours it over the breastplate.")
                self.room:send("The glow of the breastplate begins to seep into the bracelet!")
                wait(5)
                self:say("Let Creation ring throughout this hallowed forge!")
                wait(4)
                self.room:send(tostring(self.name) .. " strikes the ethereal metals again, melding the bracelet into the armor.")
                wait(4)
                self.room:send("The armor begins to decohere.")
                wait(5)
                self.room:send(tostring(self.name) .. " places the ethereal ring on the shifting energies.")
                self.room:send(tostring(self.name) .. " pours the green potion over the ring, which quickly dissolves.")
                wait(5)
                self.room:send(tostring(self.name) .. " strikes the ethereal mass over and over, chanting prayers to Moradin.")
                wait(5)
                self.room:send("The ethereal energies completely decohere!")
                self.room:send("The forge is filled with hot energy like a basin filled with water.")
                wait(5)
                self.room:send(tostring(self.name) .. " raises the Aegis amulet over his head.")
                wait(2)
                self:say("Soul Forger, let this amulet grant us Your protection!")
                wait(4)
                self.room:send("The Aegis amulet begins to <b:yellow>glow!</>")
                wait(4)
                self.room:send("All sound falls away as the radiant energies of the forge are absorbed into the amulet!")
                wait(4)
                self.room:send(tostring(self.name) .. " places the amulet on the forge anvil.")
                wait(4)
                self.room:send("With a final ceremonial blow, " .. tostring(self.name) .. " seals the protective energies into their new form!")
                wait(7)
                self.room:send("Slowly sound returns as the ringing of an anvil.")
                wait(2)
                self.room:send(tostring(self.name) .. " inspects the new holy amulet.")
                wait(2)
                self:say("Aye, our work is finished.  Thank you acolyte.")
                self:emote("bows and says, 'May the Dwarffather shield you ever more!'")
                wait(2)
                actor.name:complete_quest("group_armor")
                actor:send("You feel a stirring in your soul!")
                actor:send("<b:white>Moradin blesses you with the knowledge of Group Armor!</>")
                skills.set_level(actor.name, "group armor", 100)
            else
                self:say("Did ya find anything else?")
            end
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This isn't going to serve for Group Armor.")
    end
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What is this for?")
end
return _return_value