-- Trigger: Ill-subclass: Invasion illusion ***NOT USED***
-- Zone: 363, ID: 9
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #36309

-- Converted from DG Script #36309: Ill-subclass: Invasion illusion ***NOT USED***
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(3)
zone.echo(self.room.zone_id, "<magenta>The scent of magic is discernable, as a spell builds.</>")
self.room:send("<magenta>The scent of magic is discernable, as a spell builds.</>")
wait(7)
zone.echo(self.room.zone_id, "<magenta>The magical force is still spreading, and remains low-key.</>")
self.room:send("<magenta>The magical force is still spreading, and remains low-key.</>")
wait(7)
zone.echo(self.room.zone_id, "<magenta>A spell seems to be coming together.  Slowly, it builds.</>")
self.room:send("<magenta>A spell seems to be coming together.  Slowly, it builds.</>")
wait(5)
zone.echo(self.room.zone_id, "<magenta>Something supernatural is beginning to coalesce - and the sounds of a militant</>")
zone.echo(self.room.zone_id, "</><magenta>crowd are beginning to rise above the threshold of hearing.</>")
self.room:send("<magenta>Something supernatural is beginning to coalesce - and the sounds of a militant</>")
self.room:send("</><magenta>crowd are beginning to rise above the threshold of hearing.</>")
wait(7)
zone.echo(self.room.zone_id, "<b:white>Suddenly, a shout is heard!  It is joined by others, and the sounds of battle commence!</>")
self.room:send("<b:white>Suddenly, a shout is heard!  It is joined by others, and the sounds of battle commence!</>")
wait(2)
-- Now, if Gannigan and the quester are in here, Gannigan should react accordingly.
local gannigan = 0
local quester = 0
local person = self.people
while person do
    if person.id == 36301 then
        local gannigan = person
    elseif person.id == -1 and person:get_quest_stage("illusionist_subclass") > 1 then
        local quester = person
    end
    local person = person.next_in_room
end
if quester and gannigan then
    if quester:get_quest_stage("illusionist_subclass") == 2 then
        self.room:send("Test 3")
        gannigan:say("What?!  They attack?  Can Mielikki have gone mad?")
        wait(2)
        gannigan:say("Cestia, you must hide.  Do you recall the incantation?")
        gannigan:say("The one that will reveal the passage above the falls?")
        quester.name:advance_quest("illusionist_subclass")
        quester.name:advance_quest("illusionist_subclass")
    elseif quester:get_quest_stage("illusionist_subclass") == 3 then
        gannigan:say("An attack?  Cestia!  What have you done?  It is betrayal!")
        wait(2)
        gannigan:command("glare " .. tostring(quester.name))
        wait(2)
        gannigan:say("You will not destroy me.  But I cannot bring myself to raise my sword against you.")
        quester.name:advance_quest("illusionist_subclass")
        quester.name:advance_quest("illusionist_subclass")
    end
end