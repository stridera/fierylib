-- Raw DG %get.*[VNUM]% / get.room[] remnants converted to the proto_short/proto_noa/proto_plural/mob_short/room_name helpers (hoisted branch-scoped locals, cross-trigger values read from globals). Guards are the bodies at fierylib d00213e (prod after the dg-globals patch).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/002/002_107_phase_wand_and_phase_mace_upgrade_general_speech.lua
  (2, 107, $trig$local function proto_key(vnum)
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
return true$trig$, '2531320f26f553516fa3bc9e7f62c443'),
  -- data/triggers/002/002_112_phase_wand_general_death.lua
  (2, 112, $trig$local function proto_key(vnum)
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
local quest_type, color, wand_id, stage_target, task_key
if (self.zone_id == 238 and self.id == 3) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 307, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 1) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 308, 10, "wandtask3"
elseif (self.zone_id == 40 and self.id == 13) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 317, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 2) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 318, 10, "wandtask3"
elseif (self.zone_id == 533 and self.id == 0) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 327, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 5) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 328, 10, "wandtask3"
elseif (self.zone_id == 520 and self.id == 18) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 337, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 7) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 338, 10, "wandtask3"
end
if not quest_type then return end

local quest = quest_type .. "_wand"

local function credit(person)
    if person.room ~= self.room then return end
    if person:get_quest_stage(quest) ~= stage_target then return end
    if person:get_quest_var(quest .. ":" .. task_key) then return end
    person:set_quest_var(quest, task_key, 1)
    person:send(color .. proto_short(wand_id) .. " crackles with vibrant energy!</>")
    person:send(color .. "It is primed for reforging!</>")
end

local group = actor.group
if group and #group > 0 then
    for _, person in ipairs(group) do
        credit(person)
    end
else
    credit(actor)
end$trig$, '70bc42c4aeb004269dd58956f6f3e804'),
  -- data/triggers/002/002_115_phase_mace_speech_upgrade.lua
  (2, 115, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrades", "upgrading", "improvement", "improvements", "improving"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (self.zone_id == 185 and self.id == 2) then
    self:set_flag("sentinel", true)
end
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local macestep = globals.macestep
    if macestep then
        local minlevel = macestep * 10
        local stage = actor:get_quest_stage("phase_mace")
        local maceattack = globals.maceattack
        if stage == macestep then
            if actor.level >= minlevel then
                actor:set_quest_var("phase_mace", "greet", 1)
                actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
                actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
                actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
                actor:send("- <b:yellow>" .. proto_short(globals.maceitem2) .. "</>, for its spiritual protection.")
                if macestep ~= 2 then
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem3) .. "</>, as a model for the new mace.")
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem4) .. "</>, for its power in fighting the undead.")
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem5) .. "</>, for its guiding light.")
                else
                    actor:send(tostring(self.name) .. " says, 'And you'll need to make a pilgrimage to four burial grounds to see what lies ahead on your journey:'")
                    actor:send("- <b:yellow>the necropolis near Anduin</>")
                    actor:send("- <b:yellow>the pyramid in the Gothra desert</>")
                    actor:send("- <b:yellow>the ancient barrow in the Iron Hills</>")
                    actor:send("- <b:yellow>the cemetary outside the Cathedral of Betrayal</>")
                    actor:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>'")
                    wait(2)
                    self.room:spawn_object(185, 26)
                    self:command("give grave-spade " .. tostring(actor.name))
                    actor:send(tostring(self.name) .. " says, 'Holding this spade, <b:cyan>[dig]</> up a handful of dirt from each of these places and bring it back to me as a token of your journey.'")
                end
                actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
            end
        elseif actor:get_has_completed("phase_mace") then
            actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
        elseif (stage or 0) < macestep then
            actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
        elseif stage > macestep then
            actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
            wait(1)
            if stage == 3 then     actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
            elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
            elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
            elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
            elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne''s servators.'")
            elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun''s Oracle in the ancient pyramid near Anduin.'")
            elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
            end
        end
    end
end
if (self.zone_id == 185 and self.id == 2) then
    self:set_flag("sentinel", false)
end
return true$trig$, '2d2e9de67d539000a49a5ae35e7469d7'),
  -- data/triggers/002/002_116_phase_mace_progress.lua
  (2, 116, $trig$-- Speech phrase: mace progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
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
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]mace progress[%s%p]") then
    return true  -- Not the phrase
end
wait(2)
if actor.class ~= "cleric" and actor.class ~= "priest" then
    actor:send(tostring(self.name) .. " says, 'This weapon is only for servants of the gods.'")
    return true
end
local macestep = globals.macestep
if not macestep then return true end
local maceattack = globals.maceattack
local stage = actor:get_quest_stage("phase_mace")
local job1 = actor:get_quest_var("phase_mace:macetask1")
local job2 = actor:get_quest_var("phase_mace:macetask2")
local job3 = actor:get_quest_var("phase_mace:macetask3")
local job4 = actor:get_quest_var("phase_mace:macetask4")
local job5 = actor:get_quest_var("phase_mace:macetask5")
local job6 = actor:get_quest_var("phase_mace:macetask6")
if actor:get_has_completed("phase_mace") then
    actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
elseif stage == macestep and actor.level >= macestep * 10 then
    if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
        actor:send(tostring(self.name) .. " says, 'Tell me why you're here first.'")
    else
        actor:send(tostring(self.name) .. " says, 'I'm improving your mace.'")
        if job1 or job2 or job3 or job4 or job5 then
            actor:send(tostring(self.name) .. " says, 'You've done the following:'")
            if job1 then actor:send("- attacked " .. tostring(maceattack) .. " times") end
            if job2 then actor:send("- found " .. proto_short(globals.maceitem2)) end
            if job3 then actor:send("- found " .. proto_short(globals.maceitem3)) end
            if job4 then actor:send("- found " .. proto_short(globals.maceitem4)) end
            if job5 then actor:send("- found " .. proto_short(globals.maceitem5)) end
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 and job5 then
            if macestep ~= 2 then
                actor:send("Just give me your mace.")
                return true
            else
                if job6 then
                    actor:send("Just give me your mace.")
                    return true
                end
            end
        end
        if not job1 then
            local remaining = (stage * 50) - (actor:get_quest_var("phase_mace:attack_counter") or 0)
            if remaining > 1 then
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
            else
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
            end
        end
        if not job2 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem2) .. "</>") end
        if not job3 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem3) .. "</>") end
        if not job4 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem4) .. "</>") end
        if not job5 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem5) .. "</>") end
        if macestep == 2 and not job6 then
            actor:send("- <b:yellow>find " .. proto_short(globals.maceitem6) .. "</>")
        end
    end
elseif (stage or 0) > 0 and stage > macestep then
    if stage == 2 then     actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
    elseif stage == 3 then actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
    elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
    elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
    elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
    elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne''s servators.'")
    elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun''s Oracle in the ancient pyramid near Anduin.'")
    elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
    end
elseif (stage or 0) < macestep then
    actor:send(tostring(self.name) .. " says, 'You need to make more improvements to your mace before I can work with it.'")
