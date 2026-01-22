-- Trigger: oracle-sun-greet
-- Zone: 484, ID: 1
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 25 if statements
--   Large script: 7932 chars
--
-- Original DG Script: #48401

-- Converted from DG Script #48401: oracle-sun-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if wandstep then
    local minlevel = (wandstep - 1) * 10
elseif macestep then
    local minlevel = macestep * 10
end
if actor.quest_stage[type_wand] == "wandstep" and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
    if actor.level >= minlevel then
        if actor.quest_variable[type_wand:greet] == 0 then
            actor:send(tostring(self.name) .. " says, 'Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
        end
    end
elseif actor:get_quest_stage("phase_mace") == "macestep" and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
    if actor.level >= minlevel then
        if actor:get_quest_var("phase_mace:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
elseif actor:get_quest_stage("doom_entrance") == 5 then
    self:command("bow " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'At last, one has come to challenge the wrath of the God of the Moonless Night.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You shall need Timun's Light if you are to defeat Lokari, " .. tostring(actor.name) .. ".'")
    self.room:spawn_object(484, 31)
    self:command("give vial " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You must take this vial to a place steeped in darkness.  You shall know it by the false light shed there and the mockery of the sun it proclaims.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Then drop it on the ground and fill the place with holy light!  Once you have completed this task, return to me and I shall inform the Keeper of the Keys that you are indeed worthy.'")
    wait(4)
    if actor.quest_stage[type_wand] == "wandstep" then
        if actor.level >= minlevel then
            if actor.quest_variable[type_wand:greet] == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif actor:get_quest_stage("phase_mace") == "macestep" then
        if actor.level >= minlevel then
            if actor:get_quest_var("phase_mace:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                wait(1)
            end
        end
    end
    actor:send("With those words, the Oracle bows his head and refuses to utter another word.")
elseif actor:get_quest_stage("doom_entrance") == 6 then
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("doom_entrance") == 6 then
                person:send(tostring(self.name) .. " says, 'You have done well, " .. tostring(person.name) .. ". Your task is completed.'")
                wait(1)
                person:send(tostring(self.name) .. " says, 'May the light of the Sun find you even in the depths of Severan's Doom.'")
                person.name:complete_quest("doom_entrance")
                wait(1)
                person:send(tostring(self.name) .. " says, 'Do not forget to show the Keeper of the Keys that you have finished!'")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    self.room:spawn_object(484, 21)
    self:command("give key " .. tostring(actor.name))
    if actor.quest_stage[type_wand] == "wandstep" then
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel then
            wait(3)
            if actor.quest_variable[type_wand:greet] == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif actor:get_quest_stage("phase_mace") == "macestep" then
        if actor.level >= minlevel then
            if actor:get_quest_var("phase_mace:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                wait(1)
            end
        end
    end
elseif actor:get_has_completed("doom_entrance") then
    actor:send("As you enter the chamber " .. tostring(self.name) .. " greets you warmly.")
    self.room:send_except(actor, tostring(self.name) .. " greets " .. tostring(actor.name) .. " warmly.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Heroes, the day of Prophecy has arrived.  Know that in a nearby chamber is a Gateway to another Realm.  From that Realm, you will have access to others; and it is in one of these other Realms that you will find the way to Lokari's Domain.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Collect the three godly keys to the Domain, which were scattered by the gods upon the Champion's death, and slay the mad god for his crimes.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Go now, the Universe awaits!'")
    wait(1)
    if actor.quest_stage[type_wand] == "wandstep" then
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel then
            if actor.quest_variable[type_wand:greet] == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        elseif actor:get_quest_stage("phase_mace") == "macestep" then
            if actor.level >= minlevel then
                if actor:get_quest_var("phase_mace:greet") == 0 then
                    actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                    wait(1)
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                    wait(1)
                end
            end
        end
    end
    actor:send("With those words, the Oracle bows his head and refuses to utter another word.")
end