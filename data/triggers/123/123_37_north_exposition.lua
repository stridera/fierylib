-- Trigger: north_exposition
-- Zone: 123, ID: 37
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12337

-- Converted from DG Script #12337: north_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who are you") or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:nexpo") == 0 then
        self:say("After Sagece's siege on our ancestral home, my family sought refuge with our frost relatives near the land of the Great Snow Leopard.")
        wait(3)
        self:say("The Children of the Snow Leopard instilled a love of stone in me.  Not just a love of magical stone, their enchanted jades or mystic crystals, but mundane stone too, because it so often is more than meets the eye.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 1)
    elseif actor:get_quest_var("megalith_quest:nexpo") == 1 then
        self:say("As it turns out, that love was an extension of my natural affinity for Earth and nature.")
        wait(2)
        self:say("When I was a young woman of about 140 or so, I joined an order of arctic druids.  We worshiped in the Old Ways, paying respect to the cosmos from before the New Gods.")
        wait(4)
        self:say("In the Old Ways, I heard the voices of my ancestors.")
        wait(3)
        self:say("In the Old Ways, I heard the voice of my ancient Mother.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 2)
    elseif actor:get_quest_var("megalith_quest:nexpo") == 2 then
        self:say("She revealed to me that, just as we elves and the Fair Folk once shared a home in the Dreaming, our various traditions have common roots as well.")
        wait(5)
        self:say("Druidry and witchcraft are the same traditions, just viewed through different lenses.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 3)
    elseif actor:get_quest_var("megalith_quest:nexpo") == 3 then
        self:say("After many years, the Great Mother called upon me to find this Sisterhood.")
        wait(2)
        self:say("I believe She is guiding me to bring peace to my elven ancestors by bringing Her back to this realm and, with the aid of my Sisters, cleansing the demonic corruption of Templace.")
        wait(4)
        self:say("By growing up in a valley of frost and snow, I learned even the coldest winter is part of the natural cycle.  Even in the coldest places, spring eventually comes and the world is reborn.")
        wait(5)
        self:say("For beneath it all, the Earth rests.  Timeless.")
        wait(1)
        self:say("Just like I am.")
        actor:set_quest_var("megalith_quest", "nexpo", 0)
    end
end