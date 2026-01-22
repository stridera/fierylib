-- Trigger: quest_timulous_yesno
-- Zone: 60, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #6010

-- Converted from DG Script #6010: quest_timulous_yesno
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Rogue") and (actor.level >= 10 and actor.level <= 25) then
    if string.find(speech, "yes") then
        if actor:get_has_failed("merc_ass_thi_subclass") then
            actor:restart_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            actor:advance_quest("merc_ass_thi_subclass")
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Then try again.'")
            wait(2)
            if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
                actor:send(tostring(self.name) .. " says, 'Be careful this time!  Stay hidden getting in and out.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'And no murdering anyone!'")
            elseif actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
                actor:send(tostring(self.name) .. " says, 'And be quick about it!'")
            end
            return _return_value
        end
        if use_subclass then
            actor.name:start_quest("merc_ass_thi_subclass", use_subclass)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'So, you truly wish to continue.'")
            wait(1)
            if string.find(use_subclass, "Mer") then
                actor:send(tostring(self.name) .. " says, 'Yes, a mercenary would serve well for that...'")
                self:emote("thinks back for a moment.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'He would pay well.  Yes, that <b:cyan>Lord</> would pay well indeed.'")
            elseif string.find(use_subclass, "Ass") then
                actor:send(tostring(self.name) .. " says, 'An assassin would be perfect, but to show your true desire...'")
                self:emote("grins deeply, curling his lip up.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Yes, that would bring a good <b:cyan>price</>.'")
            elseif string.find(use_subclass, "Thi") then
                actor:send(tostring(self.name) .. " says, 'Hmmm, a true thief would have to get something I think.'")
                self:emote("smiles cruelly.")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'There is a <b:cyan>package</> that someone could get back.'")
            end
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[subclass progress]</> if you need.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have to pick one first!'")
            wait(2)
            self:command("tap")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Well which would you like to train as: <yellow>mercenary</>, <red>assassin</>, or <b:red>thief</>?'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Say one of them.'")
        end
    elseif string.find(speech, "no") then
        actor:send(tostring(self.name) .. " says, 'Well then go away.'")
        self:emote("points north.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I said go.'")
        self:emote("pushes " .. tostring(actor.name) .. " away.")
        self:command("open fence")
        actor.name:move("north")
        self:command("close fence")
    end
end
use_subclass = nil