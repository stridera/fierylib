-- Trigger: letters for the merchant
-- Zone: 625, ID: 51
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #62551

-- Converted from DG Script #62551: letters for the merchant
-- Original: MOB trigger, flags: GREET, probability: 100%
if %actor.quest_stage[ursa_quest] == 1 then
    wait(1)
    actor:send(tostring(self.name) .. " notices the concerned look on your face.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'So, the merchant has gotten himself in quite a bit")
    actor:send("</>of trouble.'")
    if self.id == 58008 then
        wait(1)
        actor:send(tostring(self.name) .. " writes a beautifully crafted white epistle.")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Please, bring him this note from me.  It describes what")
        actor:send("</>he must do for the gods to heal him.'")
        self.room:spawn_object(625, 11)
        self:command("give letter " .. tostring(actor))
    elseif self.id == 6007 then
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'I know what he must do, but he won't like it.'")
        self:command("chuckle")
        wait(1)
        actor:send(tostring(self.name) .. " dips his quill in a well of blood and scratches out a sinister letter.")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Quickly, take this to him!  Perhaps the Darkness")
        actor:send("</>still finds him...  amusing.'")
        self.room:spawn_object(625, 10)
        self:command("give letter " .. tostring(actor))
    elseif self.id == 7310 then
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'Fortunately, there isn't anything I haven't found")
        actor:send("</>the cure for.  He sent you to exactly the right person!'")
        wait(2)
        actor:send(tostring(self.name) .. " takes a crumpled piece of parchment from the floor of his hut and an exhausted coal from the fire.")
        actor:send(tostring(self.name) .. ", with coal in fist, scribbles out an ugly, barely legible note.")
        wait(2)
        self.room:spawn_object(625, 12)
        self:command("give note " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, 'Now get out of my swamp!'")
    end
end