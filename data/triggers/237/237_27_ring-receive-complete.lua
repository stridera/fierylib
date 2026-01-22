-- Trigger: ring-receive-complete
-- Zone: 237, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23727

-- Converted from DG Script #23727: ring-receive-complete
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if actor:get_quest_stage("sunfire_rescue") ==3 then
        if object.id == 52001 then
            self.room:send("Looking hesitant, the prisoner slowly slides the ring onto his finger.")
            actor.name:advance_quest("sunfire_rescue")
            self.room:spawn_object(237, 16)
            self:destroy_item("all.elven")
            wait(2)
            self:emote("vanishes from sight.")
            self:command("give " .. tostring(actor.name) .. " badge")
            actor.name:complete_quest("sunfire_rescue")
            self:whisper(actor.name, "Thank you for your help!  Please wear this badge as a token of my respect.")
            self.room:send("A voice softly echos goodbye...")
            world.destroy(self.room:find_actor("serin"))
        end
        if object.id == 52018 then
            self:command("frown " .. tostring(actor.name))
            self:say("What kind of cruel trick is this?")
            wait(1)
            self:say("Well, do you have the real one to give to me?")
        end
    end
end  -- auto-close block