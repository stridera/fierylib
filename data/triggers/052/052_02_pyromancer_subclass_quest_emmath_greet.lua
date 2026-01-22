-- Trigger: pyromancer_subclass_quest_emmath_greet
-- Zone: 52, ID: 2
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #5202

-- Converted from DG Script #5202: pyromancer_subclass_quest_emmath_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.quest_stage[type_wand] == "wandstep" then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor.quest_variable[type_wand:greet] == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            if actor.quest_variable[type_wand:wandtask1] and actor.quest_variable[type_wand:wandtask2] and actor.quest_variable[type_wand:wandtask3] then
                actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
            end
        end
    end
end
local stage = actor:get_quest_stage("pyromancer_subclass")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Come back to try again have you?  Only the best and most motivated of mages will complete the quest I lay before you.'")
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this <b:red>quest</> and become a pyromancer.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Are you ready to finish listening now?  I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif stage == 3 or stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame?  Give it here!'")
else
    if string.find(actor.class, "Sorcerer") then
        -- switch on actor.race
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            return _return_value
        else
            if actor.level >= 10 and actor.level <= 45 then
                self.room:send("Emmath Firehand's glowing eyes flash brightly for a moment.")
                actor:send(tostring(self.name) .. " says, 'Some love the life of <b:red>flame</>.  Do you?'")
                self:emote("flicks a grin around the room.")
            elseif string.find(actor.class, "Sorcerer") and actor.level < 10 then
                self:emote("stares in amazement at " .. tostring(actor.name) .. ".")
                actor:send(tostring(self.name) .. " says, 'I have no idea how you found me but you are far too inexperienced to be in these tunnels in the first place, and even less to ask for my guidance.'")
            end
        end
    end
end  -- auto-close block