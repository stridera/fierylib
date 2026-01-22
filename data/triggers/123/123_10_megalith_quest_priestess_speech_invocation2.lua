-- Trigger: megalith_quest_priestess_speech_invocation2
-- Zone: 123, ID: 10
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12310

-- Converted from DG Script #12310: megalith_quest_priestess_speech_invocation2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: we summon and stir thee
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "we") or string.find(string.lower(speech), "summon") or string.find(string.lower(speech), "and") or string.find(string.lower(speech), "stir") or string.find(string.lower(speech), "thee")) then
    return true  -- No matching keywords
end
local speech1 = "we summon and stir thee"
local speech2 = "we summon and stir thee!"
local stage = actor:get_quest_stage("megalith_quest")
local summon = actor:get_quest_var("megalith_quest:summon")
if (string.find(speech, "speech1")) or (string.find(speech, "speech2")) then
    if (stage == 4) and (self.room == 12389) and (actor:get_quest_var("megalith_quest:prayer") == 2) then
        -- switch on summon
        if summon == 1 then
            run_room_trigger(12318)
            wait(5)
            self.room:send(tostring(self.name) .. " chants:")
            self.room:send("'By Earth, Air, Water, and Fire,")
            self.room:send("</>To bring you home is our desire.'")
            wait(4)
            run_room_trigger(12319)
            actor.name:set_quest_var("megalith_quest", "summon", 2)
        elseif summon == 2 then
            run_room_trigger(12320)
            wait(2)
            self.room:send(tostring(self.name) .. " chants:")
            self.room:send("'Through the plane of vaulted sky")
            self.room:send("</>On shooting stars and moonbridge high.'")
            wait(4)
            run_room_trigger(12321)
            actor.name:set_quest_var("megalith_quest", "summon", 3)
        elseif summon == 3 then
            -- 
            -- 12320 is a wecho of just the phrase 'We summon and stir thee'
            -- It is intentionally repeated at the top of this case to echo the questor
            -- 
            run_room_trigger(12320)
            wait(2)
            self.room:send(tostring(mobiles.template(123, 1).name) .. " says, '<b:cyan>We invoke thee</>!")
        end
    end
end