-- Trigger: berserker_hjordis_speech1
-- Zone: 364, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36409

-- Converted from DG Script #36409: berserker_hjordis_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: among among? number number? who who?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "among") or string.find(string.lower(speech), "among?") or string.find(string.lower(speech), "number") or string.find(string.lower(speech), "number?") or string.find(string.lower(speech), "who") or string.find(string.lower(speech), "who?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Warrior") then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- if %actor.level% >= 10 && %actor.level% <= 25
    -- msend %actor% &1Your race may not subclass to berserker.&0
    -- halt
    -- endif
    -- break
    wait(2)
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Aye, you have the mettle of the most fearsome of all warriors, a &9<blue>ber<red>ser&9ker</>!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Do you think you have what it takes?'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Build your rage further, then seek me out again.'")
    end
end