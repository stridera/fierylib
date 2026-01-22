-- Trigger: shift_corpse_guildmaster_speech2
-- Zone: 62, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6202

-- Converted from DG Script #6202: shift_corpse_guildmaster_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: taken? god? who?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "taken?") or string.find(string.lower(speech), "god?") or string.find(string.lower(speech), "who?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("shift_corpse") == 1 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Not just any god will do, either.  It cannot be one who is")
    self.room:send("</>imprisoned in mortal flesh, like Kannon in Odaishyozen, no.'")
    self:command("shake")
    self.room:send(tostring(self.name) .. " says, 'It must be one unrestrained, at their full potential.")
    self.room:send("</>Fortunately there is a deity who has lost the support of the greater pantheon")
    self.room:send("</>leaving him vulnerable.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Lokari, God of the Moonless Night, in his outer planar")
    self.room:send("</>fortress is already wanted by the other gods for interfering in the world of")
    self.room:send("</>mortal men.'")
    wait(3)
    self:emote("opens a pitch black box.")
    wait(4)
    self:emote("takes a glowing black crystal from the box.")
    wait(1)
    self:say("Take this.")
    self.room:spawn_object(62, 28)
    self:command("give glowing-black-crystal " .. tostring(actor))
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Give it to Lokari and then banish him from the realm.  The")
    self.room:send("</>crystal will steal part of his divine spark and give you the energy you need,'")
    wait(3)
    self:say("This will not be easy.")
    wait(1)
    if not actor:get_has_completed("doom_entrance") then
        self.room:send(tostring(self.name) .. " says, 'You must consult with the three Oracles at the ancient")
        self.room:send("</>pyramid where Severan went to reclaim his stolen bride.  They will give you")
        self.room:send("</>further instructions on gaining access to Lokari's keep.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Find the Horn of the Hunt and the lost relics of Rhalean")
        self.room:send("</>and Timun, access Lokari's keep, fight past the horrors that await, and take")
        self.room:send("</>Lokari's power!'")
    end
    wait(3)
    self:say("May Death be ever at your back.")
    self:command("bow " .. tostring(actor.name))
end