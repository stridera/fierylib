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
-- TODO(parity): The original DG used `%get.obj_shortdesc[%maceitem2%]%`
-- and `%get.obj_shortdesc[%wandgem%]%` interpolations to print item
-- names. These are preserved as literal placeholders in the responses
-- below so the player can still identify the work but the names print
-- as raw text. Replace with `objects.template(z, id).name` once the
-- ids exported by the load triggers are normalised to (zone, local).
local lower = string.lower(speech or "")
local function has(word) return string.find(lower, word, 1, true) ~= nil end
if not (has("upgrade") or has("upgrading") or has("craft") or has("crafting")
        or has("improve") or has("improving") or has("improvements") or has("upgrades")) then
    return true
end
wait(2)

if self.id == 18581 or self.id == 48412 then
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
            actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem2%]%</>, for its spiritual protection.")
            actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem3%]%</>, as a model for the new mace.")
            actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem4%]%</>, for its power in fighting the undead.")
            actor:send("- <b:yellow>%get.obj_shortdesc[%maceitem5%]%</>, for its guiding light.")
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
            actor:send("- <b:yellow>%get.obj_shortdesc[%wandgem%]%</>")
            if wandstep ~= 7 and wandstep ~= 10 then
                actor:send("- <b:yellow>%get.obj_shortdesc[%wandtask3%]%</>, for its resonance with " .. quest_type .. " energies.")
                if wandstep == 4 then
                    actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if self.id == 58601 then
                        actor:send("</>    Search the far eastern edge of the continent.")
                    elseif self.id == 10306 then
                        actor:send("</>    Search the south point beyond Anlun Vale.")
                    elseif self.id == 2337 then
                        actor:send("</>    Search the surrounding forest.")
                    elseif self.id == 62504 then
                        actor:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    actor:send("</>    The phrase to call the blessing is:")
                    actor:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            end
            if wandstep == 4 then
                actor:send("- <b:yellow>%get.obj_shortdesc[%wandtask4%]%</> for its sheer magical potential.")
                actor:send("</>    Be careful, thawkinixa is extremely dangerous!")
            elseif wandstep == 5 then
                actor:send("Plus you'll need to imbue your wand in " .. tostring(globals.wandtask4) .. ".")
            elseif wandstep == 6 then
                actor:send("This next step also requires balancing harmonic frequencies.")
                actor:send("Go find <b:yellow>%get.obj_shortdesc[%wandtask4%]%</>.")
            elseif wandstep == 7 then
                actor:send("- <b:yellow>%get.obj_shortdesc[%wandtask3%]%</>, which will form the body of your new staff.")
                actor:send("- <b:yellow>%get.obj_shortdesc[%wandtask4%]%</>, as a fine head for your new staff.")
            elseif wandstep == 8 then
                actor:send("- <b:yellow>%get.obj_shortdesc[%wandtask4%]%</>, which can be harvested from those kinds of elementals.")
            elseif wandstep == 9 then
                actor:send("- proof of your mastery over " .. quest_type .. " by slaying <b:cyan>%get.mob_shortdesc[%wandtask4%]%</>.")
            elseif wandstep == 10 then
                actor:send(tostring(self.name) .. " says, 'Energize your staff by slaying <b:cyan>%get.mob_shortdesc[%wandtask3%]%</> in Templace, then return to me.'")
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
