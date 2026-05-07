-- Trigger: charm_person_serenade_speech
-- Zone: 580, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Five master charmers respond differently when the player asks "let me
-- serenade you", each declaring their preferred instrument so the
-- player knows which one to play.
--
-- TODO: legacy DG probability was 0% -- almost certainly a converter
-- artifact (the keyword gate is the real driver). The 0% gate currently
-- makes this trigger never fire, which breaks the stage-4 path.
-- TODO: keyword "let / me / you" match nearly any sentence; should
-- probably require the full phrase "let me serenade you" or just
-- "serenade".
-- TODO: branches dispatch on legacy vnums (self.id == 3010, 58017,
-- 4353, 23721, 58406). Under composite keys self.id is local_id only,
-- so these never match. Rewrite as (self.zone_id, self.local_id) checks.

-- 0% chance to trigger (preserved from original DG -- see TODO)
if not percent_chance(0) then
    return true
end

-- Speech keywords: let me serenade you
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "let") or string.find(speech_lower, "me") or string.find(speech_lower, "serenade") or string.find(speech_lower, "you")) then
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
        _return_value = true
    end
end
return _return_value