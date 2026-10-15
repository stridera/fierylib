-- Trigger: Hell Trident receive
-- Zone: 53, ID: 55
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
-- TODO(parity): branch-scoped `reward`, `phase`, `level`, `spell1`,
-- `spell2`, `go`, `gem_id`, `refuse`, `reason`, `expmod`, `expcap`.
-- `hellstage == "phase"` compares int to literal "phase". `world.destroy
-- (object.name)` should pass the object, not its name string (line 79).
-- Spawn id `(23, reward)` looks legacy. Full rewrite from DG #5355.
--
-- Original DG Script: #5355

-- Converted from DG Script #5355: Hell Trident receive
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
return _return_value