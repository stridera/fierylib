-- Trigger: east_exposition
-- Zone: 123, ID: 39
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Large script: 5835 chars
--
-- Original DG Script: #12339

-- Converted from DG Script #12339: east_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: who continue
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "who") or string.find(string.lower(speech), "continue")) then
    return true  -- No matching keywords
end
if (string.find(speech, "who") are you or string.find(speech, "continue")) and actor.id == -1 then
    wait(2)
    if actor:get_quest_var("megalith_quest:eexpo") == 0 then
        self:say("Who am I?  Are you sure you want to know?")
        self:emote("looks around slightly confused.")
        wait(4)
        self:say("Well, okay!  I come from the \"Fourth City\", Nordus.  Ever heard of it?  We used to be known for --")
        wait(2)
        self.room:send(tostring(self.name) .. " suddenly lets out a blood curdling scream!")
        wait(3)
        self.room:send("She continues to scream.")
        wait(3)
        self.room:send("And scream.")
        wait(3)
        self.room:send("And scream.")
        wait(4)
        self.room:send(tostring(self.name) .. " quickly falls silent.")
        self.room:send(tostring(self.name) .. " looks around herself, blinking.")
        wait(4)
        self:say("I'm sorry, did something weird just happen?  If you've ever been to Nordus, you may have seen stuff like that before...")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 1)
    elseif actor:get_quest_var("megalith_quest:eexpo") == 1 then
        self:say("I was an acolyte under the most respected cleric in Nordus, the great Shema.")
        wait(4)
        self:say("Shema was brilliant.  She loved languages and codes, though her favorite magic password was just spelling her name backward!")
        wait(5)
        self:say("She talked about all sorts of languages, like ones called \"Gir-main\" and \"Fence\".")
        self:command("laugh")
        wait(6)
        self:say("Have you ever heard of anything that ridiculous?!  A talking fence?!  Talking front doors, sure, but a fence??  Come on!!")
        self:command("rofl")
        wait(2)
        self:emote("wipes a tear from her eye.")
        self.room:send(tostring(self.name) .. " says, 'Aaaahhh Shema, good times...  Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 2)
    elseif actor:get_quest_var("megalith_quest:eexpo") == 2 then
        self:say("Anyway, when Luchiaans arrived in Nordus and the \"sickness\" started, Shema was the only one with enough wit to suspect him.  There was a book she --")
        wait(1)
        self:emote("suddenly focuses intently on a vacant space, as if listening to someone.")
        wait(4)
        self:say("Yes Umberto, the only one besides you.")
        wait(4)
        self.room:send(tostring(self.name) .. " whispers under her breath, 'He doesn't like to be left out...  It makes him feel invisible.'")
        wait(3)
        self:say("Point is, after he arrived, things changed.  For example, I met Umberto here!'")  -- typo: sat
        wait(3)
        self:emote("points at the empty space next to her.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 3)
    elseif actor:get_quest_var("megalith_quest:eexpo") == 3 then
        self:say("Turns out, Luchiaans had been conducting necromantic experiments on us while looking for a powerful tome about healing the body beyond death hidden in Nordus.")
        wait(5)
        self:say("Shema caught on to his plot, so she warded the book with her favorite code, bundled up a few of us and hit the road!")
        wait(4)
        self:say("We had plenty of adventures before Shema finally kicked the bucket a few years back.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 4)
    elseif actor:get_quest_var("megalith_quest:eexpo") == 4 then
        self:say("We eventually discovered we carried a part of Nordus within us everywhere we went.")
        wait(3)
        self:say("Luchiaans' experimentations had permanently changed us.  Our magics never really worked the same way again.")
        wait(3)
        self:say("I started... hearing things...  Whispers in the dark, voices when no one was around...")
        wait(3)
        self:say("At first I thought I was finally succumbing to the madness of Nordus, but then I was visited with a revelation from the stars.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 5)
    elseif actor:get_quest_var("megalith_quest:eexpo") == 5 then
        self:say("Luchiaans' meddling had somehow opened my mind to a deeper consciousness.  By total accident, I connected to the Lady of the Stars on the other side of the Veil!")
        wait(5)
        self:say("She explained the voices I was hearing was the wind calling me to dance.")
        wait(5)
        self:say("Unfit for service to the New Gods anymore, I followed the guidance of our Lady until I ran right into the coven.")
        wait(5)
        self:say("Literally, I ran face-first into " .. tostring(mobiles.template(123, 3).name) .. "!")
        self:command("laugh")
        wait(4)
        self:say("Suddenly everything made sense.  I had found my purpose and a new family.  Umberto and I have been part of the coven ever since.")
        actor:set_quest_var("megalith_quest", "eexpo", 0)
    end
end