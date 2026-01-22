-- Trigger: Infidel speech destroy?
-- Zone: 480, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48030

-- Converted from DG Script #48030: Infidel speech destroy?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: destroy?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "destroy?")) then
    return true  -- No matching keywords
end
if actor.alignment < -349 then
    if actor.level > 80 then
        wait(2)
        self:say("If you bring me the prince's skull, I can reward you.")
        wait(1)
        self:say("He is bound by certain rules.  If you say 'the champion wishes to challenge you by proxy', he will be forced to fight you.")
        wait(1)
        self:command("smile")
        self:say("That way, my victory will be absolute.")
    else
        self:say("If you are able to return once you are stronger, perhaps you can be of great assistance then.")
        wait(1)
        self:say("Now leave.")
    end
end