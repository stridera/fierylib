-- Trigger: charm_person_serenade_speech
-- Zone: 580, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Five master charmers respond differently when the player asks "let me
-- serenade you", each declaring their preferred instrument so the
-- player knows which one to play.
--
-- The converter's 0% gate (a misread of DG num_arg 0 = phrase match) is gone
-- and the keyword `or` chain is now the full phrase "let me serenade you".
-- TODO: branches dispatch on legacy vnums (self.id == 3010, 58017,
-- 4353, 23721, 58406). Under composite keys self.id is local_id only,
-- so these never match. Rewrite as (self.zone_id, self.local_id) checks.

-- Speech phrase: let me serenade you (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]let me serenade you[%s%p]") then
    return true  -- Not the phrase
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    wait(2)
    -- switch on self.id
    if (self.zone_id == 30 and self.id == 10) then
        self:say("A little music sounds delightful.  I enjoy the gentle strum of a mandolin.")
    elseif (self.zone_id == 580 and self.id == 17) then
        self:say("How unconventional!  Usually I'm the one doing the wooing.  I dearly love the willowy call of the flute.")
    elseif (self.zone_id == 43 and self.id == 53) then
        self:say("Oh of course.")
        self:command("lick")
        wait(1)
        self:say("What can I say, I'm a sucker for a hot, long pipe.")
        self:command("grin")
    elseif (self.zone_id == 237 and self.id == 21) then
        actor:send(tostring(self.name) .. " tells you telepathically, 'A very strange request.  The only surface-dwelling music I can tolerate is the lute.'")
    elseif (self.zone_id == 584 and self.id == 6) then
        self:say("I would love to hear a tune!  Instruments that sound like the wind meeting the water are my favorite.")
    else
        _return_value = true
    end
end
return _return_value