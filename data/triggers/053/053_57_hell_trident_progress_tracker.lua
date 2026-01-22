-- Trigger: Hell Trident progress tracker
-- Zone: 53, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 38 if statements
--   Large script: 9259 chars
--
-- Original DG Script: #5357

-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: weapon progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "weapon") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
if string.find(actor.class, "Diabolist") then
    if actor:get_quest_stage("hell_trident") then
        local hellstage = actor:get_quest_stage("hell_trident")
        if hellstage == 1 then
            local level = 65
        elseif hellstage == 2 then
            local level = 90
        end
        -- switch on self.id
        -- switch on hellstage
        if hellstage == 1 then
            local response = "stage2"
        elseif hellstage == 2 then
            local response = "stage3"
        else
            if actor:get_has_completed("hell_trident") then
                local response = "complete"
            end
        end
        local step = 1
        local gem = 55662
        local pl_word = "angels"
        local word = "angel"
        local spell1 = "Hellfire and Brimstone"
        local quest1 = actor:get_has_completed("hellfire_brimstone")
        local spell2 = "Banish"
        local quest2 = actor:get_has_completed("banish")
        if not actor:get_quest_var("hell_trident:helltask6") and actor.level >= level and hellstage == 1 then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        local task6 = "assisted Vilekka Kar'Shezden"
        local task6do = "&3&bAssist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.&0"
        local step = 2
        local gem = 55739
        local pl_word = "ghaeles, solars, or seraphs"
        local word = "ghaele, solar, or seraph"
        local spell1 = "Resurrect"
        local quest1 = actor:get_has_completed("resurrection_quest")
        local spell2 = "Hell Gate"
        local quest2 = actor:get_has_completed("hell_gate")
        local task6 = "Defeated the Undead Prince"
        local task6do = "find one long-buried and branded an infidel.  &3&bFinish his undying duel for him&0 as a sacrifice of honor."
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
                if not actor:get_quest_var("hell_trident:greet") then
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
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
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
                            local remaining = 666 - actor:get_quest_var("hell_trident:attack_counter")
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - actor:get_quest_var("hell_trident:celestials")
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - actor:get_quest_var("hell_trident:gems")
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
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
                local response = "level"
            end
        else
            if actor:get_has_completed("hell_trident") then
                local response = "complete"
            elseif actor:get_quest_stage("hell_trident") < step then
                local response = "stage1"
            else
                local response = "stage3"
            end
        end
    end
    if response == "stage1" then
        actor:send(tostring(self.name) .. " says, 'You must make the initial offerings with another dark priest.'")
    elseif response == "stage2" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times and then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.'")
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