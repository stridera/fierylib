-- Trigger: charm_person_serenade_speech
-- Zone: 580, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58006

-- Converted from DG Script #58006: charm_person_serenade_speech
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: let me serenade you
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "let") or string.find(string.lower(speech), "me") or string.find(string.lower(speech), "serenade") or string.find(string.lower(speech), "you")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    wait(2)
    -- switch on self.id
    if self.id == 3010 then
        self:say("A little music sounds delightful.  I enjoy the gentle strum of a mandolin.")
    elseif self.id == 58017 then
        self:say("How unconventional!  Usually I'm the one doing the wooing.  I dearly love the willowy call of the flute.")
    elseif self.id == 4353 then
        self:say("Oh of course.")
        self:command("lick")
        wait(1)
        self:say("What can I say, I'm a sucker for a hot, long pipe.")
        self:command("grin")
    elseif self.id == 23721 then
        actor:send(tostring(self.name) .. " tells you telepathically, 'A very strange request.  The only surface-dwelling music I can tolerate is the lute.'")
    elseif self.id == 58406 then
        self:say("I would love to hear a tune!  Instruments that sound like the wind meeting the water are my favorite.")
    else
        _return_value = false
    end
end
return _return_value