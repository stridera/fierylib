-- Trigger: heavens_gate_starlight_greet
-- Zone: 133, ID: 25
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #13325

-- Converted from DG Script #13325: heavens_gate_starlight_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
local stage = actor:get_quest_stage("heavens_gate")
-- (empty send to actor)
actor:send("<b:white>Soft starlight glitters throughout the cavern in welcome as you enter.</>")
if string.find(actor.class, "Priest") and actor.level > 80 then
    if stage == 0 then
        -- (empty send to actor)
        actor:send("<b:white>A strange light glints off a strange rock formation near the center of the cavern.</>")
        if world.count_objects("13350") == 0 then
            self.room:spawn_object(133, 50)
        end
    elseif stage == 1 then
        if world.count_objects("13350") == 0 then
            self.room:spawn_object(133, 50)
        end
        actor:send("<b:white>" .. tostring(self.name) .. " coalesces into the ephemeral shape of a bent old woman, standing before the rock formation.</>")
        actor:send("<b:white>Swirling stars form the shape of a bowl in her hands, which she puts on the rock pedestal.</>")
        -- (empty send to actor)
        actor:send("<b:white>The crone invites you to <b:cyan>[commune] <b:white>for visions of your progress.</>")
    elseif stage == 2 then
        if world.count_objects("13350") == 0 then
            self.room:spawn_object(133, 50)
        end
        actor:send("<b:white>The floating apparition of a valiant young knight constructed from starbeams hovers over the pedestal.</>")
        actor:send("<b:white>He seems to invite you to <b:cyan>[put] <b:white>something on the <b:white>[pedestal]<b:white>.</>")
        -- (empty send to actor)
        actor:send("<b:white>The knight invites you to <b:cyan>[commune] <b:white>for visions of your progress.</>")
    elseif stage == 3 then
        actor:send("<b:white>A starry serpent slithers through the rocky cavern.</>")
        actor:send("<b:white>It looks at you with expectant, curious eyes.</>")
        -- (empty send to actor)
        actor:send("<b:white>The serpent invites you to <b:cyan>[commune] <b:white>for visions of your progress or a new Key.</>")
    elseif stage == 4 then
        wait(1)
        actor:send("<b:white>The starlight manifests as the heavenly raven again.</>")
        wait(2)
        actor:send("This time, at last, it speaks:_")
        actor:send("<b:cyan>'I I I I am the book.  Open me prophet; read; decypher.</>")
        actor:send("<b:cyan>On you, in you, in your blood, they write, have written.</>")
        actor:send("<b:cyan>Speak it but aloud to know the path of heaven for I I I I am the final key.</>")
        actor:send("<b:cyan>I I I I have shown you visions, and through me you shall read.'</>")
        -- (empty send to actor)
        actor:send("<yellow>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
    end
end