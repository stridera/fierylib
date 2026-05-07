-- Trigger: vilekka-service
-- Zone: 237, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23751

-- Converted from DG Script #23751: vilekka-service
-- Original: MOB trigger, flags: SPEECH, probability: 100%
-- Response to 23750: starts the vilekka_stew quest for the speaker and any
-- group members in the room. 23755 is the drow master heart-spawning death
-- trigger that follows.

-- Speech keywords: service service?
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "service") then
    return true  -- No matching keywords
end
if actor.is_npc or actor.level > 99 or actor:get_has_completed("vilekka_stew") then
    return true
end
wait(1)
if actor:get_quest_stage("vilekka_stew") < 2 then
    if actor.alignment < 349 then
        self:command("con " .. tostring(actor.name))
        self:emote("smiles slowly.")
        self:say("Yes, you can be of great service to my city.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I am the High Priestess of the Spider Queen, and therefore I rule here.  But there is one who escaped my power...'")
        self:command("growl")
        wait(5)
        self:say("He must be destroyed.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I believe he is residing in one of your surface cities.  You should easily be able to recognize any drow up there, but this one...'")
        wait(5)
        self:command("sigh")
        self:say("He is always trying to pick fights.")
        self:emote("grins nastily.")
        wait(2)
        self:say("Or at least he was when he left here.")
        wait(3)
        self:say("Bring me his heart!  Then I shall reward you.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'You may ask about your <b:white>[progress]</> if you need.'")
        -- Start the quest for the speaker and any present group members.
        for _, person in ipairs(actor.group) do
            if person.room == self.room and person:get_quest_stage("vilekka_stew") == 0 then
                person:start_quest("vilekka_stew")
                person:send("<b:white>The quest has now begun!</>")
            end
        end
    end
elseif actor:get_quest_stage("vilekka_stew") == 2 then
    self:say("Well, do you want to continue or stop?")
elseif actor:get_quest_stage("vilekka_stew") == 3 then
    self:say("You must bring me the head of the drider king.")
elseif actor:get_quest_stage("vilekka_stew") == 4 then
    self:say("Well, do you want to continue or stop?")
elseif actor:get_quest_stage("vilekka_stew") == 5 then
    self.room:send(tostring(self.name) .. " says, 'Bring me some spices so that I can make this head and heart palatable.'")
else
    self:say(tostring(actor.name) .. ", you puzzle me.")
end