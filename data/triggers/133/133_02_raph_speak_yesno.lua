-- Trigger: raph_speak_yesno
-- Zone: 133, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13302

-- Converted from DG Script #13302: raph_speak_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    if string.find(speech, "yes") then
        self:say("So you want to help me do you? Well that is useful, maybe I will survive.")
        actor.name:start_quest("get_raph_food")
        self:command("smile")
        self:say("Please go get me some grain, I am very hungry and may pass on at any time.")
    end
    if string.find(speech, "no") then
        self:say("Fine, let me die get out!")
        self:command("spit " .. tostring(actor.name))
        wait(1)
        actor:send("Raph taps his wrists together and you are covered in smoke!")
        self.room:send_except(actor, "Raph glares at " .. tostring(actor.name) .. " and sends him elsewhere!")
        actor:teleport(get_room(133, 1))
    end
end