-- Trigger: get_golden_quill
-- Zone: 492, ID: 23
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #49223

-- Converted from DG Script #49223: get_golden_quill
-- Original: OBJECT trigger, flags: GET, probability: 100%
-- Inspired by ranger/druid quest
if actor:get_quest_stage("relocate_spell_quest") == 8 then
    self.room:send("The quill begins to glow brightly!")
    actor.name:advance_quest("relocate_spell_quest")
elseif actor:get_quest_stage("relocate_spell_quest") == 9 then
    self.room:send("The quill begins to glow brightly!")
else
    wait(5)
    actor:send("The quill glows so brightly it burns your hand!")
    self.room:send_except(actor, tostring(actor.name) .. " burns " .. tostring(actor.possessive) .. " hand on the quill!")
    actor:command("drop golden-quill")
end