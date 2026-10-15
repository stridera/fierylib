-- Trigger: megalith_quest_keeper_speech
-- Zone: 123, ID: 14
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- Rewritten per DG #12314: the DG vnum switch -> dispatch on self.id (3 north, 4 south, 5 east, 6 west),
-- each keeper only speaks while its own quest variable is still 0.
--
-- Original DG Script: #12314

-- Converted from DG Script #12314: megalith_quest_keeper_speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "sure", "no", "i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("megalith_quest") == 2 then
    if speech_word == "yes" or speech_word == "sure" or string.find(speech, "i will", 1, true) or string.find(speech, "i can", 1, true) then
        -- switch on self.id (keepers: 3 north, 4 south, 5 east, 6 west)
        if self.zone_id == 123 and self.id == 3 then
            -- North - get ring from Tech
            if (actor:get_quest_var("megalith_quest:north") or 0) == 0 then
                self:say("Thank you very kindly.")
                wait(0.5)
                self.room:send(tostring(self.name) .. " says, 'Far to the north, there is a civilization dedicated to the Great Snow Leopard.  There, they make <green>rings of simple granite</> which grant their constructs powerful mystic protection.  Such energies should make an ideal offering to the Earth Spirits.  Please retrieve one for me.'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>so please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                self:command("bow " .. tostring(actor.name))
                actor:set_quest_var("megalith_quest", "north", 1)
                return
            end
        elseif self.zone_id == 123 and self.id == 4 then
            -- South - Fiery Eye from Vulcera
            if (actor:get_quest_var("megalith_quest:south") or 0) == 0 then
                self:say("Excellent.")
                wait(0.4)
                self.room:send(tostring(self.name) .. " says, 'There is an island in the sea where fires of the deep meet the outer world, ruled by a demigoddess.  My people know her magic to be the ultimate blending of divine spark and protean fire.  She carries <b:red>a jewel that burns with that same fire</>.  If you can retrieve it, I believe that would be the perfect offering to the Spirits of Fire.'")
                actor:set_quest_var("megalith_quest", "south", 1)
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                wait(2)
                self:command("nod " .. tostring(actor.name))
                self:say("Good hunting.")
                return
            end
        elseif self.zone_id == 123 and self.id == 5 then
            -- East - cumulus bracelet
            if (actor:get_quest_var("megalith_quest:east") or 0) == 0 then
                self:say("Hurray!")
                self:command("clap")
                wait(1)
                self:say("There are a handful of places in the world where the clouds reach from the ground to the heavens.  One such place is the home to an ancient silver dragon.")
                wait(1)
                self:command("laugh")
                self:say("Don't worry, you don't need to mess with him on my behalf.")
                wait(2)
                self:say("His guardians on the other hand...")
                self:command("grin")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Some carry <b:white>cumulus cloud bracelets</>.  If you can get your hands on one, it'll boost my call to the Air Spirits right through the stratosphere!'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Remember, we have to cast in order:")
                self.room:send("</></><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So when you return the offerings, please start with <b:yellow>me</>!'")
                actor:set_quest_var("megalith_quest", "east", 1)
                wait(5)
                self:say("Why are you still standing here?!")
                wait(0.2)
                self:say("Go!  Go!")
                return
            end
        elseif self.zone_id == 123 and self.id == 6 then
            -- West - Spring Water
            if (actor:get_quest_var("megalith_quest:west") or 0) == 0 then
                self:say("Wonderful!")
                wait(2)
                self:say("As a creature of the Dreaming, my magic is especially fueled by energies that thin the veil between the worlds.")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'My faerie sisters have told me there is a <b:cyan>hidden spring in the surrounding forest</>.  Over the ages, it has absorbed the gentle radiance of the moon, making it ideally sympathetic with the power of the Reverie.  Even the waters from my home in the Kingdom of Dreams would pale in comparison!'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Please, take the cup you gave to the priestess, <b:cyan>fill it with water from that spring</>, and bring it back with water for me to offer the Spirits of the West.'")
                wait(6)
                self:command("ponder")
                self:say("Although this spring sounds ideal, I suppose any water will do.")
                actor:set_quest_var("megalith_quest", "west", 1)
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                self:command("curtsy " .. tostring(actor.name))
                return
            end
        end
    elseif speech_word == "no" then
        wait(0.2)
        self:command("shrug")
        self:say("Alright then.")
    end
end