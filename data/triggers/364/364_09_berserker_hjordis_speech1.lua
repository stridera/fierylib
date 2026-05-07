-- Trigger: berserker_hjordis_speech1
-- Zone: 364, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36409

-- Converted from DG Script #36409: berserker_hjordis_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: among, number, who
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "among") or string.find(speech_lower, "number") or string.find(speech_lower, "who")) then
    return true
end
if string.find(actor.class, "Warrior") then
    -- TODO(parity): legacy DG left placeholder for race restrictions:
    --   "Your race may not subclass to berserker." Restricted race list TBD.
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Aye, you have the mettle of the most fearsome of all warriors, a &9<blue>ber<red>ser&9ker</>!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Do you think you have what it takes?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Build your rage further, then seek me out again.'")
    end
end