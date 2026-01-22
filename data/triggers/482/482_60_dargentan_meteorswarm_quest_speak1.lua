-- Trigger: dargentan_meteorswarm_quest_speak1
-- Zone: 482, ID: 60
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48260

-- Converted from DG Script #48260: dargentan_meteorswarm_quest_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: teach help meteor meteorswarm meteorite air
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "teach") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "meteor") or string.find(string.lower(speech), "meteorswarm") or string.find(string.lower(speech), "meteorite") or string.find(string.lower(speech), "air")) then
    return true  -- No matching keywords
end
wait(1)
if actor:get_quest_stage("meteorswarm") == 4 then
    if actor.alignment > -349 then
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'The depths of thy training doth shine through.  I shalt teach thee for thou art stout and bold.'")
        wait(3)
        actor:send(tostring(self.name) .. " raises up, wings spread.")
        wait(2)
        actor:send(tostring(self.name) .. " begins to cast...")
        wait(3)
        actor:send("The sky swirls around the lair as all the crystals begin to hum and glow.")
        actor:send("You hear the music of the sky sing in your ears.")
        wait(1)
        actor:send("<b:white>The meteorite begins to hum in tune.</>")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'Dost thine ears perceive thus?  Tis the music of the spheres!  Remember it upon thy conjuring!'")
        actor:send("<b:white>You feel your mastery of the air growing!</>")
        actor.name:advance_quest("meteorswarm")
        wait(5)
        self:say("Alloweth this one to return thus to rest anon.")
        wait(2)
        self:command("sleep")
    else
        self:say("I shall help thee... TO SOAR 'MONGST THE BIRDS!!")
        wait(2)
        actor:send(tostring(self.name) .. " grabs you in his mighty claws and throws you bodily from the tower!")
        self.room:send_except(actor, tostring(self.name) .. " grabs " .. tostring(actor.name) .. " in his mighty claws and throws " .. tostring(actor.himher) .. " bodily from the tower!")
        actor:command("sit")
        actor:teleport(get_room(238, 93))
        wait(8)
        actor:send(self.name .. " tells you, '" .. "I doth desire thee didst enjoy thy lesson!" .. "'")
        wait(1)
        actor:send("<b:white>The meteorite begins to hum!")
        actor:send("Strangely enough, you do feel you have learned something significant about the power of the air.</>")
        actor.name:advance_quest("meteorswarm")
    end
end