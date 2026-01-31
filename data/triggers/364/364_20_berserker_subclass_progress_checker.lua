-- Trigger: berserker subclass progress checker
-- Zone: 364, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN (reviewed 2026-01-22)
--   Complex nesting: 7 if statements
--
-- Original DG Script: #36420

-- Converted from DG Script #36420: berserker subclass progress checker
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
-- switch on actor:get_quest_stage("berserker_subclass")
if actor:get_quest_stage("berserker_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
elseif actor:get_quest_stage("berserker_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
elseif actor:get_quest_stage("berserker_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
    -- switch on actor:get_quest_var("berserker_subclass:target")
    local target = actor:get_quest_var("berserker_subclass:target")
    local place = "the unknown"
    local target_zone, target_local
    if target == 16105 then
        target_zone, target_local = 161, 5
        place = "a desert cave"
    elseif target == 16310 then
        target_zone, target_local = 163, 10
        place = "some forested highlands"
    elseif target == 20311 then
        target_zone, target_local = 203, 11
        place = "a vast plain"
    elseif target == 55220 then
        target_zone, target_local = 552, 20
        place = "the frozen tundra"
    else
        -- Fallback: compute from vnum
        target_zone = target // 100
        target_local = target % 100
    end
    actor:send("The Spirits reveal to you a vision of " .. tostring(mobs.template(target_zone, target_local).short_description) .. "!")
    actor:send("You see it is in " .. tostring(place) .. "!")
    local classquest = "yes"
    if string.find(actor.class, "Warrior") then
        -- switch on actor.race
        -- case ADD RESTRICTED RACES HERE
        -- set classquest no
        if actor.level >= 10 and actor.level <= 25 then
            actor:send(tostring(self.name) .. " says, 'You aren't trying to join us yet!'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'You aren't ready to join us yet!'")
        else
            classquest = "no"
        end
    else
        classquest = "no"
    end
    if classquest == "no" then
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
end  -- auto-close block