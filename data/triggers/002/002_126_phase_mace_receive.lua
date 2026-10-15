-- Trigger: phase mace receive
-- Zone: 2, ID: 126
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #326
--
-- Generic receive handler for every phase-mace questmaster (macestep 1-9). Reads the per-mob
-- parameters 002_118 exports through `globals` (macestep, maceitem2..6, mace_id = DG macevnum,
-- reward_mace) and the player's phase_mace quest variables:
--   macetask1 = used the mace enough, macetask2..6 = gave maceitem2..6 (step 2 also needs the grave
--   dirt picked up with the spade, dirt3..6), greet = the questmaster has been spoken to.
-- Each material is taken and ticked off; the mace itself is only taken once everything else is
-- done, then it is upgraded to reward_mace and experience is awarded.
--
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`). Globals hold legacy vnums; dg.obj() turns one into
-- the (zone, id) the catalog uses (zone 2 holds vnums 200-399, zone 30 holds 3000-3306, ...).
-- The give command has no "give all", so every item goes over by itself.
--
-- Changes from the DG: the "already gave" check read task<N> although the item is recorded as
-- macetask<N>, and the dirt check tested dirt<N> == 0 although a never-dug dirt<N> is unset; both
-- now test what the other triggers actually write. The DG block that introduced the quest to a
-- first-time player of priest 30/25 sat inside the stage == macestep test, so it could never run
-- (002_117 starts the quest when the mace is first handed over); it is left out.

local dg = require("dg")

local function vkey(vnum) return dg.obj(vnum) end
local function oname(vnum) return dg.oname(vnum) end
local function is_obj(vnum) return dg.is_obj(object, vnum) end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local set_ = dg.flag

local function give_back()
    dg.give(self, object, actor)
end
local function says(msg)
    actor:send(self.name .. " says, '" .. msg .. "'")
end

-- What a questmaster tells a player who has already passed this step, by that player's stage.
local PASSED = {
    [2] = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.",
    [3] = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.",
    [4] = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.",
    [5] = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.",
    [6] = "Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.",
    [7] = "I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servitors.",
    [8] = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.",
    [9] = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.",
}

local macestep = globals.macestep
if not macestep then return true end
local maceitems = { globals.maceitem2, globals.maceitem3, globals.maceitem4, globals.maceitem5, globals.maceitem6 }
local macevnum = globals.mace_id
local reward_mace = globals.reward_mace
local quest = "phase_mace"
local priest = (self.zone_id == 185 and self.id == 2)

local number
for n = 2, 6 do
    if is_obj(maceitems[n - 1]) then
        number = n
        break
    end
end
if not (number or is_obj(macevnum)) then
    return true
end

if priest then
    self:set_flag("sentinel", true)
end

local function jobs()
    local j = {}
    for n = 1, 6 do
        j[n] = set_(actor:get_quest_var(quest .. ":macetask" .. n))
    end
    return j
end

local response, check, reward
local stage = actor:get_quest_stage(quest)
if actor.class == "cleric" or actor.class == "priest" then
    if actor.level >= macestep * 10 then
        if stage == macestep then
            if (actor:get_quest_var(quest .. ":greet") or 0) == 1 then
                if number then
                    if set_(actor:get_quest_var(quest .. ":macetask" .. number)) then
                        response = "You already gave me " .. object.shortdesc .. "."
                    elseif macestep == 2 and number > 2 and not set_(actor:get_quest_var(quest .. ":dirt" .. number)) then
                        wait(0.2)
                        self:command("shake")
                        world.destroy(object)
                        actor:send(self.name .. " scatters the dirt in the wind.")
                        wait(0.2)
                        says("You need to make the pilgrimage to these places yourself.")
                        wait(1)
                        says("Return with fresh earth when you have.")
                    else
                        actor:set_quest_var(quest, "macetask" .. number, 1)
                        wait(0.2)
                        world.destroy(object)
                        says("Ah yes, this will do.")
                        local j = jobs()
                        if macestep == 2 then
                            if j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                                check = "continue"
                            elseif not j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                                check = "count"
                            else
                                check = "stop"
                            end
                        else
                            if j[1] and j[2] and j[3] and j[4] and j[5] then
                                check = "continue"
                            elseif not j[1] and j[2] and j[3] and j[4] and j[5] then
                                check = "count"
                            else
                                check = "stop"
                            end
                        end
                    end
                else
                    -- the mace itself
                    local j = jobs()
                    if macestep == 2 then
                        if j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                            reward = "yes"
                        elseif not j[1] and j[3] and j[4] and j[5] and j[6] then
                            reward = "count"
                        else
                            reward = "stop"
                        end
                    else
                        if j[1] and j[2] and j[3] and j[4] and j[5] then
                            reward = "yes"
                        elseif not j[1] and j[2] and j[3] and j[4] and j[5] then
                            reward = "count"
                        else
                            reward = "stop"
                        end
                    end
                end
            else
                response = "Tell me why you're here first."
            end
        elseif stage > macestep then
            response = PASSED[stage]
        else
            response = "Your mace isn't advanced enough for me to work on yet."
        end
    else
        response = "Come back after you've grown some more."
    end
else
    response = "This is only needed for the priestly classes."
end

if check == "continue" then
    wait(1)
    self:command("nod")
    local z, i = vkey(macevnum)
    says("Give me the " .. get_obj_noadesc(z, i) .. ".")
elseif check == "count" then
    wait(0.2)
    says("Now just keep practicing with " .. oname(macevnum) .. ".")
elseif check == "stop" then
    wait(0.2)
    says("Do you have the other materials?")
elseif reward == "yes" then
    actor:advance_quest(quest)
    actor:set_quest_var(quest, "attack_counter", 0)
    actor:set_quest_var(quest, "greet", 0)
    for loop = 1, 6 do
        actor:set_quest_var(quest, "macetask" .. loop, 0)
    end
    wait(1)
    world.destroy(object)
    self:command("nod")
    says("Yes, this is everything.")
    wait(1)
    actor:send(self.name .. " inlays " .. oname(maceitems[1]) .. " into " .. oname(macevnum) .. ".")
    wait(2)
    if priest then
        actor:send(self.name .. " recites several long prayers as he sprinkles the handfuls of dirt over " .. oname(macevnum) .. ".")
    else
        actor:send(self.name .. " etches the markings from " .. oname(maceitems[2]) .. " to " .. oname(macevnum) .. ".")
        wait(3)
        actor:send("By the light of " .. oname(maceitems[4]) .. ", " .. self.name .. " sets recites several long prayers.")
    end
    wait(2)
    actor:send(oname(macevnum) .. " is transformed!")
    wait(1)
    says("Here you are, " .. oname(reward_mace) .. "!")
    dg.give(self, self:spawn_object(vkey(reward_mace)), actor)
    local expcap = macestep * 10
    local expmod
    if expcap < 25 then
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
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
elseif reward == "count" then
    response = "Keep practicing with " .. oname(macevnum) .. "."
elseif reward == "stop" then
    response = "Bring me the other materials first."
end

if response then
    give_back()
    actor:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    says(response)
end

if priest then
    self:set_flag("sentinel", false)
end
return true
