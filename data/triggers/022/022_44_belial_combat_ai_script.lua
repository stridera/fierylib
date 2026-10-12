-- Trigger: belial_combat_ai_script
-- Zone: 22, ID: 44
-- Type: MOB, Flags: SPEECH, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #2244
-- Legacy DG never set `action` on this trigger and only this script ever set `belial_ai`, so
-- the action switch below never matched: the script only ran the belial_ai countdown. That is
-- kept as is (action = 0); picking an action (random(1, 11)) would change the boss fight and
-- needs a design call.

-- Converted from DG Script #2244: belial_combat_ai_script
-- Original: MOB trigger, flags: SPEECH, FIGHT, num_arg: 20 (FIGHT: 20% chance per round; SPEECH: word list, not a probability)

-- num_arg 20: FIGHT = 20% roll per round; SPEECH = the word "test" (DG word list, num_arg
-- non-zero), no chance roll.
if event == "SPEECH" then
    -- DG word list (num_arg 20): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"test"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(20) then
    return true
end
-- random combat events
local timer = random(1, 4)
local belial_ai = tonumber(self:getvar("belial_ai")) or 0  -- DG: `global belial_ai`
local action = 0  -- DG never set it (see header)
if belial_ai > 0 then
    -- switch on action
    if action == 1 then
        -- Deadly Spell
        -- line 10
        run_room_trigger(22, 46)
    elseif action == 2 then
        -- Severe Spell
        run_room_trigger(22, 47)
    elseif action == 3 then
        -- Severe Spell
        run_room_trigger(22, 48)
        -- line 20
    elseif action == 4 then
        self.room:send("Belial says in common, 'Fear my wrath, puny mortal!'")
    elseif action == 5 then
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        -- line 30
        if which == 1 then
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- line 40
        -- Show random caster Fun Lovin's!
        if self:get_mexists(1000, 15) < 1 then
            run_room_trigger(22, 49)
        end
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- line 50
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- Random Banter
        -- line 60
        -- Severe Spell
        run_room_trigger(22, 48)
        -- Severe Spell
        run_room_trigger(22, 47)
        -- line 70
        -- Deadly Spell
        run_room_trigger(22, 46)
        self:say("Your soul belongs to the Nines!")
        skills.execute(self, "kick", self.fighting)
        -- line 80
    end
end  -- auto-close block
if belial_ai >= 1 then
    belial_ai = belial_ai - 1
else
    belial_ai = timer
end
self:setvar("belial_ai", belial_ai)