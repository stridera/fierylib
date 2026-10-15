-- Trigger: LP2_bard_subclass_receive
-- Zone: 43, ID: 61
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4361

-- Converted from DG Script #4361: LP2_bard_subclass_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on actor:get_quest_stage("bard_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
    if tonumber(_sw1) == 3 then
        _return_value = true
        actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
        actor:send(tostring(self.name) .. " slaps " .. tostring(object.shortdesc) .. " out of your hand!")
        self.room:send_except(actor, tostring(self.name) .. " slaps " .. tostring(object.shortdesc) .. " out of " .. tostring(actor.name) .. "'s hand!")
        actor:command("drop berthe-script")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Pick it up and take a look again.  Make sure it's the the right thing.'")
    elseif tonumber(_sw1) == 4 then
        actor:advance_quest("bard_subclass")
        wait(0.2)
        self:destroy_item("berthe-script")
        self.room:send(tostring(self.name) .. " flips through the script.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Yeah, this is it for sure.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Alright, let's <b:cyan>hear a line or two</>.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Since you already gave me the script I sure hope you're off book!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'That means \"memorized\" in the biz.'")
        self:command("wink " .. tostring(actor))
    else
        wait(0.2)
        self:destroy_item("berthe-script")
        actor:send(tostring(self.name) .. " says, 'Huh, I was looking for that.  Thanks!'")
    end
end
return _return_value