-- Trigger: academy_revel_speech_money
-- Zone: 519, ID: 92
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51992

-- Converted from DG Script #51992: academy_revel_speech_money
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: money
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "money")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 5 and not actor:get_quest_var("school:money") then
    actor:set_quest_var("school", "money", 1)
    actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>GET</>, <b:cyan>DROP</>, and <b:cyan>GIVE</> money like items.")
    actor:send("To check your current wealth, use <b:cyan>SCORE</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'During your downtime you may want to visit a bank.")
    actor:send("It's important to keep money in the bank so that when you die, you'll have emergency funds to get back to your corpse!")
    actor:send("</>")
    actor:send("I myself happen to be a certified banker!")
    actor:send("</>")
    actor:send("At a bank you can <b:cyan>DEPOSIT</> and <b:cyan>WITHDRAW</> money.")
    wait(3)
    self:command("give 5 gold 5 silver 5 copper " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Let's try out depositing money, like this:")
    actor:send("<b:cyan>DEPOSIT [amount] platinum [amount] gold [amount] silver [amount] copper'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>deposit 1 gold 1 silver 1 copper</>.'")
end