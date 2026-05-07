-- Trigger: berserker_subclass_progress_checker
-- Zone: 364, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Hjordis recaps the player's berserker_subclass quest progress on
-- "subclass" / "progress". Legacy probability was 0% (converter artefact).
--
-- Original DG Script: #36420

-- Speech keywords: subclass, progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "subclass") or string.find(speech_lower, "progress")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("berserker_subclass")

if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
    return true
end

if stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
    return true
end

if stage == 3 then
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
    return true
end

if stage == 4 then
    -- Re-reveal the assigned quarry. Lookup mirrors 364_13's QUARRIES table.
    local QUARRIES = {
        [16105] = "a desert cave",
        [16310] = "some forested highlands",
        [20311] = "a vast plain",
        [55220] = "the frozen tundra",
    }
    local target = actor:get_quest_var("berserker_subclass:target")
    local place = QUARRIES[target]
    if target and place then
        local quarry_name = mobiles.template(math.floor(target / 100), target % 100).name
        actor:send("The Spirits reveal to you a vision of " .. tostring(quarry_name) .. "!")
        actor:send("You see it is in " .. tostring(place) .. "!")
    end
    -- TODO(parity): legacy script also fell through to a race-restriction
    -- "you won't be able to become a berserker" branch with placeholder
    -- "ADD RESTRICTED RACES HERE". Restricted-race list still TBD.
    if not string.find(actor.class, "Warrior") then
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
    return true
end

-- stage 0 (or unset): not started yet.
if string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'You aren't trying to join us yet!'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to join us yet!'")
    else
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
else
    actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
end
return true
