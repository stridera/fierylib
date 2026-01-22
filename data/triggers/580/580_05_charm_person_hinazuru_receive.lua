-- Trigger: charm_person_hinazuru_receive
-- Zone: 580, ID: 5
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 8281 chars
--
-- Original DG Script: #58005

-- Converted from DG Script #58005: charm_person_hinazuru_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("charm_person")
if stage == 1 then
    if object.id == 48008 then
        actor.name:advance_quest("charm_person")
        wait(2)
        self:destroy_item("discipline")
        wait(1)
        self:say("Thank you kindly for bringing this so quickly.")
        self:command("bow " .. tostring(actor.name))
        wait(2)
        actor:send(tostring(self.name) .. " gives you an explanation and demonstration of " .. tostring(objects.template(480, 8).name) .. "'s power and function.")
        wait(3)
        self:say("Having seen this magic in a controlled environment now, I believe it's best to see it in action.")
        wait(2)
        self:say("Many people underestimate the power of charms and enchantments.  They discard them as ineffective or weak compared to more violent magic.")
        wait(4)
        self:say("Yet there is a company of performers in Anduin that proves the most insidious spells do not harm people directly, but convince them to harm themselves.")
        wait(4)
        self:say("They perform a deadly song and dance number which results in the sacrifice of an unwitting accomplice.  They give out rings of fire to those who participated at the end of the show.")
        wait(4)
        self:say("Go and watch this in action.  Bring back the fire ring as a token of your experience.")
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not the Rod of Discipline.")
    end
elseif stage == 2 then
    if object.id == 4319 then
        actor.name:advance_quest("charm_person")
        wait(2)
        self:destroy_item("ring")
        wait(1)
        self:say("Thank you kindly for bringing this so quickly.")
        self:command("bow " .. tostring(actor.name))
        wait(2)
        self:say("It's horrific what charms can make people do, isn't it?")
        wait(1)
        self:command("shake")
        wait(1)
        self:say("Yet I am glad you have seen it now so you understand the risks involved in charming and beguiling.")
        wait(3)
        self:say("I also had you observe the theatre because you need to have at least a limited knowledge of music.")
        wait(3)
        self:say("As a courtesan, I am expected to be a master of several instruments, as well as song and dance.  As a magician, I use this same mastery as a key element in my spells.")
        wait(2)
        self:say("You will need to seek out musical instruments to hone your charming skills.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'There are five instruments you must find:")
        self.room:send("- One is merely the <b:yellow>biwa</> held by Yoshino down the hall_")
        self.room:send("- Two are <b:yellow>flutes</> hidden from the sun:")
        self.room:send("</>    One <b:yellow>deep in the sea to the east</>")
        self.room:send("</>    The other <b:yellow>in a mine near Anduin</>_")
        self.room:send("- One is a <b:yellow>hand-fashioned reed pipe</>, popular with people far far to the west_")
        self.room:send("- The final is <b:yellow>a mandolin</>, found in the homes of the gods'")
        wait(4)
        self:say("Once you have found all five of these, come back to me so I may check their condition and ensure their proper tuning.")
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not one of the souvenirs the theatre company gives out after a performance.")
    end
elseif stage == 3 then
    if object.id == 58017 or object.id == 16312 or object.id == 48925 or object.id == 37012 or object.id == 41119 then
        if actor.quest_variable["charm_person:" .. object.vnum] then
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("You have already brought me " .. tostring(object.shortdesc) .. ".")
        else
            actor.name:set_quest_var("charm_person", "%object.vnum%", 1)
            wait(2)
            self.room:send(tostring(self.name) .. " checks " .. tostring(object.shortdesc) .. " for tuning and quality.")
            wait(1)
            self:say("Yes, this should do.  Now come sit, it is time for a lesson.")
            wait(2)
            actor.name:send(tostring(self.name) .. " begins to teach you several basic techniques and a few melodies.")
            self.room:send_except(actor, tostring(self.name) .. " begins to teach " .. tostring(actor.name) .. " several basic techniques and a few melodies.")
            wait(5)
            actor:send("You begin to get a feel for it...")
            wait(7)
            actor:send("After several hours, you seem to have picked up the basics!")
            self.room:send_except(actor, "After several hours, " .. tostring(actor.name) .. " seems to have picked up the basics!")
            self:command("give all " .. tostring(actor))
            self:say("Hold on to that instrument, you'll need it later.")
            wait(2)
            if actor:get_quest_var("charm_person:58017") and actor:get_quest_var("charm_person:16312") and actor:get_quest_var("charm_person:48925") and actor:get_quest_var("charm_person:37012") and actor:get_quest_var("charm_person:41119") then
                actor.name:advance_quest("charm_person")
                wait(4)
                self:say("You now have at least a modicum of experience in five instruments.  It is time to put your skills to the test and see what you have learned!")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'There are five master charmers in the world.  Take these instruments out and see if you can impress them.  Each one prefers a different kind of music, so be ready to show off your skills!")
                self.room:send("</>")
                self.room:send("</>- One runs the <b:magenta>jewelry shop in Mielikki.</>")
                self.room:send("</>- One is a local <b:magenta>actor</> here on the <b:magenta>Emerald Island.</>")
                self.room:send("</>- One works with the <b:magenta>acting company in Anduin</>, playing their <b:magenta>Queen.</>")
                self.room:send("</>- One is a <b:magenta>hideous creature that enslaves minds</> in the dark <b:magenta>drow city.</>")
                self.room:send("</>- The last can be any of the <b:magenta>river nymphs</> in the <b:magenta>Realm of the King of Dreams.</>_")
                self.room:send("</>Say to them <b:magenta>[Let me serenade you]</> and see what they do.'")
                wait(5)
                self:say("It is here our paths must split.")
                wait(1)
                self:say("It has been my pleasure to work with you.")
                wait(1)
                self:say("Farewell.")
                self:command("bow " .. tostring(actor.name))
            else
                local music = (actor:get_quest_var("charm_person:58017") + actor:get_quest_var("charm_person:16312") + actor:get_quest_var("charm_person:48925") + actor:get_quest_var("charm_person:37012") + actor:get_quest_var("charm_person:41119"))
                if music > 0 and music < 4 then
                    self:say("Do you have the other instruments?")
                elseif music == 4 then
                    self:say("Do you have the last instrument?")
                end
            end
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say(tostring(object.shortdesc) .. " is not a musical instrument.")
    end
else
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I am in need of nothing at the moment, thank you.")
end
return _return_value