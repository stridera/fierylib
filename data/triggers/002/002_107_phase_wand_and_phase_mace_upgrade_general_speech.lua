-- Trigger: phase wand and phase mace upgrade general speech
-- Zone: 2, ID: 107
-- Type: MOB, Flags: SPEECH
--
-- Reusable "upgrade" handler shared by every phase-mace and phase-wand
-- crafter mob. Listens for upgrade/craft/improve keywords and routes to
-- the right quest based on which mob this is loaded onto:
--   * cleric crafters (mob 18581 / 48412) drive the phase_mace quest,
--   * elsewhere we drive the wand-quest matching globals.type/wandstep.
-- Reads the per-mob crafting parameters exported by 002_111 (wands) or
-- 002_118 (maces) via the `globals` table.
--
-- The item names print through proto_short() / mob_short() on the ids the load triggers
-- export (legacy vnum = zone * 100 + id).

local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local lower = string.lower(speech or "")

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrading", "craft", "crafting", "improve", "improving", "improvements", "upgrades"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)

if (self.zone_id == 185 and self.id == 81) or (self.zone_id == 484 and self.id == 12) then
    if actor.class ~= "cleric" and actor.class ~= "priest" then
        return true
    end
    local macestep = globals.macestep
    if not macestep then return true end
    local minlevel = macestep * 10
    local maceattack = globals.maceattack
    local stage = actor:get_quest_stage("phase_mace")
    if stage == macestep then
        if actor.level >= minlevel then
            actor:set_quest_var("phase_mace", "greet", 1)
            actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
            actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
            actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem2) .. "</>, for its spiritual protection.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem3) .. "</>, as a model for the new mace.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem4) .. "</>, for its power in fighting the undead.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem5) .. "</>, for its guiding light.")
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
        else
            actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve the blessings on your mace.'")
        end
    elseif actor:get_has_completed("phase_mace") then
        actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
    elseif (stage or 0) < macestep then
        actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
    elseif stage > macestep then
        actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
    end
    return true
end

if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer"
        or actor.class == "illusionist" or actor.class == "necromancer" then
    local wandstep = globals.wandstep
    if not wandstep then return true end
    local wandattack = globals.wandattack
    local quest_type = globals.type or "type"
    local quest = quest_type .. "_wand"
    local minlevel = (wandstep - 1) * 10
    local stage = actor:get_quest_stage(quest)
    if stage == wandstep then
        if actor.level >= minlevel then
            actor:set_quest_var(quest, "greet", 1)
            if stage < 7 then
                if string.find(lower, "staff") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a staff but I can help improve your wand's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your wand's strength.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            elseif stage == 7 then
                actor:send(tostring(self.name) .. " says, 'Your wand has reached its maximum potential.  You're ready for a staff instead.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your current wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            else
                if string.find(lower, "wand") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a wand but I can help improve your staff's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your staff's power.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your staff <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            end
            actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
            actor:send("- <b:yellow>" .. proto_short(globals.wandgem) .. "</>")
            if wandstep ~= 7 and wandstep ~= 10 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask3) .. "</>, for its resonance with " .. quest_type .. " energies.")
                if wandstep == 4 then
                    actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if (self.zone_id == 586 and self.id == 1) then
                        actor:send("</>    Search the far eastern edge of the continent.")
                    elseif (self.zone_id == 103 and self.id == 6) then
                        actor:send("</>    Search the south point beyond Anlun Vale.")
                    elseif (self.zone_id == 23 and self.id == 37) then
                        actor:send("</>    Search the surrounding forest.")
                    elseif (self.zone_id == 625 and self.id == 4) then
                        actor:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    actor:send("</>    The phrase to call the blessing is:")
                    actor:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            end
            if wandstep == 4 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</> for its sheer magical potential.")
                actor:send("</>    Be careful, thawkinixa is extremely dangerous!")
            elseif wandstep == 5 then
                actor:send("Plus you'll need to imbue your wand in " .. tostring(globals.wandtask4) .. ".")
            elseif wandstep == 6 then
                actor:send("This next step also requires balancing harmonic frequencies.")
                actor:send("Go find <b:yellow>" .. proto_short(globals.wandtask4) .. "</>.")
            elseif wandstep == 7 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask3) .. "</>, which will form the body of your new staff.")
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</>, as a fine head for your new staff.")
            elseif wandstep == 8 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</>, which can be harvested from those kinds of elementals.")
            elseif wandstep == 9 then
                actor:send("- proof of your mastery over " .. quest_type .. " by slaying <b:cyan>" .. mob_short(globals.wandtask4) .. "</>.")
            elseif wandstep == 10 then
                actor:send(tostring(self.name) .. " says, 'Energize your staff by slaying <b:cyan>" .. mob_short(globals.wandtask3) .. "</> in Templace, then return to me.'")
            end
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[wand progress]</> at any time.'")
        else
            actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
        end
    elseif (stage or 0) < wandstep then
        actor:send(tostring(self.name) .. " says, 'Your " .. (globals.weapon or "wand") .. " isn't ready for improvement yet.'")
    elseif stage > wandstep then
        actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
    end
end
return true
