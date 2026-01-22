-- Trigger: dark_robed_recieve1
-- Zone: 590, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: &3&b* vial of blood&0
--   -- UNCONVERTED: &3&b*trinket of tattered leather&0
--   -- UNCONVERTED: &3&b*earring&0
--   Complex nesting: 19 if statements
--   Large script: 8372 chars
--
-- Original DG Script: #59008

-- Converted from DG Script #59008: dark_robed_recieve1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- check to see what is being given!
local obj = object.id
-- switch on obj
-- adornment of light
if obj == 59026 then
    -- check to see if quest is started and PC hasent given light already
    if (actor.id == -1) and (actor:get_quest_stage("sacred_haven") == 1) and (actor:get_quest_var("sacred_haven:given_light") ~= 1) then
        wait(5)
        self:emote("slowly rubs its hands together and cackles with a wicked sounding glee.")
        world.destroy(object.name)
        self.room:spawn_object(590, 31)
        wait(6)
        self:command("give dingy-key " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " whispers to you, 'Here is a key that will help you finish")
        actor:send("</>my task.  Don't waste my efforts acquiring it.'")
        wait(3)
        actor:send(tostring(self.name) .. " whispers to you, 'I have lost a few of my dark artifacts to the")
        actor:send("</>clutches of the brothers from the Sacred Haven.'")
        wait(2)
        self:emote("grumbles loudly.")
        actor.name:set_quest_var("sacred_haven", "given_light", 1)
        -- last line just set var to let code know light has been given
    elseif actor:get_quest_var("sacred_haven:given_light") == 1 then
        -- return light if already given
        wait(2)
        self:command("give adornment " .. tostring(actor.name))
        wait(3)
        self:say("You already gave me this!")
        self.room:send(tostring(self.name) .. " mumbles something about " .. tostring(actor.name) .. ".")
    else
        -- junk it if quest hasn't started
        wait(6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    end
    -- UNCONVERTED: &3&b* vial of blood&0
    if actor:get_quest_var("sacred_haven:given_blood") == 1 then
    elseif obj == 59028 then
        wait(2)
        self:say("You have already given me this.")
        self:command("give vial-dragons-blood " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(5)
        self:command("grin")
        wait(2)
        self:say("Good, now I have the vial of dragon's blood.")
        self:destroy_item("vial-dragons-blood")
        actor.name:set_quest_var("sacred_haven", "given_blood", 1)
        -- check to see if all 3 items have been returned
        if (actor:get_quest_var("sacred_haven:given_blood") == 1) and (actor:get_quest_var("sacred_haven:given_trinket") == 1) and (actor:get_quest_var("sacred_haven:given_earring") == 1) then
            local reward = "yes"
        else
            local reward = "no"
        end
    end
    -- UNCONVERTED: &3&b*trinket of tattered leather&0
    if actor:get_quest_var("sacred_haven:given_trinket") == 1 then
    elseif obj == 59029 then
        wait(2)
        self:say("You have already given me this.")
        self:command("give trinket-tattered-leather " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(5)
        self:command("grin")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Ahhh, I savor the feel of my skin against my trinket")
        self.room:send("</>of tattered leather.'")
        world.destroy(object.name)
        actor.name:set_quest_var("sacred_haven", "given_trinket", 1)
        -- check to see if all 3 items have been returned
        if (actor:get_quest_var("sacred_haven:given_blood") == 1) and (actor:get_quest_var("sacred_haven:given_trinket") == 1) and (actor:get_quest_var("sacred_haven:given_earring") == 1) then
            local reward = "yes"
        else
            local reward = "no"
        end
    end
    -- UNCONVERTED: &3&b*earring&0
    if actor:get_quest_var("sacred_haven:given_earring") == 1 then
    elseif obj == 59030 then
        wait(2)
        self:say("You have already given me this.")
        self:command("give shadow-forged-earring " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(9)
        world.destroy(object.name)
        self:command("cackle")
        wait(5)
        actor:send(tostring(self.name) .. " says, 'Yes... I have not seen the shadow forged earring in")
        self.room:send("</>quite some time.'")
        actor.name:set_quest_var("sacred_haven", "given_earring", 1)
        -- check to see if all 3 items have been returned
        if (actor:get_quest_var("sacred_haven:given_blood") == 1) and (actor:get_quest_var("sacred_haven:given_trinket") == 1) and (actor:get_quest_var("sacred_haven:given_earring") == 1) then
            local reward = "yes"
        else
            local reward = "no"
        end
    end
else
    -- junk all other obj's
    wait(6)
    self:say("I don't want this.")
    self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
    world.destroy(object.name)
end
if reward == "yes" then
    -- reward
    wait(3)
    self:command("look " .. tostring(actor.name))
    self:emote("nods their head and slowly pulls down their hood revealing a grey face.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Now that I have both the earring and vial of blood,")
    self.room:send("</>I will create a great reward with them.'")
    wait(3)
    self.room:send_except(self, tostring(self.name) .. " rubs the earring with their wrinkly fingers and uncaps the vial of dragon's <red>blood</>.")
    wait(5)
    self.room:send_except(self, tostring(self.name) .. " pours the vial onto the earring, which begins to release a thick black &9<blue>smoke</>.")
    wait(4)
    self.room:send_except(self, "The smoke clears and the blood has been dried and baked onto the earring, giving it a <b:red>red shine</>.")
    wait(4)
    local rnd = random(1, 10)
    -- switch on rnd
    if rnd == 1 or rnd == 2 or rnd == 3 or rnd == 4 or rnd == 5 or rnd == 6 or rnd == 7 then
        self:command("cackle " .. tostring(actor.name))
        self:say("And now my prize!")
        wait(1)
        self.room:spawn_object(590, 2)
        self:command("wear dragons-blood-earring")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Ahhh, you've been such a foolish one to complete")
        self.room:send("</>my deeds for me.'")
        wait(2)
        actor.name:complete_quest("sacred_haven")
        actor.name:erase_quest("sacred_haven")
        spells.cast(self, "cause crit", actor.name)
    elseif rnd == 8 or rnd == 9 or rnd == 10 then
    else
        self:emote("sighs.")
        wait(2)
        self:say("At least I have the remainder of the vial of")
        self.room:send("'dragon's blood.'")
        wait(5)
        self.room:spawn_object(590, 2)
        self:command("give dragons-blood-earring " .. tostring(actor.name))
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'And it is rumored that there are two more shadow")
        self.room:send("</>forged earrings still within the realms.'")
        wait(3)
        actor:send(tostring(self.name) .. " turns away from you.")
        self.room:send_except(actor.name, tostring(self.name) .. " turns away from " .. tostring(actor.name) .. ".")
        actor.name:complete_quest("sacred_haven")
        actor.name:erase_quest("sacred_haven")
    end
elseif reward == "no" then
    -- ask for more stuff
    wait(4)
    self:whisper(actor.name, "Ok, now bring me the rest of my artifacts.")
end