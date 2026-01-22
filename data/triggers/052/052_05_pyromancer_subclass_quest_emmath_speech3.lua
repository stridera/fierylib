-- Trigger: pyromancer_subclass_quest_emmath_speech3
-- Zone: 52, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5205

-- Converted from DG Script #5205: pyromancer_subclass_quest_emmath_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: quest quest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "quest?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("pyromancer_subclass") == 1 then
    actor.name:advance_quest("pyromancer_subclass")
    if actor.alignment >= 350 then
        local part = "white"
    elseif actor.alignment <= -350 then
        local part = "black"
    else
        local part = "gray"
    end
    actor.name:set_quest_var("pyromancer_subclass", "part", part)
    actor:send(tostring(self.name) .. " says, 'I seem to have a problem now, because some time ago...'")
    self:emote("sighs, looking troubled.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is just...'")
    wait(1)
    self.room:send("</>msend " .. tostring(actor) .. " " .. tostring(self.name) .. " says, 'Well, part of the essence of fire is no longer under my power.'")
    self:emote("shakes his head sadly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif actor:get_quest_stage("pyromancer_subclass") > 1 then
    self:command("grumble")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I already told you about the quest.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Part of the flame is no longer under my <b:red>control</>.  You should remember that much.'")
end