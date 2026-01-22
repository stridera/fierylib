-- Trigger: group_heal_doctor_speech2
-- Zone: 185, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18518

-- Converted from DG Script #18518: group_heal_doctor_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: yes yes! yep yep! okay sure
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes!") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "yep!") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "sure")) then
    return true  -- No matching keywords
end
wait(2)
if ((string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 56)) and actor:get_quest_stage("group_heal") == 0 then
    actor.name:start_quest("group_heal")
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
    if world.count_mobiles("18522") == 0 then
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