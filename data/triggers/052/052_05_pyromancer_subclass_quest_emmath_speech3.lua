-- Trigger: pyromancer_subclass_quest_emmath_speech3
-- Zone: 52, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5205
--
-- "quest" speech keyword. On first ask after stage 1, picks the actor's
-- assigned flame from alignment (white/gray/black), advances the stage,
-- and delivers the backstory monologue. Re-asks just get a grumble.

if not percent_chance(1) then
    return true
end

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "quest") then
    return true
end

wait(2)
if actor:get_quest_stage("pyromancer_subclass") == 1 then
    actor:advance_quest("pyromancer_subclass")
    local part
    if actor.alignment >= 350 then
        part = "white"
    elseif actor.alignment <= -350 then
        part = "black"
    else
        part = "gray"
    end
    actor:set_quest_var("pyromancer_subclass", "part", part)
    actor:send(tostring(self.name) .. " says, 'I seem to have a problem now, because some time ago...'")
    self:emote("sighs, looking troubled.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is just...'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Well, part of the essence of fire is no longer under my power.'")
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