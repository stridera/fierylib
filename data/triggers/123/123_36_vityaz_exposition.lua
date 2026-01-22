-- Trigger: vityaz_exposition
-- Zone: 123, ID: 36
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12336

-- Converted from DG Script #12336: vityaz_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who") are you or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:vexpo") == 0 then
        self:say("I am a sorcerer-warrior of the Tzigane people.  Though others call us by a cruder name, you've certainly seen us around the world before.  I myself come from a family caravan which is usually camped not far to the east of here.")
        wait(4)
        self:say("When I was a girl, the old witchy woman of my caravan saw mystic potential in me.  She took me under her wing and taught me to utilize that potential to defend my family and our home.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "vexpo", 1)
    elseif actor:get_quest_var("megalith_quest:vexpo") == 1 then
        self:say("Shortly after I came of age, I heard a voice calling to me in my dreams.  It told me new Sisters were waiting for me, in need of my defense.")
        wait(4)
        self:say("I came upon several sisters of the coven besieged by the walking dead outside the graveyard near Anduin.  My added strength turned the tide of battle.")
        wait(5)
        self:say("They styled me \"Vityaz,\" meaning \"Hero\" in the old tongue of my people, and I have guarded them ever since.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "vexpo", 2)
    elseif actor:get_quest_var("megalith_quest:vexpo") == 2 then
        self:say("To assist in the Great Rite of Invocation, in my duty duty as defender, I am casting and reinforcing a circle of protection between these smaller menhir.")
        wait(4)
        self:say("I will maintain it throughout the rite.")
        actor:set_quest_var("megalith_quest", "vexpo", 0)
    end
end