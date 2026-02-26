-- Trigger: Hell Trident speech trident upgrades
-- Zone: 23, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 23 if statements
--   Large script: 7185 chars
--
-- Original DG Script: #2314

-- Converted from DG Script #2314: Hell Trident speech trident upgrades
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: trident upgrades
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trident") or string.find(string.lower(speech), "upgrades")) then
    return true  -- No matching keywords
end
wait(2)
local hellstep = actor:get_quest_stage("hell_trident")
if hellstep == 1 then
    local level = 65
elseif hellstep == 2 then
    local level = 90
end
if hellstep then
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
    local spell1 = actor:get_has_completed("hellfire_brimstone")
    local spell2 = actor:get_has_completed("banish")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    local step = 2
    local spell1 = actor:get_has_completed("resurrection_quest")
    local spell2 = actor:get_has_completed("hell_gate")
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
    if actor:get_quest_stage("hell_trident") == "step" then
        if actor.level >= level then
            if not actor:get_quest_var("hell_trident:greet") then
                actor:set_quest_var("hell_trident", "greet", 1)
                if self.id == 6032 then
                    actor:send("In the hissed whisper of ecstatic fervor " .. tostring(self.name) .. " says, 'Six thrice is the number of the greater demons.  Undertaking thus six and six, and six again, their interest can be piqued.'")
                    actor:send("</>")
                    actor:send("- Attempting to land <b:yellow>six and six and six</> in thrusts of your trident shall provide the pattern of the number.")
                    actor:send("</>")
                    actor:send("- <b:yellow>Six rubies, all uncut in nature, does double the signature.")
                    actor:send("</>")
                    actor:send("- Slay <b:yellow>six beings called angels</>, be they of any make or countenance, the number being counted thrice.")
                    actor:send("</>")
                    actor:send("- Sup on the grand powers of Hell to learn the most esoteric diablery.  Complete the quests for <b:yellow>Banish</> and <b:yellow>Hellfire and Brimstone</>.")
                    actor:send("</>")
                    actor:send("- Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'In undertaking six in all will Hell be at your beck and call.'")
                elseif self.id == 12526 then
                    actor:send(tostring(self.name) .. " says, 'Perhaps I will grant you a boon if you carry out sacrifices in my name.'")
                    actor:send("</>")
                    actor:send("- <b:yellow>Attack with " .. tostring(objects.template(23, 39).name) .. " 666 times</> as a sacrifice of power.")
                    actor:send("</>")
                    actor:send("- Bring me <b:yellow>six radiant rubies</> as a sacrifice of wealth.")
                    actor:send("</>")
                    actor:send("- Slay a combination of <b:yellow>six ghaeles, solars, or lesser seraphs</>.  Their suffering shall please me as a sacrifice of divinity.")
                    actor:send("</>")
                    actor:send("- Learn the most unholy of prayers.  Complete the quests for <b:yellow>Resurrection</> and <b:yellow>Hell Gate</> as a sacrifice of knowledge.")
                    actor:send("</>")
                    actor:send("- Finally, find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor.")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Do this and I will lend you a greater share of my power.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[weapon progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'Remember your six sacrifices.  Ask about your <b:cyan>[weapon progress]</> if you must.'")
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