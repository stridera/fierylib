-- Trigger: belial_pre_combat_banter
-- Zone: 22, ID: 41
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2241

-- Converted from DG Script #2241: belial_pre_combat_banter
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Belial's Pre Combat Banter
local belial_queue = 2
local victim = self.people
while victim do
    if victim.id ~= 2219 then
        if victim.class == "Paladin" then
            if victim.gender == "Female" then
                wait(1)
                victim:send("Belial slowly approaches, lifting your chin to meet his piercing gaze.")
                self.room:send_except(victim, "Belial slowly approaches " .. tostring(victim.name) .. ", lifting her chin to his gaze.")
                wait(5)
                self.room:send("Belial says in common, 'A rare and beautiful thing...'")
                wait(3)
                self.room:send("Belial says in common, 'Such a pity you should end here.'")
                victim:send("Belial gently presses a finger to your lips.")
                self.room:send_except(victim, "Belial gently presses a finger to the lips of " .. tostring(victim.name) .. "'.")
                wait(5)
                self.room:send("Belial says in common, 'I could offer you such pleasures beyond imagination.'")
                wait(3)
                victim:send("Belial stares deeply into your eyes.")
                self.room:send_except(victim, "Belial stares deeply into the eyes of " .. tostring(victim.name))
                self.room:send("Belial says in common, 'But that would not be enough, no.?'")
                wait(5)
                self.room:send("Belial says in common, 'No... your soul is too puerile to understand such!'")
                wait(3)
                victim:send("Belial casts your head away from his sudden, baleful sneer.")
                self.room:send_except(victim, "Belial balefully sneers at " .. tostring(victim.name) .. ", casting her head aside.")
                self.room:send("Belial says in common, 'Instead you shall all die by my hand!'")
                wait(1)
                self.room:find_actor("belial"):command("kill %victim.name%")
                return _return_value
            elseif victim.gender == "Male" then
                wait(1)
                victim:send("Belial slowly paces about you, sizing up your mettle.")
                self.room:send_except(victim, "slowly paces about " .. tostring(victim.name) .. ", sizing him up.")
                wait(5)
                self.room:send("Belial says in common, 'Such pious arrogance...'")
                wait(3)
                self.room:send("Belial says in common, 'Fitting that you should end here.'")
                self.room:send("Belial pauses for a moment, pressing his finger to his lips.")
                wait(5)
                self.room:send("Belial breaths in heavily, raising his hands skyward.")
                self.room:send("Belial says in common, 'Do you hear them... do you hear their screams?'")
                wait(5)
                self.room:send("Belial says in common, 'They sing to me...'")
                wait(3)
                victim:send("Belial snaps around, sneering at you with loathing and contempt.")
                self.room:send_except(victim, "Belial snaps around, sneering at " .. tostring(victim.name) .. " with loathing and contempt.")
                wait(5)
                self.room:send("Belial says in common, 'And now I shall add your screams to the concerto!'")
                wait(1)
                self.room:find_actor("belial"):command("kill %victim.name%")
                return _return_value
            end
        else
            wait(2)
            self.room:send("Belial says in common, 'How charming, someone come to throw themselves on my blade!'")
            wait(3)
            self.room:send("Belial says in common, 'Agents of a lesser perhaps... hmmm?'")
            self.room:send("Belial says in common, 'Come to usurp my throne, yes?'")
            wait(5)
            self.room:send("Belial paces about observingly, one hand clenched around a blood-red ranseur.")
            wait(3)
            self.room:send("Belial says in common, 'What's the matter, hellcat got your tongue?'")
            wait(3)
            self.room:send("Belial says in common, 'Don't be fooled, I see you trembling with fear...'")
            self.room:send("Belial says in common, 'I can smell it on you like a rotting, fetid wound!'")
            wait(5)
            self.room:send("Belial's eyes flair black as coal as he spins the blood-red ranseur about.")
            wait(3)
            self.room:send("Belial says in common, 'No matter, for your life ends here!'")
            self.room:send("Belial growls, 'Have at thee!'")
            wait(1)
            self.room:find_actor("belial"):command("kill %victim.name%")
            return _return_value
        end
    end
    local victim = victim.next_in_room
end