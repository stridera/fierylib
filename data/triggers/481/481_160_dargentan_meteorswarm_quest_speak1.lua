-- Trigger: dargentan_meteorswarm_quest_speak1
-- Zone: 481, ID: 160
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48260

-- Converted from DG Script #48260: dargentan_meteorswarm_quest_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"teach", "help", "meteor", "meteorswarm", "meteorite", "air"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
if actor:get_quest_stage("meteorswarm") == 4 then
    if actor.alignment > -349 then
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'The depths of thy training doth shine through.  I shalt teach thee for thou art stout and bold.'")
        wait(3)
        actor:send(tostring(self.name) .. " raises up, wings spread.")
        wait(0.2)
        actor:send(tostring(self.name) .. " begins to cast...")
        wait(3)
        actor:send("The sky swirls around the lair as all the crystals begin to hum and glow.")
        actor:send("You hear the music of the sky sing in your ears.")
        wait(1)
        actor:send("<b:white>The meteorite begins to hum in tune.</>")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'Dost thine ears perceive thus?  Tis the music of the spheres!  Remember it upon thy conjuring!'")
        actor:send("<b:white>You feel your mastery of the air growing!</>")
        actor:advance_quest("meteorswarm")
        wait(5)
        self:say("Alloweth this one to return thus to rest anon.")
        wait(0.2)
        self:command("sleep")
    else
        self:say("I shall help thee... TO SOAR 'MONGST THE BIRDS!!")
        wait(0.2)
        actor:send(tostring(self.name) .. " grabs you in his mighty claws and throws you bodily from the tower!")
        self.room:send_except(actor, tostring(self.name) .. " grabs " .. tostring(actor.name) .. " in his mighty claws and throws " .. tostring(actor.himher) .. " bodily from the tower!")
        actor:command("sit")
        actor:teleport(get_room(238, 93))
        wait(8)
        actor:send(self.name .. " tells you, '" .. "I doth desire thee didst enjoy thy lesson!" .. "'")
        wait(1)
        actor:send("<b:white>The meteorite begins to hum!")
        actor:send("Strangely enough, you do feel you have learned something significant about the power of the air.</>")
        actor:advance_quest("meteorswarm")
    end
end