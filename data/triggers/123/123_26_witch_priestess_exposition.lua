-- Trigger: witch_priestess_exposition
-- Zone: 123, ID: 26
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12326

-- Converted from DG Script #12326: witch_priestess_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who are you") or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:hexpo") == 0 then
        self:say("I am the high priestess of a sacred sisterhood of witches dedicated to the worship of the faerie goddess the Great Mother, Lady of Stars.")
        wait(4)
        self:say("We strive to keep the Old Ways alive, as our foremothers did, and their foremothers before them, and their foremothers before them, back through the centuries.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 1)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 1 then
        self:say("Witchcraft has always been in my blood.")
        wait(2)
        self:say("The people of my homeland in the Green Green Sea still observe the Old Ways.  The Fair Folk still walk among us.  A bocan hobgoblin or two playing tricks on you is part of our daily routine.  Every woman in the village knows how to mix herbs and what to do when you see a ghost.")
        wait(4)
        self:say("I was, and still am, nothing special.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 2)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 2 then
        self:say("Then I heard the call.")
        wait(2)
        self:say("Nightly dreams led me on a global pilgrimage.  I found myself seeking out clandestine lore and lost secrets from a myriad of other traditions.")
        wait(4)
        self:say("I trained under the Priests of Mielikki.")
        wait(3)
        self:say("I was honored with a meeting for tea with the Hierophant of the Highlands.")
        wait(3)
        self:say("I've read the texts of Seblan, and the Enchiridion.")
        wait(3)
        self:say("I even learned a thing or two from the lizard shamans in the Northern Swamps.")
        wait(3)
        self:say("And after many years, I returned home where the Great Mother revealed herself to me.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 3)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 3 then
        self:say("She charged me with seeking out this coven.  I dedicated myself to Her service and through years of loving care and gentle insight, I have become Her priestess as we push to revitalize the Old Ways.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 4)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 4 then
        self:say("Like myself, my Sisters hail from every corner of Ethilien.")
        wait(2)
        self:say("Some are just women called to our coven to provide succor to others.")
        wait(3)
        self:say("Others have more... unusual stories which have led them to the Faerie Mother.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Yet today, we have all come to this place to <b:cyan>perform the Great Rite of Invocation.</>'")
        actor:set_quest_var("megalith_quest", "hexpo", 0)
    end
end