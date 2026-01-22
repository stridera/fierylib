-- Trigger: merchant dialogue
-- Zone: 625, ID: 18
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 5456 chars
--
-- Original DG Script: #62518

-- Converted from DG Script #62518: merchant dialogue
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: help yes sacred spring power permanent solution powerful people hi hello hurt ok okay
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "sacred") or string.find(string.lower(speech), "spring") or string.find(string.lower(speech), "power") or string.find(string.lower(speech), "permanent") or string.find(string.lower(speech), "solution") or string.find(string.lower(speech), "powerful") or string.find(string.lower(speech), "people") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "hurt") or string.find(string.lower(speech), "ok") or string.find(string.lower(speech), "okay")) then
    return true  -- No matching keywords
end
wait(1)
local speech = speech
if actor.id == -1 then
    if actor:get_quest_stage("ursa_quest") < 1 then
        if string.find(speech, "help") or string.find(speech, "ok") or string.find(speech, "yes") then
            actor.name:start_quest("ursa_quest")
            self:emote("looks at you.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'You'll help me?!'")
            return _return_value
        elseif string.find(speech, "hi") or string.find(speech, "hello") then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Please, I'm very ill.  Can you <b:cyan>help</> me?'")
            return _return_value
        elseif string.find(speech, "hurt") then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I'm very sick.  The disease makes me lose control.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'When I do, I... hurt people.'")
            self:command("shudder")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Please <b:cyan>help</> me!")
        end
    end
    if actor:get_quest_stage("ursa_quest") == 1 then
        if string.find(speech, "yes") then
            actor:send(tostring(self.name) .. " says, 'I am suffering from werebear lycanthropy in its early stages.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'The <b:cyan>power of this sacred spring</> is halting the disease's progression.'")
            return _return_value
        elseif string.find(speech, "sacred") or string.find(speech, "spring") or string.find(speech, "power") then
            actor:send(tostring(self.name) .. " says, 'As long as I am near this spring, and no one gives fuel to the disease's rage...'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I can retain my true form.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, '...for now.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But, I must find a more <b:cyan>permanent solution</>.'")
            return _return_value
        elseif string.find(speech, "permanent") or string.find(speech, "solution") then
            self:command("sigh")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Many say there is no cure for lycanthropy.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, '...aside from death.'")
            wait(1)
            self:command("shudder")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But in my travels I've met many <b:cyan>powerful people</>.  At least one of them has to know more...'")
            wait(1)
            self:emote("hesitates for a moment, grasping for words.")
            wait(1)
            actor:send(tostring(self.name) .. " says, '...more favorable remedy.'")
            return _return_value
        elseif string.find(speech, "powerful") or string.find(speech, "people") then
            actor:send(tostring(self.name) .. " says, 'On a nearby island are a very refined people.  They've found cures for many things, and are in good favor with powerful gods.  Perhaps the Lord of their island will know how to help me.'")
            wait(6)
            actor:send(tostring(self.name) .. " says, 'I also know that Blackmourne has always shown a lot of interest and ability in diseases of the mind.  I've traveled to the Red City many times to bring the cultists fresh...'")
            wait(4)
            self:emote("hesitates.")
            wait(2)
            actor:send(tostring(self.name) .. " says, '...supplies.  Perhaps one of them might help.'")
            wait(6)
            actor:send(tostring(self.name) .. " says, 'Then there's the old nut in the swamp.  If all else fails, maybe he's got some sort of remedy.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Whichever one you manage to contact, they will know who I am.  Just bring me back news of what can be done to help me.  I'm sure one of them will know what to do.'")
            return _return_value
        end
    end
    if actor:get_quest_stage("ursa_quest") > 1 then
        actor:send(tostring(self.name) .. " says, 'Please, what do you have for me?'")
        return _return_value
    end
end