elseif actor.level < macestep * 10 then
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end
return true$trig$, 'b1e874af632b32f6bb768052ea4c2505'),
  -- data/triggers/004/004_101_enlightenment_progress_journal.lua
  (4, 101, $trig$-- Converted from DG Script #501: Enlightenment progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
local place
if string.find(arg, "enlightenment") or string.find(arg, "monk vision") or string.find(arg, "monk_vision") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local missionstage = actor:get_quest_stage("elemental_chaos")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        actor:send("<b:u:green>Enlightenment</>")
        local level
        if (visionstage or 0) == 0 then
            level = 10
        else
            level = visionstage * 10
        end
        if not actor:get_has_completed("monk_vision") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("monk_vision") then
            status = "Completed!"
        elseif (visionstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if visionstage == 0 then
                actor:send("You must undertake a <b:cyan>[mission]</> in service of Balance first.")
                return _return_value
            elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            -- switch on visionstage
            local book
            local gem
            local room
            local hint
            do
                local _sw1 = string.lower(tostring(visionstage or ""))
                if tonumber(_sw1) == 1 then
                    book = 59006
                    gem = 55582
                    room = get_room("4328")
                    place = room.name
                    hint = "in a place to perform."
                elseif tonumber(_sw1) == 2 then
                    book = 18505
                    gem = 55591
                    room = get_room("58707")
                    place = room.name
                    hint = "near a sandy beach."
                elseif tonumber(_sw1) == 3 then
                    book = 8501
                    gem = 55623
                    room = get_room("18597")
                    place = room.name
                    hint = "in a cloistered library."
                elseif tonumber(_sw1) == 4 then
                    book = 12532
                    gem = 55655
                    room = get_room("58102")
                    place = room.name
                    hint = "on Hakujo's home island."
                elseif tonumber(_sw1) == 5 then
                    book = 16209
                    gem = 55665
                    room = get_room("16057")
                    place = room.name
                    hint = "in the ghostly fortress."
                elseif tonumber(_sw1) == 6 then
                    book = 43013
                    gem = 55678
                    room = get_room("59054")
                    place = room.name
                    hint = "in the fortress of the zealous."
                elseif tonumber(_sw1) == 7 then
                    book = 53009
                    gem = 55710
                    room = get_room("49079")
                    place = room.name
                    hint = "off-shore of the island of great beasts."
                elseif tonumber(_sw1) == 8 then
                    book = 58415
                    gem = 55722
                    room = get_room("11820")
                    place = room.name
                    hint = "beyond the Blue-Fog Trail."
                elseif tonumber(_sw1) == 9 then
                    book = 58412
                    gem = 55741
                    room = get_room("52075")
                    place = room.name
                    hint = "in the shattered citadel of Templace."
                end
            end
            local attack = visionstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job3 then
                    actor:send("- found " .. proto_short(book))
                end
                if job4 then
                    actor:send("- read in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your current vision mark.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("monk_vision:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- find <b:yellow>" .. proto_short(gem) .. "</> and <b:yellow>" .. proto_short(book) .. "</> and <b:yellow>read</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. proto_short(gem) .. "</>")
                end
                if not job3 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. proto_short(book) .. "</>")
                end
            end
        end
    end
end
return _return_value$trig$, '207888c9cfc9c05f23ee3f9bb6a20f43'),
  -- data/triggers/004/004_11_guild_armor_phase_one_progress_journal.lua
  (4, 11, $trig$-- Converted from DG Script #411: Guild Armor Phase One progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "one") or string.find(arg, "1"))) or string.find(arg, "guild_armor_phase_one") or string.find(arg, "guild_armor_phase_1") or string.find(arg, "phase_armor_one") or string.find(arg, "phase_armor_1") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase One</>")
    actor:send("Mininum Level: 1")
    actor:send("Items for this quest drop from mobs between level 1 and 20.")
    if actor:get_quest_stage("phase_armor") > 0 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
        local clericclasses = "Cleric Priest Druid Diabolist"
        local warriorclasses = "Warrior Anti-Paladin Ranger Paladin Monk Berserker"
        local rogueclasses = "Rogue Mercenary Assassin Thief Bard"
        local feet_gem
        local head_gem
        local hands_gem
        local arms_gem
        local legs_gem
        local body_gem
        local wrist_gem
        local feet_armor
        local head_armor
        local hands_armor
        local arms_armor
        local legs_armor
        local body_armor
        local wrist_armor
        local feet_reward
        local head_reward
        local hands_reward
        local arms_reward
        local legs_reward
        local body_reward
        local wrist_reward
        local master
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55571
            head_gem = 55579
            hands_gem = 55567
            arms_gem = 55583
            legs_gem = 55587
            body_gem = 55591
            wrist_gem = 55575
            feet_armor = 55306
            head_armor = 55314
            hands_armor = 55302
            arms_armor = 55318
            legs_armor = 55322
            body_armor = 55326
            wrist_armor = 55310
            feet_reward = 55402
            head_reward = 55398
            hands_reward = 55404
            arms_reward = 55399
            legs_reward = 55401
            body_reward = 55400
            wrist_reward = 55403
            master = "the Archmage of Mielikki and Gagar"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55570
            head_gem = 55578
            hands_gem = 55566
            arms_gem = 55582
            legs_gem = 55586
            body_gem = 55590
            wrist_gem = 55574
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55395
            head_reward = 55391
            hands_reward = 55397
            arms_reward = 55392
            legs_reward = 55394
            body_reward = 55393
            wrist_reward = 55396
            master = "the High Priestess of Mielikki and Rorgdush"
        elseif string.find(string.lower(warriorclasses), actor.class, 1, true) then
            feet_gem = 55573
            head_gem = 55581
            hands_gem = 55569
            arms_gem = 55585
            legs_gem = 55589
            body_gem = 55593
            wrist_gem = 55577
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55388
            head_reward = 55384
            hands_reward = 55390
            arms_reward = 55385
            legs_reward = 55387
            body_reward = 55386
            wrist_reward = 55389
            master = "the Warrior Coach of Mielikki and Grort"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55572
            head_gem = 55580
            hands_gem = 55568
            arms_gem = 55584
            legs_gem = 55588
            body_gem = 55592
            wrist_gem = 55576
            feet_armor = 55305
            head_armor = 55313
            hands_armor = 55301
            arms_armor = 55317
            legs_armor = 55321
            body_armor = 55325
            wrist_armor = 55309
            feet_reward = 55409
            head_reward = 55405
            hands_reward = 55411
            arms_reward = 55406
            legs_reward = 55408
            body_reward = 55407
            wrist_reward = 55410
            master = "the Master Rogue of Mielikki and Tinilas"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed!</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. proto_short(hands_armor) .. " and 3 of " .. proto_short(hands_gem))
        actor:send("</>  " .. proto_short(feet_armor) .. " and 3 of " .. proto_short(feet_gem))
        actor:send("</>  " .. proto_short(wrist_armor) .. " and 3 of " .. proto_short(wrist_gem))
        actor:send("</>  " .. proto_short(head_armor) .. " and 3 of " .. proto_short(head_gem))
        actor:send("</>  " .. proto_short(arms_armor) .. " and 3 of " .. proto_short(arms_gem))
        actor:send("</>  " .. proto_short(legs_armor) .. " and 3 of " .. proto_short(legs_gem))
        actor:send("</>  " .. proto_short(body_armor) .. " and 3 of " .. proto_short(body_gem))
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. proto_short(hands_armor))
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. proto_short(hands_gem))
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. proto_short(feet_armor))
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. proto_short(feet_gem))
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. proto_short(wrist_armor))
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. proto_short(wrist_gem))
        end
        if got_head and not done_head then
            actor:send("</>  " .. proto_short(head_armor))
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. proto_short(head_gem))
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. proto_short(arms_armor))
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. proto_short(arms_gem))
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. proto_short(legs_armor))
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. proto_short(legs_gem))
        end
        if got_body and not done_body then
            actor:send("</>  " .. proto_short(body_armor))
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. proto_short(body_gem))
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. proto_short(hands_reward))
        end
        if done_feet then
            actor:send("</>  " .. proto_short(feet_reward))
        end
        if done_wrist then
            actor:send("</>  " .. proto_short(wrist_reward))
        end
        if done_head then
            actor:send("</>  " .. proto_short(head_reward))
        end
        if done_arms then
            actor:send("</>  " .. proto_short(arms_reward))
        end
        if done_legs then
            actor:send("</>  " .. proto_short(legs_reward))
        end
        if done_body then
            actor:send("</>  " .. proto_short(body_reward))
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, 'be2cb799844526817a742c100fb579e8'),
  -- data/triggers/004/004_12_guild_armor_phase_two_progress_journal.lua
  (4, 12, $trig$-- Converted from DG Script #412: Guild Armor Phase Two progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "two") or string.find(arg, "2"))) or string.find(arg, "guild_armor_phase_two") or string.find(arg, "guild_armor_phase_2") or string.find(arg, "phase_armor_two") or string.find(arg, "phase_armor_2") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase Two</>")
    actor:send("Mininum Level: 21")
    actor:send("Items for this quest drop from mobs between level 21 and 40.")
    if actor:get_quest_stage("phase_armor") > 1 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        local hands_armor, hands_gem, feet_armor, feet_gem, wrist_armor, wrist_gem, head_armor, head_gem, arms_armor, arms_gem, legs_armor, legs_gem, body_armor, body_gem, hands_reward, feet_reward, wrist_reward, head_reward, arms_reward, legs_reward, body_reward
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55613
            head_gem = 55635
            hands_gem = 55602
            arms_gem = 55646
            legs_gem = 55657
            body_gem = 55668
            wrist_gem = 55624
            feet_armor = 55335
            head_armor = 55343
            hands_armor = 55331
            arms_armor = 55347
            legs_armor = 55351
            body_armor = 55355
            wrist_armor = 55339
            feet_reward = 55479
            head_reward = 55475
            hands_reward = 55481
            arms_reward = 55476
            legs_reward = 55478
            body_reward = 55477
            wrist_reward = 55480
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Ickle"
            elseif string.find(actor.class, "cryomancer") then
                master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "pyromancer") then
                master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "illusionist") then
                master = "the Archmage of Ickle, Erasmus, and Esh"
            end
        elseif string.find(actor.class, "necromancer") then
            feet_gem = 55609
            head_gem = 55631
            hands_gem = 55598
            arms_gem = 55642
            legs_gem = 55653
            body_gem = 55664
            wrist_gem = 55620
            feet_armor = 55335
            head_armor = 55343
            hands_armor = 55331
            arms_armor = 55347
            legs_armor = 55351
            body_armor = 55355
            wrist_armor = 55339
            feet_reward = 55458
            head_reward = 55454
            hands_reward = 55460
            arms_reward = 55455
            legs_reward = 55457
            body_reward = 55456
            wrist_reward = 55459
            master = "Asiri'Qaxt and Schkerra"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55612
            head_gem = 55634
            hands_gem = 55601
            arms_gem = 55645
            legs_gem = 55656
            body_gem = 55667
            wrist_gem = 55623
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55437
            head_reward = 55433
            hands_reward = 55439
            arms_reward = 55434
            legs_reward = 55436
            body_reward = 55435
            wrist_reward = 55438
            master = "the High Priestess of Anduin and Zeno the Priest"
        elseif string.find(actor.class, "diabolist") then
            feet_gem = 55606
            head_gem = 55628
            hands_gem = 55595
            arms_gem = 55639
            legs_gem = 55650
            body_gem = 55661
            wrist_gem = 55617
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55472
            head_reward = 55468
            hands_reward = 55474
            arms_reward = 55469
            legs_reward = 55471
            body_reward = 55470
            wrist_reward = 55473
            master = "the Black Priestess"
        elseif string.find(actor.class, "druid") then
            feet_gem = 55607
            head_gem = 55629
            hands_gem = 55596
            arms_gem = 55640
            legs_gem = 55651
            body_gem = 55662
            wrist_gem = 55618
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55451
            head_reward = 55447
            hands_reward = 55453
            arms_reward = 55448
            legs_reward = 55450
            body_reward = 55449
            wrist_reward = 55452
            master = "the Black Priestess and the diabolist"
        elseif string.find(actor.class, "warrior") then
            feet_gem = 55615
            head_gem = 55637
            hands_gem = 55604
            arms_gem = 55648
            legs_gem = 55659
            body_gem = 55670
            wrist_gem = 55626
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55416
            head_reward = 55412
            hands_reward = 55418
            arms_reward = 55413
            legs_reward = 55415
            body_reward = 55414
            wrist_reward = 55417
            master = "the high druid and a serene druidess"
        elseif actor.class == "anti-paladin" then
            feet_gem = 55605
            head_gem = 55627
            hands_gem = 55594
            arms_gem = 55638
            legs_gem = 55649
            body_gem = 55660
            wrist_gem = 55616
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55430
            head_reward = 55426
            hands_reward = 55432
            arms_reward = 55427
            legs_reward = 55429
            body_reward = 55428
            wrist_reward = 55431
            master = "the warrior coach of Anduin"
        elseif string.find(actor.class, "ranger") then
            feet_gem = 55611
            head_gem = 55633
            hands_gem = 55600
            arms_gem = 55644
            legs_gem = 55655
            body_gem = 55666
            wrist_gem = 55622
            feet_armor = 55333
            head_armor = 55341
            hands_armor = 55329
            arms_armor = 55345
            legs_armor = 55349
            body_armor = 55353
            wrist_armor = 55337
            feet_reward = 55444
            head_reward = 55440
            hands_reward = 55446
            arms_reward = 55441
            legs_reward = 55443
            body_reward = 55442
            wrist_reward = 55445
            master = "Galithel Silverwing"
        elseif actor.class == "paladin" then
            feet_gem = 55610
            head_gem = 55632
            hands_gem = 55599
            arms_gem = 55643
            legs_gem = 55654
            body_gem = 55665
            wrist_gem = 55621
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55423
            head_reward = 55419
            hands_reward = 55425
            arms_reward = 55420
            legs_reward = 55422
            body_reward = 55421
            wrist_reward = 55424
            master = "the Grey Knight"
        elseif string.find(actor.class, "monk") then
            feet_gem = 55608
            head_gem = 55630
            hands_gem = 55597
            arms_gem = 55641
            legs_gem = 55652
            body_gem = 55663
            wrist_gem = 55619
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55465
            head_reward = 55461
            hands_reward = 55467
            arms_reward = 55462
            legs_reward = 55464
            body_reward = 55463
            wrist_reward = 55466
            master = "the Head Monk"
        elseif string.find(actor.class, "berserker") then
            feet_gem = 55607
            head_gem = 55631
            hands_gem = 55595
            arms_gem = 55638
            legs_gem = 55655
            body_gem = 55665
            wrist_gem = 55619
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55771
            head_reward = 55767
            hands_reward = 55773
            arms_reward = 55768
            legs_reward = 55770
            body_reward = 55769
            wrist_reward = 55772
            master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55614
            head_gem = 55636
            hands_gem = 55603
            arms_gem = 55647
            legs_gem = 55658
            body_gem = 55669
            wrist_gem = 55625
            feet_armor = 55333
            head_armor = 55341
            hands_armor = 55329
            arms_armor = 55345
            legs_armor = 55349
            body_armor = 55353
            wrist_armor = 55337
            feet_reward = 55486
            head_reward = 55482
            hands_reward = 55488
            arms_reward = 55483
            legs_reward = 55485
            body_reward = 55484
            wrist_reward = 55487
            master = "Princess Signess, Haren, and Blackhaven"
        elseif string.find(actor.class, "bard") then
            feet_gem = 55606
            head_gem = 55630
            hands_gem = 55600
            arms_gem = 55640
            legs_gem = 55649
            body_gem = 55664
            wrist_gem = 55621
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55785
            head_reward = 55781
            hands_reward = 55787
            arms_reward = 55782
            legs_reward = 55784
            body_reward = 55783
            wrist_reward = 55786
            master = "the Master Herald and the Bard Union Master"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed!</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. proto_short(hands_armor) .. " and 3 of " .. proto_short(hands_gem))
        actor:send("</>  " .. proto_short(feet_armor) .. " and 3 of " .. proto_short(feet_gem))
        actor:send("</>  " .. proto_short(wrist_armor) .. " and 3 of " .. proto_short(wrist_gem))
        actor:send("</>  " .. proto_short(head_armor) .. " and 3 of " .. proto_short(head_gem))
        actor:send("</>  " .. proto_short(arms_armor) .. " and 3 of " .. proto_short(arms_gem))
        actor:send("</>  " .. proto_short(legs_armor) .. " and 3 of " .. proto_short(legs_gem))
        actor:send("</>  " .. proto_short(body_armor) .. " and 3 of " .. proto_short(body_gem))
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. proto_short(hands_armor))
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. proto_short(hands_gem))
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. proto_short(feet_armor))
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. proto_short(feet_gem))
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. proto_short(wrist_armor))
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. proto_short(wrist_gem))
        end
        if got_head and not done_head then
            actor:send("</>  " .. proto_short(head_armor))
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. proto_short(head_gem))
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. proto_short(arms_armor))
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. proto_short(arms_gem))
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. proto_short(legs_armor))
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. proto_short(legs_gem))
        end
        if got_body and not done_body then
            actor:send("</>  " .. proto_short(body_armor))
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. proto_short(body_gem))
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. proto_short(hands_reward))
        end
        if done_feet then
            actor:send("</>  " .. proto_short(feet_reward))
        end
        if done_wrist then
            actor:send("</>  " .. proto_short(wrist_reward))
        end
        if done_head then
            actor:send("</>  " .. proto_short(head_reward))
        end
        if done_arms then
            actor:send("</>  " .. proto_short(arms_reward))
        end
        if done_legs then
            actor:send("</>  " .. proto_short(legs_reward))
        end
        if done_body then
            actor:send("</>  " .. proto_short(body_reward))
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, 'c8864d9650f8eb86f483ae68e5dea4dd'),
  -- data/triggers/004/004_13_guild_armor_phase_three_progress_journal.lua
  (4, 13, $trig$-- Converted from DG Script #413: Guild Armor Phase Three progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "three") or string.find(arg, "3"))) or string.find(arg, "guild_armor_phase_three") or string.find(arg, "guild_armor_phase_3") or string.find(arg, "phase_armor_three") or string.find(arg, "phase_armor_3") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase Three</>")
    actor:send("Mininum Level: 41")
    actor:send("Items for this quest drop from mobs above level 41.")
    if actor:get_quest_stage("phase_armor") > 2 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        local hands_armor, hands_gem, feet_armor, feet_gem, wrist_armor, wrist_gem, head_armor, head_gem, arms_armor, arms_gem, legs_armor, legs_gem, body_armor, body_gem, hands_reward, feet_reward, wrist_reward, head_reward, arms_reward, legs_reward, body_reward
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55690
            head_gem = 55712
            hands_gem = 55679
            arms_gem = 55723
            legs_gem = 55734
            body_gem = 55745
            wrist_gem = 55701
            feet_armor = 55363
            head_armor = 55371
            hands_armor = 55359
            arms_armor = 55375
            legs_armor = 55379
            body_armor = 55383
            wrist_armor = 55367
            feet_reward = 55556
            head_reward = 55552
            hands_reward = 55558
            arms_reward = 55553
            legs_reward = 55555
            body_reward = 55554
            wrist_reward = 55557
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Anduin"
            elseif string.find(actor.class, "cryomancer") then
                master = "a cryomancer in Anduin"
            elseif string.find(actor.class, "pyromancer") then
                master = "a pyromancer in Anduin"
            elseif string.find(actor.class, "illusionist") then
                master = "Aylana in Anduin"
            end
        elseif string.find(actor.class, "necromancer") then
            feet_gem = 55686
            head_gem = 55708
            hands_gem = 55675
            arms_gem = 55719
            legs_gem = 55730
            body_gem = 55741
            wrist_gem = 55697
            feet_armor = 55363
            head_armor = 55371
            hands_armor = 55359
            arms_armor = 55375
            legs_armor = 55379
            body_armor = 55383
            wrist_armor = 55367
            feet_reward = 55535
            head_reward = 55531
            hands_reward = 55537
            arms_reward = 55532
            legs_reward = 55534
            body_reward = 55533
            wrist_reward = 55536
            master = "a necromancer in Anduin"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55689
            head_gem = 55711
            hands_gem = 55678
            arms_gem = 55722
            legs_gem = 55733
            body_gem = 55744
            wrist_gem = 55700
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55514
            head_reward = 55510
            hands_reward = 55516
            arms_reward = 55511
            legs_reward = 55513
            body_reward = 55512
            wrist_reward = 55515
            master = "the High Priest Zalish"
        elseif string.find(actor.class, "diabolist") then
            feet_gem = 55683
            head_gem = 55705
            hands_gem = 55672
            arms_gem = 55716
            legs_gem = 55727
            body_gem = 55738
            wrist_gem = 55694
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55549
            head_reward = 55545
            hands_reward = 55551
            arms_reward = 55546
            legs_reward = 55548
            body_reward = 55547
            wrist_reward = 55550
            master = "Ruin Wormheart"
        elseif string.find(actor.class, "druid") then
            feet_gem = 55684
            head_gem = 55706
            hands_gem = 55673
            arms_gem = 55717
            legs_gem = 55728
            body_gem = 55739
            wrist_gem = 55695
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55528
            head_reward = 55524
            hands_reward = 55530
            arms_reward = 55525
            legs_reward = 55527
            body_reward = 55526
            wrist_reward = 55529
            master = "the Heirophant"
        elseif string.find(actor.class, "warrior") then
            feet_gem = 55692
            head_gem = 55714
            hands_gem = 55681
            arms_gem = 55725
            legs_gem = 55736
            body_gem = 55747
            wrist_gem = 55703
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55493
            head_reward = 55489
            hands_reward = 55495
            arms_reward = 55490
            legs_reward = 55492
            body_reward = 55491
            wrist_reward = 55494
            master = "the Warrior Coach in Ickle"
        elseif actor.class == "anti-paladin" then
            feet_gem = 55682
            head_gem = 55704
            hands_gem = 55671
            arms_gem = 55715
            legs_gem = 55726
            body_gem = 55737
            wrist_gem = 55693
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55507
            head_reward = 55503
            hands_reward = 55509
            arms_reward = 55504
            legs_reward = 55506
            body_reward = 55505
            wrist_reward = 55508
            master = "the Avatar of Zzur"
        elseif string.find(actor.class, "ranger") then
            feet_gem = 55688
            head_gem = 55710
            hands_gem = 55677
            arms_gem = 55721
            legs_gem = 55732
            body_gem = 55743
            wrist_gem = 55699
            feet_armor = 55361
            head_armor = 55369
            hands_armor = 55357
            arms_armor = 55373
            legs_armor = 55377
            body_armor = 55381
            wrist_armor = 55365
            feet_reward = 55521
            head_reward = 55517
            hands_reward = 55523
            arms_reward = 55518
            legs_reward = 55520
            body_reward = 55519
            wrist_reward = 55522
            master = "the Avatar of Haddixx"
        elseif actor.class == "paladin" then
            feet_gem = 55687
            head_gem = 55709
            hands_gem = 55676
            arms_gem = 55720
            legs_gem = 55731
            body_gem = 55742
            wrist_gem = 55698
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55500
            head_reward = 55496
            hands_reward = 55502
            arms_reward = 55497
            legs_reward = 55499
            body_reward = 55498
            wrist_reward = 55501
            master = "Belward"
        elseif string.find(actor.class, "monk") then
            feet_gem = 55685
            head_gem = 55707
            hands_gem = 55674
            arms_gem = 55718
            legs_gem = 55729
            body_gem = 55740
            wrist_gem = 55696
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55542
            head_reward = 55538
            hands_reward = 55544
            arms_reward = 55539
            legs_reward = 55541
            body_reward = 55540
            wrist_reward = 55543
            master = "the Almoner"
        elseif string.find(actor.class, "berserker") then
            feet_gem = 55686
            head_gem = 55710
            hands_gem = 55672
            arms_gem = 55717
            legs_gem = 55726
            body_gem = 55742
            wrist_gem = 55696
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55778
            head_reward = 55774
            hands_reward = 55780
            arms_reward = 55775
            legs_reward = 55777
            body_reward = 55776
            wrist_reward = 55779
            master = "Avaldr Mountainhelm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55691
            head_gem = 55713
            hands_gem = 55680
            arms_gem = 55724
            legs_gem = 55735
            body_gem = 55746
            wrist_gem = 55702
            feet_armor = 55361
            head_armor = 55369
            hands_armor = 55357
            arms_armor = 55373
            legs_armor = 55377
            body_armor = 55381
            wrist_armor = 55365
            feet_reward = 55563
            head_reward = 55559
            hands_reward = 55565
            arms_reward = 55560
            legs_reward = 55562
            body_reward = 55561
            wrist_reward = 55564
            master = "an Elite Mercenary in Ickle"
        elseif string.find(actor.class, "bard") then
            feet_gem = 55685
            head_gem = 55708
            hands_gem = 55671
            arms_gem = 55720
            legs_gem = 55728
            body_gem = 55743
            wrist_gem = 55694
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55792
            head_reward = 55788
            hands_reward = 55794
            arms_reward = 55789
            legs_reward = 55791
            body_reward = 55790
            wrist_reward = 55793
            master = "Grand Diva Belissica"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. proto_short(hands_armor) .. " and 3 of " .. proto_short(hands_gem))
        actor:send("</>  " .. proto_short(feet_armor) .. " and 3 of " .. proto_short(feet_gem))
        actor:send("</>  " .. proto_short(wrist_armor) .. " and 3 of " .. proto_short(wrist_gem))
        actor:send("</>  " .. proto_short(head_armor) .. " and 3 of " .. proto_short(head_gem))
        actor:send("</>  " .. proto_short(arms_armor) .. " and 3 of " .. proto_short(arms_gem))
        actor:send("</>  " .. proto_short(legs_armor) .. " and 3 of " .. proto_short(legs_gem))
        actor:send("</>  " .. proto_short(body_armor) .. " and 3 of " .. proto_short(body_gem))
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. proto_short(hands_armor))
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. proto_short(hands_gem))
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. proto_short(feet_armor))
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. proto_short(feet_gem))
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. proto_short(wrist_armor))
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. proto_short(wrist_gem))
        end
        if got_head and not done_head then
            actor:send("</>  " .. proto_short(head_armor))
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. proto_short(head_gem))
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. proto_short(arms_armor))
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. proto_short(arms_gem))
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. proto_short(legs_armor))
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. proto_short(legs_gem))
        end
        if got_body and not done_body then
            actor:send("</>  " .. proto_short(body_armor))
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. proto_short(body_gem))
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. proto_short(hands_reward))
        end
        if done_feet then
            actor:send("</>  " .. proto_short(feet_reward))
        end
        if done_wrist then
            actor:send("</>  " .. proto_short(wrist_reward))
        end
        if done_head then
            actor:send("</>  " .. proto_short(head_reward))
        end
        if done_arms then
            actor:send("</>  " .. proto_short(arms_reward))
        end
        if done_legs then
            actor:send("</>  " .. proto_short(legs_reward))
        end
        if done_body then
            actor:send("</>  " .. proto_short(body_reward))
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '9615c56dcca513cd0d4572f3b08870a0'),
  -- data/triggers/004/004_15_moonwell_progress_journal.lua
  (4, 15, $trig$-- Converted from DG Script #415: Moonwell progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "moonwell") or string.find(arg, "moonwell_spell_quest") then
    if string.find(actor.class, "druid") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("moonwell_spell_quest")
        local master = mobiles.template(163, 16).name
        actor:send("<b:u:green>Moonwell</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("moonwell_spell_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("moonwell_spell_quest") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local item
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
                    -- Vine of Mielikki
                    item = 16350
                    place = "an island of lava and fire"
                elseif tonumber(_sw1) == 3 then
                    -- The Heartstone
                    item = 48024
                    place = "an ancient burial site far to the north"
                elseif tonumber(_sw1) == 4 then
                    -- Flask of Eleweiss
                    item = 16356
                    place = "the cult of the ice dragon"
                elseif tonumber(_sw1) == 5 then
                    -- Flask of Eleweiss
                    item = 16356
                    place = "the cult of the ice dragon"
                elseif tonumber(_sw1) == 6 then
                    -- Glittering ruby ring
                    item = 5201
                    place = "a temple dedicated to fire"
                elseif tonumber(_sw1) == 7 then
                    -- Orb of Winds
                    item = 16006
                    place = "a dark fortress to the east"
                elseif tonumber(_sw1) == 8 then
                    -- Jade ring
                    item = 49011
                    place = "a wood nymph on an island of our brothers beset by beasts"
                elseif tonumber(_sw1) == 10 then
                    -- Chaos Orb
                    item = 4003
                    place = "a great dragon hidden in a hellish labyrinth"
                elseif tonumber(_sw1) == 11 then
                    -- Granite Ring
                    item = 55020
                    place = "a large temple hidden in a mountain"
                end
            end
            if stage < 6 or (stage >= 6 and (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 0) then
                actor:send("Bring " .. proto_short(item) .. " from " .. tostring(place) .. ".")
            else
                actor:send("Bring " .. tostring(master) .. " your bark map.")
            end
            if stage > 6 then
                actor:send("</>")
                actor:send("If you need a new map, return to " .. tostring(master) .. " and say \"<b:green>I lost my map</>\".")
            end
        end
    end
end
return _return_value$trig$, '5b08e1043c6efae74e2d23d2abbb5da9'),
  -- data/triggers/004/004_19_major_globe_progress_journal.lua
  (4, 19, $trig$-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local wards_left, plant, mist, water, flame, ice
local _return_value = true  -- Default: allow action
if string.find(arg, "major globe") or string.find(arg, "globe") or string.find(arg, "major_globe") or string.find(arg, "major_globe_spell") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("major_globe_spell")
        actor:send("<b:u:green>Major Globe</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("major_globe_spell") then
            status = "Completed!"
        elseif actor:get_quest_stage("major_globe_spell") > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("major_globe_spell") then
            -- switch on stage
            if stage == 1 then
                local master = mobiles.template(534, 50).name
                local task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                local master = mobiles.template(490, 8).name
                local task = "Find shale on Fiery Island."
            elseif stage == 3 then
                local master = mobiles.template(490, 8).name
                local task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                local master = mobiles.template(490, 8).name
                local task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                local master = mobiles.template(534, 50).name
                local task = "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."
            elseif stage == 7 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                local master = mobiles.template(534, 50).name
                plant = actor:get_quest_var("major_globe_spell:ward_53453")
                mist = actor:get_quest_var("major_globe_spell:ward_53454")
                water = actor:get_quest_var("major_globe_spell:ward_53455")
                flame = actor:get_quest_var("major_globe_spell:ward_53456")
                ice = actor:get_quest_var("major_globe_spell:ward_53457")
                wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                local task = "Bring " .. tostring(master) .. " <b:yellow>" .. tostring(wards_left) .. " more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if (final_item or 0) == 53458 then
                    place = "in a border keep"
                elseif (final_item or 0) == 53459 then
                    place = "on an emerald isle"
                elseif (final_item or 0) == 53460 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                local task = "Find " .. proto_short(final_item) .. " " .. tostring(place) .. "."
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                local task = "Deliver " .. proto_short(final_item) .. " to " .. tostring(master) .. "."
                actor:send("Quest Master: " .. tostring(master))
                actor:send("</>")
                actor:send(tostring(task))
                if stage == 8 then
                    if wards_left < 5 then
                        actor:send("You have found:")
                        if plant == 2 then
                            actor:send(tostring(objects.template(534, 53).name))
                        end
                        if mist == 2 then
                            actor:send(tostring(objects.template(534, 54).name))
                        end
                        if water == 2 then
                            actor:send(tostring(objects.template(534, 55).name))
                        end
                        if flame == 2 then
                            actor:send(tostring(objects.template(534, 56).name))
                        end
                        if ice == 2 then
                            actor:send(tostring(objects.template(534, 57).name))
                        end
                    end
                end
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, '23d2eddd0785595ba069be75b712a5a0'),
  -- data/triggers/004/004_22_combat_in_eldoria_progress_journal.lua
  (4, 22, $trig$-- Converted from DG Script #422: Combat in Eldoria progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local _return_value = true  -- Default: allow action
if string.find(arg, "combat in eldoria") or string.find(arg, "combat_in_eldoria") or string.find(arg, "third eldorian guard") or string.find(arg, "third black legion") or string.find(arg, "black_legion") or string.find(arg, "eldorian_guard") or string.find(arg, "third_black_legion") or string.find(arg, "third_eldorian_guard") or string.find(arg, "combat") or string.find(arg, "eldoria") then
    _return_value = true
    actor:send("<b:u:green>Combat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    if actor:get_quest_stage("black_legion") > 0 then
        actor:send("<cyan>Status: Continuous</>_")
        local id_trophy1
        local id_trophy2
        local id_trophy3
        local id_trophy4
        local id_trophy5
        local id_trophy6
        local id_trophy7
        local id_gem_cap
        local id_gem_neck
        local id_gem_arm
        local id_gem_wrist
        local id_gem_gloves
        local id_gem_jerkin
        local id_gem_robe
        local id_gem_belt
        local id_gem_legs
        local id_gem_boots
        local id_gem_mask
        local id_gem_symbol
        local id_gem_staff
        local id_gem_ssword
        local id_gem_whammer
        local id_gem_flail
        local id_gem_shiv
        local id_gem_lsword
        local id_gem_smace
        local id_gem_light
        local id_gem_food
        local id_gem_drink
        local id_cap
        local id_neck
        local team_a_idrm
        local id_wrist
        local id_gloves
        local id_jerkin
        local team_b_idelt
        local id_legs
        local team_b_idoots
        local id_mask
        local id_robe
        local id_symbol
        local id_staff
        local id_ssword
        local id_whammer
        local id_flail
        local id_shiv
        local id_lsword
        local id_smace
        local id_light
        local id_food
        local id_drink
        local legion
        local master
        local status
        if actor:get_quest_var("Black_Legion:bl_ally") then
            id_trophy1 = 5504
            id_trophy2 = 5506
            id_trophy3 = 5508
            id_trophy4 = 5510
            id_trophy5 = 5512
            id_trophy6 = 5514
            id_trophy7 = 5516
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5517
            id_neck = 5519
            team_a_idrm = 5521
            id_wrist = 5523
            id_gloves = 5525
            id_jerkin = 5527
            team_b_idelt = 5529
            id_legs = 5531
            team_b_idoots = 5533
            id_mask = 5535
            id_robe = 5537
            id_symbol = 5515
            id_staff = 5539
            id_ssword = 5540
            id_whammer = 5541
            id_flail = 5542
            id_shiv = 5543
            id_lsword = 5544
            id_smace = 5545
            id_light = 5553
            id_food = 5555
            id_drink = 5557
            legion = "Black Legion"
            master = mobiles.template(41, 27).name .. " and " .. mobiles.template(55, 12).name
            status = actor:get_quest_var("black_legion:bl_faction")
        elseif actor:get_quest_var("Black_Legion:eg_ally") then
            id_trophy1 = 5503
            id_trophy2 = 5505
            id_trophy3 = 5507
            id_trophy4 = 5509
            id_trophy5 = 5511
            id_trophy6 = 5513
            id_trophy7 = 5515
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5518
            id_neck = 5520
            team_a_idrm = 5522
            id_wrist = 5524
            id_gloves = 5526
            id_jerkin = 5528
            team_b_idelt = 5530
            id_legs = 5532
            team_b_idoots = 5534
            id_mask = 5536
            id_robe = 5538
            id_symbol = 5516
            id_staff = 5546
            id_ssword = 5547
            id_whammer = 5548
            id_flail = 5549
            id_shiv = 5550
            id_lsword = 5551
            id_smace = 5552
            id_light = 5554
            id_food = 5556
            id_drink = 5558
            legion = "Eldorian Guard"
            master = mobiles.template(186, 99).name .. " and " .. mobiles.template(55, 24).name
            status = actor:get_quest_var("black_legion:eg_faction")
        end
        actor:send("You are pledged to the " .. tostring(legion) .. ".")
        actor:send("Quest Master: " .. tostring(master))
        -- osend %actor% &0
        -- osend %actor% The %legion% is interested in:
        -- osend %actor% - %get.obj_shortdesc[%id_trophy1%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy2%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy3%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy4%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy5%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy6%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy7%]%
        actor:send("</>")
        actor:send("You have turned in:")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy1) .. "_trophies")) .. " " .. proto_plural(id_trophy1))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy2) .. "_trophies")) .. " " .. proto_plural(id_trophy2))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy3) .. "_trophies")) .. " " .. proto_plural(id_trophy3))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy4) .. "_trophies")) .. " " .. proto_plural(id_trophy4))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy5) .. "_trophies")) .. " " .. proto_plural(id_trophy5))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy6) .. "_trophies")) .. " " .. proto_plural(id_trophy6))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy7) .. "_trophies")) .. " " .. proto_plural(id_trophy7))
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. proto_short(id_food) .. "</> for <magenta>" .. proto_short(id_gem_food) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_food) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_drink) .. "</> for <magenta>" .. proto_short(id_gem_drink) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_drink) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_cap) .. "</> for <magenta>" .. proto_short(id_gem_cap) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_cap) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_ssword) .. "</> for <magenta>" .. proto_short(id_gem_ssword) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_ssword) .. "_reward")) .. ")_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. proto_short(id_neck) .. "</> for <magenta>" .. proto_short(id_gem_neck) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_neck) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_staff) .. "</> for <magenta>" .. proto_short(id_gem_staff) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_staff) .. "_reward")) .. ")_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. proto_short(team_a_idrm) .. "</> for <magenta>" .. proto_short(id_gem_arm) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_a_idrm) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_whammer) .. "</> for <magenta>" .. proto_short(id_gem_whammer) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_whammer) .. "_reward")) .. ")_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. proto_short(id_wrist) .. "</> for <magenta>" .. proto_short(id_gem_wrist) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_wrist) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_flail) .. "</> for <magenta>" .. proto_short(id_gem_flail) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_flail) .. "_reward")) .. ")_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. proto_short(id_gloves) .. "</> for <magenta>" .. proto_short(id_gem_gloves) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_gloves) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_symbol) .. "</> for <magenta>" .. proto_short(id_gem_symbol) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_symbol) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_light) .. "</> for <magenta>" .. proto_short(id_gem_light) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_light) .. "_reward")) .. ")_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. proto_short(team_b_idelt) .. "</> for <magenta>" .. proto_short(id_gem_belt) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idelt) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_shiv) .. "</> for <magenta>" .. proto_short(id_gem_shiv) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_shiv) .. "_reward")) .. ")_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. proto_short(team_b_idoots) .. "</> for <magenta>" .. proto_short(id_gem_boots) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idoots) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_lsword) .. "</> for <magenta>" .. proto_short(id_gem_lsword) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_lsword) .. "_reward")) .. ")_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. proto_short(id_legs) .. "</> for <magenta>" .. proto_short(id_gem_legs) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_legs) .. "_reward")) .. ")_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. proto_short(id_robe) .. "</> for <magenta>" .. proto_short(id_gem_robe) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_robe) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_jerkin) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_jerkin) .. "_reward")) .. ")_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. proto_short(id_mask) .. "</> for <magenta>" .. proto_short(id_gem_mask) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_mask) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_smace) .. "</> for <magenta>" .. proto_short(id_gem_smace) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_smace) .. "_reward")) .. ")_")
        end
        if (status or 0) < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '9f829e5410c3a89036f1c9dc77728011'),
  -- data/triggers/004/004_23_phoenix_sous_chef_progress_journal.lua
  (4, 23, $trig$-- Converted from DG Script #423: Phoenix Sous Chef progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "phoenix") or string.find(arg, "sous") or string.find(arg, "chef") or string.find(arg, "resort_cooking") or string.find(arg, "resort") or string.find(arg, "cooking") or string.find(arg, "phoenix_sous_chef") then
    if actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("resort_cooking")
        actor:send("<b:u:green>Phoenix Sous Chef</>")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but requires level 90+ to finish.")
        local status
        if actor:get_has_completed("resort_cooking") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>")
        if stage > 0 and not actor:get_has_completed("resort_cooking") then
            actor:send("</>")
            actor:send("Quest Master: " .. tostring(mobiles.template(103, 8).name))
            actor:send("</>")
            -- switch on stage
            local recipe
            local item1
            local item2
            local item3
            local item4
            local item5
            local item6
            local item7
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    recipe = "Peach Cobbler"
                    item1 = 61501
                    item2 = 23754
                    item3 = 3114
                    item4 = 35001
                elseif tonumber(_sw1) == 2 then
                    recipe = "Seafood Salad"
                    item1 = 49024
                    item2 = 23750
                    item3 = 23722
                    item4 = 8003
                    item5 = 12515
                    item6 = 1606
                elseif tonumber(_sw1) == 3 then
                    recipe = "Fish Stew"
                    item1 = 55213
                    item2 = 30002
                    item3 = 10030
                    item4 = 12552
                    item5 = 23757
                    item6 = 18509
                    item7 = 10311
                elseif tonumber(_sw1) == 4 then
                    recipe = "Honey-Glazed Ham"
                    item1 = 41011
                    item2 = 8350
                    item3 = 2001
                    item4 = 50207
                    item5 = 6106
                elseif tonumber(_sw1) == 5 then
                    recipe = "Saffroned Jasmine Rice"
                    item1 = 58019
                    item2 = 37013
                    item3 = 23760
                end
            end
            actor:send("You are trying to make:")
            actor:send("</>========<==b:white>" .. tostring(recipe) .. "</>==========")
            if item1 then
                actor:send("</>  " .. proto_short(item1))
            end
            if item2 then
                actor:send("</>  " .. proto_short(item2))
            end
            if item3 then
                actor:send("</>  " .. proto_short(item3))
            end
            if item4 then
                actor:send("</>  " .. proto_short(item4))
            end
            if item5 then
                actor:send("</>  " .. proto_short(item5))
            end
            if item6 then
                actor:send("</>  " .. proto_short(item6))
            end
            if item7 then
                actor:send("</>  " .. proto_short(item7))
            end
            actor:send("</>")
            actor:send("You have retrieved:")
            local nothing = 1
            if actor:get_quest_var("resort_cooking:item1") then
                actor:send("</>  " .. proto_short(item1))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item2") then
                actor:send("</>  " .. proto_short(item2))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item3") then
                actor:send("</>  " .. proto_short(item3))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item4") then
                actor:send("</>  " .. proto_short(item4))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item5") then
                actor:send("</>  " .. proto_short(item5))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item6") then
                actor:send("</>  " .. proto_short(item6))
                nothing = 0
            end
            if actor:get_quest_var("resort_cooking:item7") then
                actor:send("</>  " .. proto_short(item7))
                nothing = 0
            end
            if nothing then
                actor:send("</>  Nothing.")
            end
        end
    end
end
return _return_value$trig$, '6c6ce40f9aed2b8a03d08577b9bbf0bc'),
  -- data/triggers/004/004_25_resurrection_progress_journal.lua
  (4, 25, $trig$-- Converted from DG Script #425: Resurrection progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
local mob1, mob2, mob3
if string.find(arg, "resurrection") or string.find(arg, "resurrect") or string.find(arg, "resurrection_quest") or string.find(arg, "res") then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("resurrection_quest")
        actor:send("<b:u:green>Resurrection</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("resurrection_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        local hunt, item
        if stage > 0 and not actor:get_has_completed("resurrection_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(85, 50).name))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Ask Norisent about payment.")
                    return _return_value
                elseif tonumber(_sw1) == 2 then
                    actor:send("Norisent told you:")
                    actor:send("Do something to interfere with Ziijhan.  I hear he has a bishop locked up in the Cathedral dungeon.")
                    return _return_value
                elseif tonumber(_sw1) == 3 then
                    actor:send("Return to Norisent.")
                    return _return_value
                elseif tonumber(_sw1) == 4 then
                    hunt = tostring(mobiles.template(40, 4).name) .. ", " .. tostring(mobiles.template(40, 3).name) .. ", and " .. tostring(mobiles.template(40, 16).name)
                    mob1 = 4004
                    mob2 = 4003
                    mob3 = 4016
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 5 then
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 6 then
                    hunt = "2 Xeg-Yi and " .. tostring(mobiles.template(533, 8).name)
                    mob2 = 53411
                    mob1 = 53308
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 7 then
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 8 or tonumber(_sw1) == 9 then
                    hunt = tostring(mobiles.template(510, 5).name) .. ", " .. tostring(mobiles.template(530, 1).name) .. ", and " .. tostring(mobiles.template(510, 14).name)
                    mob1 = 51005
                    mob2 = 53001
                    mob3 = 51014
                    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                        item = "a large book on healing from Nordus"
                    elseif string.find(actor.class, "diabolist") then
                        item = objects.template(510, 28).name
                    end
                elseif tonumber(_sw1) == 10 then
                    hunt = tostring(mobiles.template(520, 3).name) .. " and " .. tostring(mobiles.template(520, 15).name)
                    mob1 = 52003
                    mob2 = 52015
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 11 then
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 12 then
                    actor:send("Destroy Norisent!")
                    return _return_value
                end
            end
        end
        if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
            local target1 = actor:get_quest_var("resurrection_quest:mob1")
            local target2 = actor:get_quest_var("resurrection_quest:mob2")
            local target3
            if stage ~= 6 and stage ~= 10 then
                target3 = actor:get_quest_var("resurrection_quest:mob3")
            end
            actor:send("You must eliminate:")
            actor:send(tostring(hunt))
            if stage == 4 or stage == 8 then
                if target1 and target2 and target3 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            elseif stage == 6 then
                if target1 and ((target2 or 0) == 2) then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            else
                if target1 and target2 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            end
            if target1 or target2 or target3 then
                actor:send("</>")
                actor:send("You have destroyed:")
                if target1 then
                    actor:send("- " .. mob_short(mob1))
                end
                if stage == 6 then
                    actor:send("- " .. tostring(target2) .. " " .. mob_short(mob2))
                else
                    if target2 then
                        actor:send("- " .. mob_short(mob2))
                    end
                end
                if stage == 4 or stage == 8 then
                    if target3 then
                        actor:send("- " .. mob_short(mob3))
                    end
                end
            end
            if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
                actor:send("</>")
                actor:send("You still need to dispatch:")
                if not target1 then
                    actor:send("- " .. mob_short(mob1))
                end
                if stage == 6 then
                    if (target2 or 0) < 2 then
                        local xeg = (2 - (target2 or 0))
                        actor:send("- " .. tostring(xeg) .. " " .. mob_short(mob2))
                    end
                else
                    if not target2 then
                        actor:send("- " .. mob_short(mob2))
                    end
                end
                if stage ~= 6 and stage ~= 10 then
                    if not target3 then
                        actor:send("- " .. mob_short(mob3))
                    end
                end
                actor:send("</>")
                actor:send("Return " .. tostring(item) .. " as proof.")
            end
            actor:send("</>")
            actor:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
        elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
            actor:send("Bring Norisent back " .. tostring(item) .. ".")
        end
        if stage >= 4 and not actor:get_has_completed("resurrection_quest") then
            actor:send("</>")
            actor:send("If you need a new talisman, return to Norisent and say <b:black>\"I need a new talisman\"</>.")
        end
    end
end
return _return_value$trig$, 'a7ad714a1ecda16de801cc6ad6da23f3'),
  -- data/triggers/004/004_30_banish_progress_journal.lua
  (4, 30, $trig$-- Converted from DG Script #430: Banish progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
local mob
local place
if string.find(arg, "banish") then
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) then
        _return_value = true
        local stage = actor:get_quest_stage("banish")
        local master = mobiles.template(302, 16).name
        actor:send("<b:u:green>Banish</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("banish") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("banish") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local known
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    mob = 41119
                    place = "her chamber under the ocean waves"
                    known = "Nothing."
                elseif tonumber(_sw1) == 2 then
                    mob = 53313
                    place = "the frozen tunnels of the north"
                    known = "v"
                elseif tonumber(_sw1) == 3 then
                    mob = 37000
                    place = "a deep and ancient mine"
                    known = "vi"
                elseif tonumber(_sw1) == 4 then
                    mob = 48005
                    place = "a room filled with art in an ancient barrow"
                    known = "vib"
                elseif tonumber(_sw1) == 5 then
                    mob = 53417
                    place = "the cold valley of the far north"
                    known = "vibu"
                elseif tonumber(_sw1) == 6 then
                    mob = 23811
                    place = "a nearby fortress of clouds and crystals"
                    known = "vibug"
                elseif tonumber(_sw1) == 7 then
                    actor:send("Return to " .. tostring(mobiles.template(302, 16).name) .. " and speak the prayer aloud: <b:magenta>vibugp</>")
                    return _return_value
                end
            end
            if (actor:get_quest_var("banish:greet") or 0) == 1 then
                actor:send("To learn Banish you must next kill " .. mob_short(mob) .. " in " .. tostring(place) .. ".")
            else
                actor:send("Return to " .. tostring(master) .. " for further instruction.")
            end
            actor:send("</>")
            actor:send("</>Your knowledge of the prayer so far: <b:cyan>" .. tostring(known) .. "</>")
        end
    end
end
return _return_value$trig$, 'c13615a627a48d8b4ccfe4198d16ac11'),
  -- data/triggers/004/004_32_word_of_command_progress_journal.lua
  (4, 32, $trig$-- Converted from DG Script #432: Word of Command progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
if string.find(arg, "word") or string.find(arg, "command") or string.find(arg, "word of command") or string.find(arg, "word_command") then
    if actor.level >= 65 then
        local stage
        if string.find(actor.class, "diabolist") or string.find(actor.class, "priest") then
            _return_value = true
            stage = actor:get_quest_stage("word_command")
            actor:send("<b:u:green>Word of Command</>")
            local status
            if actor:get_has_completed("word_command") then
                status = "Completed!"
            elseif (stage or 0) > 0 then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
        if stage > 0 and not actor:get_has_completed("word_command") then
            actor:send("Quest Master: " .. tostring(mobiles.template(430, 21).name))
            actor:send("</>")
            actor:send("Help " .. tostring(mobiles.template(430, 21).name) .. " escape from Demise Keep!")
            actor:send(mob_short(43017) .. " and its minions will stop at nothing to keep " .. mob_short(43021) .. " trapped in its clutches!")
        end
    end
end
return _return_value$trig$, '8d2a882c85280619088c62acf1959232'),
  -- data/triggers/004/004_35_creeping_doom_progress_journal.lua
  (4, 35, $trig$-- Converted from DG Script #435: Creeping Doom progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
local item1, item2, item3
local place1, place2, place3
if string.find(arg, "creeping") or string.find(arg, "creeping doom") or string.find(arg, "creeping_doom") then
    if actor.level >= 75 and string.find(actor.class, "druid") then
        _return_value = true
        local stage = actor:get_quest_stage("creeping_doom")
        actor:send("<b:u:green>Creeping Doom</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("creeping_doom") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("creeping_doom") then
            actor:send("Quest Master: " .. tostring(mobiles.template(615, 27).name))
            actor:send("</>")
            -- switch on stage
            local step
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    item1 = 11812
                    place1 = "an assassin vine on Mist Mountain"
                    item2 = 16213
                    place2 = "the great pyramid"
                    item3 = 48029
                    place3 = "Rhalean's evil sister in the northern barrow"
                    step = "gathering Nature's Rage"
                elseif tonumber(_sw1) == 2 then
                    local essence = actor:get_quest_var("creeping_doom:spiders")
                    local total = 11 - (actor:get_quest_var("creeping_doom:spiders") or 0)
                    actor:send("You are collecting essences of swarms from flies, insects, spiders, bugs, scorpions, giant ant people, etc.")
                    actor:send("</>")
                    actor:send("You have found " .. tostring(essence) .. " essences.")
                    actor:send("You need to find " .. tostring(total) .. " more.")
                    actor:send("</>")
                    actor:send("Remember, the tougher the bug, the better your chances of finding essences.")
                    return _return_value
                elseif tonumber(_sw1) == 3 then
                    step = "locate three sources of Nature's Vengeance."
                    item1 = 48416
                    place1 = "the elder tremaen in the elemental Plane of Fire"
                    item2 = 52034
                    place2 = "the burning tree in Templace"
                    item3 = 62503
                    place3 = "the Treant in the eldest Rhell's forest"
                elseif tonumber(_sw1) == 4 then
                    actor:send("Take the Essence of Nature's Vengeance and drop it at the entrance to the logging camp, then return to the angry pixie.")
                    return _return_value
                elseif tonumber(_sw1) == 5 then
                    actor:send("return to the very angry pixie.")
                    return _return_value
                end
            end
            local job1 = actor:get_quest_var("creeping_doom:item1")
            local job2 = actor:get_quest_var("creeping_doom:item2")
            local job3 = actor:get_quest_var("creeping_doom:item3")
            actor:send("You are trying to " .. tostring(step) .. ".")
            actor:send("</>")
            if job1 or job2 or job3 then
                actor:send("You have brought me:")
                if job1 then
                    actor:send("- " .. proto_short(item1))
                end
                if job2 then
                    actor:send("- " .. proto_short(item2))
                end
                if job3 then
                    actor:send("- " .. proto_short(item3))
                end
            end
            actor:send("</>")
            actor:send("You still need:")
            if not job1 then
                actor:send("- " .. proto_short(item1) .. " from " .. tostring(place1) .. ".")
            end
            if not job2 then
                actor:send("- " .. proto_short(item2) .. " from " .. tostring(place2) .. ".")
            end
            if not job3 then
                actor:send("- " .. proto_short(item3) .. " from " .. tostring(place3) .. ".")
            end
        end
    end
end
return _return_value$trig$, '4ada29eaf51b0afe5534b87fe844df79'),
  -- data/triggers/004/004_47_illusory_wall_progress_journal.lua
  (4, 47, $trig$-- Converted from DG Script #447: Illusory Wall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "illusory") or string.find(arg, "illusory wall") or string.find(arg, "illusory_wall") then
    if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("illusory_wall")
        local master = mobiles.template(364, 2).name
        actor:send("<b:u:green>Illusory Wall</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("illusory_wall") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("illusory_wall") then
            actor:send("Quest Master: " .. tostring(master))
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local item1 = actor:get_quest_var("illusory_wall:10307")
                    local item2 = actor:get_quest_var("illusory_wall:18511")
                    local item3 = actor:get_quest_var("illusory_wall:41005")
                    local item4 = actor:get_quest_var("illusory_wall:51017")
                    actor:send("You're looking for things to make magical spectacles.")
                    if item1 or item2 or item3 or item4 then
                        actor:send("</>")
                        actor:send("</>You have already brought me:")
                        if item1 then
                            actor:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
                        end
                        if item2 then
                            actor:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
                        end
                        if item3 then
                            actor:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
                        end
                        if item4 then
                            actor:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not item1 and not item2 then
                        actor:send("- <b:yellow>" .. proto_short(10307) .. "</> or <b:yellow>" .. proto_short(18511) .. "</>")
                    end
                    if not item3 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
                    end
                    if not item4 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
                    end
                elseif tonumber(_sw1) == 2 then
                    actor:send("Complete your study of doors in 20 regions.")
                    actor:send("</>")
                    local doors = actor:get_quest_var("illusory_wall:total")
                    actor:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")
                    if actor:get_quest_var("illusory_wall:Outback") then
                        actor:send("- <blue>Rocky Outback</>")
                    end
                    if actor:get_quest_var("illusory_wall:Shadows") then
                        actor:send("- <blue>Forest of Shadows</>")
                    end
                    if actor:get_quest_var("illusory_wall:Merchant") then
                        actor:send("- <blue>Old Merchant Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Caelia_West") then
                        actor:send("- <blue>South Caelia West</>")
                    end
                    if actor:get_quest_var("illusory_wall:River") then
                        actor:send("- <blue>Blue-Fog River</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mielikki") then
                        actor:send("- <blue>The Village of Mielikki</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mielikki_Forest") then
                        actor:send("- <blue>Mielikki's Forests</>")
                    end
                    if actor:get_quest_var("illusory_wall:Labyrinth") then
                        actor:send("- <blue>Laveryn Labyrinth</>")
                    end
                    if actor:get_quest_var("illusory_wall:Split") then
                        actor:send("- <blue>Split Skull</>")
                    end
                    if actor:get_quest_var("illusory_wall:Theatre") then
                        actor:send("- <blue>The Theatre in Anduin</>")
                    end
                    if actor:get_quest_var("illusory_wall:Rocky_Tunnels") then
                        actor:send("- <blue>Rocky Tunnels</>")
                    end
                    if actor:get_quest_var("illusory_wall:Lava") then
                        actor:send("- <blue>Lava Tunnels</>")
                    end
                    if actor:get_quest_var("illusory_wall:Misty") then
                        actor:send("- <blue>Misty Caverns</>")
                    end
                    if actor:get_quest_var("illusory_wall:Combat") then
                        actor:send("- <blue>Combat in Eldoria</>")
                    end
                    if actor:get_quest_var("illusory_wall:Anduin") then
                        actor:send("- <blue>The City of Anduin</>")
                    end
                    if actor:get_quest_var("illusory_wall:Pastures") then
                        actor:send("- <blue>Anduin Pastures</>")
                    end
                    if actor:get_quest_var("illusory_wall:Great_Road") then
                        actor:send("- <blue>The Great Road</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nswamps") then
                        actor:send("- <blue>The Northern Swamps</>")
                    end
                    if actor:get_quest_var("illusory_wall:Farmlands") then
                        actor:send("- <blue>Mielikki Farmlands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frakati") then
                        actor:send("- <blue>Frakati Reservation</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cathedral") then
                        actor:send("- <blue>Cathedral of Betrayal</>")
                    end
                    if actor:get_quest_var("illusory_wall:Meercats") then
                        actor:send("- <blue>Kingdom of the Meer Cats</>")
                    end
                    if actor:get_quest_var("illusory_wall:Logging") then
                        actor:send("- <blue>The Logging Camp</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dairy") then
                        actor:send("- <blue>The Dairy Farm</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ickle") then
                        actor:send("- <blue>Ickle</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frostbite") then
                        actor:send("- <blue>Mount Frostbite</>")
                    end
                    if actor:get_quest_var("illusory_wall:Phoenix") then
                        actor:send("- <blue>Phoenix Feather Hot Spring</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blue_Fog_Trail") then
                        actor:send("- <blue>Blue-Fog Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Twisted") then
                        actor:send("- <blue>Twisted Forest</>")
                    end
                    if actor:get_quest_var("illusory_wall:Megalith") then
                        actor:send("- <blue>The Sacred Megalith</>")
                    end
                    if actor:get_quest_var("illusory_wall:Tower") then
                        actor:send("- <blue>The Tower in the Wasted</>")
                    end
                    if actor:get_quest_var("illusory_wall:Miner") then
                        actor:send("- <blue>The Miner's Cavern</>")
                    end
                    if actor:get_quest_var("illusory_wall:Morgan") then
                        actor:send("- <blue>Morgan Hill</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mystwatch") then
                        actor:send("- <blue>The Fortress of Mystwatch</>")
                    end
                    if actor:get_quest_var("illusory_wall:Desert") then
                        actor:send("- <blue>Gothra Desert</>")
                    end
                    if actor:get_quest_var("illusory_wall:Pyramid") then
                        actor:send("- <blue>Gothra Pyramid</>")
                    end
                    if actor:get_quest_var("illusory_wall:Highlands") then
                        actor:send("- <blue>Highlands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Haunted") then
                        actor:send("- <blue>The Haunted House</>")
                    end
                    if actor:get_quest_var("illusory_wall:Citadel") then
                        actor:send("- <blue>The Citadel of Testing</>")
                    end
                    if actor:get_quest_var("illusory_wall:Chaos") then
                        actor:send("- <blue>Temple of Chaos</>")
                    end
                    if actor:get_quest_var("illusory_wall:Canyon") then
                        actor:send("- <blue>Canyon</>")
                    end
                    if actor:get_quest_var("illusory_wall:Topiary") then
                        actor:send("- <blue>Mielikki's Topiary</>")
                    end
                    if actor:get_quest_var("illusory_wall:Abbey") then
                        actor:send("- <blue>The Abbey</>")
                    end
                    if actor:get_quest_var("illusory_wall:Plains") then
                        actor:send("- <blue>Gothra Plains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dheduu") then
                        actor:send("- <blue>Dheduu</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dargentan") then
                        actor:send("- <blue>Dargentan's Lair</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ogakh") then
                        actor:send("- <blue>Ogakh</>")
                    end
                    if actor:get_quest_var("illusory_wall:Bluebonnet") then
                        actor:send("- <blue>Bluebonnet Pass</>")
                    end
                    if actor:get_quest_var("illusory_wall:Caelia_East") then
                        actor:send("- <blue>South Caelia East</>")
                    end
                    if actor:get_quest_var("illusory_wall:Brush") then
                        actor:send("- <blue>Brush Lands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Kaaz") then
                        actor:send("- <blue>Temple of the Kaaz</>")
                    end
                    if actor:get_quest_var("illusory_wall:SeaWitch") then
                        actor:send("- <blue>Sea's Lullaby</>")
                    end
                    if actor:get_quest_var("illusory_wall:Smuggler") then
                        actor:send("- <blue>Smuggler's Hideout</>")
                    end
                    if actor:get_quest_var("illusory_wall:Sirestis") then
                        actor:send("- <blue>Sirestis' Folly</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ancient_Ruins") then
                        actor:send("- <blue>Ancient Ruins</>")
                    end
                    if actor:get_quest_var("illusory_wall:Minithawkin") then
                        actor:send("- <blue>Minithawkin Mines</>")
                    end
                    if actor:get_quest_var("illusory_wall:Arabel") then
                        actor:send("- <blue>Arabel Ocean</>")
                    end
                    if actor:get_quest_var("illusory_wall:Hive") then
                        actor:send("- <blue>Hive</>")
                    end
                    if actor:get_quest_var("illusory_wall:Demise") then
                        actor:send("- <blue>Demise Keep</>")
                    end
                    if actor:get_quest_var("illusory_wall:Aviary") then
                        actor:send("- <blue>Ickle's Aviary</>")
                    end
                    if actor:get_quest_var("illusory_wall:Graveyard") then
                        actor:send("- <blue>The Graveyard</>")
                    end
                    if actor:get_quest_var("illusory_wall:Earth") then
                        actor:send("- <blue>The Plane of Earth</>")
                    end
                    if actor:get_quest_var("illusory_wall:Water") then
                        actor:send("- <blue>The Plane of Water</>")
                    end
                    if actor:get_quest_var("illusory_wall:Fire") then
                        actor:send("- <blue>The Plane of Fire</>")
                    end
                    if actor:get_quest_var("illusory_wall:Barrow") then
                        actor:send("- <blue>The Barrow</>")
                    end
                    if actor:get_quest_var("illusory_wall:Fiery") then
                        actor:send("- <blue>Fiery Island</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nukreth") then
                        actor:send("- <blue>Nukreth Spire</>")
                    end
                    if actor:get_quest_var("illusory_wall:Doom") then
                        actor:send("- <blue>An Ancient Forest and Pyramid</>")
                    end
                    if actor:get_quest_var("illusory_wall:Air") then
                        actor:send("- <blue>The Plane of Air</>")
                    end
                    if actor:get_quest_var("illusory_wall:Lokari") then
                        actor:send("- <blue>Lokari's Keep</>")
                    end
                    if actor:get_quest_var("illusory_wall:Griffin") then
                        actor:send("- <blue>Griffin Island</>")
                    end
                    if actor:get_quest_var("illusory_wall:BlackIce") then
                        actor:send("- <blue>Black-Ice Desert</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nymrill") then
                        actor:send("- <blue>The Lost City of Nymrill</>")
                    end
                    if actor:get_quest_var("illusory_wall:Bayou") then
                        actor:send("- <blue>The Bayou</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nordus") then
                        actor:send("- <blue>The Enchanted Village of Nordus</>")
                    end
                    if actor:get_quest_var("illusory_wall:Templace") then
                        actor:send("- <blue>Templace</>")
                    end
                    if actor:get_quest_var("illusory_wall:Sunken") then
                        actor:send("- <blue>Sunken Castle</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cult") then
                        actor:send("- <blue>Ice Cult</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frost") then
                        actor:send("- <blue>Frost Valley</>")
                    end
                    if actor:get_quest_var("illusory_wall:Technitzitlan") then
                        actor:send("- <blue>Technitzitlan</>")
                    end
                    if actor:get_quest_var("illusory_wall:Black_Woods") then
                        actor:send("- <blue>Black Woods</>")
                    end
                    if actor:get_quest_var("illusory_wall:Kaas_Plains") then
                        actor:send("- <blue>Kaas Plains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dark_Mountains") then
                        actor:send("- <blue>Dark Mountains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cold_Fields") then
                        actor:send("- <blue>Cold Fields</>")
                    end
                    if actor:get_quest_var("illusory_wall:Iron") then
                        actor:send("- <blue>Iron Hills</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blackrock") then
                        actor:send("- <blue>Black Rock Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Eldorian") then
                        actor:send("- <blue>Eldorian Foothills</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blacklake") then
                        actor:send("- <blue>Black Lake</>")
                    end
                    if actor:get_quest_var("illusory_wall:Odz") then
                        actor:send("- <blue>Odaishyozen</>")
                    end
                    if actor:get_quest_var("illusory_wall:Syric") then
                        actor:send("- <blue>Syric Mountain Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:KoD") then
                        actor:send("- <blue>Kingdom of Dreams</>")
                    end
                    if actor:get_quest_var("illusory_wall:Beachhead") then
                        actor:send("- <blue>Beachhead</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ice_Warrior") then
                        actor:send("- <blue>The Ice Warrior's Compound</>")
                    end
                    if actor:get_quest_var("illusory_wall:Haven") then
                        actor:send("- <blue>Sacred Haven</>")
                    end
                    if actor:get_quest_var("illusory_wall:Hollow") then
                        actor:send("- <blue>Enchanted Hollow</>")
                    end
                    if actor:get_quest_var("illusory_wall:Rhell") then
                        actor:send("- <blue>The Rhell Forest</>")
                    end
                    actor:send("</>")
                    local remaining = (20 - (doors or 0))
                    actor:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
                    actor:send("</>")
                    actor:send("If you need new lenses return to " .. tostring(master) .. " and say, <b:magenta>\"I need new glasses\"</>.")
                end
            end
        end
    end
end
return _return_value$trig$, '36e723c25b1bcb922824be954335a7f4'),
  -- data/triggers/004/004_48_the_finale_progress_journal.lua
  (4, 48, $trig$-- Converted from DG Script #448: The Finale progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "pippin") or string.find(arg, "theatre") or string.find(arg, "theater") or string.find(arg, "finale") then
    _return_value = true
    local stage = actor:get_quest_stage("theatre")
    actor:send("<b:u:green>The Finale</>")
    actor:send("Defeat wild monkeys, recover keys, and help the theatre troupe perform their fiery Finale!")
    actor:send("Recommended Level: 10")
    if (stage or 0) > 0 then
        actor:send("<cyan>Status: Repeatable</>")
        -- switch on stage
        local master
        do
            local _sw1 = string.lower(tostring(stage or ""))
            if tonumber(_sw1) == 1 then
                master = mobiles.template(43, 51).name
            elseif tonumber(_sw1) == 2 then
                master = mobiles.template(43, 45).name
            elseif tonumber(_sw1) == 3 then
                master = mobiles.template(43, 53).name
            elseif tonumber(_sw1) == 4 then
                master = mobiles.template(43, 52).name
            elseif tonumber(_sw1) == 5 then
                master = mobiles.template(43, 11).name
            elseif tonumber(_sw1) == 6 then
                master = mobiles.template(43, 12).name
            elseif tonumber(_sw1) == 7 then
                master = mobiles.template(43, 99).name
            end
        end
        actor:send("Quest Master: " .. tostring(master))
        actor:send("</>")
        -- switch on stage
        do
            local _sw2 = string.lower(tostring(stage or ""))
            if tonumber(_sw2) == 1 then
                actor:send("Get back Catherine's dressing room key from the ceiling monkeys, then bring her her eyelashes from her dressing room.")
                if (actor:get_quest_var("theatre:lashes") or 0) == 0 then
                    actor:send("Give Catherine her eyelashes.")
                elseif (actor:get_quest_var("theatre:lashes") or 0) == 1 then
                    actor:send("Give Catherine her dressing room key.")
                end
            elseif tonumber(_sw2) == 2 then
                actor:send("Give Lewis his dressing room key.")
            elseif tonumber(_sw2) == 3 then
                actor:send("Give Fastrada her dressing room key.")
            elseif tonumber(_sw2) == 4 then
                local item1 = 4320
                local item2 = 4301
                actor:send("Give Charlemagne his dressing room key and his missing sash.")
                if (actor:get_quest_var("theatre:sash") or 0) ~= 0 or (actor:get_quest_var("theatre:charles") or 0) ~= 0 then
                    actor:send("</>")
                    actor:send("You have brought him:")
                    if (actor:get_quest_var("theatre:sash") or 0) ~= 0 then
                        actor:send(proto_short(item1))
                    end
                    if (actor:get_quest_var("theatre:charles") or 0) ~= 0 then
                        actor:send(proto_short(item2))
                    end
                end
                actor:send("</>")
                actor:send("You still need:")
                if (actor:get_quest_var("theatre:sash") or 0) == 0 then
                    actor:send(proto_short(item1))
                end
                if (actor:get_quest_var("theatre:charles") or 0) == 0 then
                    actor:send(proto_short(item2))
                end
            elseif tonumber(_sw2) == 5 then
                actor:send("Give the Fire Goddess her skirt.")
            elseif tonumber(_sw2) == 6 then
                actor:send("The Fire Goddess told you:")
                actor:send("We need to find our Pippin in order to perform the grand Finale.  He's somewhere out in the world, trying to find his corner of the sky.")
                actor:send("</>")
                actor:send("I want you to bring him to us.")
                actor:send("</>")
                actor:send("Take " .. tostring(objects.template(43, 18).name) .. ".")
                actor:send("</>")
                actor:send("Hold it in your hand when you find him.  He won't be able to resist the beauty of one perfect flame.")
                actor:send("</>")
                actor:send("Now, when you get him back here, <b:cyan>[order]</> him to <b:cyan>[enter]</> the Fire Box.  We've prepared and hidden it upstage center just for him.")
                actor:send("</>")
                actor:send("<b:red>Be careful not to get inside it yourself!</>")
                actor:send("</>")
                actor:send("It's only for an extraordinary person like Pippin.")
            elseif tonumber(_sw2) == 7 then
                actor:send("Lead Pippin back to the theatre and order him to get in the Fire Box.")
            end
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '49a3ba1958062c9baf1740dd81e9093e'),
  -- data/triggers/004/004_49_air_wand_progress_journal.lua
  (4, 49, $trig$-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function room_by_vnum(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return nil end
    return get_room(zone, id)
end
local function room_name(vnum)
    local room = room_by_vnum(vnum)
    return room and room.name or ""
end
local _return_value = true  -- Default: allow action
if (string.find(arg, "air") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "air_wand") or string.find(arg, "air_wands") or string.find(arg, "air_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("air_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Air Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("air_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("air_wand") then
            local job1 = actor:get_quest_var("air_wand:wandtask1")
            local job2 = actor:get_quest_var("air_wand:wandtask2")
            local job3 = actor:get_quest_var("air_wand:wandtask3")
            local job4 = actor:get_quest_var("air_wand:wandtask4")
            local job5 = actor:get_quest_var("air_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("air_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55577
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(185, 0).name
                    hint = "Speak with the old Abbot in the Abbey of St. George."
                    wandgem = 55591
                    wandtask3 = 23750
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(586, 1).name
                    hint = "The keeper of a southern coastal tower will have advice for you."
                    wandgem = 55605
                    wandtask3 = 2330
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 5).name
                    hint = "A master of air near the megalith in South Caelia will be able to help next."
                    wandgem = 55644
                    wandtask3 = 12509
                    wandtask4 = "<b:white>the icy ledge outside Technitzitlan</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(123, 2).name
                    wandgem = 55665
                    hint = "Seek out the warrior-witch at the center of the southern megalith."
                    wandtask3 = 23800
                    wandtask4 = 59040
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(490, 3).name
                    wandgem = 55682
                    hint = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you."
                    wandtask3 = 51014
                    wandtask4 = 23710
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(85, 15).name
                    hint = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work."
                    wandgem = 55721
                    wandtask3 = 11799
                    wandtask4 = 53454
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(62, 16).name
                    hint = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips."
                    wandgem = 55742
                    wandtask3 = 49019
                    wandtask4 = 23803
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(185, 81).name
                    hint = "Silania will help you craft the finest of air weapons."
                    wandgem = 11811
                    wandtask3 = 52001
                    wandtask4 = 48862
                end
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("air_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the far eastern edge of the continent.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'bdb3ae4f3e31ea036c677e1c501468f6'),
  -- data/triggers/004/004_50_fire_wand_progress_journal.lua
  (4, 50, $trig$-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function room_by_vnum(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return nil end
    return get_room(zone, id)
end
local function room_name(vnum)
    local room = room_by_vnum(vnum)
    return room and room.name or ""
end
local _return_value = true  -- Default: allow action
if (string.find(arg, "fire") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "fire_wand") or string.find(arg, "fire_wands") or string.find(arg, "fire_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("fire_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Fire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("fire_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fire_wand") then
            local job1 = actor:get_quest_var("fire_wand:wandtask1")
            local job2 = actor:get_quest_var("fire_wand:wandtask2")
            local job3 = actor:get_quest_var("fire_wand:wandtask3")
            local job4 = actor:get_quest_var("fire_wand:wandtask4")
            local job5 = actor:get_quest_var("fire_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("fire_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55575
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(41, 26).name
                    hint = "A minion of the dark flame out east will know what to do."
                    wandgem = 55590
                    wandtask3 = 23752
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(103, 6).name
                    hint = "There's a fire master in the frozen north who likes to spend his time at the hot springs."
                    wandgem = 55612
                    wandtask3 = 2331
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 4).name
                    hint = "A master of fire near the megalith in South Caelia will be able to help next."
                    wandgem = 55639
                    wandtask3 = 12526
                    wandtask4 = "<b:red>the Lava Tunnels</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(238, 11).name
                    hint = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia."
                    wandgem = 55662
                    wandtask3 = 5201
                    wandtask4 = 32412
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(481, 5).name
                    hint = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though..."
                    wandgem = 55689
                    wandtask3 = 43018
                    wandtask4 = 11705
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(481, 150).name
                    hint = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further."
                    wandgem = 55716
                    wandtask3 = 53000
                    wandtask4 = 53456
                    place = 5272
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(484, 12).name
                    hint = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your wand."
                    wandgem = 55739
                    wandtask3 = 48126
                    wandtask4 = 4013
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(52, 30).name
                    hint = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff."
                    wandgem = 23822
                    wandtask3 = 52002
                    wandtask4 = 47800
                end
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("fire_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '37c605442b3978336da4a92c03578a17'),
  -- data/triggers/004/004_51_ice_wand_progress_journal.lua
  (4, 51, $trig$-- Converted from DG Script #451: Ice Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function room_by_vnum(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return nil end
    return get_room(zone, id)
end
local function room_name(vnum)
    local room = room_by_vnum(vnum)
    return room and room.name or ""
end
local _return_value = true  -- Default: allow action
if ((string.find(arg, "ice") or string.find(arg, "water") or string.find(arg, "cold") or string.find(arg, "frost")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "ice_wand") or string.find(arg, "ice_wands") or string.find(arg, "ice_staff") or string.find(arg, "water_wand") or string.find(arg, "water_wands") or string.find(arg, "water_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("ice_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Ice Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("ice_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("ice_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_wand") then
            local job1 = actor:get_quest_var("ice_wand:wandtask1")
            local job2 = actor:get_quest_var("ice_wand:wandtask2")
            local job3 = actor:get_quest_var("ice_wand:wandtask3")
            local job4 = actor:get_quest_var("ice_wand:wandtask4")
            local job5 = actor:get_quest_var("ice_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("ice_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55574
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(178, 6).name
                    hint = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice."
                    wandgem = 55592
                    wandtask3 = 23753
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(23, 37).name
                    hint = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale."
                    wandgem = 55607
                    wandtask3 = 2333
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(550, 13).name
                    hint = "A master of spirits in the far north will be able to help next."
                    wandgem = 55640
                    wandtask3 = 58018
                    wandtask4 = "<b:cyan>the Arabel Ocean</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(238, 2).name
                    hint = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets."
                    wandgem = 55666
                    wandtask3 = 49011
                    wandtask4 = 17309
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(533, 16).name
                    hint = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite."
                    wandgem = 55684
                    wandtask3 = 55016
                    wandtask4 = 23815
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(103, 0).name
                    hint = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting."
                    wandgem = 55717
                    wandtask3 = 23847
                    wandtask4 = 53457
                    place = 55105
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(100, 12).name
                    hint = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him."
                    wandgem = 55743
                    wandtask3 = 48018
                    wandtask4 = 53300
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(550, 20).name
                    hint = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff."
                    wandgem = 53314
                    wandtask3 = 52005
                    wandtask4 = 47708
                end
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("ice_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search near the crystalline pool in Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '0515f2d63699520205ca981ee640fe5c'),
  -- data/triggers/004/004_52_acid_wand_progress_journal.lua
  (4, 52, $trig$-- Converted from DG Script #452: Acid Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function room_by_vnum(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return nil end
    return get_room(zone, id)
end
local function room_name(vnum)
    local room = room_by_vnum(vnum)
    return room and room.name or ""
end
local _return_value = true  -- Default: allow action
if ((string.find(arg, "acid") or string.find(arg, "earth")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "acid_wand") or string.find(arg, "acid_wands") or string.find(arg, "acid_staff") or string.find(arg, "earth_wand") or string.find(arg, "earth_wands") or string.find(arg, "earth_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("acid_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Acid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("acid_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("acid_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("acid_wand") then
            local job1 = actor:get_quest_var("acid_wand:wandtask1")
            local job2 = actor:get_quest_var("acid_wand:wandtask2")
            local job3 = actor:get_quest_var("acid_wand:wandtask3")
            local job4 = actor:get_quest_var("acid_wand:wandtask4")
            local job5 = actor:get_quest_var("acid_wand:wandtask5")
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("acid_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55576
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(100, 56).name .. " in Ickle"
                    hint = "First, seek the one who guards the eastern gates of Ickle."
                    wandgem = 55593
                    wandtask3 = 23751
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(625, 4).name .. " in the Rhell Forest"
                    hint = "The next two artisans dwell in the Rhell Forest south-east of Mielikki."
                    wandgem = 55606
                    wandtask3 = 2332
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(625, 3).name
                    hint = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance."
                    wandgem = 55647
                    wandtask3 = 16303
                    wandtask4 = "<b:black>the Northern Swamps</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(470, 75).name .. " in the Graveyard"
                    hint = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay."
                    wandgem = 55663
                    wandtask3 = 55020
                    wandtask4 = 16107
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(40, 17).name .. " in the Black-Ice Desert"
                    hint = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert."
                    wandgem = 55683
                    wandtask3 = 16305
                    wandtask4 = 37082
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(480, 29).name .. " in the Barrow"
                    hint = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you."
                    wandgem = 55724
                    wandtask3 = 58414
                    wandtask4 = 53453
                    place = 16355
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(35, 49).name .. " at the Ranger Guild"
                    hint = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her."
                    wandgem = 55740
                    wandtask3 = 47006
                    wandtask4 = 52018
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(163, 15).name
                    hint = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff."
                    wandgem = 52031
                    wandtask3 = 52007
                    wandtask4 = 47672
                end
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("acid_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search in the heart of the heart of the thorns.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '6d47c60827bc7e569d90988d6269c1b0'),
  -- data/triggers/004/004_53_spirit_maces_progress_journal.lua
  (4, 53, $trig$-- Converted from DG Script #453: Spirit Maces progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if (string.find(arg, "spirit") and (string.find(arg, "mace") or string.find(arg, "maces"))) or string.find(arg, "phase_mace") or string.find(arg, "spirit_mace") then
    if string.find(actor.class, "priest") or string.find(actor.class, "cleric") then
        _return_value = true
        local stage = actor:get_quest_stage("phase_mace")
        local minlevel = stage * 10
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:u:green>Spirit Maces</>")
        if not actor:get_has_completed("phase_mace") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("phase_mace") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("phase_mace") then
            local job1 = actor:get_quest_var("phase_mace:macetask1")
            local job2 = actor:get_quest_var("phase_mace:macetask2")
            local job3 = actor:get_quest_var("phase_mace:macetask3")
            local job4 = actor:get_quest_var("phase_mace:macetask4")
            local job5 = actor:get_quest_var("phase_mace:macetask5")
            local job6 = actor:get_quest_var("phase_mace:macetask6")
            local attack = stage * 50
            local remaining = ((attack) - (actor:get_quest_var("phase_mace:attack_counter") or 0))
            -- switch on stage
            local master
            local maceitem2
            local maceitem3
            local maceitem4
            local maceitem5
            local hint
            local maceitem6
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    master = mobiles.template(30, 25).name
                    maceitem2 = 55577
                    maceitem3 = 55211
                    maceitem4 = 13614
                    maceitem5 = 58809
                    hint = "The Holy Templar Magistrate is a master of spiritual combat.  Perhaps he knows more."
                elseif tonumber(_sw1) == 2 then
                    master = mobiles.template(185, 2).name
                    maceitem2 = 55593
                    maceitem3 = 18522
                    maceitem4 = 18523
                    maceitem5 = 18524
                    maceitem6 = 18525
                    hint = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki."
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(100, 0).name
                    maceitem2 = 55604
                    maceitem3 = 32409
                    maceitem4 = 59022
                    maceitem5 = 2327
                    hint = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you."
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(62, 18).name
                    maceitem2 = 55631
                    maceitem3 = 16030
                    maceitem4 = 47002
                    maceitem5 = 5211
                    hint = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin."
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(85, 1).name
                    maceitem2 = 55660
                    maceitem3 = 43007
                    maceitem4 = 59012
                    maceitem5 = 17308
                    hint = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal."
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(185, 81).name
                    maceitem2 = 55681
                    maceitem3 = 23824
                    maceitem4 = 53016
                    maceitem5 = 16201
                    hint = "Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further."
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(60, 7).name
                    maceitem2 = 55708
                    maceitem3 = 49502
                    maceitem4 = 4008
                    maceitem5 = 47017
                    hint = "Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators."
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(484, 12).name
                    maceitem2 = 55737
                    maceitem3 = 53305
                    maceitem4 = 12307
                    maceitem5 = 51073
                    hint = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin."
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(30, 21).name
                    maceitem2 = 55738
                    maceitem3 = 48002
                    maceitem4 = 52010
                    maceitem5 = 3218
                    hint = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do."
                end
            end
            if actor.level >= minlevel then
                if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                    actor:send("Find the next master crafter and tell them why you have come.")
                    actor:send(tostring(hint))
                    return _return_value
                else
                    actor:send("Quest Master: " .. tostring(master))
                    actor:send("</>")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("</>")
                        actor:send("You've done the following:")
                        if job1 then
                            actor:send("- attacked " .. tostring(attack) .. " times")
                        end
                        if job2 then
                            actor:send("- found " .. proto_short(maceitem2))
                        end
                        if job3 then
                            actor:send("- found " .. proto_short(maceitem3))
                        end
                        if job4 then
                            actor:send("- found " .. proto_short(maceitem4))
                        end
                        if job5 then
                            actor:send("- found " .. proto_short(maceitem5))
                        end
                        if job6 then
                            actor:send("- found " .. proto_short(maceitem6))
                        end
                    end
                    actor:send("</>")
                    actor:send("You need to:")
                    if job1 and job2 and job3 and job4 and job5 then
                        if macestep ~= 2 then
                            actor:send("Bring " .. tostring(master) .. " your mace.")
                            return _return_value
                        else
                            if job6 then
                                actor:send("Bring " .. tostring(master) .. " your mace.")
                                return _return_value
                            end
                        end
                    end
                    if not job1 then
                        if remaining > 1 then
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
                        else
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
                        end
                    end
                    if not job2 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem2) .. "</>")
                    end
                    if not job3 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem3) .. "</>")
                    end
                    if not job4 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem4) .. "</>")
                    end
                    if not job5 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem5) .. "</>")
                    end
                    if stage == 2 then
                        if not job6 then
                            actor:send("- <b:yellow>find " .. proto_short(maceitem6) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'ecf6b44cda656f52c2ff4bb6682da61f'),
  -- data/triggers/004/004_56_assassin_mask_progress_journal.lua
  (4, 56, $trig$-- Converted from DG Script #456: Assassin Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "deadly") or string.find(arg, "promotion") or string.find(arg, "deadly_promotion or arg ~=assassin_mask") then
    if string.find(actor.class, "assassin") then
        _return_value = true
        local bountystage = actor:get_quest_stage("bounty_hunt")
        local maskstage = actor:get_quest_stage("assassin_mask")
        local master = mobiles.template(60, 51).name
        local job1 = actor:get_quest_var("assassin_mask:masktask1")
        local job2 = actor:get_quest_var("assassin_mask:masktask2")
        local job3 = actor:get_quest_var("assassin_mask:masktask3")
        local job4 = actor:get_quest_var("assassin_mask:masktask4")
        actor:send("<b:u:green>Deadly Promotion</>")
        local level
        if (maskstage or 0) == 0 then
            level = 10
        else
            level = maskstage * 10
        end
        if not actor:get_has_completed("assassin_mask") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif (maskstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if maskstage == 0 then
                actor:send("You have to do a <b:cyan>[job]</> for " .. tostring(master) .. " first though.")
                return _return_value
            elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
                actor:send("You need to complete some more Contract Killer jobs before you can receive another promotion.")
                return _return_value
            end
            -- switch on maskstage
            local mask
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(maskstage or ""))
                if tonumber(_sw1) == 1 then
                    mask = 4500
                    gem = 55592
                    place = "The Shadowy Lair"
                    hint = "in the Misty Caverns."
                elseif tonumber(_sw1) == 2 then
                    mask = 17809
                    gem = 55594
                    place = "The Dark Chamber"
                    hint = "behind a desert door."
                elseif tonumber(_sw1) == 3 then
                    mask = 59023
                    gem = 55620
                    place = "A Dark Tunnel"
                    hint = "on the way to a dark, hidden city."
                elseif tonumber(_sw1) == 4 then
                    mask = 10304
                    gem = 55638
                    place = "Dark Chamber"
                    hint = "hidden below a ghostly fortress."
                elseif tonumber(_sw1) == 5 then
                    mask = 16200
                    gem = 55666
                    place = "Darkness......"
                    hint = "inside an enchanted closet."
                elseif tonumber(_sw1) == 6 then
                    mask = 43017
                    gem = 55675
                    place = "Surrounded by Darkness"
                    hint = "in a volcanic shaft."
                elseif tonumber(_sw1) == 7 then
                    mask = 51075
                    gem = 55693
                    place = "Dark Indecision"
                    hint = "before an altar in a fallen maze."
                elseif tonumber(_sw1) == 8 then
                    mask = 49062
                    gem = 55719
                    place = "Heart of Darkness"
                    hint = "buried deep in an ancient tomb."
                elseif tonumber(_sw1) == 9 then
                    mask = 48427
                    gem = 55743
                    place = "A Dark Room"
                    hint = "under the ruins of a shop in an ancient city."
                end
            end
            local attack = maskstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(mask))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- hidden in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old mask.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("assassin_mask:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your mask.")
            end
            if not job2 then
                actor:send("- find <b:black>" .. proto_short(mask) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:black>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:black>hide in a place called \"<b:black>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:black>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '80e5508e19100dce39ef627bcd615b58'),
  -- data/triggers/004/004_58_divine_devotion_progress_journal.lua
  (4, 58, $trig$-- Converted from DG Script #458: Divine Devotion progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "divine") or string.find(arg, "devotion") or string.find(arg, "divine_devotion") or string.find(arg, "paladin_pendant") or string.find(arg, "paladin pendant") then
    local anti = "Anti-Paladin"
    if string.find(actor.class, "paladin") or actor.class == "anti-paladin" then
        _return_value = true
        local huntstage = actor:get_quest_stage("dragon_slayer")
        local pendantstage = actor:get_quest_stage("paladin_pendant")
        local master = mobiles.template(30, 80).name
        local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
        local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
        local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
        local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
        actor:send("<b:u:green>Divine Devotion</>")
        local level
        if (pendantstage or 0) == 0 then
            level = 10
        else
            level = pendantstage * 10
        end
        if not actor:get_has_completed("paladin_pendant") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("paladin_pendant") then
            status = "Completed!"
        elseif (pendantstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if pendantstage == 0 then
                actor:send("Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.")
                return _return_value
            elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
                actor:send("Slay a few more dragons before you can receive another promotion.")
                return _return_value
            end
            -- switch on pendantstage
            local necklace
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(pendantstage or ""))
                if tonumber(_sw1) == 1 then
                    necklace = 12003
                    gem = 55582
                    place = "The Mist Temple Altar"
                    hint = "in the Misty Caverns."
                elseif tonumber(_sw1) == 2 then
                    necklace = 23708
                    gem = 55590
                    place = "Chamber of Chaos"
                    hint = "in the Temple of Chaos."
                elseif tonumber(_sw1) == 3 then
                    necklace = 58005
                    gem = 55622
                    place = "Altar of Borgan"
                    hint = "in the lost city of Nymrill."
                elseif tonumber(_sw1) == 4 then
                    necklace = 48123
                    gem = 55654
                    place = "A Hidden Altar Room"
                    hint = "in a cave in South Caelia's Wailing Mountains."
                elseif tonumber(_sw1) == 5 then
                    necklace = 12336
                    gem = 55662
                    place = "The Altar of the Snow Leopard Order"
                    hint = "buried deep in Mt. Frostbite"
                elseif tonumber(_sw1) == 6 then
                    necklace = 43019
                    gem = 55677
                    place = "Chapel Altar"
                    hint = "deep underground in a lost castle."
                elseif tonumber(_sw1) == 7 then
                    necklace = 37015
                    gem = 55709
                    place = "A Cliffside Altar"
                    hint = "tucked away in the land of Dreams."
                elseif tonumber(_sw1) == 8 then
                    necklace = 58429
                    gem = 55738
                    place = "Dark Altar"
                    hint = "entombed with an ancient evil king."
                elseif tonumber(_sw1) == 9 then
                    necklace = 52010
                    gem = 55739
                    place = "An Altar"
                    hint = "far away in the Plane of Air."
                end
            end
            local attack = pendantstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(necklace))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- prayed in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old necklace.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("paladin_pendant:attack_counter") or 0)
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. proto_short(necklace) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '9202eea798f4985beb1229e2d1bc8d82'),
  -- data/triggers/004/004_60_eye_of_the_tiger_progress_journal.lua
  (4, 60, $trig$-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "eye of the tiger") or string.find(arg, "tiger") then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if string.find(string.lower(hunterclasses), actor.class, 1, true) then
        _return_value = true
        local huntstage = actor:get_quest_stage("beast_master")
        local trophystage = actor:get_quest_stage("ranger_trophy")
        local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
        local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
        local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
        local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
        actor:send("<b:u:green>Eye of the Tiger</>")
        local level
        if (trophystage or 0) == 0 then
            level = 10
        else
            level = trophystage * 10
        end
        if not actor:get_has_completed("ranger_trophy") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif (trophystage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if trophystage == 0 then
                actor:send("You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.")
                return _return_value
            elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
                actor:send("Prove your dominion over some more great beasts before you can demonstrate your skills.")
                return _return_value
            end
            -- switch on trophystage
            local trophy
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(trophystage or ""))
                if tonumber(_sw1) == 1 then
                    trophy = 1607
                    gem = 55579
                    place = "A Coyote's Den"
                    hint = "near the Kingdom of the Meer Cats."
                elseif tonumber(_sw1) == 2 then
                    trophy = 17806
                    gem = 55591
                    place = "In the Lions' Den"
                    hint = "in the western reaches of Gothra."
                elseif tonumber(_sw1) == 3 then
                    trophy = 1805
                    gem = 55628
                    place = "either of the two Gigantic Roc Nests"
                    hint = "in the Wailing Mountains."
                elseif tonumber(_sw1) == 4 then
                    trophy = 62513
                    gem = 55652
                    place = "Chieftain's Lair"
                    hint = "in Nukreth Spire in South Caelia."
                elseif tonumber(_sw1) == 5 then
                    trophy = 23803
                    gem = 55664
                    place = "The Heart of the Den"
                    hint = "where the oldest unicorn in South Caelia makes its home."
                elseif tonumber(_sw1) == 6 then
                    trophy = 43009
                    gem = 55685
                    place = "Giant Lynx's Lair"
                    hint = "far to the north beyond Mt. Frostbite."
                elseif tonumber(_sw1) == 7 then
                    trophy = 47008
                    gem = 55705
                    place = "Giant Griffin's Nest"
                    hint = "tucked away in a secluded and well guarded corner of Griffin Island."
                elseif tonumber(_sw1) == 8 then
                    trophy = 53323
                    gem = 55729
                    place = "Witch's Den"
                    hint = "entombed with an ancient evil king."
                elseif tonumber(_sw1) == 9 then
                    trophy = 52014
                    gem = 55741
                    place = "Dargentan's Lair"
                    hint = "at the pinnacle of his flying fortress."
                end
            end
            local attack = trophystage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(trophy))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- foraged in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old trophy.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("ranger_trophy:attack_counter") or 0)
                actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
            end
            if not job2 then
                actor:send("- find <b:green>" .. proto_short(trophy) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:green>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '5b35d7996dbe0e8da6918caf543c6642'),
  -- data/triggers/004/004_70_berserker_subclass_progress_journal.lua
  (4, 70, $trig$-- Converted from DG Script #470: Berserker Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function mob_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and mobiles.template(zone, id).name
    if not name or name == "" then return "[no description for mobile " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local berserkerraces = "none"
    if string.find(arg, "Berserker") and string.find(actor.class, "warrior") and actor.level <= 25 and not (string.find(berserkerraces, actor.race)) then
        _return_value = true
        actor:send("<b:black>Berserker</>")
        actor:send("Quest Master: " .. tostring(mobiles.template(364, 30).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if actor:get_quest_stage("berserker_subclass") > 0 then
            actor:send(tostring(mobiles.template(364, 30).name) .. " said to you:")
            -- switch on actor:get_quest_stage("berserker_subclass")
            do
                local _sw1 = string.lower(tostring(actor:get_quest_stage("berserker_subclass") or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("There are a few shared rites that bind us together.")
                    actor:send("None is more revered than the Wild Hunt.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Let us challenge the Spirits for the right to prove ourselves!")
                    actor:send("If they deem you worthy, the Spirits send you a vision of a mighty beast.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Howl to the spirits before " .. tostring(mobiles.template(364, 30).name) .. " and make your song known!")
                elseif tonumber(_sw1) == 4 then
                    -- switch on actor:get_quest_var("berserker_subclass:target")
                    local target
                    local place
                    do
                        local _sw2 = string.lower(tostring(actor:get_quest_var("berserker_subclass:target") or ""))
                        if tonumber(_sw2) == 16105 then
                            target = 16105
                            place = "a desert cave"
                        elseif tonumber(_sw2) == 16310 then
                            target = 16310
                            place = "some forested highlands"
                        elseif tonumber(_sw2) == 20311 then
                            target = 20311
                            place = "a vast plain"
                        elseif tonumber(_sw2) == 55220 then
                            target = 55220
                            place = "the frozen tundra"
                        end
                    end
                    actor:send("The Spirits revealed to you a vision of " .. mob_short(target) .. "!")
                    actor:send("You saw it iss in " .. tostring(place) .. "!")
                end
            end
        end
    end
end
return _return_value$trig$, '7d8ceecd4f6b5efb6b74171fb338bc2f'),
  -- data/triggers/004/004_86_infernal_weaponry_progress_journal.lua
  (4, 86, $trig$-- Converted from DG Script #486: Infernal Weaponry progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local _return_value = true  -- Default: allow action
local gem
if string.find(arg, "trident") or string.find(arg, "hell trident") or string.find(arg, "hell_trident") or string.find(arg, "Infernal Weaponry") or string.find(arg, "infernal") or string.find(arg, "weaponry") or string.find(arg, "infernal_weaponry") then
    if string.find(actor.class, "diabolist") then
        _return_value = true
        actor:send("<b:u:green>Infernal Weaponry</>")
        actor:send("Weapons of the lower realms await a diabolist dedicated enough to claim them.")
        local hellstage = actor:get_quest_stage("hell_trident")
        local minlevel
        if (hellstage or 0) == 0 then
            minlevel = 35
        elseif hellstage == 1 then
            minlevel = 65
        elseif hellstage == 2 then
            minlevel = 90
        end
        if not actor:get_has_completed("hell_trident") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("hell_trident") then
            status = "Completed!"
        elseif (hellstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("hell_trident") > 0 then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            -- switch on hellstage
            local master, pl_word, word, spell2, spell1, task6, task6do
            do
                local _sw1 = string.lower(tostring(hellstage or ""))
                if tonumber(_sw1) == 1 then
                    master = mobiles.template(60, 32).name
                    gem = 55662
                    pl_word = "angels"
                    word = "angel"
                    spell2 = "Banish"
                    spell1 = "Hellfire and Brimstone"
                    task6 = "assisted Vilekka Kar'Shezden"
                    task6do = "<b:yellow>Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.</>"
                elseif tonumber(_sw1) == 2 then
                    master = mobiles.template(125, 26).name
                    gem = 55739
                    pl_word = "ghaeles, solars, or seraphs"
                    word = "ghaele, solar, or seraph"
                    spell1 = "Resurrect"
                    spell2 = "Hell Gate"
                    task6 = "Defeated the Undead Prince"
                    task6do = "find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor."
                else
                    if not actor:get_has_completed("hell_trident") then
                        actor:send("Only someone mighty enough to claim the ancient truthstone and present it unto the leader of chaos may be given the dark powers of hell.  These diabolists will be rewarded for their unquenchable devotion by the dark gods themselves!")
                        return _return_value
                    end
                end
            end
            if actor.level >= minlevel then
                actor:send("Quest Master: " .. tostring(master))
                if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
                    actor:send("Speak with " .. tostring(master) .. ".")
                    return _return_value
                else
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("You have done the following:")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. proto_short(gem))
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send("Give " .. tostring(master) .. " your trident to finalize the pact.")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - (actor:get_quest_var("hell_trident:attack_counter") or 0)
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - (actor:get_quest_var("hell_trident:celestials") or 0)
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - (actor:get_quest_var("hell_trident:gems") or 0)
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. proto_plural(gem) .. "</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. proto_noa(gem) .. "</>")
                            end
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '8e8bef348799096f6c99eebf0a346d1a'),
  -- data/triggers/004/004_97_rogue_cloak_progress_journal.lua
  (4, 97, $trig$-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak and dagger") or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "rogue") or string.find(actor.class, "bard") or actor.class ~= "thief" then
        _return_value = true
        local huntstage = actor:get_quest_stage("treasure_hunter")
        local cloakstage = actor:get_quest_stage("rogue_cloak")
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        actor:send("<b:u:green>Cloak and Dagger</>")
        local level
        if (cloakstage or 0) == 0 then
            level = 10
        else
            level = cloakstage * 10
        end
        if not actor:get_has_completed("rogue_cloak") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("rogue_cloak") then
            status = "Completed!"
        elseif (cloakstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if cloakstage == 0 then
                actor:send("You must <b:cyan>[hunt]</> down more treasure first.")
                return _return_value
            elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
                actor:send("Find some more treasures before you seek another promotion.")
                return _return_value
            end
            -- switch on cloakstage
            local cloak
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(cloakstage or ""))
                if tonumber(_sw1) == 1 then
                    cloak = 58801
                    gem = 55585
                    place = "A Storage Room"
                    hint = "in the house on the hill."
                elseif tonumber(_sw1) == 2 then
                    cloak = 17307
                    gem = 55593
                    place = "A Small Alcove"
                    hint = "in the holy library."
                elseif tonumber(_sw1) == 3 then
                    cloak = 10308
                    gem = 55619
                    place = "either Treasure Room"
                    hint = "in the paladin fortress."
                elseif tonumber(_sw1) == 4 then
                    cloak = 12325
                    gem = 55659
                    place = "The Treasure Room"
                    hint = "beyond the Tower in the Wastes."
                elseif tonumber(_sw1) == 5 then
                    cloak = 43022
                    gem = 55663
                    place = "Treasury"
                    hint = "in the ghostly fortress."
                elseif tonumber(_sw1) == 6 then
                    cloak = 23810
                    gem = 55674
                    place = "either Treasure Room with a chest"
                    hint = "lost in the sands."
                elseif tonumber(_sw1) == 7 then
                    cloak = 51013
                    gem = 55714
                    place = "Mesmeriz's Secret Treasure Room"
                    hint = "hidden deep underground."
                elseif tonumber(_sw1) == 8 then
                    cloak = 58410
                    gem = 55740
                    place = "Treasure Room"
                    hint = "sunk in the swamp."
                elseif tonumber(_sw1) == 9 then
                    cloak = 52009
                    gem = 55741
                    place = "Treasure Room"
                    hint = "buried with an ancient king."
                end
            end
            local attack = cloakstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(cloak))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- searched in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give Honus your old cloak.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("rogue_cloak:attack_counter") or 0)
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. proto_short(cloak) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, 'bc660459ff0c9b7d9f533577582ccf2b'),
  -- data/triggers/030/030_87_paladin_pendant_isilynor_speech.lua
  (30, 87, $trig$-- Converted from DG Script #3087: Paladin pendant Isilynor speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"devotion"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
local huntstage = actor:get_quest_stage("dragon_slayer")
local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
wait(0.2)
if actor.class ~= "paladin" and actor.class ~= "anti-paladin" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Such acts are only for warriors of Justice or Destruction.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (pendantstage * 10) then
    self:say("You aren't ready for another devotional act yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("paladin_pendant") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
    return _return_value
end
if pendantstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a dragon first though.'")
    return _return_value
elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old necklace.'")
    return _return_value
end
-- switch on pendantstage
local place, hint
local necklace, gem
do
    local _sw1 = string.lower(tostring(pendantstage or ""))
    if tonumber(_sw1) == 1 then
        necklace = 12003
        gem = 55582
        place = "The Mist Temple Altar"
        hint = "in the Misty Caverns."
    elseif tonumber(_sw1) == 2 then
        necklace = 23708
        gem = 55590
        place = "Chamber of Chaos"
        hint = "in the Temple of Chaos."
    elseif tonumber(_sw1) == 3 then
        necklace = 58005
        gem = 55622
        place = "Altar of Borgan"
        hint = "in the lost city of Nymrill."
    elseif tonumber(_sw1) == 4 then
        necklace = 48123
        gem = 55654
        place = "A Hidden Altar Room"
        hint = "in a cave in South Caelia's Wailing Mountains."
    elseif tonumber(_sw1) == 5 then
        necklace = 12336
        gem = 55662
        place = "The Altar of the Snow Leopard Order"
        hint = "buried deep in Mt. Frostbite"
    elseif tonumber(_sw1) == 6 then
        necklace = 43019
        gem = 55677
        place = "Chapel Altar"
        hint = "deep underground in a lost castle."
    elseif tonumber(_sw1) == 7 then
        necklace = 37015
        gem = 55709
        place = "A Cliffside Altar"
        hint = "tucked away in the land of Dreams."
    elseif tonumber(_sw1) == 8 then
        necklace = 58429
        gem = 55738
        place = "Dark Altar"
        hint = "entombed with an ancient evil king."
    elseif tonumber(_sw1) == 9 then
        necklace = 52010
        gem = 55739
        place = "An Altar"
        hint = "far away in the Plane of Air."
    end
end
local attacks = pendantstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act of devotion you'll earn a new necklace.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current necklace.")
actor:send("- Find <b:yellow>" .. proto_short(necklace) .. "</> as the base for the new necklace.")
actor:send("- Find <b:yellow>" .. proto_short(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your necklace and <b:yellow>[pray]</> in a sanctified space.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '6baf4e8748098571973634f6e1e17eb4'),
  -- data/triggers/030/030_89_paladin_pendant_progress_tracker.lua
  (30, 89, $trig$-- Converted from DG Script #3089: Paladin Pendant progress tracker
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Dragon Slayer</>")
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif actor:get_quest_stage("dragon_slayer") == 0 and actor.level > 4 then
    actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
elseif actor.level < 5 then
    actor:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
elseif actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_var("dragon_slayer:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("dragon_slayer")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("dragon_slayer") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
end
local anti = "Anti-Paladin"
local necklace, gem
if actor.class == "paladin" or actor.class == "anti-paladin" then
    actor:send("</>")
    actor:send("<b:green>Divine Devotion</>")
    local huntstage = actor:get_quest_stage("dragon_slayer")
    local pendantstage = actor:get_quest_stage("paladin_pendant")
    local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
    local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
    local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
    local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (pendantstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another devotional act yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
        return _return_value
    end
    if pendantstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.'")
        return _return_value
    elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
        return _return_value
    end
    -- switch on pendantstage
    local place, hint
    do
        local _sw2 = string.lower(tostring(pendantstage or ""))
        if tonumber(_sw2) == 1 then
            necklace = 12003
            gem = 55582
            place = "The Mist Temple Altar"
            hint = "in the Misty Caverns."
        elseif tonumber(_sw2) == 2 then
            necklace = 23708
            gem = 55590
            place = "Chamber of Chaos"
            hint = "in the Temple of Chaos."
        elseif tonumber(_sw2) == 3 then
            necklace = 58005
            gem = 55622
            place = "Altar of Borgan"
            hint = "in the lost city of Nymrill."
        elseif tonumber(_sw2) == 4 then
            necklace = 48123
            gem = 55654
            place = "A Hidden Altar Room"
            hint = "in a cave in South Caelia's Wailing Mountains."
        elseif tonumber(_sw2) == 5 then
            necklace = 12336
            gem = 55662
            place = "The Altar of the Snow Leopard Order"
            hint = "buried deep in Mt. Frostbite"
        elseif tonumber(_sw2) == 6 then
            necklace = 43019
            gem = 55677
            place = "Chapel Altar"
            hint = "deep underground in a lost castle."
        elseif tonumber(_sw2) == 7 then
            necklace = 37015
            gem = 55709
            place = "A Cliffside Altar"
            hint = "tucked away in the land of Dreams."
        elseif tonumber(_sw2) == 8 then
            necklace = 58429
            gem = 55738
            place = "Dark Altar"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            necklace = 52010
            gem = 55739
            place = "An Altar"
            hint = "far away in the Plane of Air."
        end
    end
    local attack = pendantstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(necklace))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
        end
        if job4 then
            actor:send("- prayed in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old necklace.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - (actor:get_quest_var("paladin_pendant:attack_counter") or 0)
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. proto_short(necklace) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end$trig$, 'e98e02a2ae4acc1f8a3dcf6cb06539d2'),
  -- data/triggers/041/041_03_3bl_turn_in.lua
  (41, 3, $trig$local function proto_key(vnum)
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
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- The original zone using these quests was
-- 55 Combat in Eldoria.  I'm adapting the
-- format of the quest mechanics to spread the
-- vast wealth of these quests to other zones
-- such that there isn't so much loot in one zone.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- 
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    -- 
    local id_3el_skull = 5504
    local id_3el_ring = 5506
    local id_3el_badge = 5508
    local id_3el_token = 5510
    local id_3el_insignia = 5512
    local id_3el_wand = 5514
    local id_3el_symbol = 5516
    -- gems for this faction
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    -- rewards
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
    local id_3bl_food = 55
    local id_3bl_drink = 57
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- These cases will only have the objects rewarded by this
    -- questmaster though the full set of objects will be defined
    -- by the script.
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    if object.id == "%id_gem_3bl_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_3el_skull%" then
        exp_multiplier = 2
        id_trophy = id_3el_skull
        faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        exp_multiplier = 2
        id_trophy = id_3el_ring
        faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        exp_multiplier = 2
        id_trophy = id_3el_badge
        faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        exp_multiplier = 2
        id_trophy = id_3el_token
        faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        exp_multiplier = 2
        id_trophy = id_3el_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        exp_multiplier = 2
        id_trophy = id_3el_wand
        faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        exp_multiplier = 2
        id_trophy = id_3el_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, I see you have been out raiding the")
            actor:send("</>monks assisting the Eldorians.  According to my records you have now turned in")
            actor:send("</>have now turned in <b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Black Legion as you possibly can by raiding the Abbey.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You may find other more difficult battles")
            actor:send("</>in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Seek out the Third Black Legion Recruiter")
            actor:send("</>at the base of Tarelithis in order to curry more favor with our")
            actor:send("</>lords.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                -- 
                local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                actor:set_quest_var("black_legion", "eg_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "eg_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
            actor:send("</>cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
    actor:send("</>cause to earn our rewards.  You need a lower alignement, or to start these")
    actor:send("</>quests by saying <b:white>[yes]</>, <b:white>[quest]</>, or <b:white>[hello]</>.'")
end
return _return_value$trig$, '45a0fa926a57281066889a0ea2113c39'),
  -- data/triggers/041/041_07_3eg_turn_in.lua
  (41, 7, $trig$local function proto_key(vnum)
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
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- 3eg is Third Eldorian Guard
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local id_3bl_skull = 5503
    local id_3bl_ring = 5505
    local id_3bl_badge = 5507
    local id_3bl_token = 5509
    local id_3bl_insignia = 5511
    local id_3bl_wand = 5513
    local id_3bl_symbol = 5515
    -- gems for this faction
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    -- rewards
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
    local id_3eg_food = 56
    local id_3eg_drink = 58
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    if object.id == "%id_gem_3eg_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        id_trophy = id_3bl_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Eldorian Guard as you possibly can by raiding Split Skull.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You will find other more difficult battles")
            actor:send("</>with the Legion that will curry more favor with our masters in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Go to Tarelithis and seek the Recruiter of")
            actor:send("</>the Third Eldorian Guard!'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
            actor:send("<b:red>You feel more hated by the Black Legion!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, '1bfc9242ba175779e0e3d0813f6dc093'),
  -- data/triggers/053/053_17_ranger_trophy_pumahl_speech_skill.lua
  (53, 17, $trig$-- Converted from DG Script #5317: Ranger Trophy Pumahl speech skill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"skill"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local trophystage = actor:get_quest_stage("ranger_trophy")
local huntstage = actor:get_quest_stage("beast_master")
local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
wait(0.2)
if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "berserker" and actor.class ~= "mercenary" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only warriors, rangers, berserkers, and mercenaries possess the skills required for this.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (trophystage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("ranger_trophy") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
    return _return_value
end
if trophystage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a great beast first though.'")
    return _return_value
elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old trophy.'")
    return _return_value
end
-- switch on trophystage
local place, hint
local trophy, gem
do
    local _sw1 = string.lower(tostring(trophystage or ""))
    if tonumber(_sw1) == 1 then
        trophy = 1607
        gem = 55579
        place = "A Coyote's Den"
        hint = "near the Kingdom of the Meer Cats."
    elseif tonumber(_sw1) == 2 then
        trophy = 17806
        gem = 55591
        place = "In the Lions' Den"
        hint = "in the western reaches of Gothra."
    elseif tonumber(_sw1) == 3 then
        trophy = 1805
        gem = 55628
        place = "either of the two Gigantic Roc Nests"
        hint = "in the Wailing Mountains."
    elseif tonumber(_sw1) == 4 then
        trophy = 62513
        gem = 55652
        place = "Chieftain's Lair"
        hint = "in Nukreth Spire in South Caelia."
    elseif tonumber(_sw1) == 5 then
        trophy = 23803
        gem = 55664
        place = "The Heart of the Den"
        hint = "where the oldest unicorn in South Caelia makes its home."
    elseif tonumber(_sw1) == 6 then
        trophy = 43009
        gem = 55685
        place = "Giant Lynx's Lair"
        hint = "far to the north beyond Mt. Frostbite."
    elseif tonumber(_sw1) == 7 then
        trophy = 47008
        gem = 55705
        place = "Giant Griffin's Nest"
        hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif tonumber(_sw1) == 8 then
        trophy = 53323
        gem = 55729
        place = "Witch's Den"
        hint = "entombed with an ancient evil king."
    elseif tonumber(_sw1) == 9 then
        trophy = 52014
        gem = 55741
        place = "Dargentan's Lair"
        hint = "at the pinnacle of his flying fortress."
    end
end
local attacks = trophystage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act mission you'll earn a new trophy.  Undertake the following:")
actor:send("- Attack <b:green>" .. tostring(attacks) .. "</> times while wearing your current trophy.")
actor:send("- Find <b:green>" .. proto_short(trophy) .. "</> as another demonstration of mastery over the beasts of the wild.")
actor:send("- Find <b:green>" .. proto_short(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your trophy and <b:green>[forage]</> in a great beast's home.")
actor:send("Find \"<b:green>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '6ceba51a5f660604f4bc6ea8f03b0ec6'),
  -- data/triggers/053/053_19_ranger_trophy_pumahl_progress.lua
  (53, 19, $trig$-- Converted from DG Script #5319: Ranger Trophy Pumahl progress
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("beast_master") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
local trophy, gem
if actor.class == "warrior" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "mercenary" then
    actor:send("</>")
    actor:send("<b:green>Eye of the Tiger</>")
    local huntstage = actor:get_quest_stage("beast_master")
    local trophystage = actor:get_quest_stage("ranger_trophy")
    local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
    local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
    local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
    local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (trophystage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
        return _return_value
    end
    if trophystage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.'")
        return _return_value
    elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
        return _return_value
    end
    -- switch on trophystage
    local place, hint
    do
        local _sw2 = string.lower(tostring(trophystage or ""))
        if tonumber(_sw2) == 1 then
            trophy = 1607
            gem = 55579
            place = "A Coyote's Den"
            hint = "near the Kingdom of the Meer Cats."
        elseif tonumber(_sw2) == 2 then
            trophy = 17806
            gem = 55591
            place = "In the Lions' Den"
            hint = "in the western reaches of Gothra."
        elseif tonumber(_sw2) == 3 then
            trophy = 1805
            gem = 55628
            place = "either of the two Gigantic Roc Nests"
            hint = "in the Wailing Mountains."
        elseif tonumber(_sw2) == 4 then
            trophy = 62513
            gem = 55652
            place = "Chieftain's Lair"
            hint = "in Nukreth Spire in South Caelia."
        elseif tonumber(_sw2) == 5 then
            trophy = 23803
            gem = 55664
            place = "The Heart of the Den"
            hint = "where the oldest unicorn in South Caelia makes its home."
        elseif tonumber(_sw2) == 6 then
            trophy = 43009
            gem = 55685
            place = "Giant Lynx's Lair"
            hint = "far to the north beyond Mt. Frostbite."
        elseif tonumber(_sw2) == 7 then
            trophy = 47008
            gem = 55705
            place = "Giant Griffin's Nest"
            hint = "tucked away in a secluded and well guarded corner of Griffin Island."
        elseif tonumber(_sw2) == 8 then
            trophy = 53323
            gem = 55729
            place = "Witch's Den"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            trophy = 52014
            gem = 55741
            place = "Dargentan's Lair"
            hint = "at the pinnacle of his flying fortress."
        end
    end
    local attack = trophystage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(trophy))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
        end
        if job4 then
            actor:send("- foraged in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old trophy.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - (actor:get_quest_var("ranger_trophy:attack_counter") or 0)
        actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
    end
    if not job2 then
        actor:send("- find <b:green>" .. proto_short(trophy) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:green>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
    end
end$trig$, '4ae09ccb5246e25260f0cb5396c372d0'),
  -- data/triggers/053/053_28_honus_speech_promotion.lua
  (53, 28, $trig$-- Converted from DG Script #5328: Honus speech promotion
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"promotion"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
local huntstage = actor:get_quest_stage("treasure_hunter")
local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
wait(0.2)
if actor.class ~= "rogue" and actor.class ~= "bard" and actor.class ~= "thief" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'We only promote within the cloak and dagger guilds.  Sorry.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for a promotion yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (cloakstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
    return _return_value
elseif actor:get_has_completed("rogue_cloak") then
    actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
    return _return_value
end
if cloakstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
    return _return_value
elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old cloak.'")
    return _return_value
end
-- switch on cloakstage
local place, hint
local cloak, gem
do
    local _sw1 = string.lower(tostring(cloakstage or ""))
    if tonumber(_sw1) == 1 then
        cloak = 58801
        gem = 55585
        place = "A Storage Room"
        hint = "in the house on the hill."
    elseif tonumber(_sw1) == 2 then
        cloak = 17307
        gem = 55593
        place = "A Small Alcove"
        hint = "in the holy library."
    elseif tonumber(_sw1) == 3 then
        cloak = 10308
        gem = 55619
        place = "either Treasure Room"
        hint = "in the paladin fortress."
    elseif tonumber(_sw1) == 4 then
        cloak = 12325
        gem = 55659
        place = "The Treasure Room"
        hint = "beyond the Tower in the Wastes."
    elseif tonumber(_sw1) == 5 then
        cloak = 43022
        gem = 55663
        place = "Treasury"
        hint = "in the ghostly fortress."
    elseif tonumber(_sw1) == 6 then
        cloak = 23810
        gem = 55674
        place = "either Treasure Room with a chest"
        hint = "lost in the sands."
    elseif tonumber(_sw1) == 7 then
        cloak = 51013
        gem = 55714
        place = "Mesmeriz's Secret Treasure Room"
        hint = "hidden deep underground."
    elseif tonumber(_sw1) == 8 then
        cloak = 58410
        gem = 55740
        place = "Treasure Room"
        hint = "sunken in the swamp."
    elseif tonumber(_sw1) == 9 then
        cloak = 52009
        gem = 55741
        place = "Treasure Room"
        hint = "buried with an ancient king."
    end
end
local attacks = cloakstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each promotion you'll earn a new cloak to signify your new station.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current cloak.")
actor:send("- Find <b:yellow>" .. proto_short(cloak) .. "</> as the base for the new cloak.")
actor:send("- Find <b:yellow>" .. proto_short(gem) .. "</> for decoration.")
actor:send("</>")
actor:send("You also need to take your cloak and <b:yellow>[search]</> in various treasure rooms.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, 'd9b56327725a90d72e4cfec9f1dc8f3e'),
  -- data/triggers/053/053_30_rogue_cloak_progress.lua
  (53, 30, $trig$-- Converted from DG Script #5330: Rogue Cloak Progress
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Treasure Hunters</>")
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif actor:get_quest_stage("treasure_hunter") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
elseif actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("treasure_hunter")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("treasure_hunter") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
end
local cloak, gem
if actor.class == "rogue" or actor.class == "bard" or actor.class == "thief" then
    actor:send("</>")
    actor:send("<b:green>Cloak and Shadow</>")
    local huntstage = actor:get_quest_stage("treasure_hunter")
    local cloakstage = actor:get_quest_stage("rogue_cloak")
    local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
    local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
    local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
    local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for an promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (cloakstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
        return _return_value
    end
    if cloakstage == 0 then
        self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
        return _return_value
    elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
        return _return_value
    end
    -- switch on cloakstage
    local place, hint
    do
        local _sw2 = string.lower(tostring(cloakstage or ""))
        if tonumber(_sw2) == 1 then
            cloak = 58801
            gem = 55585
            place = "A Storage Room"
            hint = "in the house on the hill."
        elseif tonumber(_sw2) == 2 then
            cloak = 17307
            gem = 55593
            place = "A Small Alcove"
            hint = "in the holy library."
        elseif tonumber(_sw2) == 3 then
            cloak = 10308
            gem = 55619
            place = "either Treasure Room"
            hint = "in the paladin fortress."
        elseif tonumber(_sw2) == 4 then
            cloak = 12325
            gem = 55659
            place = "The Treasure Room"
            hint = "beyond the Tower in the Wastes."
        elseif tonumber(_sw2) == 5 then
            cloak = 43022
            gem = 55663
            place = "Treasury"
            hint = "in the ghostly fortress."
        elseif tonumber(_sw2) == 6 then
            cloak = 23810
            gem = 55674
            place = "either Treasure Room with a chest"
            hint = "lost in the sands."
        elseif tonumber(_sw2) == 7 then
            cloak = 51013
            gem = 55714
            place = "Mesmeriz's Secret Treasure Room"
            hint = "hidden deep underground."
        elseif tonumber(_sw2) == 8 then
            cloak = 58410
            gem = 55740
            place = "Treasure Room"
            hint = "sunken in the swamp."
        elseif tonumber(_sw2) == 9 then
            cloak = 52009
            gem = 55741
            place = "Treasure Room"
            hint = "buried with an ancient king."
        end
    end
    local attack = cloakstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. proto_short(cloak))
        end
        if job3 then
            actor:send("- found " .. proto_short(gem))
        end
        if job4 then
            actor:send("- searched in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old cloak.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - (actor:get_quest_var("rogue_cloak:attack_counter") or 0)
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. proto_short(cloak) .. "</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. proto_short(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end$trig$, '98e98221b943ab4be9df32d47fbcd6d8'),
  -- data/triggers/053/053_41_monk_vision_hakujo_speech_vision.lua
  (53, 41, $trig$-- Converted from DG Script #5341: Monk Vision Hakujo speech vision
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"vision", "enlightenment"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local visionstage = actor:get_quest_stage("monk_vision")
local missionstage = actor:get_quest_stage("elemental_chaos")
local job1 = actor:get_quest_var("monk_vision:visiontask1")
local job2 = actor:get_quest_var("monk_vision:visiontask2")
local job3 = actor:get_quest_var("monk_vision:visiontask3")
local job4 = actor:get_quest_var("monk_vision:visiontask4")
wait(0.2)
if actor.class ~= "monk" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Only monks have the mental fortitude to seek Enlightenment.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (visionstage * 10) then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for another vision yet.  Come back when you've gained more experience.'")
    return _return_value
elseif actor:get_has_completed("monk_vision") then
    actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    return _return_value
end
if visionstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    return _return_value
elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'Just give me your current vision mark.'")
    return _return_value
end
-- switch on visionstage
local place, hint
local gem, book
do
    local _sw1 = string.lower(tostring(visionstage or ""))
    if tonumber(_sw1) == 1 then
        book = 59006
        gem = 55582
        local room = get_room("4328")
        place = room.name
        hint = "in a place to perform."
    elseif tonumber(_sw1) == 2 then
        book = 18505
        gem = 55591
        local room = get_room("58707")
        place = room.name
        hint = "near a sandy beach."
    elseif tonumber(_sw1) == 3 then
        book = 8501
        gem = 55623
        local room = get_room("18597")
        place = room.name
        hint = "in a cloistered library."
    elseif tonumber(_sw1) == 4 then
        book = 12532
        gem = 55655
        local room = get_room("58102")
        place = room.name
        hint = "on my home island."
    elseif tonumber(_sw1) == 5 then
        book = 16209
        gem = 55665
        local room = get_room("16057")
        place = room.name
        hint = "in the ghostly fortress."
    elseif tonumber(_sw1) == 6 then
        book = 43013
        gem = 55678
        local room = get_room("59054")
        place = room.name
        hint = "in the fortress of the zealous."
    elseif tonumber(_sw1) == 7 then
        book = 53009
        gem = 55710
        local room = get_room("49079")
        place = room.name
        hint = "off-shore of the island of great beasts."
    elseif tonumber(_sw1) == 8 then
        book = 58415
        gem = 55722
        local room = get_room("11820")
        place = room.name
        hint = "beyond the Blue-Fog Trail."
    elseif tonumber(_sw1) == 9 then
        book = 58412
        gem = 55741
        local room = get_room("52075")
        place = room.name
        hint = "in the shattered citadel of Templace."
    end
end
local attacks = visionstage * 100
self:command("nod")
if visionstage == 1 then
    actor:send(tostring(self.name) .. " says, 'You will undertake a series of vision quests, gathering esoteric works of philosophy, history, and magic.  With each vision quest you'll earn a new marking to signify your path toward Enlightenment.'")
    actor:send("</>")
end
actor:send(tostring(self.name) .. " says, 'For your vision quest do the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current vision marking.")
actor:send("- Find <b:yellow>" .. proto_short(gem) .. "</> to awaken your Third Eye charka and <b:yellow>" .. proto_short(book) .. "</>.")
actor:send("- While donning your vision marking, take gem and text to a place of deep reflection and <b:yellow>[read]</> the text to broaden your awareness.")
actor:send("</>  Go to \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("Once you have, bring the gem, text, and your vision marking back to me.")
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, 'db072b2ac875e2dca8e927da5dcd7ef7'),
  -- data/triggers/053/053_43_elemental_chaos_hakujo_progress_checker.lua
  (53, 43, $trig$-- Converted from DG Script #5343: Elemental Chaos Hakujo progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Elemental Chaos</>")
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
elseif actor:get_quest_stage("elemental_chaos") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't walking the Way with me.'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
elseif actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("elemental_chaos")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("elemental_chaos") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshiping it!'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
end
local gem, book
local place, hint
if string.find(actor.class, "monk") then
    actor:send("</>")
    actor:send("</>")
    actor:send("<b:green>Enlightenment</>")
    local missionstage = actor:get_quest_stage("elemental_chaos")
    local visionstage = actor:get_quest_stage("monk_vision")
    local job1 = actor:get_quest_var("monk_vision:visiontask1")
    local job2 = actor:get_quest_var("monk_vision:visiontask2")
    local job3 = actor:get_quest_var("monk_vision:visiontask3")
    local job4 = actor:get_quest_var("monk_vision:visiontask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for a vision yet.  Come back when you've grown a bit.'")
    elseif actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    elseif actor.level < (visionstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    elseif visionstage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    else
        -- switch on visionstage
        do
            local _sw2 = string.lower(tostring(visionstage or ""))
            if tonumber(_sw2) == 1 then
                book = 59006
                gem = 55582
                local room = get_room("4328")
                place = room.name
                hint = "in a place to perform."
            elseif tonumber(_sw2) == 2 then
                book = 18505
                gem = 55591
                local room = get_room("58707")
                place = room.name
                hint = "near a sandy beach."
            elseif tonumber(_sw2) == 3 then
                book = 8501
                gem = 55623
                local room = get_room("18597")
                place = room.name
                hint = "in a cloistered library."
            elseif tonumber(_sw2) == 4 then
                book = 12532
                gem = 55655
                local room = get_room("58102")
                place = room.name
                hint = "on my home island."
            elseif tonumber(_sw2) == 5 then
                book = 16209
                gem = 55665
                local room = get_room("16057")
                place = room.name
                hint = "in the ghostly fortress."
            elseif tonumber(_sw2) == 6 then
                book = 43013
                gem = 55678
                local room = get_room("59054")
                place = room.name
                hint = "in the fortress of the zealous."
            elseif tonumber(_sw2) == 7 then
                book = 53009
                gem = 55710
                local room = get_room("49079")
                place = room.name
                hint = "off-shore of the island of great beasts."
            elseif tonumber(_sw2) == 8 then
                book = 58415
                gem = 55722
                local room = get_room("11820")
                place = room.name
                hint = "beyond the Blue-Fog Trail."
            elseif tonumber(_sw2) == 9 then
                book = 58412
                gem = 55741
                local room = get_room("52075")
                place = room.name
                hint = "in the shattered citadel of Templace."
            end
        end
        local attack = visionstage * 100
        if job1 or job2 or job3 or job4 then
            actor:send("You've done the following:")
            if job1 then
                actor:send("- attacked " .. tostring(attack) .. " times")
            end
            if job2 then
                actor:send("- found " .. proto_short(gem))
            end
            if job3 then
                actor:send("- found " .. proto_short(book))
            end
            if job4 then
                actor:send("- read in " .. tostring(place))
            end
            actor:send("</>")
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 then
            actor:send("Just give me your current vision mark.")
        else
            if not job1 then
                local remaining = attack - (actor:get_quest_var("monk_vision:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- take <b:yellow>" .. proto_short(gem) .. "</> and <b:yellow>" .. proto_short(book) .. "</> and <b:yellow>read</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- give me <b:yellow>" .. proto_short(gem) .. "</>")
                end
                if not job3 then
                    actor:send("- give me <b:yellow>" .. proto_short(book) .. "</>")
                end
            end
        end
    end
    if actor:get_quest_stage("monk_chants") > 0 then
        local chantstage = actor:get_quest_stage("monk_chants")
        -- switch on chantstage
        local chant, level, item
        do
            local _sw3 = string.lower(tostring(chantstage or ""))
            if tonumber(_sw3) == 1 then
                chant = "Tremors of Saint Augustine"
                level = 30
                item = "a book surrounded by trees and shadows"
                place = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful"
            elseif tonumber(_sw3) == 2 then
                chant = "Tempest of Saint Augustine"
                level = 40
                item = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity"
                place = "at the marker on a southern mountain range."
            elseif tonumber(_sw3) == 3 then
                chant = "Blizzards of Saint Augustine"
                level = 50
                item = "a book held by a master who in turn is a servant of a beast of winter"
                place = "in a temple shrouded in mists"
            elseif tonumber(_sw3) == 4 then
                chant = "Aria of Dissonance"
                level = 60
                item = "a book on war, held by a banished war god"
                place = "in a dark cave before a blasphemous book, near an unholy fire"
            elseif tonumber(_sw3) == 5 then
                chant = "Apocalyptic Anthem"
                level = 75
                item = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape"
                place = "in a chapel of the walking dead"
            elseif tonumber(_sw3) == 6 then
                chant = "Fires of Saint Augustine"
                level = 80
                item = "a scroll of curses, carried by children of air in a floating fortress"
                place = "at an altar dedicated to fire's destructive forces"
            elseif tonumber(_sw3) == 7 then
                chant = "Seed of Destruction"
                level = 99
                item = "the eye of one caught in an eternal feud"
                place = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied"
            end
        end
        actor:send("</>")
        actor:send("</>")
        actor:send("<b:green>Esoteric Chants</>")
        if actor.level >= level then
            if chantstage < (visionstage - 2) then
                actor:send(tostring(self.name) .. " says, 'You are seeking the chant " .. tostring(chant) .. ".'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " says, 'You are looking for " .. tostring(item) .. ".")
                actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(place) .. ".'")
            else
                actor:send(tostring(self.name) .. " says, 'You must first take another step towards <b:cyan>[enlightenment]</> before you can grasp more esoteric knowledge.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't ready to learn the next chant yet.'")
        end
    end
end$trig$, '8eca8690d02d9b8dd92dd1fcba4b9847'),
  -- data/triggers/053/053_55_hell_trident_receive.lua
  (53, 55, $trig$-- Converted from DG Script #5355: Hell Trident receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local _return_value = true  -- Default: allow action
local hellstage = actor:get_quest_stage("hell_trident")
-- switch on self.id
-- Black Priestess p2
local reward, phase, level, spell1, spell2, go
if (self.zone_id == 60 and self.id == 32) then
    reward = 39
    phase = 1
    level = 65
    spell1 = actor:get_has_completed("banish")
    spell2 = actor:get_has_completed("hellfire_brimstone")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    if (object.zone_id == 556 and object.id == 62) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 34) then
        go = "trident"
    end
elseif (self.zone_id == 125 and self.id == 26) then
    reward = 40
    phase = 2
    level = 90
    spell1 = actor:get_has_completed("resurrection_quest")
    spell2 = actor:get_has_completed("hell_gate")
    if (object.zone_id == 557 and object.id == 39) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 39) then
        go = "trident"
    end
end
-- adding in case it's not caught somewhere else
if hellstage == "phase" then
    if not actor:get_quest_var("hell_trident:helltask5") then
        if spell1 then
            actor:set_quest_var("hell_trident", "helltask5", 1)
        end
    end
    if not actor:get_quest_var("hell_trident:helltask4") then
        if spell2 then
            actor:set_quest_var("hell_trident", "helltask4", 1)
        end
    end
end
local refuse, reason
if actor:get_has_completed("hell_trident") then
    go = nil
    refuse = 1
    reason = "You already command the greatest power imaginable!"
elseif actor.level < level then
    go = nil
    refuse = 1
    reason = "You are not yet strong enough to handle more power."
elseif hellstage < phase then
    go = nil
    refuse = 1
    reason = "Your trident is not ready to upgrade yet."
elseif hellstage > phase then
    go = nil
    refuse = 1
    reason = "I've already done everything I can to help."
end
local refuse, reason
if go == "gem" then
    local gem_id = object.id
    local gem_count = actor:get_quest_var("hell_trident:gems") or 0
    if gem_count < 6 then
        wait(0.2)
        world.destroy(object.name)
        gem_count = gem_count + 1
        actor:set_quest_var("hell_trident", "gems", gem_count)
        actor:send(tostring(self.name) .. " says, 'Yes, this is perfect.'")
        wait(0.2)
        if gem_count == 1 then
            actor:send(tostring(self.name) .. " says, 'You have given me 1 of 6 " .. proto_plural(gem_id) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'You have given me " .. tostring(gem_count) .. " of 6 " .. proto_plural(gem_id) .. ".'")
        end
        wait(0.2)
        if gem_count >= 6 then
            actor:set_quest_var("hell_trident", "helltask3", 1)
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Now present the trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Complete your other sacrifices then return to me.'")
            end
        end
    else
        _return_value = true
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You have already given me 6 " .. proto_plural(gem_id) .. ".'")
    end
elseif go == "trident" then
    local job1 = actor:get_quest_var("hell_trident:helltask1")
    local job2 = actor:get_quest_var("hell_trident:helltask2")
    local job3 = actor:get_quest_var("hell_trident:helltask3")
    local job4 = actor:get_quest_var("hell_trident:helltask4")
    local job5 = actor:get_quest_var("hell_trident:helltask5")
    local job6 = actor:get_quest_var("hell_trident:helltask6")
    if job1 and job2 and job3 and job4 and job5 and job6 then
        wait(0.2)
        world.destroy(object)
        if (self.zone_id == 125 and self.id == 26) then
            actor:send(tostring(self.name) .. " says, 'We are pleased.'")
            self:command("grin")
            wait(1)
            self.room:send(tostring(self.name) .. " turns and faces out into the endless void of his vast realm.")
            wait(1)
            self.room:send(tostring(self.name) .. " growls, 'Ir ya roza aem ya iz ednuyt...'")
            wait(2)
            self.room:send("The inner <b:blue>ire</> of the " .. get_obj_noadesc(23, 39) .. " ignites and <red>b<blue>urn</><red>s</>!")
            wait(2)
            self.room:send(tostring(self.name) .. " roars, 'Liy ya gaoh yaezk'aqa, ir ya aehg mol'tiaer I kiwa yiz laodaer zes mina...'")
            wait(2)
            self.room:send(tostring(self.name) .. " erupts in glorious <red>f<blue>l<yellow>a<red>m</><red>e</>!")
            wait(2)
            self.room:send("The <red>f<b:yellow>i<red>r</><red>es<blue>t<yellow>o<red>r</><red>m</> forms a vortex about the " .. get_obj_noadesc(23, 39) .. ", like an explosion in reverse.")
            wait(1)
            self.room:send("The trident <b:magenta>t</><magenta>w<b:black>i</><magenta>s<blue>ts</> and contorts in the wild <red>f<b:yellow>i<red>r</><red>e</>!")
            wait(3)
            self.room:send("The fire subsides, leaving a <b:black>midnight-black</> weapon pulsing with dark radiance.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Our bond is forged.'")
        else
            actor:send(tostring(self.name) .. " says, 'The infernal ones are pleased.'")
            wait(1)
            self.room:send(tostring(self.name) .. "'s neck goes limp as her eyes roll back into her head.")
            wait(2)
            self.room:send(tostring(self.name) .. " begins to murmur... 'Hin tel'quiet nehel -nal rillis fis...'")
            wait(3)
            self.room:send("Brilliant <blue>b<b:black>lac</><blue>k fire seeps out of " .. get_obj_noadesc(23, 34) .. " and spreads across its surface.")
            wait(2)
            self.room:send(tostring(self.name) .. " babbles in an alien voice, 'Aul adoe shunti mor ik mor...'")
            wait(2)
            self.room:send("<red>Scarlet</> <blue>fl<blue>ames</> ignite in " .. tostring(self.name) .. "'s hands, pulsing in rhythm with her speech.")
            wait(2)
            self.room:send(tostring(self.name) .. " utters, 'Slidc ya qnoes oynaezz ya khozz qaed...' as she holds her hand over the " .. get_obj_noadesc(23, 34) .. ".")
            wait(2)
            self.room:send("The flames burn away the trident, leaving only a blazing tendril.")
            wait(2)
            self.room:send(tostring(self.name) .. " grabs the burning spire and commands, 'Le yaezzoth esaeu qae qota maenz!'")
            self.room:send("The wild flames contort as they cool into a new three-pointed form.")
            wait(2)
            if actor.level >= 90 then
                actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
            else
                actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
                actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
            end
        end
        self.room:spawn_object(23, reward)
        self:command("give trident " .. tostring(actor))
        local expcap = level
        local expmod
        if expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        local number = 1
        while number < 7 do
            actor:set_quest_var("hell_trident", "helltask%number%", 0)
            number = number + 1
        end
        actor:set_quest_var("hell_trident", "gems", 0)
        actor:set_quest_var("hell_trident", "greet", 0)
        if actor:get_quest_stage("hell_trident") == 1 then
            actor:advance_quest("hell_trident")
        else
            actor:complete_quest("hell_trident")
        end
    else
        refuse = 1
        reason = "You have to complete all your other offerings before you give me your trident."
    end
end
if refuse then
    _return_value = true
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(reason) .. "'")
end
return _return_value$trig$, '9e8f694c88e7d82979fc5345e4b8810f'),
  -- data/triggers/053/053_57_hell_trident_progress_tracker.lua
  (53, 57, $trig$-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: weapon progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
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
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local quest1, quest2, pl_word, spell1, spell2, task6, word, task6do, step
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]weapon progress[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
local gem
if string.find(actor.class, "diabolist") then
    local level, response
    if actor:get_quest_stage("hell_trident") > 0 then
        local hellstage = actor:get_quest_stage("hell_trident")
        if hellstage == 1 then
            level = 65
        elseif hellstage == 2 then
            level = 90
        end
        -- switch on self.id
        do
            if (self.zone_id == 23 and self.id == 11) then
                -- switch on hellstage
                do
                    local _sw2 = string.lower(tostring(hellstage or ""))
                    if tonumber(_sw2) == 1 then
                        response = "stage2"
                    elseif tonumber(_sw2) == 2 then
                        response = "stage3"
                    else
                        if actor:get_has_completed("hell_trident") then
                            response = "complete"
                        end
                    end
                end
            elseif (self.zone_id == 60 and self.id == 32) then
                step = 1
                gem = 55662
                pl_word = "angels"
                word = "angel"
                spell1 = "Hellfire and Brimstone"
                quest1 = actor:get_has_completed("hellfire_brimstone")
                spell2 = "Banish"
                quest2 = actor:get_has_completed("banish")
                if not actor:get_quest_var("hell_trident:helltask6") and actor.level >= level and hellstage == 1 then
                    if actor:get_quest_stage("vilekka_stew") > 3 then
                        actor:set_quest_var("hell_trident", "helltask6", 1)
                    end
                end
                task6 = "assisted Vilekka Kar'Shezden"
                task6do = "<b:yellow>Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.</>"
            elseif (self.zone_id == 125 and self.id == 26) then
                step = 2
                gem = 55739
                pl_word = "ghaeles, solars, or seraphs"
                word = "ghaele, solar, or seraph"
                spell1 = "Resurrect"
                quest1 = actor:get_has_completed("resurrection_quest")
                spell2 = "Hell Gate"
                quest2 = actor:get_has_completed("hell_gate")
                task6 = "Defeated the Undead Prince"
                task6do = "find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor."
            end
        end
        if hellstage == "step" then
            if actor.level >= level then
                if not actor:get_quest_var("hell_trident:helltask4") then
                    if quest1 then
                        actor:set_quest_var("hell_trident", "helltask4", 1)
                    end
                end
                if not actor:get_quest_var("hell_trident:helltask5") then
                    if quest2 then
                        actor:set_quest_var("hell_trident", "helltask5", 1)
                    end
                end
                if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " says, 'Tell me why you have come.'")
                else
                    local job1 = actor:get_quest_var("hell_trident:helltask1")
                    local job2 = actor:get_quest_var("hell_trident:helltask2")
                    local job3 = actor:get_quest_var("hell_trident:helltask3")
                    local job4 = actor:get_quest_var("hell_trident:helltask4")
                    local job5 = actor:get_quest_var("hell_trident:helltask5")
                    local job6 = actor:get_quest_var("hell_trident:helltask6")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send(tostring(self.name) .. " says, 'You have done the following:'")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. proto_short(gem))
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send(tostring(self.name) .. " says, 'Give me your trident to finalize the pact.'")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - (actor:get_quest_var("hell_trident:attack_counter") or 0)
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - (actor:get_quest_var("hell_trident:celestials") or 0)
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - (actor:get_quest_var("hell_trident:gems") or 0)
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. proto_plural(gem) .. "</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. proto_noa(gem) .. "</>")
                            end
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            else
                response = "level"
            end
        else
            if actor:get_has_completed("hell_trident") then
                response = "complete"
            elseif actor:get_quest_stage("hell_trident") < step then
                response = "stage1"
            else
                response = "stage3"
            end
        end
    end
    if response == "stage1" then
        actor:send(tostring(self.name) .. " says, 'You must make the initial offerings with another dark priest.'")
    elseif response == "stage2" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.'")
        else
            actor:send(tostring(self.name) .. " says, 'Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "stage3" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
        else
            actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "complete" then
        actor:send(tostring(self.name) .. " says, 'You've already marshalled the forces of Hell and Damnation to your side!'")
    elseif response == "level" then
        actor:send(tostring(self.name) .. " say, 'Stand before me again when you have achieved a larger measure of greatness.'")
        actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
    end
end$trig$, 'ade618bc872e28a036a122494eb3cfce'),
  -- data/triggers/055/055_03_3bl_turn_in.lua
  (55, 3, $trig$-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local id_3el_skull = 5504
    local id_3el_ring = 5506
    local id_3el_badge = 5508
    local id_3el_token = 5510
    local id_3el_insignia = 5512
    local id_3el_wand = 5514
    local id_3el_symbol = 5516
    -- gems for this faction
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_gloves = 55574
    local id_gem_3bl_jerkin = 55575
    local id_gem_3bl_robe = 55589
    local id_gem_3bl_belt = 55576
    local id_gem_3bl_legs = 55577
    local id_gem_3bl_boots = 55578
    local id_gem_3bl_mask = 55579
    local id_gem_3bl_symbol = 55580
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_shiv = 55585
    local id_gem_3bl_lsword = 55586
    local id_gem_3bl_smace = 55587
    local id_gem_3bl_light = 55588
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    -- rewards
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_gloves = 25
    local id_3bl_jerkin = 27
    local id_3bl_belt = 29
    local id_3bl_legs = 31
    local id_3bl_boots = 33
    local id_3bl_mask = 35
    local id_3bl_robe = 37
    local id_3bl_symbol = 15
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
    local id_3bl_shiv = 43
    local id_3bl_lsword = 44
    local id_3bl_smace = 45
    local id_3bl_light = 53
    local id_3bl_food = 55
    local id_3bl_drink = 57
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These case set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    if object.id == "%id_gem_3bl_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3bl_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3bl_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3el_skull%" then
        exp_multiplier = 2
        id_trophy = id_3el_skull
        faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        exp_multiplier = 2
        id_trophy = id_3el_ring
        faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        exp_multiplier = 2
        id_trophy = id_3el_badge
        faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        exp_multiplier = 2
        id_trophy = id_3el_token
        faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        exp_multiplier = 2
        id_trophy = id_3el_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        exp_multiplier = 2
        id_trophy = id_3el_wand
        faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        exp_multiplier = 2
        id_trophy = id_3el_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with")
            actor:send("</>the Black Legion as you possibly can by fighting the Third Eldrian Guard.  You")
            actor:send("</>may one day find other more difficult battles with those tree rats that will")
            actor:send("</>curry more favor with our lords.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                actor:set_quest_var("black_legion", "eg_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor:save()
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "eg_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, '50a9479e3a2bb84bf407604bbef40ae0'),
  -- data/triggers/055/055_04_3bl_rewards_list.lua
  (55, 4, $trig$-- Converted from DG Script #5504: 3bl_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local id_gem_3bl_cap = 55570
local id_gem_3bl_neck = 55571
local id_gem_3bl_arm = 55572
local id_gem_3bl_wrist = 55573
local id_gem_3bl_gloves = 55574
local id_gem_3bl_jerkin = 55575
local id_gem_3bl_robe = 55589
local id_gem_3bl_belt = 55576
local id_gem_3bl_legs = 55577
local id_gem_3bl_boots = 55578
local id_gem_3bl_mask = 55579
local id_gem_3bl_symbol = 55580
local id_gem_3bl_staff = 55581
local id_gem_3bl_ssword = 55582
local id_gem_3bl_whammer = 55583
local id_gem_3bl_flail = 55584
local id_gem_3bl_shiv = 55585
local id_gem_3bl_lsword = 55586
local id_gem_3bl_smace = 55587
local id_gem_3bl_light = 55588
local id_gem_3bl_food = 55566
local id_gem_3bl_drink = 55567
-- rewards
local id_3bl_cap = 5517
local id_3bl_neck = 5519
local id_3bl_arm = 5521
local id_3bl_wrist = 5523
local id_3bl_gloves = 5525
local id_3bl_jerkin = 5527
local id_3bl_belt = 5529
local id_3bl_legs = 5531
local id_3bl_boots = 5533
local id_3bl_mask = 5535
local id_3bl_robe = 5537
local id_3bl_symbol = 5515
local id_3bl_staff = 5539
local id_3bl_ssword = 5540
local id_3bl_whammer = 5541
local id_3bl_flail = 5542
local id_3bl_shiv = 5543
local id_3bl_lsword = 5544
local id_3bl_smace = 5545
local id_3bl_light = 5553
local id_3bl_food = 5555
local id_3bl_drink = 5557
-- 
-- Check faction and react accordingly
-- 
if actor.alignment <= 150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit,")
            actor:send("</>come back when you have defeated more of the Eldorian villainy.'")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor:get_quest_var("black_legion:bl_faction")%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the")
            actor:send("</>ears I suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_food) .. "</> for <magenta>" .. proto_short(id_gem_3bl_food) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_drink) .. "</> for <magenta>" .. proto_short(id_gem_3bl_drink) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_cap) .. "</> for <magenta>" .. proto_short(id_gem_3bl_cap) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_ssword) .. "</> for <magenta>" .. proto_short(id_gem_3bl_ssword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_neck) .. "</> for <magenta>" .. proto_short(id_gem_3bl_neck) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_staff) .. "</> for <magenta>" .. proto_short(id_gem_3bl_staff) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_arm) .. "</> for <magenta>" .. proto_short(id_gem_3bl_arm) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_whammer) .. "</> for <magenta>" .. proto_short(id_gem_3bl_whammer) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_wrist) .. "</> for <magenta>" .. proto_short(id_gem_3bl_wrist) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_flail) .. "</> for <magenta>" .. proto_short(id_gem_3bl_flail) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_gloves) .. "</> for <magenta>" .. proto_short(id_gem_3bl_gloves) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_symbol) .. "</> for <magenta>" .. proto_short(id_gem_3bl_symbol) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_light) .. "</> for <magenta>" .. proto_short(id_gem_3bl_light) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_belt) .. "</> for <magenta>" .. proto_short(id_gem_3bl_belt) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_shiv) .. "</> for <magenta>" .. proto_short(id_gem_3bl_shiv) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_boots) .. "</> for <magenta>" .. proto_short(id_gem_3bl_boots) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_lsword) .. "</> for <magenta>" .. proto_short(id_gem_3bl_lsword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_legs) .. "</> for <magenta>" .. proto_short(id_gem_3bl_legs) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_robe) .. "</> for <magenta>" .. proto_short(id_gem_3bl_robe) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_3bl_jerkin) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_mask) .. "</> for <magenta>" .. proto_short(id_gem_3bl_mask) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_smace) .. "</> for <magenta>" .. proto_short(id_gem_3bl_smace) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black")
            actor:send("</>Legion improves I will show you more rewards.'")
        end
        -- (empty send to actor)
    end
end$trig$, '8e2db4e43f534a12f0fc37dc164ac45f'),
  -- data/triggers/055/055_07_3eg_turn_in.lua
  (55, 7, $trig$-- Converted from DG Script #5507: 3eg_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3eg is Third Eldorian Guard
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local id_3bl_skull = 5503
    local id_3bl_ring = 5505
    local id_3bl_badge = 5507
    local id_3bl_token = 5509
    local id_3bl_insignia = 5511
    local id_3bl_wand = 5513
    local id_3bl_symbol = 5515
    -- gems for this faction
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_gloves = 55574
    local id_gem_3eg_jerkin = 55575
    local id_gem_3eg_robe = 55589
    local id_gem_3eg_belt = 55576
    local id_gem_3eg_legs = 55577
    local id_gem_3eg_boots = 55578
    local id_gem_3eg_mask = 55579
    local id_gem_3eg_symbol = 55580
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_shiv = 55585
    local id_gem_3eg_lsword = 55586
    local id_gem_3eg_smace = 55587
    local id_gem_3eg_light = 55588
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    -- rewards
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_gloves = 26
    local id_3eg_jerkin = 28
    local id_3eg_belt = 30
    local id_3eg_legs = 32
    local id_3eg_boots = 34
    local id_3eg_mask = 36
    local id_3eg_robe = 38
    local id_3eg_symbol = 16
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
    local id_3eg_shiv = 50
    local id_3eg_lsword = 51
    local id_3eg_smace = 52
    local id_3eg_light = 54
    local id_3eg_food = 56
    local id_3eg_drink = 58
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    if object.id == "%id_gem_3eg_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3eg_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3eg_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        id_trophy = id_3bl_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in")
        actor:send("</>this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have")
            actor:send("</>been out fighting the Black Legion.  I see from my records you have now given")
            actor:send("</>me <b:yellow>" .. tostring(trophies) .. " <white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as")
            actor:send("</>much favor with the Eldorian Guard as you possibly can by fighting the Third")
            actor:send("</>Black Legion.  You may one day find other more difficult battles with those")
            actor:send("</>tree rats that will curry more favor with our masters.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
            actor:send("<b:red>You feel more hated by the Black Legion!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good")
            actor:send("</>enough for these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard")
            actor:send("</>thanks you for your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
            actor:send("</>enough with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
    actor:send("</>enough with our cause to earn our rewards.  You need a higher alignment or to")
    actor:send("</>start these quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, 'b75a582ee55636282ac3afcb46ed6b3e'),
  -- data/triggers/055/055_08_3eg_rewards_list.lua
  (55, 8, $trig$-- Converted from DG Script #5508: 3eg_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local id_gem_3eg_cap = 55570
local id_gem_3eg_neck = 55571
local id_gem_3eg_arm = 55572
local id_gem_3eg_wrist = 55573
local id_gem_3eg_gloves = 55574
local id_gem_3eg_jerkin = 55575
local id_gem_3eg_robe = 55589
local id_gem_3eg_belt = 55576
local id_gem_3eg_legs = 55577
local id_gem_3eg_boots = 55578
local id_gem_3eg_mask = 55579
local id_gem_3eg_symbol = 55580
local id_gem_3eg_staff = 55581
local id_gem_3eg_ssword = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail = 55584
local id_gem_3eg_shiv = 55585
local id_gem_3eg_lsword = 55586
local id_gem_3eg_smace = 55587
local id_gem_3eg_light = 55588
local id_gem_3eg_food = 55566
local id_gem_3eg_drink = 55567
-- rewards
local id_3eg_cap = 5518
local id_3eg_neck = 5520
local id_3eg_arm = 5522
local id_3eg_wrist = 5524
local id_3eg_gloves = 5526
local id_3eg_jerkin = 5528
local id_3eg_belt = 5530
local id_3eg_legs = 5532
local id_3eg_boots = 5534
local id_3eg_mask = 5536
local id_3eg_robe = 5538
local id_3eg_symbol = 5516
local id_3eg_staff = 5546
local id_3eg_ssword = 5547
local id_3eg_whammer = 5548
local id_3eg_flail = 5549
local id_3eg_shiv = 5550
local id_3eg_lsword = 5551
local id_3eg_smace = 5552
local id_3eg_light = 5554
local id_3eg_food = 5556
local id_3eg_drink = 5558
-- 
-- Check faction and react accordingly
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a")
            actor:send("</>recruit, come back when you have defeated more of the Black Legion hordes.'")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor:get_quest_var("black_legion:eg_faction")%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit")
            actor:send("</>wet behind the ears I suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_food) .. "</> for <magenta>" .. proto_short(id_gem_3eg_food) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_drink) .. "</> for <magenta>" .. proto_short(id_gem_3eg_drink) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_cap) .. "</> for <magenta>" .. proto_short(id_gem_3eg_cap) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_ssword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_ssword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_neck) .. "</> for <magenta>" .. proto_short(id_gem_3eg_neck) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_staff) .. "</> for <magenta>" .. proto_short(id_gem_3eg_staff) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_arm) .. "</> for <magenta>" .. proto_short(id_gem_3eg_arm) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_whammer) .. "</> for <magenta>" .. proto_short(id_gem_3eg_whammer) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_wrist) .. "</> for <magenta>" .. proto_short(id_gem_3eg_wrist) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_flail) .. "</> for <magenta>" .. proto_short(id_gem_3eg_flail) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_gloves) .. "</> for <magenta>" .. proto_short(id_gem_3eg_gloves) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_symbol) .. "</> for <magenta>" .. proto_short(id_gem_3eg_symbol) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_light) .. "</> for <magenta>" .. proto_short(id_gem_3eg_light) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_belt) .. "</> for <magenta>" .. proto_short(id_gem_3eg_belt) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_shiv) .. "</> for <magenta>" .. proto_short(id_gem_3eg_shiv) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_boots) .. "</> for <magenta>" .. proto_short(id_gem_3eg_boots) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_lsword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_lsword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_legs) .. "</> for <magenta>" .. proto_short(id_gem_3eg_legs) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_robe) .. "</> for <magenta>" .. proto_short(id_gem_3eg_robe) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_3eg_jerkin) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_mask) .. "</> for <magenta>" .. proto_short(id_gem_3eg_mask) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_smace) .. "</> for <magenta>" .. proto_short(id_gem_3eg_smace) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with")
            actor:send("</>the 3rd Eldorian Guard improves I will show you more rewards.'")
        end
    end
end$trig$, 'ab5518222d5b672ffcf62405ece4e457'),
  -- data/triggers/055/055_09_3eg_trophy.lua
  (55, 9, $trig$-- Converted from DG Script #5509: 3eg_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
local id_trophy1 = 5503
local id_trophy2 = 5505
local id_trophy3 = 5507
local id_trophy4 = 5509
local id_trophy5 = 5511
local id_trophy6 = 5513
local id_trophy7 = 5515
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Black")
    actor:send("</>Legion you will periodically find goods on their bodies that we will want in")
    actor:send("</>order to prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. proto_short(id_trophy1))
    actor:send("- " .. proto_short(id_trophy2))
    actor:send("- " .. proto_short(id_trophy3))
    actor:send("- " .. proto_short(id_trophy4))
    actor:send("- " .. proto_short(id_trophy5))
    actor:send("- " .. proto_short(id_trophy6))
    actor:send("- " .. proto_short(id_trophy7))
end$trig$, '2853b04ae198cdcd1f8722d5abc3ddf7'),
  -- data/triggers/055/055_10_3bl_trophy.lua
  (55, 10, $trig$-- Converted from DG Script #5510: 3bl_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local id_trophy1 = 5504
local id_trophy2 = 5506
local id_trophy3 = 5508
local id_trophy4 = 5510
local id_trophy5 = 5512
local id_trophy6 = 5514
local id_trophy7 = 5516
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Eldorian Guard you")
    actor:send("</>will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. proto_short(id_trophy1))
    actor:send("- " .. proto_short(id_trophy2))
    actor:send("- " .. proto_short(id_trophy3))
    actor:send("- " .. proto_short(id_trophy4))
    actor:send("- " .. proto_short(id_trophy5))
    actor:send("- " .. proto_short(id_trophy6))
    actor:send("- " .. proto_short(id_trophy7))
end$trig$, '96d4e24d71c8b6da56254039996de31a'),
  -- data/triggers/185/185_28_phase_mace_sexton_speech_upgrade.lua
  (185, 28, $trig$local function proto_key(vnum)
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
local s = string.lower(speech)

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrades", "upgrading", "mace", "improvement", "improvements", "improving"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local minlevel = (globals.macestep or 0) * 10
    if actor:get_quest_stage("phase_mace") == globals.macestep then
        if actor.level >= minlevel then
            actor:set_quest_var("phase_mace", "greet", 1)
            self.room:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
            wait(1)
            self:say("You'll need to use your mace " .. tostring(globals.maceattack) .. " times.")
            -- (empty room echo)
            self:say("I'll also need the following:")
            self.room:send("- <b:cyan>" .. proto_short(globals.maceitem3) .. "</>, for its spiritual protection.")
            if globals.macestep ~= 2 then
                self.room:send("- <b:cyan>" .. proto_short(globals.maceitem2) .. "</>, as a model for the new mace.")
                self.room:send("- <b:cyan>" .. proto_short(globals.maceitem3) .. "</>, for its power in fighting the undead.")
                self.room:send("- <b:cyan>" .. proto_short(globals.maceitem4) .. "</>, for its guiding light.")
            else
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'And finally, you'll need to make a pilgrimage to four burial")
                self.room:send("</>grounds to see what lies ahead on your journey:'")
                self.room:send("- <magenta>the necropolis near Anduin</>")
                self.room:send("- <magenta>the pyramid in the Gothra desert</>")
                self.room:send("- <magenta>the ancient barrow in the Iron Hills</>")
                self.room:send("- <magenta>the cemetary outside the Cathedral of Betrayal</>")
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>  All you")
                self.room:send("</>have to do is <b:cyan>[dig]</> up a handful of dirt from each place and bring it")
                self.room:send("</>back to me.'")
            end
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at")
            self.room:send("</>any time.'")
        else
            self.room:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I")
            self.room:send("</>can improve your bond with your weapon.'")
        end
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    elseif actor:get_quest_stage("phase_mace") < globals.macestep then
        self:say("Your mace isn't ready for improvement yet.")
    elseif actor:get_quest_stage("phase_mace") > globals.macestep then
        self:say("I've done all I can already.")
        wait(1)
        -- switch on actor:get_quest_stage("phase_mace")
        if actor:get_quest_stage("phase_mace") == 3 then
            self.room:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous")
            self.room:send("</>crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle")
            self.room:send("</>and talk to High Priest Zalish.  He should be able to help you.'")
        elseif actor:get_quest_stage("phase_mace") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in")
            self.room:send("</>with the High Priestess in the City of Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 5 then
            self.room:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their")
            self.room:send("</>own dark natures against them.  Few are as knowledgeable about the dark")
            self.room:send("</>arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("phase_mace") == 6 then
            self.room:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out")
            self.room:send("</>Silania.  Her mastry of spiritual matters will be necessary to improve")
            self.room:send("</>this mace any further.'")
        elseif actor:get_quest_stage("phase_mace") == 7 then
            self.room:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your")
            self.room:send("</>mace, one is a priest of a god most foul.  Find Ruin Wormheart, that")
            self.room:send("</>most heinous of Blackmourne's servators.'")
        elseif actor:get_quest_stage("phase_mace") == 8 then
            self.room:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead")
            self.room:send("</>is the sun itself.  Consult with the sun's Oracle in the ancient pyramid")
            self.room:send("</>near Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 9 then
            self.room:send(tostring(self.name) .. " says, 'With everything prepared, return to the very")
            self.room:send("</>beginning of your journey.  The High Priestess of Mielikki, the very")
            self.room:send("</>center of the Cleric Guild, will know what to do.'")
        end
    end
end$trig$, '6f140e3fd9731b722526681afa935fb6'),
  -- data/triggers/556/556_27_unused.lua
  (556, 27, $trig$-- Converted from DG Script #55627: **UNUSED**
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- Speech phrase: status (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
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
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]status[%s%p]") then
    return true  -- Not the phrase
end


-- TODO(parity): Status report relies on broken DG-Script remnants from auto-conversion.
-- Issues to fix in a future rewrite of the phase_armor quest dispatch:
--   * Quest-var keys are literal strings ("phase_armor:id_destroyed_gloves_armor_acquired")
--     instead of being interpolated with the per-class id_destroyed_* values, so every
--     class shares the same key namespace and the per-class id_* tables below are dead
--     code.
--   * 5-digit legacy vnums (55300+) need to be split into composite (zone, id) pairs
--     and resolved through the object catalog.
--   * The "given" truthiness check (line: "if given then") sums numeric quest vars,
--     so it reports "You have given me:" even when the player has given nothing
--     (0 is truthy in Lua).
--   * "_return_value" is referenced but never defined.
--   * Class identifiers (Warrior/Cleric/etc.) are bare globals instead of strings.
-- The trigger is currently gated by "if not percent_chance(0) then return true end",
-- so it never actually fires in production. Leaving the body intact for later rewrite.


-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local right_class = actor.class == "cleric" or actor.class == "priest"
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55678
        local id_gem_boots = 55689
        local id_gem_bracer = 55700
        local id_gem_helm = 55711
        local id_gem_arm = 55722
        local id_gem_legs = 55733
        local id_gem_chest = 55744
        -- rewards for this class
        local id_reward_helm = 55510
        local id_reward_arms = 55511
        local id_reward_chest = 55512
        local id_reward_legs = 55513
        local id_reward_boots = 55514
        local id_reward_bracer = 55515
        local id_reward_gloves = 55516
        local gloves_armor = actor:get_quest_var("phase_armor:id_destroyed_gloves_armor_acquired")
        local boots_armor = actor:get_quest_var("phase_armor:id_destroyed_boots_armor_acquired")
        local bracer_armor = actor:get_quest_var("phase_armor:id_destroyed_bracer_armor_acquired")
        local helm_armor = actor:get_quest_var("phase_armor:id_destroyed_helm_armor_acquired")
        local arm_armor = actor:get_quest_var("phase_armor:id_destroyed_arm_armor_acquired")
        local legs_armor = actor:get_quest_var("phase_armor:id_destroyed_legs_armor_acquired")
        local chest_armor = actor:get_quest_var("phase_armor:id_destroyed_chest_armor_acquired")
        local gloves_gems = actor:get_quest_var("phase_armor:id_gem_gloves_gems_acquired")
        local boots_gems = actor:get_quest_var("phase_armor:id_gem_boots_gems_acquired")
        local bracer_gems = actor:get_quest_var("phase_armor:id_gem_bracer_gems_acquired")
        local helm_gems = actor:get_quest_var("phase_armor:id_gem_helm_gems_acquired")
        local arm_gems = actor:get_quest_var("phase_armor:id_gem_arm_gems_acquired")
        local legs_gems = actor:get_quest_var("phase_armor:id_gem_legs_gems_acquired")
        local chest_gems = actor:get_quest_var("phase_armor:id_gem_chest_gems_acquired")
        local done_gloves = (gloves_armor or 0) == 1  and  (gloves_gems or 0) == 3
        local done_boots = (boots_armor or 0) == 1  and  (boots_gems or 0) == 3
        local done_bracer = (bracer_armor or 0) == 1  and  (bracer_gems or 0) == 3
        local done_helm = (helm_armor or 0) == 1  and  (helm_gems or 0) == 3
        local done_arm = (arm_armor or 0) == 1  and  (arm_gems or 0) == 3
        local done_legs = (legs_armor or 0) == 1  and  (legs_gems or 0) == 3
        local done_chest = (chest_armor or 0) == 1  and  (chest_gems or 0) == 3
        local given = (gloves_armor or 0) + (boots_armor or 0) + (bracer_armor or 0) + (helm_armor or 0) + (arm_armor or 0) + (legs_armor or 0) + (chest_armor or 0)
        given = given + (gloves_gems or 0) + (boots_gems or 0) + (bracer_gems or 0) + (helm_gems or 0) + (arm_gems or 0) + (legs_gems or 0) + (chest_gems or 0)
        if given then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return _return_value
        end
        if gloves_armor and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_gloves) .. "'")
        end
        if gloves_gems and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. proto_short(id_gem_gloves) .. "'")
        end
        if boots_armor and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_boots) .. "'")
        end
        if boots_gems and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. proto_short(id_gem_boots) .. "'")
        end
        if bracer_armor and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_bracer) .. "'")
        end
        if bracer_gems and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. proto_short(id_gem_bracer) .. "'")
        end
        if helm_armor and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_helm) .. "'")
        end
        if helm_gems and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. proto_short(id_gem_helm) .. "'")
        end
        if arm_armor and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_arm) .. "'")
        end
        if arm_gems and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. proto_short(id_gem_arm) .. "'")
        end
        if legs_armor and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_legs) .. "'")
        end
        if legs_gems and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. proto_short(id_gem_legs) .. "'")
        end
        if chest_armor and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_destroyed_chest) .. "'")
        end
        if chest_gems and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. proto_short(id_gem_chest) .. "'")
        end
        if done_gloves and done_boots and done_bracer and done_helm and done_arm and done_legs and done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. proto_short(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, 'a6601133c191cda12fd1640294e24a0c')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
