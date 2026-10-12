-- Trigger: megalith_quest_priestess_speech_stage2
-- Zone: 123, ID: 7
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12307

-- Converted from DG Script #12307: megalith_quest_priestess_speech_stage2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"under"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Preset item vars
local item = 0
local speech1 = "Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!"
local speech2 = "Under the watchful eye of Earth Air Fire and Water we awaken this hallowed ground"
local speech3 = "Under the watchful eye of Earth Air Fire and Water we awaken this hallowed ground!"
local speech4 = "Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground"
local item1 = actor:get_quest_var("megalith_quest:item1")
local item2 = actor:get_quest_var("megalith_quest:item2")
local item3 = actor:get_quest_var("megalith_quest:item3")
local item4 = actor:get_quest_var("megalith_quest:item4")
if speech == speech1 or speech == speech2 or speech == speech3 or speech == speech4 then
    if actor:get_quest_stage("megalith_quest") == 2 then
        if item1 and item2 and item3 and item4 then
            actor:advance_quest("megalith_quest")
            -- Reset quest 'item' variables
            for slot = 1, 5 do
                actor:set_quest_var("megalith_quest", "item" .. tostring(slot), 0)
            end
            wait(1)
            self.room:send("<b:white>The menhir begin to hum with deep chthonic harmonics.</>")
            wait(3)
            self:say("It's working!  I can feel the energies of the stones returning to life.")
            wait(1)
            self:emote("closes her eyes and basks in the chthonic resonance.")
            wait(3)
            self:emote("opens her eyes, invigorated.")
            self:say("We're so close to success!")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'With the circle cast and the land prepared, I require three holy <b:cyan>reliquaries</> to summon our Goddess.'")
        end
    end
end