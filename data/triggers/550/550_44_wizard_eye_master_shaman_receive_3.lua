-- Trigger: Wizard Eye Master Shaman receive 3
-- Zone: 550, ID: 44
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55044

-- Converted from DG Script #55044: Wizard Eye Master Shaman receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("wizard_eye")
if stage == 8 then
    wait(2)
    actor.name:advance_quest("wizard_eye")
    world.destroy(object.name)
    self:emote("smells the cinnamon-rose blend.")
    actor:send(tostring(self.name) .. " says, 'Ahhh, what a gorgeous fragrance!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Cinnamon and rose both open the third eye andincrease psychic awareness.  And I would never have thought to use powdered sapphire in an incense.  Very clever.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I shall put this with the other necessaries.'")
    actor:send(tostring(self.name) .. " tucks the incense away in her chamber.")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'It looks like you have everything prepared.  Now for the most difficult part.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I have been scrying on my cauldron to determine the final steps of your journey.  I believe I have located <b:yellow>four potential orbs</> to serve as your crystal ball.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Unfortunately, I'm not sure which of the four will be best suited to you:")
    actor:send("</>")
    actor:send("</>- First is a simple <b:yellow>quartz ball</>.")
    actor:send("</>  But be careful!  It is in the possession of a priest of Blackmourne in Anduin, and they are as dangerous as they are homicidal.")
    actor:send("</>")
    actor:send("</>- Second is an <b:yellow>orb of pure Chaos</>.")
    actor:send("</>  It is kept by the Beast of Borgan, which dwells in the Layveran Labyrinth in the Black Ice Desert.")
    actor:send("</>")
    actor:send("</>- Third is the <b:yellow>Orb of Catastrophe</>.")
    actor:send("</>  Cyprianum the Reaper, the ruler of Demise Keep in the Syric Mountains lays claim to that one.")
    actor:send("</>")
    actor:send("</>- Fourth is a <b:yellow>glass globe</> which controls the flow of time.")
    actor:send("</>  The mysterious Time Elemental Lord, stranded in Frost Valley after the Time Cataclysm, carries this one.'")
    wait(6)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Gather all four and bring them to the Oracle of Justice</> at our sister pyramid in the ancient forest near Anduin.  Only he can tell you which is best for you.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Once the proper choice has been determined, bring the final selection back to me.  I will lead you through the full casting process.'")
end