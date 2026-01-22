-- Trigger: quest_relocate_greet
-- Zone: 492, ID: 50
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49250

-- Converted from DG Script #49250: quest_relocate_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if not (actor:get_has_completed("relocate_spell_quest")) and actor.level < 100 then
    if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" then
        if actor.level >= 65 then
            -- switch on actor:get_quest_stage("relocate_spell_quest")
            if actor:get_quest_stage("relocate_spell_quest") == 1 or actor:get_quest_stage("relocate_spell_quest") == 2 then
                actor:send("A lost mage asks you, 'Have you dealt with the thieving druid?  Please if you")
                actor:send("</>have, give me the staff!'")
                self.room:send_except(actor, "A lost mage grins as she asks " .. tostring(actor.name) .. " a question.")
            elseif actor:get_quest_stage("relocate_spell_quest") == 3 or actor:get_quest_stage("relocate_spell_quest") == 4 or actor:get_quest_stage("relocate_spell_quest") == 5 then
                actor:send("A lost mage asks you, 'Did you get the Crystal Telescope?  Please give me the")
                actor:send("</>Telescope!'")
                self.room:send_except(actor, "A lost mage grins as she asks " .. tostring(actor.name) .. " a question.")
            elseif actor:get_quest_stage("relocate_spell_quest") == 6 then
                actor:send("A lost mage asks you, 'Did you get the silver-trimmed spellbook?  Please give")
                actor:send("</>me the spellbook!'")
                self.room:send_except(actor, "A lost mage grins as she asks " .. tostring(actor.name) .. " a question.")
            elseif actor:get_quest_stage("relocate_spell_quest") == 7 then
                actor:send("A lost mage asks you, 'Do you have the map?  Please give me the map!'")
                self.room:send_except(actor, "A lost mage grins as she asks " .. tostring(actor.name) .. " a question.")
            elseif actor:get_quest_stage("relocate_spell_quest") == 8 or actor:get_quest_stage("relocate_spell_quest") == 9 then
                actor:send("A lost mage asks you, 'Do you have the Quill?  Please give me the Quill!'")
                self.room:send_except(actor, "A lost mage grins as she asks " .. tostring(actor.name) .. " a question.")
            else
                actor:send("A scared-looking mage comes running over to you!")
                self.room:send_except(actor, "A scared-looking woman gets up and runs over to " .. tostring(actor.name) .. ".")
                wait(10)
                actor:send("A lost mage asks you, 'Please, can you help me?'")
                self.room:send_except(actor, "A lost mage pleads with " .. tostring(actor.name) .. ".")
                wait(10)
                self:command("cry")
                wait(10)
                self.room:send_except(actor, "A lost mage pleads with " .. tostring(actor.name) .. ".")
                actor:send("A lost mage asks you, 'I'm completely lost in this dark desert, <b:cyan>help</>")
                actor:send("</>me get out!'")
            end
        end
    end
end