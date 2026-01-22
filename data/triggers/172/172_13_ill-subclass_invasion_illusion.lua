-- Trigger: Ill-subclass: Invasion illusion
-- Zone: 172, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #17213

-- Converted from DG Script #17213: Ill-subclass: Invasion illusion
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
zone.echo(363, "<magenta>The scent of magic is discernible, as a spell builds.</>")
wait(5)
zone.echo(363, "<magenta>The magical force is still spreading, and remains low-key.</>")
wait(3)
zone.echo(363, "<magenta>A spell seems to be coming together.  Slowly, it builds.</>")
wait(3)
zone.echo(363, "<magenta>Something supernatural is beginning to coalesce - and the sounds of a militant</>_")
zone.echo(363, "</><magenta>crowd are beginning to rise above the threshold of hearing.</>")
wait(3)
zone.echo(363, "<b:white>Suddenly, a shout is heard!</>_")
zone.echo(363, "<b:white>It is joined by others, and the sounds of battle commence!</>")
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
        gannigan:say("What?!  They attack?  Can Mielikki have gone mad?")
        wait(2)
        gannigan:say("Cestia, you must hide!")
        wait(2)
        gannigan:say("Do you recall the incantation?  The one that will reveal the passage above the falls?")
        quester.name:advance_quest("illusionist_subclass")
        quester.name:advance_quest("illusionist_subclass")
    elseif quester:get_quest_stage("illusionist_subclass") == 3 then
        gannigan:say("An attack?  Cestia!  What have you done?  It is betrayal!")
        wait(2)
        gannigan:command("glare " .. tostring(quester.name))
        wait(2)
        gannigan:say("You will not destroy me.")
        wait(2)
        gannigan:emote("raises his sword in anger!")
        wait(1)
        gannigan:emote("hesitates.")
        wait(3)
        gannigan:say("But I cannot bring myself to raise my sword against you.")
        quester.name:advance_quest("illusionist_subclass")
        quester.name:advance_quest("illusionist_subclass")
    end
end