-- Trigger: hell_gate_diabolist_receive
-- Zone: 564, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #56404
--
-- Diabolist hell-gate quest: per-stage gift handler.
--  stage 1: receives the spider-shaped dagger (30, 213) -> advance and
--           reveal the seven-keys hint
--  stage 2: receives any of seven keys -> mark, when all seven received
--           spawn dagger (564, 7) and advance
--  stage 3: optional dagger replacement if the player set the "new" var
--  stage 4: receives the (564, 7) ritual dagger -> begin angel summon
local stage = actor:get_quest_stage("hell_gate")
if stage == 1 then
    if object.zone_id == 30 and object.local_id == 213 then
        actor:advance_quest("hell_gate")
        wait(1)
        self:say("Yes, this seems to match the description.")
        self.room:send(tostring(self.name) .. " lifts " .. tostring(object.shortdesc) .. " in offering.")
        self:destroy_item("dagger")
        wait(2)
        self.room:send("The island rumbles and groans as the hellish voice bubbles up out of the lake.")
        self.room:send("<red>'You have done well, dark ones.  Let us continue.'</>")
        wait(2)
        self.room:send("</><red>'To unlock the pathways, you must procure seven keys to seven gates.'</>")
        wait(3)
        actor:send("Your brain burns as a fiery collage of images is seared into your memory!")
        actor:send("One by one you receive a vision of each key:")
        -- (empty send to actor)
        actor:send("<b:white>A small, well-crafted key made of wood with the smell of rich sap</>")
        actor:send("</><b:white>  kept at the gate of a tribe's home.</>")
        -- (empty send to actor)
        actor:send("<b:white>A key made of light silvery metal which only elves can work</>")
        actor:send("</><b:white>  deep in a frozen valley.</>")
        -- (empty send to actor)
        actor:send("<b:white>A large, black key humming with magical energy</>")
        actor:send("</><b:white>  from a twisted cruel city in a huge underground cavern.</>")
        -- (empty send to actor)
        actor:send("<b:white>A simple lacquered iron key in the care of a radiant bird</>")
        actor:send("</><b:white>  on an emerald island.</>")
        -- (empty send to actor)
        actor:send("<b:white>A rusted but well cared for key held by a winged captain</>")
        actor:send("</><b:white>  on an island of magical beasts.</>")
        -- (empty send to actor)
        actor:send("<b:white>A golden plated, wrought-iron key</>")
        actor:send("</><b:white>  held at the gates to a desecrated city.</>")
        -- (empty send to actor)
        actor:send("<b:white>One nearly impossible to see</>")
        actor:send("</><b:white>  guarded by a fiery beast with many heads.</>")
        wait(5)
        self.room:send("<red>'With these keys you will be able to unlock the gate to the lower realms.</>")
        self.room:send("</><red>Go, find them!'</>")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Let's split up.  See what you can find and")
        self.room:send("</>I'll meet you back here.'")
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("I don't think this is what we need.")
        return false
    end
