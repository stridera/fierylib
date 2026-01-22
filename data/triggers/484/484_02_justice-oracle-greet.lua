-- Trigger: justice-oracle-greet
-- Zone: 484, ID: 2
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48402

-- Converted from DG Script #48402: justice-oracle-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        -- 
        -- Added by Daedela 3-2021 for Wizard Eye
        -- 
        if person:get_quest_stage("wizard_eye") == 9 then
            person.name:advance_quest("wizard_eye")
            person:send(tostring(self.name) .. " says, 'I have foreseen this moment and anticipated your arrival.  If you seek my guidance, present to me the crystals in question.'")
        else
            if person:get_quest_stage("doom_entrance") == 3 then
                person:send(tostring(self.name) .. " says, 'Greetings, " .. tostring(person.name) .. ".'")
                wait(2)
                person:send(tostring(self.name) .. " says, 'It has come to my attention that you seek to prove your worth to Rhalean.  As the goddess of Justice, Rhalean has but one foe: her evil sister, trapped underground in the ages before the Riftwars.'")
                wait(1)
                person:send(tostring(self.name) .. " says, 'To prove yourself, return here after you have slain this vile creature.'")
            elseif person:get_quest_stage("doom_entrance") == 4 then
                person.name:advance_quest("doom_entrance")
                person:send("<b:white>You have advanced the quest!</>")
                person:send(tostring(self.name) .. " says, 'Excellent!'")
                wait(1)
                person:send(tostring(self.name) .. " says, 'You have proven yourself to Rhalean, " .. tostring(person.name) .. ". Please, continue on to the Oracle of the Sun.'")
            else
                person:send("As thoughts of Justice run through your mind, the Oracle clenches a calloused hand.")
                wait(1)
                person:send(tostring(self.name) .. " says, 'All crimes may be forgiven, save the murder of innocents.  For this sin, even the gods must take reckoning.  For this reason, you must do what the gods are prevented from doing, and slay Lokari.'")
            end
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end