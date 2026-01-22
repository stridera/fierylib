-- Trigger: vilekka-service
-- Zone: 237, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #23751

-- Converted from DG Script #23751: vilekka-service
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: service service?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "service") or string.find(string.lower(speech), "service?")) then
    return true  -- No matching keywords
end
-- OK, this is in response to 23750, the beginning of the vilekka_stew quest.
-- By responding favorably to her, they begin. 23755 is the drow master
-- head-spawning death trigger.
if actor.id ~= -1 or actor.level > 99 or actor:get_has_completed("vilekka_stew") then
    return _return_value
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
        local person = actor
        local i = person.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("vilekka_stew") == 0 then
                    person.name:start_quest("vilekka_stew")
                    person:send("<b:white>The quest has now begun!</>")
                end
            elseif person and person.id == -1 then
                local i = i + 1
            end
            local a = a + 1
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