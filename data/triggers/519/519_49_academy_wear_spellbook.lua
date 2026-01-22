-- Trigger: academy_wear_spellbook
-- Zone: 519, ID: 49
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #51949

-- Converted from DG Script #51949: academy_wear_spellbook
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if actor:get_quest_var("school:fight") == 3 then
    actor:set_quest_var("school", "fight", 4)
    wait(2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'Next, <b:cyan>(H)OLD</> your quill.")
    if not actor:has_equipped("1154") and not actor:has_item("1154") then
        actor:send("Looks like you need a new one.'")
        self.room:find_actor("chair"):spawn_object(11, 54)
        self.room:find_actor("chair"):command("give pen " .. tostring(actor))
    else
        actor:send("You started with one.'")
    end
    wait(1)
    actor:send("</>Type <b:cyan>hold quill</> to grab your quill.'")
end