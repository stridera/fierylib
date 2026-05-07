-- Trigger: pyromancer_subclass_quest_emmath_speech4
-- Zone: 52, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5206
--
-- "control"/"taken" follow-up after #5205. On stage 2, advances to 3 and
-- gives the location hint matching the actor's assigned flame.

if not percent_chance(1) then
    return true
end

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "control") or string.find(speech_lower, "taken")) then
    return true
end
wait(2)
if actor:get_quest_stage("pyromancer_subclass") == 2 then
    actor:advance_quest("pyromancer_subclass")
    self:command("nod " .. tostring(actor.name))
elseif actor:get_quest_stage("pyromancer_subclass") > 2 then
    self:command("roll")
    actor:send(tostring(self.name) .. " says, 'I already told you once.'")
    wait(2)
    self:command("sigh")
end
if actor:get_quest_stage("pyromancer_subclass") >= 2 then
    actor:send(tostring(self.name) .. " says, 'Yes, I once had control over all three fire elements.'")
    self:emote("again shakes his head sadly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me.'")
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
    self:emote("mutters something about the villainy of it all.")
    wait(3)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Are you still here?  You should leave now.'")
end