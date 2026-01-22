-- Trigger: quest_timulos_status
-- Zone: 60, ID: 25
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 6759 chars
--
-- Original DG Script: #6025

-- Converted from DG Script #6025: quest_timulos_status
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: subclass progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "subclass") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
local quest_name = actor:get_quest_var("merc_ass_thi_subclass:subclass_name")
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if quest_name == "mercenary" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
        actor:send(tostring(self.name) .. " says, 'Yes, a mercenary would serve well for that...'")
        self:emote("thinks back for a moment.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'He would pay well.  Yes, that <b:cyan>Lord</> would pay well indeed.'")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'An assassin would be perfect, but to show your true desire...'")
        self:emote("grins deeply, curling his lip up.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Yes, that would bring a good <b:cyan>price</>.'")
    elseif quest_name == "thief" then
        actor:send(tostring(self.name) .. " says, 'Hmmm, a true thief would have to get something I think.'")
        self:emote("smiles cruelly.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'There is a <b:cyan>package</> that someone could get back.'")
    end
    if quest_name == "mercenary" then
    elseif actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
        actor:send(tostring(self.name) .. " says, 'Well, a great Lord, who shall remain unnamed, has lost a cloak.'")
        self:command("smirk")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'He has come to me for its return.  If you went and procured it, he would be grateful.'")
        self:command("grin")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'And if he is grateful, I would be as well, and your training would be finished.  It would be quite a payday for a <b:cyan>cloak</>.'")
    elseif quest_name == "thief" then
        actor:send(tostring(self.name) .. " says, 'Yes a package.'")
        self:command("fume")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Some time ago it was sent and picked up by someone who should not have it.'")
        self:command("grumble")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Bloody <b:cyan>farmers</>.'")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'Yes, a great price.'")
        self:command("grin")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'I have some rich men unhappy with the politics of the region in question.  You could help with those <b:cyan>politics</> if you wish.'")
    end
    if quest_name == "mercenary" then
    elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        actor:send(tostring(self.name) .. " says, 'Well yes, this cloak is worth much to him.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'It was made off with in a raid on his castle by some bothersome insect warriors.'")
        self:command("mutter")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'All the Lord was able to tell me is they said something about wanting it for their queen.'")
        self:command("shrug")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you should go find it now.  Come back when you have the <b:yellow>cloak</>, or do not come back at all.'")
        self:command("open fence")
        self:emote("pushes " .. tostring(actor.name) .. " away.")
        actor.name:move("north")
        self:command("close fence")
    elseif quest_name == "assassin" then
        actor:send(tostring(self.name) .. " says, 'Ah yes, the politics of it all.  Personally I am not one for them, but some people get all mixed up in those.'")
        wait(2)
        self:command("consider " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " says, 'Well, you seem fit, I guess.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Go kill the Mayor of Mielikki.  He's probably holed up in his office in City Hall.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'You'll have to break in, sneak past the guards, and <red>kill</> him.  Get his <b:yellow>cane</> as proof and come back and give it to me.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'It is worth much to me if he dies, so get to it.  It will be worth it for you as well.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Well, go on.'")
        self:command("open fence")
        self:emote("pushes " .. tostring(actor.name) .. " away.")
        actor.name:move("north")
        self:command("close fence")
    elseif quest_name == "thief" then
        actor:send(tostring(self.name) .. " says, 'That is right, a <b:yellow>package</> was taken by a farmer who should not have it.'")
        self:command("grumble")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I know this: he got it from the post office in Mielikki and he lives near there.  Go get it back and I will make it worth it to you.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Do not let anyone see you and do not leave a trail of bodies behind you.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'And be careful!  If you jostle the package too much it just might explode.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'For now though, we are done, begone.'")
        wait(2)
        self:command("open fence")
        actor:send(tostring(self.name) .. " says, 'Well, go on.'")
        self:emote("pushes " .. tostring(actor.name) .. " harshly away.")
        actor.name:move("north")
        self:command("close fence")
    end
else
    if string.find(actor.class, "Rogue") then
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You are not on any quests from me.'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'I like your zeal, but it's a little too soon for you to subclass kid.'")
        else
            actor:send(tostring(self.name) .. " says, 'It's waaaaaaay too late to train you.  That ship has sailed!'")
        end
    else
        actor:send(tostring(self.name) .. " says, 'I don't train \"your type.\"  Now get lost.'")
    end
end