elseif stage == 2 then
    -- Seven keys: (83,3), (237,9), (490,8), (520,12), (520,13), (534,2), (580,109)
    local function is_key()
        local z, i = object.zone_id, object.local_id
        return (z == 83 and i == 3)
            or (z == 237 and i == 9)
            or (z == 490 and i == 8)
            or (z == 520 and i == 12)
            or (z == 520 and i == 13)
            or (z == 534 and i == 2)
            or (z == 580 and i == 109)
    end
    if is_key() then
        local key_var = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
        if actor:get_quest_var("hell_gate:" .. key_var) then
            self:say("You already brought that key.")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false
        else
            actor:set_quest_var("hell_gate", key_var, 1)
            wait(1)
            self:destroy_item("key")
        end
        local key1 = actor:get_quest_var("hell_gate:83_3")
        local key2 = actor:get_quest_var("hell_gate:237_9")
        local key3 = actor:get_quest_var("hell_gate:490_8")
        local key4 = actor:get_quest_var("hell_gate:520_12")
        local key5 = actor:get_quest_var("hell_gate:520_13")
        local key6 = actor:get_quest_var("hell_gate:534_2")
        local key7 = actor:get_quest_var("hell_gate:580_109")
        local function num(v) return tonumber(v) or 0 end
        if key1 and key2 and key3 and key4 and key5 and key6 and key7 then
            self.room:send("The rumbling demonic voice speaks.")
            self.room:send("<red>'Yes, these keys are ideal.  Several bear the marks of goodness.  They shall be</>")
            self.room:send("</><red>perfect to corrupt and despoil!'</>")
            -- (empty room echo)
            self.room:send("The voice bellows a horrific laugh.")
            -- (empty room echo)
            self.room:send("<red>'Once their essences have been defiled, they can open the locks on the</>")
            self.room:send("</><red>infernal realms. To corrupt the keys, bathe them in the blood of seven</>")
            self.room:send("</><red>different mortal children, slain in sacrifice to the demon lords.'</>")
            wait(1)
            self.room:send("<b:red>'Use the spider-shaped dagger to kill each child.'</>")
            -- (empty room echo)
            self.room:spawn_object(564, 7)
            self:command("give dagger " .. tostring(actor.name))
            wait(1)
            self.room:send("<red>'Now go, seek out seven different kinds of children, sacrifice them, and <blue>drop</>")
            self.room:send("</><red>their blood here.'</>")
            actor:advance_quest("hell_gate")
        else
            local keys = num(key1) + num(key2) + num(key3) + num(key4) + num(key5) + num(key6) + num(key7)
            if keys < 6 then
                self:say("Let's keep looking for the rest of the keys!")
            else
                self:say("Let's look for the last key!")
            end
        end
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not one of the seven keys.")
        return false
    end
elseif stage == 3 then
    if actor:get_quest_var("hell_gate:new") ~= "yes" then
        if object.zone_id == 30 and object.local_id == 213 then
            wait(2)
            self:say("Yes, this is a suitable replacement.")
            self:destroy_item("dagger")
            wait(1)
            self.room:spawn_object(564, 7)
            self:command("give dagger " .. tostring(actor.name))
            self:say("Return to hunting your sacrifices.")
        else
            self:say("This is not an appropriate dagger.")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false
        end
    else
        self:say("I don't need anything from you right now.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false
    end
elseif stage == 4 then
    if object.zone_id == 564 and object.local_id == 7 then
        wait(1)
        self:destroy_item("dagger")
        actor:advance_quest("hell_gate")
        wait(2)
        self.room:send(tostring(self.name) .. " swirls the dagger through the pool of blood while reciting an incantation.")
        self.room:send(tostring(self.name) .. " smears each key with the crimson mixture.")
        wait(2)
        self.room:send("The seven keys turn jet black and start to sizzle.")
        self.room:send("The Black Lake starts to bubble and boil.")
        wait(3)
        self.room:send("The demonic voice says, <red>'One more thing then all is done.  Spill the blood of a</>")
        self.room:send("</><red>celestial creature here in a final act of desecration.  I have been keeping</>")
        self.room:send("</><red>such a pet for just this purpose!'</>")
        wait(5)
        self.room:send("In a swirl of smoke and brimstone a radiant winged being materializes within the ring of keys.")
        wait(3)
        self.room:send("<red>'Kill this worshiper of mine Larathiel, and I shall free you from Garl'lixxil!'</>")
        self.room:send("The demonic voice laughs cruelly.")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " runs and hides!")
        wait(10)
        self.room:spawn_mobile(564, 1)
        self.room:send("The defiled angel screams with rage and attacks!")
        local angel = self.room:find_actor("angel")
        if angel then
            angel:command("kill " .. tostring(actor.name))
        end
        self:teleport(get_room(11, 0))
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("No, the dagger, quickly!")
        return false
    end
else
    self:say("What is this for?")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    return false
end
return true