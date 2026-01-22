-- Trigger: pyro_subclass_flameball_emmath_status
-- Zone: 52, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #5211

-- Converted from DG Script #5211: pyro_subclass_flameball_emmath_status
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "subclass") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
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
    -- switch on actor:get_quest_var("pyromancer_subclass:part")
    if actor:get_quest_var("pyromancer_subclass:part") == "white" then
        local place = "&bin some kind of mine&0"
    elseif actor:get_quest_var("pyromancer_subclass:part") == "black" then
        local place = "&bin some kind of temple&0"
    elseif actor:get_quest_var("pyromancer_subclass:part") == "gray" then
    else
        local place = "&bnear some kind of hill&0"
    end
    actor:send(tostring(self.name) .. " says, 'Last I heard, it was <b:cyan>" .. tostring(place) .. "</>, or something of the like.'")
    if actor:get_has_completed("pyromancer_subclass") then
        actor:send(tostring(self.name) .. " says, 'You're already a pyromancer you ninny.'")
    else
        -- switch on actor.race
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_frost" or actor.race == "arborean" then
                actor:send("<red>Your race may not subclass to pyromancer.</>")
                return _return_value
            end
        else
            if actor.level >= 10 and actor.level <= 45 then
                actor:send(tostring(self.name) .. " says, 'You aren't working to be a pyromancer.'")
            elseif actor.level < 10 then
                actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
            else
                actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
            end
        end
    end
end  -- auto-close block