-- Trigger: group_heal_doctor_speech2
-- Zone: 185, ID: 18
-- Type: MOB, Flags: SPEECH
--
-- Player accepts the doctor's offer to help with the group_heal quest.
-- Starts the quest and spawns the bandit raider in the desert.
--
-- TODO(parity): the elseif chain at the bandit-spawn block (stages
-- 3/4/5) is unreachable because the outer guard requires stage 0.
-- The legacy intent was likely a separate "yes" handler for later
-- stages; needs review with the original DG to split correctly.

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes!", "yep", "yep!", "okay", "sure"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if ((string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    actor:start_quest("group_heal")
    self:say("Thank you so much!")
    wait(1)
    self:say("There is an immediate problem I need your help with.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A shipment of medical supplies was coming to us from Anduin")
    self.room:send("</>via the Black Rock Trail.  Unfortunately the transport was robbed and the")
    self.room:send("</>entire shipment was stolen by bandits.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The few who survived said a fierce bandit raider attacked")
    self.room:send("</>their wagon and headed off into the desert with their belongings.  They said")
    self.room:send("</>he fought like nothing they had ever seen before.  Some kind of frenzy of")
    self.room:send("</>swords and daggers.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Please, do whatever you need to recover those supplies and")
    self.room:send("</>bring them to me.'")
    if world.count_mobiles(185, 22) == 0 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(185, 22)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):command("wear all")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):teleport(get_room(161, 86))
        end)
    elseif actor:get_quest_stage("group_heal") == 3 or actor:get_quest_stage("group_heal") == 4 then
        self:say("May I see them please?")
    elseif actor:get_quest_stage("group_heal") == 5 then
        self:say("May I see what they have to say?")
    end
end