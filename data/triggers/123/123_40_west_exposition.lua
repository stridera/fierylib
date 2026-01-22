-- Trigger: west_exposition
-- Zone: 123, ID: 40
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12340

-- Converted from DG Script #12340: west_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who") are you or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:wexpo") == 0 then
        self:say("My home realm, the Reverie, the Dreaming, is a plane of the dreams of mortals made manifest.")
        wait(3)
        self:say("Unlike most of the other fey creatures in Ethilien, I am not in this world by choice.")
        wait(3)
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 1)
    elseif actor:get_quest_var("megalith_quest:wexpo") == 1 then
        self:say("I am also unique from my coven Sisters because I knew our Mother.  I was shaped by Her hand directly.  Reaching out from the deepest parts of the Dreaming, The Great Mother formed me from a river in part of the Reverie ruled by a creature known as the Goblin King.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 2)
    elseif actor:get_quest_var("megalith_quest:wexpo") == 2 then
        self:say("Driven by an insatiable hunger for power and wealth, the Goblin King grew tired of being confined to the Dreaming.")
        wait(4)
        self:say("So, he approached the troll witch Baba Yaga.  Together they concocted a way to pierce the veil between the world and merge his court with the mortal realm.")
        wait(4)
        self:say("Not caring what the consequences might be, they tore the Goblin King's land from the Reverie and smashed it into the Syric Mountains.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 3)
    elseif actor:get_quest_var("megalith_quest:wexpo") == 3 then
        self:say("In the chaos that ensued, I could still hear my Mother's voice.  She whispered to me that there was a new world waiting beyond the Dreaming and She would be there, with a new family if I dared to dream it.")
        wait(4)
        self:say("I chose to leave.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 4)
    elseif actor:get_quest_var("megalith_quest:wexpo") == 4 then
        self:say("The Great Mother guided me to the coven, who welcomed me with open arms and introduced this world to me.")
        wait(3)
        self:say("Being among mortals, meeting the long-descended elven children of my ancient siblings, climbing the rocky peaks, dancing in the golden pastures of Ethilien...")
        wait(5)
        self:say("I have awakened to a splendor I feared I would lose forever, with a kind of family I never had.")
        wait(3)
        self:say("She had taken me from one Dream and set me free in another.")
        actor:set_quest_var("megalith_quest", "wexpo", 0)
    end
end