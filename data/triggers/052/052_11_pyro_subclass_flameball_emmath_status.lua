-- Trigger: pyro_subclass_flameball_emmath_status
-- Zone: 52, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5211
--
-- "subclass"/"progress" status check for the pyromancer_subclass quest.
-- The legacy DG used probability 0 to suppress random firing; this is a
-- deliberate keyword-only handler invoked when other speech triggers
-- forward to it. Repeats Emmath's monologue for each stage so players
-- can re-read where they're at.

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true
end
wait(2)
-- switch on actor:get_quest_stage("pyromancer_subclass")
if actor:get_quest_stage("pyromancer_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Only the best and most motivated of mages will complete the <b:red>quest</> I lay before you.'")
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.'")
elseif actor:get_quest_stage("pyromancer_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'You want to be a pyromancer?'")
    wait(1)
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
elseif actor:get_quest_stage("pyromancer_subclass") == 3 or actor:get_quest_stage("pyromancer_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'I'm giving you your quest to become a pyromancer.  Pay attention!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me.")
    self:command("look " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'To truly help, I suggest you stop loitering and go recover it.'")
    self:command("ponder")
    wait(2)
    local part = actor:get_quest_var("pyromancer_subclass:part")
    local place
    if part == "white" then
        place = "&bin some kind of mine&0"
    elseif part == "black" then
        place = "&bin some kind of temple&0"
    elseif part == "gray" then
        place = "&bnear some kind of hill&0"
    else
        place = "&bsomewhere out there&0"
    end
    actor:send(tostring(self.name) .. " says, 'Last I heard, it was <b:cyan>" .. tostring(place) .. "</>, or something of the like.'")
    if actor:get_has_completed("pyromancer_subclass") then
        actor:send(tostring(self.name) .. " says, 'You're already a pyromancer you ninny.'")
    elseif actor.race == "dragonborn_frost" or actor.race == "arborean" then
        actor:send("<red>Your race may not subclass to pyromancer.</>")
    elseif actor.level >= 10 and actor.level <= 45 then
        actor:send(tostring(self.name) .. " says, 'You aren't working to be a pyromancer.'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
    end
end