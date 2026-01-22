-- Trigger: give_ivory_vulcera
-- Zone: 481, ID: 21
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48121

-- Converted from DG Script #48121: give_ivory_vulcera
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("fieryisle_quest") == 8 then
    wait(2)
    actor.name:advance_quest("fieryisle_quest")
    actor:send("<b:white>You have advanced your quest!</>")
    if not world.count_mobiles("48127") then
        get_room(481, 97):at(function()
            self.room:spawn_mobile(481, 27)
        end)
    end
    self:say("You did well to find this, even with my powers I was unable to locate it.  On the other hand, you were a bit dumb to just hand it over to me!  It would seem Lokari taught me well.")
    wait(3)
    self:command("unlock chest")
    self:command("open chest")
    self:command("get all chest")
    self:emote("examines the ivory ring.")
    wait(2)
    self:say("Pah, humans!")
    if self:has_item("48114") then
        self:destroy_item("ivory-ring")
    end
    self.room:spawn_object(481, 27)
    self:command("wear ring")
    wait(2)
    self:say("Heh, it still fits after all these years, but Lokari won't be happy.")
    self:destroy_item("key")
    self:command("peer " .. tostring(actor.name))
    wait(2)
    self.room:spawn_object(481, 26)
    self:command("wear cloak-fire")
    self:say("If you want this cloak, you better think again, begone mortal!")
    self.room:teleport_all(get_room(482, 0))
    get_room(482, 0):at(function()
        self.room:send("You can hear Vulcera's laughter ringing in your ears.")
    end)
    self:teleport(get_room(482, 23))
end