-- Trigger: yes_to_help
-- Zone: 18, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1805

-- Converted from DG Script #1805: yes_to_help
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("blur") == 0 or actor:get_has_completed("blur") then
    wait(2)
    self.room:send("A beautiful woman emerges from amongst the trees.")
    self.room:spawn_mobile(18, 11)
    self.room:send("The woman smiles warmly.")
    wait(4)
    self.room:send("The woman says, 'Long ago, two men came here to duel.  Neither truly won or lost.  The forest is tainted by the malevolence each held for the other.'")
    wait(4)
    self.room:send("The woman sighs heavily.")
    wait(2)
    self.room:send("The woman says, 'One locked the other's soul in a hidden room, and threw the key into the forest.  He too had not long to live and soon perished, leaving behind a bit of himself.'")
    wait(4)
    self.room:send("The woman shakes her head, sadly.")
    wait(2)
    self.room:send("The woman says, 'The other's hatred infected the spirits of the forest, warping some of them.'")
    wait(2)
    self.room:send("The woman says, 'One in particular became so consumed by it we had to imprison her in a prison of thorns.'")
    wait(4)
    self.room:send("The woman says, 'If you could perhaps find and release the soul, perhaps they could end the duel.  Maybe then this forest will return to normal.'")
    wait(3)
    self.room:send("The woman retreats into the trees.")
    world.destroy(self.room:find_actor("nymph"))
    if world.count_objects(18, 99) < 2 then
        get_room(18, 2 + random(1, 13)):at(function()
            self.room:spawn_object(18, 99)
        end)
    end
end