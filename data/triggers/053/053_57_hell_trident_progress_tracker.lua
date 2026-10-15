-- Trigger: Hell Trident progress tracker
-- Zone: 53, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): converter mangled the stage dispatch — `local step`,
-- `local gem`, `local pl_word`, `local word`, `local spell1/2`,
-- `local quest1/2`, `local task6/task6do` are declared at top level
-- TWICE (once with phase-1 values, once with phase-2 values, lines 43-67),
-- so phase-2 always wins regardless of hellstage. Inner `hellstage ==
-- "step"` is a string compare. `local response` is branch-scoped via
-- elseif. The dead 0% gate is gone.
-- Full rewrite from DG #5357.
--
-- Original DG Script: #5357

-- Converted from DG Script #5357: Hell Trident progress tracker
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
end