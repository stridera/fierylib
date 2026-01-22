-- Trigger: south_exposition
-- Zone: 123, ID: 38
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12338

-- Converted from DG Script #12338: south_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who are you") or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:sexpo") == 0 then
        self:say("I am Keeper of the South, the warden of fire.  As befits my station, I hail from an island where molten fire reigns supreme.  It flows from the mountain, touches the sky, and meets the ocean.")
        wait(6)
        self:say("When murderous \"adventurers\" come from the Three Cities to loot my homeland, they see a hostile land subjugated by a petty and cruel demigoddess where the people live without stone monuments for homes.")
        wait(6)
        self:say("They, marauding lunatics that they are, call us \"savage\" and \"uncivilized\".  They think us inferior for living in the ways of the land and not claiming dominion over the volcano.")
        wait(5)
        self:say("That the volcano goddess was once beloved by the God of the Moonless Night -")
        self.room:send("</>")
        self:emote(tostring(self.name) .. " makes a face and spits on the ground and utters,")
        self:say("- may he ever suffer terrible vengeance -")
        self.room:send("</>")
        self.room:send(tostring(self.name) .. " continues, ' - does not help either.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 1)
    elseif actor:get_quest_var("megalith_quest:sexpo") == 1 then
        self:say("But living in the ways of the jungle does not make us \"savage\".  To my Jungle Tribe, we cannot stop Vulcera or the volcano, for it is the natural ebb and flow of creation.")
        wait(6)
        self:say("I spent several years apprenticed to the old island shaman learning not how to prevent this process, but how to shape it.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 2)
    elseif actor:get_quest_var("megalith_quest:sexpo") == 2 then
        self:say("It was during those years I first felt the primordial churn in the stellar inferno of the cosmos.  Just like within the fires of the volcano, I could feel the pulse of creation beating in the heart of each star.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 3)
    elseif actor:get_quest_var("megalith_quest:sexpo") == 3 then
        self:say("One summer, several Sisters of the coven stopped at my village on their way to seek guidance from the old wise woman of the Mountain Tribe.")
        wait(5)
        self:say("I expected they would bring nothing but death and belittlement like all outsiders do.")
        wait(2)
        self:say("But when they expressed great concern for the volcano and the creatures within, I was greatly surprised.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 4)
    elseif actor:get_quest_var("megalith_quest:sexpo") == 4 then
        self:say("They became welcomed guests and gradually friends.  They returned many times, each time asking me to join them, calling me Sister in the Old Ways.  After many meetings, I finally relented and left my home for the first time.")
        wait(6)
        self:say("I was reluctant at first, but I have come to see we walk the same paths as keepers of the land.  The sacred duties we share unite us in purpose beyond blood - we are truly Sisters.")
        actor:set_quest_var("megalith_quest", "sexpo", 0)
    end
end