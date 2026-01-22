-- Trigger: belial_combat_ai_script
-- Zone: 22, ID: 44
-- Type: MOB, Flags: SPEECH, FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #2244

-- Converted from DG Script #2244: belial_combat_ai_script
-- Original: MOB trigger, flags: SPEECH, FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end

-- Speech keywords: test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
-- random combat events
local timer = random(1, 4)
if belial_ai > 0 then
    -- switch on action
    if action == 1 then
        -- Deadly Spell
        -- line 10
        run_room_trigger(2246)
    elseif action == 2 then
        -- Severe Spell
        run_room_trigger(2247)
    elseif action == 3 then
        -- Severe Spell
        run_room_trigger(2248)
        -- line 20
    elseif action == 4 then
        self.room:send("Belial says in common, 'Fear my wrath, puny mortal!'")
    elseif action == 5 then
        -- Kick / Switch Opponents
        local victim = room.actors[random(1, #room.actors)]
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
        if self:get_mexists("15") < 1 then
            run_room_trigger(2249)
        end
        -- Kick / Switch Opponents
        local victim = room.actors[random(1, #room.actors)]
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
        run_room_trigger(2248)
        -- Severe Spell
        run_room_trigger(2247)
        -- line 70
        -- Deadly Spell
        run_room_trigger(2246)
        self:say("Your soul belongs to the Nines!")
        skills.execute(self, "kick", self.fighting)
        -- line 80
    end
    if belial_ai >= 1 then
        local belial_ai = belial_ai - 1
    else
        local belial_ai = timer
    end
    globals.belial_ai = globals.belial_ai or true
end  -- auto-close block