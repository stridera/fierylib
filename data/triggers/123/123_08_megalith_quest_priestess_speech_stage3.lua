-- Trigger: megalith_quest_priestess_speech_stage3
-- Zone: 123, ID: 8
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #12308

-- Converted from DG Script #12308: megalith_quest_priestess_speech_stage3
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: reliquaries reliquaries?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reliquaries") or string.find(string.lower(speech), "reliquaries?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("megalith_quest") == 3 then
    wait(2)
    self:say("Indeed.  Sources of divine power to guide the Invocation:")
    self.room:send("</>")
    self.room:send("- A <b:yellow>prayer bowl</> to scry upon and pierce through the veil between the worlds.")
    self.room:send("</>    I believe greater Celestials bring such things from the Outer Planes.")
    self.room:send("</>")
    self.room:send("- An <b:yellow>icon to represent the divine feminine</>.")
    self.room:send("</>    Any piece of the sacred regalia of another Goddess would be an appropriate")
    self.room:send("</>    icon.")
    self.room:send("</>")
    self.room:send("- Something to represent Her fey nature.")
    self.room:send("</>    There are several <b:yellow>faerie relics</> where the King of Dreams' realm has fused")
    self.room:send("</>    with ours.  I believe any of them will do.")
    -- (empty room echo)
    self:say("Bring me these and we shall perform the Invocation!")
end