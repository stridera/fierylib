-- Trigger: Monk Chants Hakujo Speech chants
-- Zone: 53, ID: 54
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 9210 chars
--
-- Original DG Script: #5354

-- Converted from DG Script #5354: Monk Chants Hakujo Speech chants
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: chant chants
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "chant") or string.find(string.lower(speech), "chants")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("monk_vision") >= 3 then
    if not actor:get_quest_stage("monk_chants") then
        actor:send(tostring(self.name) .. " says, 'As you walk your path to enlightenment, your mind's capacity for esoteric knowledge will vastly increase.  This knowledge forms the basis for many powerful chants and hymns.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Each new vision marking represents your readiness for a new chant.  Much like the vision quests you undertake, you will need to find a source of knowledge and meditate on it in a place of great resonance.'")
        actor:start_quest("monk_chants")
        wait(2)
    end
    if actor:get_quest_stage("monk_chants") == 1 then
        if actor.level >= 30 then
            actor:send(tostring(self.name) .. " says, 'The first esoteric chant you can learn is the <b:yellow>Tremors of Saint Augustine</>.  This prayer will channel the forces of the earth through your hands, allowing you to disintegrate your foes with your touch.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'The secrets of this chant are contained in <b:yellow>a book surrounded by trees and shadows</>.  To understand the deeper truth, you must find this book and <b:cyan>[meditate]</> in <b:yellow>a place that is both natural and urban, serenely peaceful and profoundly sorrowful</>.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'I cannot be more specific than this.  You must prove your capabilities and solve the puzzle on your own.  Do so and you will gain the knowledge of the Tremors of Saint Augustine.'")
            wait(2)
            self:command("bow " .. tostring(actor))
        else
            local decline = "level"
        end
    elseif actor:get_quest_stage("monk_chants") == 2 then
        if actor:get_quest_stage("monk_vision") > 4 then
            if actor.level >= 40 then
                actor:send(tostring(self.name) .. " says, 'Waiting for you next is the <b:yellow>Tempest of Saint Augustine</>.  This prayer will channel the electrical might of the storm through your fists.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There is <b:yellow>a scroll dedicated to this particular chant, guarded by a creature of the same elemental affinity</>.  <b:cyan>[Meditate]</> on it at <b:yellow>the peak of Urchet Pass</> and you will gain the knowledge of the chant.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                local decline = "level"
            end
        else
            local decline = "vision"
        end
    elseif actor:get_quest_stage("monk_chants") == 3 then
        if actor:get_quest_stage("monk_vision") > 5 then
            if actor.level >= 50 then
                actor:send(tostring(self.name) .. " says, 'You are ready for a third prayer to Saint Augustine.  This prayer will call the howling force of the blizzard, freezing anything you touch.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Knowledge of ice and snow is kept in <b:yellow>a book held by a master who in turn is a servant of a beast of winter</>.  The secrets of the book can be revealed through <b:cyan>[meditating]</> in <b:yellow>a temple shrouded in mists</>.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Complete this meditation and the <b:yellow>Blizzards of Saint Augustine</> will be revealed to you.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                local decline = "level"
            end
        else
            local decline = "vision"
        end
    elseif actor:get_quest_stage("monk_chants") == 4 then
        if actor:get_quest_stage("monk_vision") > 6 then
            if actor.level >= 60 then
                actor:send(tostring(self.name) .. " says, 'Words are powerful weapons.  Properly intoned, words can be as devastating as any sword.  The <b:yellow>Aria of Dissonance</> is a mystical weapon of war that monks can unleash to descimate their opponent's defenses.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'As a tool of war, the secrets are deeply encoded in <b:yellow>a book on war, held by a banished war god</>.  They can be understood only by <b:cyan>[meditating]</> on them in <b:yellow>a dark cave before a blasphemous book, near an unholy fire</>.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                local decline = "level"
            end
        else
            local decline = "vision"
        end
    elseif actor:get_quest_stage("monk_chants") == 5 then
        if actor:get_quest_stage("monk_vision") > 7 then
            if actor.level >= 75 then
                actor:send(tostring(self.name) .. " says, 'To augment the growth of the mind, it is important to understand the self is but a multifaceted illusion.  Understanding that will allow you to manipulate that illusion to provoke others to attacking you.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There is <b:yellow>a scroll where this revelation is inscribed over and over held by a brother who thirsts for escape</>.  Give him what he most desires to earn the scroll.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'With the scroll in hand, <b:cyan>[meditate]</> on it in <b:yellow>a chapel of the walking dead</> to hear the music that lays beyond the end of all things, the <b:yellow>Apocalyptic Anthem</>.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                local decline = "level"
            end
        else
            local decline = "vision"
        end
    elseif actor:get_quest_stage("monk_chants") == 6 then
        if actor:get_quest_stage("monk_vision") > 8 then
            if actor.level >= 80 then
                actor:send(tostring(self.name) .. " says, 'You are ready for the final prayer to Saint Augustine.  This prayer will allow you to hold fire in your hands, making you a living inferno.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Fire is both a blessing and a curse.  It provides heat vital to life and can incinerate life just as easily.  This duality is reflected in <b:yellow>scrolls of curses, carried by children of air in a floating fortress</>.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Take one of these scrolls to <b:yellow>an altar dedicated to fire's destructive forces</> and <b:cyan>[meditate]</> to unleash the power of the <b:yellow>Fires of Saint Augustine</>.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                local decline = "level"
            end
        else
            local decline = "vision"
        end
    elseif actor:get_quest_stage("monk_chants") == 7 then
        if actor:get_quest_stage("monk_vision") > 9 then
            if actor.level >= 99 then
                actor:send(tostring(self.name) .. " says, 'The final esoteric chant is the ability to plant the seed of doubt in an opponent's very core, shattering the false reality that is corporeal form.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The chant is the ultimate weaponization of revenge.  An eye for an eye, as the saying goes, is the ultimately symbol of revenge.  Cut out the <b:yellow>eye of one caught in an eternal feud</>.  Bring it to <b:yellow>an altar deep in the outer realms surrounded by those who's vengeance was never satisfied</>.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, '<b:cyan>[meditate]</> on the illusory satisfaction of what revenge makes one think is certain to understand the doubt that is the <b:yellow>Seed of Destruction</>.'")
                wait(2)
                self:command("bow " .. tostring(actor))
            else
                actor:send(tostring(self.name) .. " says, 'Unfortunately you must reach the pinnacle of mortal experience before you are ready to grasp this final chant.'")
                return _return_value
            end
        else
            local decline = "vision"
        end
    end
    if decline == "level" then
        actor:send(tostring(self.name) .. " says, 'You must gain more practical experience before you can take on more esoteric experience.'")
    elseif decline == "vision" then
        actor:send(tostring(self.name) .. " says, 'You must first take another step towards <b:cyan>[enlightenment]</> before you can grasp more esoteric knowledge.'")
    end
end