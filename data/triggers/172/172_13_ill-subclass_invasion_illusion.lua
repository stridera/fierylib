-- Trigger: Ill-subclass: Invasion illusion
-- Zone: 172, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Plays the magical-invasion echoes across zone 363. If Gannigan (363:1)
-- and a mid-quest player are both in this room, Gannigan reacts to the
-- "raid" - panicked at stage 2 (player kept the disguise intact) or
-- furious at stage 3 (player was spotted dropping the vial). Either way
-- the quest jumps two stages.
--
-- Original DG Script: #17213

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

local gannigan = nil
local quester = nil
local person = self.people
while person do
    if person.zone_id == 363 and person.local_id == 1 then
        gannigan = person
    elseif person.is_player and person:get_quest_stage("illusionist_subclass") > 1 then
        quester = person
    end
    person = person.next_in_room
end

if not (quester and gannigan) then
    return true
end

local stage = quester:get_quest_stage("illusionist_subclass")
if stage == 2 then
    gannigan:say("What?!  They attack?  Can Mielikki have gone mad?")
    wait(2)
    gannigan:say("Cestia, you must hide!")
    wait(2)
    gannigan:say("Do you recall the incantation?  The one that will reveal the passage above the falls?")
    quester:advance_quest("illusionist_subclass")
    quester:advance_quest("illusionist_subclass")
elseif stage == 3 then
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
    quester:advance_quest("illusionist_subclass")
    quester:advance_quest("illusionist_subclass")
end