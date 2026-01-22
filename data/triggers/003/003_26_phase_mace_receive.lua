-- Trigger: phase mace receive
-- Zone: 3, ID: 26
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 23 if statements
--   Large script: 12831 chars
--
-- Original DG Script: #326

-- Converted from DG Script #326: phase mace receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if self.id == 18502 then
    self:set_flag("sentinel", true)
end
if object.id == "maceitem2" or object.id == "maceitem3" or object.id == "maceitem4" or object.id == "maceitem5" or object.id == "maceitem6" or object.id == "macevnum" then
    if actor.class == "cleric" or actor.class == "priest" then
        if actor.level >= (macestep * 10) then
            if actor:get_quest_stage("phase_mace") == "macestep" then
                if actor:get_quest_var("phase_mace:greet") == 1 then
                    if object.id == "maceitem2" or object.id == "maceitem3" or object.id == "maceitem4" or object.id == "maceitem5" or object.id == "maceitem6" then
                        -- switch on object.id
                        if object.id == "%maceitem2%" then
                            local number = 2
                        elseif object.id == "%maceitem3%" then
                            local number = 3
                        elseif object.id == "%maceitem4%" then
                            local number = 4
                        elseif object.id == "%maceitem5%" then
                            local number = 5
                        elseif object.id == "%maceitem6%" then
                            local number = 6
                        end
                        if actor.quest_variable[phase_mace:tasknumber] == 1 then
                            local response = You already gave me object.shortdesc.
                        elseif macestep == 2 and number > 2 and actor.quest_variable[phase_mace:dirtnumber] == 0 then
                            wait(2)
                            self:command("shake")
                            world.destroy(object)
                            actor:send(self.name .. " scatters the dirt in the wind.")
                            wait(2)
                            actor:send(tostring(self.name) .. " says, 'You need to make the pilgrimage to these places yourself.'")
                            wait(1)
                            actor:send(tostring(self.name) .. " says, 'Return with fresh earth when you have.'")
                        else
                            actor:set_quest_var("phase_mace", "macetask%number%", 1)
                            wait(2)
                            world.destroy(object)
                            actor:send(tostring(self.name) .. " says, 'Ah yes, this will do.'")
                            local job1 = actor:get_quest_var("phase_mace:macetask1")
                            local job2 = actor:get_quest_var("phase_mace:macetask2")
                            local job3 = actor:get_quest_var("phase_mace:macetask3")
                            local job4 = actor:get_quest_var("phase_mace:macetask4")
                            local job5 = actor:get_quest_var("phase_mace:macetask5")
                            local job6 = actor:get_quest_var("phase_mace:macetask6")
                            if macestep == 2 then
                                if job1 and job2 and job3 and job4 and job5 and job6 then
                                    local check = "continue"
                                elseif not job1 and job2 and job3 and job4 and job5 and job6 then
                                    local check = "count"
                                else
                                    local check = "stop"
                                end
                            else
                                if job1 and job2 and job3 and job4 and job5 then
                                    local check = "continue"
                                elseif not job1 and job2 and job3 and job4 and job5 then
                                    local check = "count"
                                else
                                    local check = "stop"
                                end
                            end
                        end
                    elseif object.id == "macevnum" then
                        if self.id == 3025 and not actor:get_quest_stage("phase_mace") then
                            actor:start_quest("phase_mace")
                            wait(2)
                            actor:send(tostring(self.name) .. " says, 'What an unusual mace...'")
                            self:command("give " .. tostring(object) .. " " .. tostring(actor))
                            wait(1)
                            self:command("ponder")
                            wait(1)
                            actor:send(tostring(self.name) .. " says, 'I could bless it against the undead, if I had the proper materials.  Bring me the following:")
                            actor:send("- <b:yellow>" .. tostring(objects.template(552, 11).name) .. "</> to use as a model")
                            actor:send("- <b:yellow>" .. tostring(objects.template(555, 77).name) .. "</> and")
                            actor:send("- <b:yellow>" .. tostring(objects.template(136, 14).name) .. "</> for their protection against malevolent spirits")
                            actor:send("- <b:yellow>" .. tostring(objects.template(588, 9).name) .. "</> as a flame to ward against the dark")
                            actor:send("</>")
                            actor:send("Also attack with " .. tostring(objects.template(3, 40).name) .. " <b:yellow>50</> times to fully bond with it.'")
                            actor:send("</>")
                            actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[mace progress]</> at any time.'")
                            return _return_value
                        end
                        local job1 = actor:get_quest_var("phase_mace:macetask1")
                        local job2 = actor:get_quest_var("phase_mace:macetask2")
                        local job3 = actor:get_quest_var("phase_mace:macetask3")
                        local job4 = actor:get_quest_var("phase_mace:macetask4")
                        local job5 = actor:get_quest_var("phase_mace:macetask5")
                        local job6 = actor:get_quest_var("phase_mace:macetask6")
                        if macestep == 2 then
                            if job1 and job2 and job3 and job4 and job5 and job6 then
                                local reward = "yes"
                            elseif not job1 and job3 and job4 and job5 and job6 then
                                local reward = "count"
                            else
                                local reward = "stop"
                            end
                        else
                            if job1 and job2 and job3 and job4 and job5 then
                                local reward = "yes"
                            elseif not job1 and job2 and job3 and job4 and job5 then
                                local reward = "count"
                            else
                                local reward = "stop"
                            end
                        end
                    end
                else
                    local response = "Tell me why you're here first."
                end
            elseif actor:get_quest_stage("phase_mace") > macestep then
                -- switch on actor:get_quest_stage("phase_mace")
                if actor:get_quest_stage("phase_mace") == 2 then
                    local response = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki."
                elseif actor:get_quest_stage("phase_mace") == 3 then
                    local response = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you."
                elseif actor:get_quest_stage("phase_mace") == 4 then
                    local response = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin."
                elseif actor:get_quest_stage("phase_mace") == 5 then
                    local response = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal."
                elseif actor:get_quest_stage("phase_mace") == 6 then
                    local response = "Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further."
                elseif actor:get_quest_stage("phase_mace") == 7 then
                    local response = "I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servitors."
                elseif actor:get_quest_stage("phase_mace") == 8 then
                    local response = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin."
                elseif actor:get_quest_stage("phase_mace") == 9 then
                    local response = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do."
                end
            else
                local response = "Your mace isn't advanced enough for me to work on yet."
            end
        else
            local response = "Come back after you've grown some more."
        end
    else
        local response = "This is only needed for the priestly classes."
    end
