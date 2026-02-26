-- Trigger: quest_relocate_receive
-- Zone: 492, ID: 54
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: sta
--   Complex nesting: 9 if statements
--   Large script: 7784 chars
--
-- Original DG Script: #49254

-- Converted from DG Script #49254: quest_relocate_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- edit 3-7-2021 by Daedela: Acerites code was throwing errors because of the logic flow.
-- It worked when the questor did exactly as told, but deviating risked system failure.
-- The quest is identical, but the logic has been completely re-written to eliminate the errors.
-- Comments about Acerites hatred of ampersands is preserved for posterity and the previous code is logged on the Wiki.
local stage = actor:get_quest_stage("relocate_spell_quest")
if stage == 1 then
    if object.id == 49250 then
        wait(1)
        self:destroy_item("mystics")
        self.room:send("A lost mage examines the Druidstaff carefully.")
        wait(1)
        self:command("glare " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'No no, it is of no use to me unless you destroy the druid")
        self.room:send("</>YOURSELF!  Try again.'")
        wait(1)
        self:command("frown")
    end
elseif stage == 2 then
    if object.id == 49250 then
        wait(2)
        actor.name:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Excellent, thank you! Thank you!'")
        wait(10)
        self:command("hold mystics")
        wait(10)
        actor:send("A lost mage tells you, 'Ok, the next thing required is the Crystal")
        actor:send("</>Telescope.  An observer of the cold village holds it, but you must not harm")
        actor:send("</>him.  Convince him to give it to you, then bring it back to me.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(20)
        actor:send("A lost mage tells you, 'Go now, I must start with the staff!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 4 then
    if object.id == 49252 then
        wait(1)
        self:destroy_item("telescope")
        self.room:send("A lost mage examines the telescope carefully.")
        wait(1)
        self:command("frown " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'How did you get this? There's something missing here.")
        self.room:send("</>You must earn this properly. Go NOW!'")
    end
elseif stage == 5 then
    if object.id == 49252 then
        wait(2)
        actor.name:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Yes, yes! Thank you!")
        wait(10)
        self:command("hold telescope")
        wait(10)
        actor:send("A lost mage tells you, 'Ok ok, you've done well, the next item I need is the")
        actor:send("</>spellbook.'")
        wait(20)
        actor:send("A lost mage tells you, 'But not just any spellbook.  This one is held deep")
        actor:send("</>inside a very powerful tower.  To find the tower you must look within the")
        actor:send("</>destroyed land.  That is all I can say.  Go now!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 6 then
    if object.id == 12520 then
        actor.name:advance_quest("relocate_spell_quest")
        actor:save()
        wait(2)
        actor:send("A lost mage tells you, 'Perfect! Only two items left!'")
        wait(10)
        self:command("rem mystics")
        self:destroy_item("mystics")
        self:command("hold spellbook")
        wait(10)
        actor:send("A lost mage tells you, 'There is something I need from South Caelia.  I don't")
        actor:send("</>know the area well, but I know someone who does.  I once met a man that mapped")
        actor:send("</>everything he saw.  Please get me his map.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(10)
        self:command("ponder")
        wait(10)
        actor:send("A lost mage tells you, 'I think he said something about the ocean and the")
        actor:send("</>beach, that's all I know.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 7 then
    if object.id == 58608 then
        actor.name:advance_quest("relocate_spell_quest")
        wait(2)
        actor:send("A lost mage tells you, 'Almost there, one more!'")
        wait(10)
        self:command("rem telescope")
        self:destroy_item("telescope")
        self:command("hold map")
        wait(10)
        actor:send("A lost mage tells you, 'The only thing left that I need is something to write")
        actor:send("</>with.  A while back I dropped something while engaged in a little confrontation")
        actor:send("</>with that witch Baba.  Luckily, I don't think she saw me drop it, so it should")
        actor:send("</>still be hidden around there.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(4)
        self:command("sigh")
        wait(1)
        actor:send("A lost mage tells you, 'Please get my quill back, then I shall share the spell")
        actor:send("</>with you!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        run_room_trigger(49225)
    end
elseif stage == 8 then
    if object.id == 49251 then
        wait(1)
        self.room:send("A lost mage examines the golden quill.")
        wait(1)
        self:command("sigh")
        self.room:send(tostring(self.name) .. " says, 'You did not get this yourself.  Unfortunately this is a")
        self.room:send("</>problem, as now that another has touched this it has lost its power.'")
        self:command("frown")
    end
elseif stage == 9 then
    if object.id == 49251 then
        wait(20)
        actor:send("A lost mage tells you, 'Excellent, Thank you so much, please wait while I")
        actor:send("</>scribe my spell!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(1)
        self:command("sit")
        self:command("rem map")
        self:destroy_item("map")
        self:command("hold quill")
        self.room:send("A lost mage puts on her spectacles and begins to scribe.")
        wait(20)
        self.room:send("A lost mage puts away her spectacles and stops scribing.")
        -- UNCONVERTED: sta
        self:command("fly")
        wait(1)
        actor:send("A lost mage tells you, 'Very well, I'm done!  Thank you so much,")
        actor:send("</>" .. tostring(actor.name) .. "!'")
        wait(20)
        actor:send("A lost mage tells you, 'And, as I promised, here is the spell!'")
        actor:send("A lost mage shows you the spell scribed in her spellbook.")
        skills.set_level(actor.name, "relocate", 100)
        actor.name:complete_quest("relocate_spell_quest")
        self.room:send_except(actor, "A lost mage shows " .. tostring(actor.name) .. " her spellbook, teaching " .. tostring(actor.possessive) .. " her secrets.")
        wait(20)
        self.room:send("A lost mage starts casting <b:yellow>'relocate'</>...")
        wait(15)
        self.room:send("<b:white>A lost mage's molecules loosen and eventually dissipate into thin air.</>")
        self:teleport(get_room(492, 99))
        world.destroy(self.room:find_actor("self"))
    end
else
    _return_value = false
    wait(2)
    actor:send("A lost mage tells you, 'This item doesn't help me.'")
    actor:send("A lost mage returns your item.")
    self.room:send_except(actor, "A lost mage returns " .. tostring(actor.name) .. "'s item.")
end
return _return_value