-- Trigger: Hell Trident receive
-- Zone: 53, ID: 55
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 9690 chars
--
-- Original DG Script: #5355

-- Converted from DG Script #5355: Hell Trident receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local hellstage = actor:get_quest_stage("hell_trident")
-- switch on self.id
-- Black Priestess p2
if self.id == 6032 then
    local reward = 2339
    local phase = 1
    local level = 65
    local spell1 = actor:get_has_completed("banish")
    local spell2 = actor:get_has_completed("hellfire_brimstone")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    if object.id == 55662 then
        local go = "gem"
    elseif object.id == 2334 then
        local go = "trident"
    end
elseif self.id == 12526 then
    local reward = 2340
    local phase = 2
    local level = 90
    local spell1 = actor:get_has_completed("resurrection_quest")
    local spell2 = actor:get_has_completed("hell_gate")
    if object.id == 55739 then
        local go = "gem"
    elseif object.id == 2339 then
        local go = "trident"
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
if actor:get_has_completed("hell_trident") then
    go = nil
    local refuse = 1
    local reason = "You already command the greatest power imaginable!"
elseif actor.level < level then
    go = nil
    local refuse = 1
    local reason = "You are not yet strong enough to handle more power."
elseif hellstage < phase then
    go = nil
    local refuse = 1
    local reason = "Your trident is not ready to upgrade yet."
elseif hellstage > phase then
    go = nil
    local refuse = 1
    local reason = "I've already done everything I can to help."
end
if go == "gem" then
    local gem_vnum = object.id
    local gem_count = actor:get_quest_var("hell_trident:gems")
    if gem_count < 6 then
        wait(2)
        world.destroy(object.name)
        local gem_count = gem_count + 1
        actor.name:set_quest_var("hell_trident", "gems", gem_count)
        actor:send(tostring(self.name) .. " says, 'Yes, this is perfect.'")
        wait(2)
        if gem_count == 1 then
            actor:send(tostring(self.name) .. " says, 'You have given me 1 of 6 " .. "%get.obj_pldesc[%gem_vnum%]%.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have given me " .. tostring(gem_count) .. " of 6 " .. "%get.obj_pldesc[%gem_vnum%]%.'")
        end
        wait(2)
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
                actor:send(tostring(self.name) .. " says, 'Complete your other sacrifices and then return to me.'")
            end
        end
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You have already given me 6 " .. "%get.obj_pldesc[%gem_vnum%]%.'")
    end
elseif go == "trident" then
    local job1 = actor:get_quest_var("hell_trident:helltask1")
    local job2 = actor:get_quest_var("hell_trident:helltask2")
    local job3 = actor:get_quest_var("hell_trident:helltask3")
    local job4 = actor:get_quest_var("hell_trident:helltask4")
    local job5 = actor:get_quest_var("hell_trident:helltask5")
    local job6 = actor:get_quest_var("hell_trident:helltask6")
    if job1 and job2 and job3 and job4 and job5 and job6 then
        wait(2)
        world.destroy(object)
        if self.id == 12526 then
            actor:send(tostring(self.name) .. " says, 'We are pleased.'")
            self:command("grin")
            wait(1)
            self.room:send(tostring(self.name) .. " turns and faces out into the endless void of his vast realm.")
            wait(1)
            self.room:send(tostring(self.name) .. " growls, 'Ir ya roza aem ya iz ednuyt...'")
            wait(2)
            self.room:send("The inner <b:blue>ire</> of the " .. get_obj_noadesc("2339") .. " ignites and <red>b<blue>urn</><red>s</>!")
            wait(2)
            self.room:send(tostring(self.name) .. " roars, 'Liy ya gaoh yaezk'aqa, ir ya aehg mol'tiaer I kiwa yiz laodaer zes mina...'")
            wait(2)
            self.room:send(tostring(self.name) .. " erupts in glorious <red>f<blue>l<yellow>a<red>m</><red>e</>!")
            wait(2)
            self.room:send("The <red>f<b:yellow>i<red>r</><red>es<blue>t<yellow>o<red>r</><red>m</> forms a vortex about the " .. get_obj_noadesc("2339") .. ", like an explosion in reverse.")
            wait(1)
            self.room:send("The trident <b:magenta>t</><magenta>w&9<blue>i</><magenta>s<blue>ts</> and contorts in the wild <red>f<b:yellow>i<red>r</><red>e</>!")
            wait(3)
            self.room:send("The fire subsides, leaving a &9<blue>midnight-black</> weapon pulsing with dark radiance.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Our bond is forged.'")
        else
            actor:send(tostring(self.name) .. " says, 'The infernal ones are pleased.'")
            wait(1)
            self.room:send(tostring(self.name) .. "'s neck goes limp as her eyes roll back into her head.")
            wait(2)
            self.room:send(tostring(self.name) .. " begins to murmur... 'Hin tel'quiet nehel -nal rillis fis...'")
            wait(3)
            self.room:send("Brilliant <blue>b&9<blue>lac</><blue>k fire seeps out of " .. get_obj_noadesc("2334") .. " and spreads across its surface.")
            wait(2)
            self.room:send(tostring(self.name) .. " babbles in an alien voice, 'Aul adoe shunti mor ik mor...'")
            wait(2)
            self.room:send("<red>Scarlet</> <blue>fl<blue>ames</> ignite in " .. tostring(self.name) .. "'s hands, pulsing in rhythm with her speech.")
            wait(2)
            self.room:send(tostring(self.name) .. " utters, 'Slidc ya qnoes oynaezz ya khozz qaed...' as she holds her hand over the " .. get_obj_noadesc("2334") .. ".")
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
        self.room:spawn_object(vnum_to_zone(reward), vnum_to_local(reward))
        self:command("give trident " .. tostring(actor))
        local expcap = level
        if expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            actor:award_exp(setexp)
            local loop = loop + 1
        end
        local number = 1
        while number < 7 do
            actor:set_quest_var("hell_trident", "helltask%number%", 0)
            local number = number + 1
        end
        actor:set_quest_var("hell_trident", "gems", 0)
        actor:set_quest_var("hell_trident", "greet", 0)
        if actor:get_quest_stage("hell_trident") == 1 then
            actor:advance_quest("hell_trident")
        else
            actor:complete_quest("hell_trident")
        end
    else
        local refuse = 1
        local reason = "You have to complete all your other offerings before you give me your trident."
    end
end
if refuse then
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(reason) .. "'")
end
return _return_value