end
if check == "continue" then
    wait(1)
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'Give me the " .. "%get.obj_noadesc[%macevnum%]%.'")
elseif check == "count" then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Now just keep practicing with " .. "%get.obj_shortdesc[%macevnum%]%.'")
elseif check == "stop" then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Do you have the other materials?'")
elseif reward == "yes" then
    actor:advance_quest("phase_mace")
    actor:set_quest_var("phase_mace", "attack_counter", 0)
    actor:set_quest_var("phase_mace", "greet", 0)
    local loop = 1
    while loop < 7 do
        actor:set_quest_var("phase_mace", "macetask%loop%", 0)
        local loop = loop + 1
    end
    wait(1)
    world.destroy(object)
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'Yes, this is everything.'")
    wait(1)
    actor:send(tostring(self.name) .. " inlays " .. "%get.obj_shortdesc[%maceitem2%]% into %get.obj_shortdesc[%macevnum%]%.")
    wait(2)
    if self.id == 18502 then
        actor:send(self.name .. " recites several long prayers as he sprinkles the handfuls of dirt over " .. "%get.obj_shortdesc[%macevnum%]%.")
    else
        actor:send(tostring(self.name) .. " etches the markings from " .. "%get.obj_shortdesc[%maceitem3%]% to %get.obj_shortdesc[%macevnum%]%.")
        wait(3)
        actor:send("By the light of " .. "%get.obj_shortdesc[%maceitem5%]%, %self.name% sets recites several long prayers.")
    end
    wait(2)
    actor:send("%get.obj_shortdesc[%macevnum%]% is transformed!")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Here you are, " .. "%get.obj_shortdesc[%reward_mace%]%!'")
    self.room:spawn_object(vnum_to_zone(reward_mace), vnum_to_local(reward_mace))
    self:command("give mace " .. tostring(actor))
    local expcap = (macestep * 10)
    if expcap < 25 then
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
elseif reward == "count" then
    local response = Keep practicing with get.obj_shortdesc[macevnum].
elseif reward == "stop" then
    local response = "Bring me the other materials first."
end
if response then
    _return_value = false
    actor:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
if self.id == 18502 then
    self:set_flag("sentinel", false)
end
return _return_value