-- Trigger: Infernal Weaponry progress journal
-- Zone: 4, ID: 86
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #486

-- Converted from DG Script #486: Infernal Weaponry progress journal
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
return _return_value