-- Trigger: shaman_speak3
-- Zone: 481, ID: 44
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48144

-- Converted from DG Script #48144: shaman_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"who?", "who", "vulcera", "vulcera?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Vulcera is some kind of fiery demigoddess.  She appeared many years ago and took the volcano as her new palace.'")
wait(2)
self.room:send(tostring(self.name) .. " says, 'Vulcera enslaved the dwarrow, the gnome-dwarves of the Mountain Tribe who live inside the volcano itself, and forced them to build her an ivory tower.'")
wait(2)
self.room:send(tostring(self.name) .. " says, 'She quickly laid claim to the rest of the island as her dominion.  Vulcera claimed she was the new volcano god demanded all sacrifices be made to her.  She slaughters anyone who displeases or disobeys along with their whole family.'")
wait(3)
self.room:send(tostring(self.name) .. " says, 'But the true god grows angry.  Without our sacrifices, he will surely destroy the entire island.  The people of the Ocean Tribe turned to cannibal rituals to protect themselves.  We of the Jungle Tribe wish Vulcera removed but are not strong enough to destroy a demigoddess.'")