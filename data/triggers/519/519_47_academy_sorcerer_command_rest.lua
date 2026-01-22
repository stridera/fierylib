-- Trigger: academy_sorcerer_command_rest
-- Zone: 519, ID: 47
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #51947

-- Converted from DG Script #51947: academy_sorcerer_command_rest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rest
if not (cmd == "rest") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_var("school:fight") == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("rest")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'As a sorcerer, you need to <b:cyan>SCRIBE</> spells in your spellbook.")
    actor:send("<b:cyan>(SPE)LL</> will show you all the spells you can <b:cyan>SCRIBE</>.")
    actor:send("You must <b:cyan>HOLD</> a <b:yellow>SPELLBOOK</> with blank pages and a <b:yellow>PEN</> of some kind to scribe.")
    if not actor:has_equipped("1029") and not actor:has_item("1029") and not actor:has_equipped("1154") and not actor:has_item("1154") then
        actor:send("Looks like you need a book and pen!")
        self.room:spawn_object(11, 54)
        self.room:spawn_object(10, 29)
        self:command("give book " .. tostring(actor))
        self:command("give pen " .. tostring(actor))
    else
        actor:send("All new sorcerers start with an empty book and quill.")
    end
    actor:send("</>")
    actor:send("Once you leave the Academy, you many only <b:cyan>SCRIBE</> spells in the presence of your <b:yellow>Guild Master</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Check your spell list by typing <b:green>spell</>.'")
elseif actor:get_quest_var("school:fight") == 10 then
    actor:set_quest_var("school", "fight", 11)
    actor:command("rest")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Next, you should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
end
_return_value = false
return _return_value