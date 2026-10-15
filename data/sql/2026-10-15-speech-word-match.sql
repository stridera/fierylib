-- Speech triggers match the spoken word or phrase, not the whole utterance (playtest r12 follow-up)
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/001/001_06_cleric_quest_spell_hints.lua
  (1, 6, $trig$-- Converted from DG Script #106: Cleric Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"heal", "heal?", "resurrect", "resurrect?", "group", "group?", "dragon", "dragon?", "dragons", "dragons?", "health", "health?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = speech_word
    if _sw1 == "heal" or _sw1 == "heal?" or _sw1 == "group" or _sw1 == "group?" or _sw1 == "armor" or _sw1 == "armor?" then
        if string.find(self.class, "cleric") or string.find(self.class, "priest") then
            self:say("Ah yes, there are two powerful group spells:")
            self.room:send("'<b:yellow>Group Heal</> was a potent tool in various religious practices. There is a'")
            self.room:send("'doctor who had been researching at his infirmary out west. He may know more.'")
            -- (empty room echo)
            self.room:send("'The other is <b:white>Group Armor</>, powerful war magic. The paladins of South'")
            self.room:send("'Caelia make ample use of it.'")
        elseif string.find(self.class, "diabolist") then
            self:say("Ah yes, there are two powerful group spells:")
            self.room:send("'<b:yellow>Group Heal</> can be learned by members of the diabolical orders, but'")
            self.room:send("'unfortunately it comes from outside our religious traditions. As loathe as I'")
            self.room:send("'am to admit it, you may have to talk to some of the monks of the more'")
            self.room:send("'priestly orders for more information.'")
            -- (empty room echo)
            self.room:send("'The other is a spell our demonic patrons will not grant us. Don't waste your'")
            self.room:send("'time trying to pursue it.'")
        else
            self:say("I'm afraid I know little about more advanced")
            self.room:send("'group support magics.'")
        end
    elseif _sw1 == "resurrect" or _sw1 == "resurrect?" then
        if string.find(self.class, "cleric") or string.find(self.class, "priest") or string.find(self.class, "diabolist") then
            self.room:send(tostring(self.name) .. " says, 'Yes, it is possible to <b:cyan>Resurrect</> the dead.'")
            self.room:send("'However the secrets of it have been lost over the centuries. Only'")
            self.room:send("'someone with knowledge of ages past may have a chance of still knowing such'")
            self.room:send("'magics.'")
            -- (empty room echo)
            self.room:send("'There are rumors that nigh-immortal supplicants orship in the darkest of'")
            self.room:send("'traditions. Perhaps someone in the most trecherous of religious houses would'")
            self.room:send("'know where to begin.'")
        elseif string.find(self.class, "necromancer") then
            self:say("Just use <b:black>Animate Dead</>. Isn't that enough for you?")
        else
            self:say("I'm afraid I know little about returning the dead")
            self.room:send("'to life.'")
        end
    elseif _sw1 == "dragon" or _sw1 == "dragon?" or _sw1 == "dragons" or _sw1 == "dragons?" or _sw1 == "health" or _sw1 == "health?" then
        if string.find(self.class, "cleric") or self.class == "priest" then
            self:say("<b:yellow>Dragons Health</> is a prayer derived from a")
            self.room:send("'song passed down amongst true dragon kind. Occassionally, highly trusted'")
            self.room:send("'dragonborn are taught the song while they care of the nests of their larger'")
            self.room:send("'cousins.'")
            -- (empty room echo)
            self.room:send("'Often these nesting grounds are near warm dunes or beaches.'")
        else
            self:say("As much as I wish I knew more about dragons,")
            self.room:send("'my knowledge of that spell is limited.'")
        end
    else
        _return_value = true
    end
end
return _return_value$trig$, '321ad98d8e2c09a672e86cd37b111e5d'),
  -- data/triggers/001/001_07_priest_quest_spell_hints.lua
  (1, 7, $trig$-- Converted from DG Script #107: Priest Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"banish", "banish?", "heaven", "heaven?", "heavens", "heavens?", "gate", "gate?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = speech_word
    if _sw1 == "gate" then
        if string.find(self.class, "diabolist") then
            if string.find(actor.class, "diabolist") then
                self:say("Our infernal lords can grant us the power to open a")
                self.room:send("'<b:red>Hell Gate</> o travel anywhere instantly via the Nine Hells.'")
                -- (empty room echo)
                self.room:send("'Places where Garl'lixxil have touched Ethilien like Templace are particularly'")
                self.room:send("'suitable for attuning to the proper energies.'")
            elseif string.find(actor.class, "priest") then
                self:say("We don't trifle with such silly things.")
                self.room:send("'Our diabolical patrons shift us through the very bowels of Hell instead!'")
            elseif string.find(actor.class, "druid") then
                self:say("Our traditions use inferal methods of travel, not lunar ones.")
            end
        elseif string.find(self.class, "priest") then
            if string.find(actor.class, "diabolist") then
                self:say("Members of priestly orders travel by the Will of")
                self.room:send("'Heaven. We do not spread the knowledge of Infernal magics.'")
            elseif string.find(actor.class, "priest") then
                self:say("The secrets to opening <b:cyan>Heavens Gate</> are")
                self.room:send("'taught by the stars themselves.'")
                -- (empty room echo)
                self.room:send("'There is a place near Anduin where starlight reaches deep into the bowels of'")
                self.room:send("'Ethilien and whispers to those who listen.'")
            elseif string.find(actor.class, "druid") then
                self:say("As much as we too revere the Moon in the Heavens,")
                self.room:send("'we're unable to provide you with the secrets of your Order.'")
            end
        elseif string.find(self.class, "druid") then
            if string.find(actor.class, "druid") then
                self.room:send(tostring(self.name) .. " says, 'The ability to call <b:cyan>Moonwells</> is a gift")
                self.room:send("'bestowed on us by the greatest powers in Nature.'")
                -- (empty room echo)
                self.room:send("'The western-most branch of our order is well known for their lunar rites.'")
            elseif string.find(actor.class, "diabolist") then
                self:say("We move by the power of the Moon,")
                self.room:send("'not the Nine Hells.'")
            elseif string.find(actor.class, "priest") then
                self:say("We move by the power of the Moon,")
                self.room:send("'not the Will of Heaven.'")
            end
        else
            self:say("Opening gates and wells is the works of other")
            self.room:send("'magical traditions, not ours.'")
        end
    elseif _sw1 == "banish" or _sw1 == "banish?" then
        if string.find(self.class, "priest") or string.find(self.class, "diabolist") then
            self:say("There's a diabolist known to skulk about South")
            self.room:send("'Caelia who is said to be quite adept at <b:black>Banish</>.'")
            -- (empty room echo)
            self.room:send("'They say she makes common use of it in the conflict between the military city'")
            self.room:send("'Ogakh and the paladins of Sacred Haven.'")
        else
            self:say("Unfortunately that spell is outside of our")
            self.room:send("'guild traditions.'")
        end
    elseif _sw1 == "heaven" or _sw1 == "heavens" or _sw1 == "heaven?" or _sw1 == "heavens?" then
        if string.find(self.class, "priest") then
            self:say("The secrets to opening <b:cyan>Heavens Gate</> are")
            self.room:send("'taught by the stars themselves.'")
            -- (empty room echo)
            self.room:send("'There is a place near Anduin where starlight reaches deep into the bowels of'")
            self.room:send("'Ethilien and whispers to those who listen.'")
        elseif string.find(self.class, "diabolist") then
            self:say("We don't trifle with such silly things.")
            self.room:send("'Our diabolical patrons shift us through the very bowels of of Hell instead!'")
        elseif string.find(self.class, "druid") then
            self:say("We move by the power of the Moon,")
            self.room:send("'not the Will of Heaven.'")
        else
            self:say("Apologies, I haven't the faintest clue where to begin looking.")
        end
    else
        _return_value = true
    end
end
return _return_value$trig$, '8e53a3de56b693292daa33127d1a8f27'),
  -- data/triggers/001/001_09_sorcerer_quest_spell_hints.lua
  (1, 9, $trig$-- Converted from DG Script #109: Sorcerer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"major", "major?", "globe", "globe?", "relocate", "relocate?", "charm", "charm?", "person", "person?", "wizard", "wizard?", "eye", "eye?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = speech_word
    if _sw1 == "major" or _sw1 == "major?" or _sw1 == "globe" or _sw1 == "globe?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
            self:say("The battle mage Lirne was talking about")
            self.room:send("'developing a new spell called <b:blue>Major Globe</> to defend himself against'")
            self.room:send("'powerful magicians.'")
            -- (empty room echo)
            self.room:send("'Last I heard, he was going to test it out against a powerful demonic agent of'")
            self.room:send("'chaos in the far north.'")
        else
            self:say("I'm afraid Major Globe isn't a spell I know how")
            self.room:send("'to cast.'")
        end
    elseif _sw1 == "relocate" or _sw1 == "relocate?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "pyromancer") or string.find(self.class, "cryomancer") then
            self:say("A student of Bigby's in Mielikki was working on")
            self.room:send("'A powerful teleportation spell she called <b:magenta>Relocate</>.'")
            -- (empty room echo)
            self.room:send("'Bigby or one of his lab assistants might know more.'")
        else
            self:say("Our Guild doesn't keep records of esoteric")
            self.room:send("'magics exclusive to other guilds. Sorry.'")
        end
    elseif _sw1 == "charm" or _sw1 == "charm?" or _sw1 == "person" or _sw1 == "person?" then
        if string.find(self.class, "sorcerer") or string.find(self.class, "illusionist") or string.find(self.class, "bard") then
            self:say("Charming is both a magical and a personal skill.")
            self.room:send("'<b:magenta>Charm Person</> relies on mixing both.'")
            -- (empty room echo)
            self.room:send("'However, those that make charming others a profession, particularly'")
            self.room:send("'courtesans, are the best teachers.'")
        else
            self:say("As charming as you are, I cannot point you in a")
            self.room:send("'better direction.'")
        end
    elseif _sw1 == "wizard" or _sw1 == "wizard?" or _sw1 == "eye" or _sw1 == "eye?" then
        if string.find(self.class, "sorcerer") then
            self:say("A simple but highly effective spell! The shamans of the")
            self.room:send("'Great Snow Leopard are particularly adept At teaching <b:cyan>Wizard Eye</> to'")
            self.room:send("'interested scholars.'")
            -- (empty room echo)
            self.room:send("'Seek them out to learn more.'")
        else
            self:say("That is a highly exclusive sorcerer spell. I am")
            self.room:send("'unable to help with that.'")
        end
    else
        _return_value = true
    end
end
return _return_value$trig$, '6d0d751f1f7e71900c87bbb8d94d4ad6'),
  -- data/triggers/001/001_10_cryomancer_quest_spell_hints.lua
  (1, 10, $trig$-- Converted from DG Script #110: Cryomancer Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"waterform", "waterform?", "flood", "flood?", "ice", "ice?", "shards", "shards?", "water", "water?", "form", "form?", "wall", "wall?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = speech_word
    if _sw1 == "waterform" or _sw1 == "waterform?" or _sw1 == "water" or _sw1 == "water?" or _sw1 == "form" or _sw1 == "form?" then
        if string.find(self.class, "cryomancer") then
            self.room:send(tostring(self.name) .. " says, '<b:blue>Waterform</> is more absorbed via osmosis than")
            self.room:send("'taught in the traditional sense. The spell is typically imparted by powerful'")
            self.room:send("'water elementals.'")
            -- (empty room echo)
            self.room:send("'You can find such elementals in the vast lakes and rivers of Ethilien.'")
        else
            self:say("That spell is unique to the Cryomancer's Guild.")
        end
    elseif _sw1 == "ice" or _sw1 == "ice?" or _sw1 == "shards" or _sw1 == "shards?" then
        if string.find(self.class, "cryomancer") then
            self.room:send(tostring(self.name) .. " says, 'Unfortunately, <b:cyan>Ice Shards</>'")
            self.room:send("'has been lost to our guild for many centuries. Khysan, a cyromancer from a'")
            self.room:send("'smaller branch of the elven Sunfire family, has been doing research into the'")
            self.room:send("'last known records of the spell, but hasn't reported any findings or updates'")
            self.room:send("'in many years.'")
            -- (empty room echo)
            self.room:send("'Perhaps you could check in with him. He works at the springs.'")
        else
            self:say("I've heard even the cryomancers don't know where")
            self.room:send("'to look for that spell. There's no chance anyone in our Guild would know.'")
        end
    elseif _sw1 == "flood" or _sw1 == "flood?" then
        if string.find(self.class, "cryomancer") then
            self:say("The power to call the roaring waters of Ethilien")
            self.room:send("'in a cataclysmic <b:blue>Flood</> is taught by the ocean herself. You would be")
            self.room:send("'either very lucky or very cursed to find her avatar.")
        elseif string.find(self.class, "druid") then
            self:say("We commune with the waters of the world in a very,")
            self.room:send("'very different way.'")
        else
            self:say("Unfortunately I don't have any guidance for you.")
        end
    elseif _sw1 == "wall" or _sw1 == "wall?" then
        if string.find(self.class, "cryomancer") then
            if string.find(actor.class, "cryomancer") then
                self:say("They regularly make use of <b:cyan>Wall of Ice</> to")
                self.room:send("'keep The most dangerous creatures from Frost Valley out of Mount Frostbite.'")
                -- (empty room echo)
                self.room:send("'Someone up there will know what to do.'")
            elseif string.find(actor.class, "illusionist") then
                self.room:send(tostring(self.name) .. " says, 'There is an <b:magenta>Illusory Wall</> spell out there,'")
                self.room:send("'but I don't know much about it.'")
            end
        elseif string.find(self.class, "illusionist") then
            if string.find(actor.class, "illusionist") then
                self:say("The best teacher of <b:magenta>Illusory Wall</> was a Post Commander")
                self.room:send("'for the Eldorian Guard.'")
                -- (empty room echo)
                self.room:send("'I hear she retired to the far north.'")
            elseif string.find(actor.class, "cryomancer") then
                self.room:send(tostring(self.name) .. " says, 'Your <b:cyan>Wall of Ice</> spell is extremely similar to our wall'")
                self.room:send("'spell, but I don't know much about it.'")
            end
        else
            self:say("Wall spells are not part of our Guild teachings.")
        end
    else
        _return_value = true
    end
end
return _return_value$trig$, 'f77bc0ce78c578b8c6189739878b0abf'),
  -- data/triggers/001/001_11_druid_quest_spell_hints.lua
  (1, 11, $trig$-- Converted from DG Script #111: Druid Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"creeping", "creeping?", "doom", "doom?", "moon", "moon?", "well", "well?", "moonwell", "moonwell?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
-- switch on speech
do
    local _sw1 = speech_word
    if _sw1 == "creeping" or _sw1 == "creeping?" or _sw1 == "doom" or _sw1 == "doom?" then
        if string.find(self.class, "druid") then
            self:say("The rage of the fair folk can summon a carpet of")
            self.room:send("'living death.'")
            -- (empty room echo)
            self.room:send("'Seek out the weakest-seeming of faeries and sprites to learn <b:green>Creeping Doom</>.'")
        else
            self:say("Invoking the wrath of nature is exclusive to the")
            self.room:send("'Druid Guild.'")
        end
    elseif _sw1 == "moonwell" or _sw1 == "moonwell?" or _sw1 == "well" or _sw1 == "well?" or _sw1 == "moon" or _sw1 == "moon?" then
        if string.find(self.class, "diabolist") then
            self:say("Our traditions use infernal methods of travel,")
            self.room:send("'not lunar ones.'")
        elseif string.find(self.class, "priest") then
            self:say("As much as we too revere the Moon, we're unable")
            self.room:send("'to provide you with the secrets of your Order.'")
        elseif string.find(self.class, "druid") then
            if string.find(actor.class, "druid") then
                self.room:send(tostring(self.name) .. " says, 'The ability to call <b:cyan>Moonwells</> is a gift'")
                self.room:send("'bestowed on us by the greatest powers in Nature. The western-most branch of'")
                self.room:send("'our order is well known for their lunar rites.'")
            elseif string.find(actor.class, "diabolist") then
                self:say("We move by the power of the Moon,")
                self.room:send("'not the Nine Hells.'")
            elseif string.find(actor.class, "priest") then
                self:say("We move by the power of the Moon,")
                self.room:send("'not the Will of Heaven.'")
            end
        else
            self:say("Opening gates and wells is the works of other")
            self.room:send("'magical traditions, not ours.'")
        end
    else
        _return_value = true
    end
end
return _return_value$trig$, '87f2e70cce621014ae68c8acd6479225'),
  -- data/triggers/002/002_101_phase_wand_bigby_research_assistant_speech.lua
  (2, 101, $trig$local dg = require("dg")

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"wand", "earth", "air", "fire", "water", "upgrade", "lightning", "wind", "shock", "electricity", "smoldering", "burning", "cold", "ice", "frost", "acid", "tremors", "corrosion", "powerful", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local class = actor.class or ""
if not (string.find(class, "sorcerer") or string.find(class, "pyromancer")
        or string.find(class, "cryomancer") or string.find(class, "illusionist")
        or string.find(class, "necromancer")) then
    self:say("I'm sorry, only true wizards can use these weapons.")
    return true
end
if actor.level < 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
    return true
end

-- "wand" or "upgrade" can share a sentence with the element ("upgrade my fire wand"), and the first listed
-- word found would then be "wand", so look for the element words themselves.
local element_of = {
    air = "air", lightning = "air", wind = "air", shock = "air", electricity = "air",
    fire = "fire", smoldering = "fire", burning = "fire",
    water = "ice", cold = "ice", ice = "ice", frost = "ice",
    earth = "acid", acid = "acid", tremors = "acid", corrosion = "acid",
}
local gem_of = {air = 55577, fire = 55575, ice = 55574, acid = 55576}
local quest_type, wandgem
for _, word in ipairs({"air", "lightning", "wind", "shock", "electricity", "fire", "smoldering", "burning",
                       "water", "cold", "ice", "frost", "earth", "acid", "tremors", "corrosion"}) do
    if string.find(speech_padded, "[%s%p]" .. word .. "[%s%p]") then
        quest_type = element_of[word]
        wandgem = gem_of[quest_type]
        break
    end
end

if not quest_type then
    -- Any other listed word ("wand", "upgrade", "yes"): DG read %type% here before it was set, so
    -- the stage was always 0 and the prompt below is what every player got.
    self:say("Yeah, I can help you upgrade any basic wand!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Tell me what element you would like to improve.  You can say <green>acid</>, <b:yellow>air</>, <red>fire</>, or <b:blue>ice</>.'")
    return true
end

local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
wait(2)
if actor:get_has_completed(quest) then
    self.room:send(tostring(self.name) .. " says, 'It looks like you already have the most powerful weapon of " .. quest_type .. " in existence!'")
elseif (stage or 0) == 0 or stage == 1 then
    if (stage or 0) == 0 then
        actor:start_quest(quest)
    end
    self.room:send(tostring(self.name) .. " says, 'I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'This step is relatively simple.  You can check your <b:cyan>[wand progress]</> with me as well.'")
    wait(2)
    self:say("First, let me see your wand.")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'If you have the practice, give me " .. dg.oname(wandgem) .. " and your current wand.'")
elseif stage > 2 then
    if quest_type == "air" then
        self.room:send(tostring(self.name) .. " says, 'You'll be studying with a plethora of seers, mystics, and wisemen.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("Speak with the old Abbot in the Abbey of St. George.")
        elseif stage == 4 then self:say("The keeper of a southern coastal tower will have advice for you.")
        elseif stage == 5 then self:say("A master of air near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("Seek out the warrior-witch at the center of the southern megalith.")
        elseif stage == 7 then self:say("She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.")
        elseif stage == 8 then self:say("In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.")
        elseif stage == 9 then self:say("The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.")
        elseif stage == 10 then self:say("Silania will help you craft the finest of air weapons.")
        end
    elseif quest_type == "fire" then
        self.room:send(tostring(self.name) .. " says, 'You should seek out the most renowned pyromancers in the world.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The keeper of the temple to the dark flame out east will know what to do.")
        elseif stage == 4 then self:say("There's a fire master in the frozen north who likes to spend his time at the hot springs.")
        elseif stage == 5 then self:say("A master of fire near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.")
        elseif stage == 7 then self:say("I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...")
        elseif stage == 8 then self:say("You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.")
        elseif stage == 9 then self:say("Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.")
        elseif stage == 10 then self:say("Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.")
        end
    elseif quest_type == "ice" then
        self.room:send(tostring(self.name) .. " says, 'Masters of ice and water are highly varied in their professions.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
        elseif stage == 4 then self:say("Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.")
        elseif stage == 5 then self:say("A master of spirits in the far north will be able to help next.")
        elseif stage == 6 then self:say("Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.")
        elseif stage == 7 then self:say("You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.")
        elseif stage == 8 then self:say("There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.")
        elseif stage == 9 then self:say("The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.")
        elseif stage == 10 then self:say("You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.")
        end
    elseif quest_type == "acid" then
        self.room:send(tostring(self.name) .. " says, 'Acid is the energy of earth.  The master earth crafters all belong to the ranger network that safeguards places around Caelia.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("First, seek the one who guards the eastern gates of Ickle.")
        elseif stage == 4 then self:say("The next two artisans dwell in the Rhell Forest south-east of Mielikki.")
        elseif stage == 5 then self:say("Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.")
        elseif stage == 6 then self:say("The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.")
        elseif stage == 7 then self:say("Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.")
        elseif stage == 8 then self:say("Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.")
        elseif stage == 9 then self:say("The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.")
        elseif stage == 10 then self:say("Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.")
        end
    end
end
return true$trig$, '3f141b689d22d4c657f4ac2ac713ddd0'),
  -- data/triggers/030/030_160_skill_trainer_speach.lua
  (30, 160, $trig$-- Converted from DG Script #3160: ***skill trainer speach***
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "backstab", "bludgeoning", "shadow", "slashing", "sneak", "steal", "switch", "throatcut", "track", "conceal", "corner", "double", "dual", "eye", "retreat", "hide", "pick", "piercing", "bandage", "douse", "lure", "cartwheel", "rend"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3160") < 1 then
    actor:start_quest("trainer_3160")
else
    actor:erase_quest("trainer_3160")
    actor:start_quest("trainer_3160")
end
-- Which topic was asked about?  The player may wrap it in other words ("dodge please"), so look for the
-- longest known topic named as a whole word or phrase; the greeting words rank last.
local topic
for _, name in ipairs({"bludgeoning weapons", "piercing weapons", "slashing weapons", "double attack", "group retreat", "instant kill", "sneak attack", "dual wield", "cartwheel", "eye gouge", "pick lock", "throatcut", "backstab", "bandage", "conceal", "retreat", "riposte", "corner", "shadow", "switch", "dodge", "douse", "parry", "sneak", "steal", "track", "hide", "lure", "rend", "training", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(name, "%p", "%%%0") .. "[%s%p]") then
        topic = name
        break
    end
end
-- introductions: lists the skills available
if topic == "training" or topic == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary stealthy")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>backstab, bandage, bludgeoning weapons, cartwheel, conceal, corner")
    self.room:send("</>double attack, douse, dual wield, eye gouge, group retreat, hide, lure, pick lock,")
    self.room:send("</>piercing weapons, rend, retreat, shadow, slashing weapons, sneak, sneak attack,")
    self.room:send("</>steal, switch, throatcut, track.")
    return _return_value
else
    -- defining variables for this script
    speech = topic or speech  -- canonical topic name: it is echoed and saved as the skill below
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if topic == "backstab" then
        skill = actor:get_skill("backstab")
    elseif topic == "bludgeoning weapons" then
        skill = actor:get_skill("bludgeoning weapons")
        word2 = "weapons"
    elseif topic == "cartwheel" then
        skill = actor:get_skill("cartwheel")
    elseif topic == "conceal" then
        skill = actor:get_skill("conceal")
    elseif topic == "corner" then
        skill = actor:get_skill("corner")
    elseif topic == "double attack" then
        skill = actor:get_skill("double attack")
        word2 = "attack"
    elseif topic == "dual wield" then
        skill = actor:get_skill("dual wield")
        word2 = "wield"
    elseif topic == "eye gouge" then
        word2 = "gouge"
        skill = actor:get_skill("eye gouge")
    elseif topic == "group retreat" then
        word2 = "retreat"
        skill = actor:get_skill("group retreat")
    elseif topic == "hide" then
        skill = actor:get_skill("hide")
    elseif topic == "instant kill" then
        skill = actor:get_skill("instant kill")
        word2 = "kill"
    elseif topic == "lure" then
        skill = actor:get_skill("lure")
    elseif topic == "pick lock" then
        skill = actor:get_skill("pick lock")
        word2 = "lock"
    elseif topic == "piercing weapons" then
        skill = actor:get_skill("piercing weapons")
        word2 = "weapons"
    elseif topic == "rend" then
        skill = actor:get_skill("rend")
    elseif topic == "retreat" then
        skill = actor:get_skill("retreat")
    elseif topic == "shadow" then
        skill = actor:get_skill("shadow")
    elseif topic == "slashing weapons" then
        skill = actor:get_skill("slashing weapons")
        word2 = "weapons"
    elseif topic == "sneak" then
        skill = actor:get_skill("sneak")
    elseif topic == "sneak attack" then
        skill = actor:get_skill("sneak attack")
        word2 = "attack"
    elseif topic == "steal" then
        skill = actor:get_skill("steal")
    elseif topic == "switch" then
        skill = actor:get_skill("switch")
    elseif topic == "throatcut" then
        skill = actor:get_skill("throatcut")
    elseif topic == "track" then
        skill = actor:get_skill("track")
    elseif topic == "bandage" then
        skill = actor:get_skill("bandage")
    elseif topic == "douse" then
        skill = actor:get_skill("douse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if topic == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif topic == "dodge" or topic == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif topic == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you. You've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("</>I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("..but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = math.floor(change * opinion * actor.level * actor.level / (skill * 20))
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price // 1000
    local gold = price // 100 - plat * 10
    local silv = price // 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just bring me the money when you're ready to practice.")
    actor:set_quest_var("trainer_3160", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3160", "word2", word2)
    end
    actor:set_quest_var("trainer_3160", "skill_level", skill)
    actor:set_quest_var("trainer_3160", "max_skill", maxskill)
    actor:set_quest_var("trainer_3160", "price", price)
    actor:set_quest_var("trainer_3160", "actor_level", actor.level)
end$trig$, '590531928a2b58b9feb05617fbf52b32'),
  -- data/triggers/030/030_165_calken_trainer_speech.lua
  (30, 165, $trig$-- Converted from DG Script #3165: Calken trainer speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "2h", "dodge", "parry", "riposte", "hitall", "barehand", "bash", "disarm", "first", "guard", "kick", "mount", "rescue", "riding", "safefall", "springleap", "tame", "tantrum", "maul", "berserk", "ground", "battle", "roundhouse"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3165") < 1 then
    actor:start_quest("trainer_3165")
else
    actor:erase_quest("trainer_3165")
    actor:start_quest("trainer_3165")
end
-- Which topic was asked about?  The player may wrap it in other words ("dodge please"), so look for the
-- longest known topic named as a whole word or phrase; the greeting words rank last.
local topic
for _, name in ipairs({"ground shaker", "battle howl", "roundhouse", "springleap", "first aid", "barehand", "safefall", "berserk", "riposte", "tantrum", "disarm", "hitall", "rescue", "riding", "dodge", "guard", "mount", "parry", "track", "bash", "kick", "maul", "tame", "training", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(name, "%p", "%%%0") .. "[%s%p]") then
        topic = name
        break
    end
end
-- introductions: lists the skills available
if topic == "training" or topic == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary martial")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>2H bludgeoning weapons, 2H piercing weapons, 2H slashing weapons, barehand,")
    self.room:send("</>bash, battle howl, berserk, disarm, dodge, first aid, ground shaker, guard,")
    self.room:send("</>hitall, kick, maul, mount, parry, rescue, riding, riposte, roundhouse, safefall,")
    self.room:send("</>springleap, tame, tantrum.")
    wait(2)
    self:say("Feel free to ask me about one of them and I'll give you a price.")
    return _return_value
else
    -- defining variables for this script
    speech = topic or speech  -- canonical topic name: it is echoed and saved as the skill below
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if topic == "bash" then
        skill = actor:get_skill("bash")
    elseif string.find(speech, "2h") then
        if string.find(speech, "bludgeoning") then
            word2 = "bludgeoning"
            skill = actor:get_skill("2H bludgeoning weapons")
        elseif string.find(speech, "piercing") then
            word2 = "piercing"
            skill = actor:get_skill("2H piercing weapons")
        elseif string.find(speech, "slashing") then
            word2 = "slashing"
            skill = actor:get_skill("2H slashing weapons")
        else
            self:say("Not sure that I've heard of that one.  What was it again?")
            return _return_value
        end
    elseif topic == "disarm" then
        skill = actor:get_skill("disarm")
    elseif topic == "dodge" then
        skill = actor:get_skill("dodge")
    elseif topic == "parry" then
        skill = actor:get_skill("parry")
    elseif topic == "riposte" then
        skill = actor:get_skill("riposte")
    elseif topic == "hitall" then
        skill = actor:get_skill("hitall")
    elseif topic == "barehand" then
        skill = actor:get_skill("barehand")
    elseif topic == "springleap" then
        skill = actor:get_skill("springleap")
    elseif topic == "safefall" then
        skill = actor:get_skill("safefall")
    elseif topic == "bash" then
        skill = actor:get_skill("bash")
    elseif topic == "guard" then
        skill = actor:get_skill("guard")
    elseif topic == "rescue" then
        skill = actor:get_skill("rescue")
    elseif topic == "kick" then
        skill = actor:get_skill("kick")
    elseif topic == "first aid" then
        word2 = "aid"
        skill = actor:get_skill("first aid")
    elseif topic == "mount" then
        skill = actor:get_skill("mount")
    elseif topic == "riding" then
        skill = actor:get_skill("riding")
    elseif topic == "tame" then
        skill = actor:get_skill("tame")
    elseif topic == "ground shaker" then
        word2 = "shaker"
        skill = actor:get_skill("ground shaker")
    elseif topic == "battle howl" then
        word2 = "howl"
        skill = actor:get_skill("battle howl")
    elseif topic == "maul" then
        skill = actor:get_skill("maul")
    elseif topic == "tantrum" then
        skill = actor:get_skill("tantrum")
    elseif topic == "berserk" then
        skill = actor:get_skill("berserk")
    elseif topic == "roundhouse" then
        skill = actor:get_skill("roundhouse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if topic == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif topic == "dodge" or topic == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif topic == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you - you've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = math.floor(change * opinion * actor.level * actor.level / (skill * 20))
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price // 1000
    local gold = price // 100 - plat * 10
    local silv = price // 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money, and I'll get started.")
    actor:set_quest_var("trainer_3165", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3165", "word2", word2)
    end
    actor:set_quest_var("trainer_3165", "skill_level", skill)
    actor:set_quest_var("trainer_3165", "max_skill", maxskill)
    actor:set_quest_var("trainer_3165", "price", price)
    actor:set_quest_var("trainer_3165", "actor_level", actor.level)
end$trig$, 'f88e5877cd3fe9990bee44878041cb30'),
  -- data/triggers/030/030_170_shaman_trainer_speech.lua
  (30, 170, $trig$-- Converted from DG Script #3170: shaman trainer speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "spell", "sphere", "chant", "scribe", "meditate", "vampiric", "breathe", "perform"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3170") < 1 then
    actor:start_quest("trainer_3170")
else
    actor:erase_quest("trainer_3170")
    actor:start_quest("trainer_3170")
end
-- Which topic was asked about?  The player may wrap it in other words ("dodge please"), so look for the
-- longest known topic named as a whole word or phrase; the greeting words rank last.
local topic
for _, name in ipairs({"spell knowledge", "vampiric touch", "quick chant", "meditate", "perform", "scribe", "chant", "training", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(name, "%p", "%%%0") .. "[%s%p]") then
        topic = name
        break
    end
end
-- introductions: lists the skills available
if topic == "training" or topic == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary magical")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    -- (empty room echo)
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    -- (empty room echo)
    self.room:send("</>breathe acid, breathe fire, breathe frost, breathe gas, breathe lightning,")
    self.room:send("</>chant, meditate, perform, scribe, spell knowledge, sphere of air,")
    self.room:send("</>sphere of death, sphere of divination, sphere of earth, sphere of enchantment,")
    self.room:send("</>sphere of fire, sphere of generic, sphere of healing, sphere of protection,")
    self.room:send("</>sphere of summoning, sphere of water, quick chant.")
    return _return_value
else
    -- defining variables for this script
    speech = topic or speech  -- canonical topic name: it is echoed and saved as the skill below
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local word2, skill
    if topic == "spell knowledge" then
        word2 = "knowledge"
        skill = actor:get_skill("spell knowledge")
    elseif string.find(speech, "sphere") then
        if string.find(speech, "air") then
            word2 = "air"
            skill = actor:get_skill("sphere of air")
        elseif string.find(speech, "death") then
            word2 = "death"
            skill = actor:get_skill("sphere of death")
        elseif string.find(speech, "divination") then
            word2 = "divination"
            skill = actor:get_skill("sphere of divination")
        elseif string.find(speech, "earth") then
            word2 = "earth"
            skill = actor:get_skill("sphere of earth")
        elseif string.find(speech, "enchantment") then
            word2 = "enchantment"
            skill = actor:get_skill("sphere of enchantment")
        elseif string.find(speech, "fire") then
            word2 = "fire"
            skill = actor:get_skill("sphere of fire")
        elseif string.find(speech, "generic") then
            word2 = "generic"
            skill = actor:get_skill("sphere of generic")
        elseif string.find(speech, "healing") then
            word2 = "healing"
            skill = actor:get_skill("sphere of healing")
        elseif string.find(speech, "protection") then
            word2 = "protection"
            skill = actor:get_skill("sphere of protection")
        elseif string.find(speech, "summoning") then
            word2 = "summoning"
            skill = actor:get_skill("sphere of summoning")
        elseif string.find(speech, "water") then
            word2 = "water"
            skill = actor:get_skill("sphere of water")
        else
            self:say("I've never heard of that sphere of magic before.")
        end
    elseif string.find(speech, "breathe") then
        if string.find(speech, "fire") then
            word2 = "fire"
            skill = actor:get_skill("breathe fire")
        elseif string.find(speech, "frost") then
            word2 = "frost"
            skill = actor:get_skill("breathe frost")
        elseif string.find(speech, "lightning") then
            word2 = "lightning"
            skill = actor:get_skill("breathe lightning")
        elseif string.find(speech, "acid") then
            word2 = "acid"
            skill = actor:get_skill("breathe acid")
        elseif string.find(speech, "gas") then
            word2 = "gas"
            skill = actor:get_skill("breathe gas")
        else
            self:say("Whatever that is, you can't breathe it!")
            return _return_value
        end
    elseif topic == "quick chant" then
        word2 = "chant"
        skill = actor:get_skill("quick chant")
    elseif topic == "chant" then
        skill = actor:get_skill("chant")
    elseif topic == "scribe" then
        skill = actor:get_skill("scribe")
    elseif topic == "meditate" then
        skill = actor:get_skill("meditate")
    elseif topic == "vampiric touch" then
        word2 = "touch"
        skill = actor:get_skill("vampiric touch")
    elseif topic == "perform" then
        skill = actor:get_skill("perform")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = (actor.level * 10) + 60
    -- check for capped skills
    local cap = 1000
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you. You've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("You're a charming person.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you are very quick witted.")
            self.room:send("</>I'll be delighted to give you a good rate.'")
        elseif int < 50 then
            self:say("...but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you aren't the smartest.")
            self.room:send("</>So this is going to cost you.'")
        else
        end
    else
        self:say("I wouldn't mind working with you.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...but you aren't the smartest.")
            self.room:send("</>So, this is going to cost a bit more than usual.'")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = math.floor(change * opinion * actor.level * actor.level / (skill * 20))
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price // 1000
    local gold = price // 100 - plat * 10
    local silv = price // 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money, and I'll get started.")
    actor:set_quest_var("trainer_3170", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3170", "word2", word2)
    end
    actor:set_quest_var("trainer_3170", "skill_level", skill)
    actor:set_quest_var("trainer_3170", "max_skill", maxskill)
    actor:set_quest_var("trainer_3170", "price", price)
    actor:set_quest_var("trainer_3170", "actor_level", actor.level)
end$trig$, '1639b23391eba0d356dbbaf28e4d5019'),
  -- data/triggers/043/043_54_lp_bard_subclass_speech1.lua
  (43, 54, $trig$-- Converted from DG Script #4354: LP_bard_subclass_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    do
        wait(0.2)
        if speech_word == "yes" then
            actor:send(tostring(self.name) .. " says, 'Right this way then!'")
            local next_line
            -- switch on actor:get_quest_stage("bard_subclass")
            do
                local _sw2 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
                if tonumber(_sw2) == 1 then
                    next_line = "Let's hear you <b:magenta>sing</>!"
                elseif tonumber(_sw2) == 2 then
                    next_line = "Let's see you <b:magenta>dance</>!"
                elseif tonumber(_sw2) == 3 or tonumber(_sw2) == 4 then
                    next_line = "Do you have the <b:yellow>script</>?"
                elseif tonumber(_sw2) == 5 then
                    next_line = "Let's hear some <b:cyan>dialogue</>!"
                else
                    next_line = "So, let's discuss your <b:cyan>audition</>."
                    wait(0.2)
                    actor:send(tostring(self.name) .. " says, 'Seems like you got real star potential kid.'")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Follow me to the rehearsal studio.  We want you to audition for us.'")
                end
            end
            wait(2)
            actor:send(tostring(self.name) .. " escorts you backstage to a smaller dance studio.")
            self.room:send_except(actor, tostring(self.name) .. " escorts " .. tostring(actor.name) .. " backstage.")
            wait(2)
            actor:teleport(get_room(43, 69))
            -- actor looks around
            wait(2)
            actor:send(tostring(self.name) .. " settles in.")
            wait(1)
            get_room(43, 69):at(function()
                actor:send(tostring(self.name) .. " says, '" .. tostring(next_line) .. "'")
            end)
        else
            actor:send(tostring(self.name) .. " says, 'Too bad.  You have real start potential kid.  You could be big.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Huge!'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Lemme know if you change your mind.  It's not too late for you.'")
        end
    end
end$trig$, '46aa7780031dda5edfdafeb41b27fdf5'),
  -- data/triggers/062/062_01_necromancer_quest_spell_hints_and_shift_corpse_sta.lua
  (62, 1, $trig$-- TODO(parity): The original DG script's structure for the "degeneration"
-- branch is ambiguous after conversion (empty inner if + dangling elseif).
-- Current behavior: Necromancer guildmaster handles shift/corpse for
-- Necromancer askers; "degeneration" / fallback hint live below in a
-- separate top-level branch. Verify against DG #6201 source if available.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"shift", "shift?", "corpse", "corpse?", "degeneration", "degeneration?"}) do
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
if string.find(self.class, "necromancer") then
    if speech_word == "degeneration" or speech_word == "degeneration?" then
        self.room:send(tostring(self.name) .. " says, 'Controlling negative energy to bolster the dead or")
        self.room:send("</>degenerate the living is theoretically possible.  Someone is working to")
        self.room:send("</>develop a <b:black>Degeneration</> spell for use in the ongoing battle against")
        self.room:send("</>the Eldorian Guard.'")
    elseif string.find(actor.class, "necromancer") and actor:get_quest_stage("shift_corpse") == 0 then
        if speech_word == "shift" or speech_word == "shift?" or speech_word == "corpse" or speech_word == "corpse?" then
            self:say("So you want to learn our most powerful secrets, eh?")
            self:command("peer " .. tostring(actor))
            wait(1)
            if actor.level < 97 then
                self.room:send(tostring(self.name) .. " says, 'Unfortunately you are not prepared to handle such magic.")
                self.room:send("</>There are easier ways to kill yourself.'")
            else
                self:command("nod")
                self.room:send(tostring(self.name) .. " says, 'I will teach you the words to the spell.  But the words")
                self.room:send("</>alone are meaningless.  The true power to fuel Shift Corpse cannot be")
                self.room:send("</>taught - it must be taken.'")
                wait(2)
                self:say("You must steal the power of a god.")
                actor:start_quest("shift_corpse")
            end
        else
            self.room:send_except(actor, tostring(self.name) .. " sneers at " .. tostring(actor.name) .. ".")
            actor:send(tostring(self.name) .. " sneers at you.")
            self:say("This magic is not for you!")
        end
    else
        self:say("That spell is far outside the realm of our Guild.")
    end
else
    self.room:send(tostring(self.name) .. " says, 'Only a powerful member of the Necromancer Guild")
    self.room:send("</>might know how to cast such a spell.'")
end$trig$, '4f7b3109f0e90bbe6040915808b287bc'),
  -- data/triggers/062/062_04_pyromancer_quest_spell_hints_and_supernova_start.lua
  (62, 4, $trig$-- TODO(parity): Original DG branching for non-supernova hints (meteorswarm,
-- diabolist response, fallback) is ambiguous after conversion (empty inner if
-- + dangling elseif). Pyromancers fall through to spell-specific hints below;
-- verify against DG #6204 source if this is wrong.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"supernova", "supernova?", "super", "super?", "nova", "nova?", "meteorswarm", "meteorswarm?", "meteor", "meteor?", "swarm", "swarm?"}) do
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
if string.find(self.class, "pyromancer") then
    -- Supernova quest entrypoint, Pyromancer asker only
    if speech_word == "super" or speech_word == "super?" or speech_word == "nova" or speech_word == "nova?" or speech_word == "supernova" or speech_word == "supernova?" then
        if string.find(actor.class, "pyromancer") then
            if actor.level > 88 then
                if actor:get_quest_stage("supernova") == 0 then
                    actor:start_quest("supernova")
                    self.room:send(tostring(self.name) .. " says, 'Supernova is really only taught by one person:")
                    self.room:send("</>Phayla, daughter of the Sun.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, 'Phayla is one of the most powerful sorceresses in")
                    self.room:send("</>existence.  Beings from all across the universe have sought her out for just a")
                    self.room:send("</>chance to study under her.  Most fail to find her.  She has agreed to teach")
                    self.room:send("</>even fewer.'")
                    wait(5)
                    self.room:send(tostring(self.name) .. " says, 'She resides in a demiplane of her own creation.")
                    self.room:send("</>It's constantly shifting and changing, so it's impossible for anyone but Phayla")
                    self.room:send("</>to know where it is or how to access it without help.'")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'However, she likes to leave clues to accessing it")
                    self.room:send("</>scattered throughout the world.'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " says, 'On their own, the clues are illegible and")
                    self.room:send("</>unintelligible.  The keys to reading them are lamps Phayla gives to her most")
                    self.room:send("</>ardent and formidable followers.'")
                    wait(4)
                    self:say("If you find one I may be able to help you more.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, 'You can check in with me about your <b:white>[progress]</>")
                    self.room:send("</>toward learning Supernova at any time.'")
                    self.room:send(tostring(self.name) .. " says, 'If you want to know about your armor quests, ask")
                    self.room:send("</>me about your <white></>[status]</> instead.'")
                else
                    self.room:send(tostring(self.name) .. " says, 'You're not ready to be asking about such an")
                    self.room:send("</>awesome spell.  We can do a follow-up visit after you gain some more")
                    self.room:send("</>experience.'")
                end
            else
                self:say("Supernova is beyond your discipline.")
            end
        else
            self:say("Supernova is far outside our discipline.")
        end
    elseif speech_word == "meteor" or speech_word == "meteor?" or speech_word == "swarm" or speech_word == "swarm?" or speech_word == "meteorswarm" or speech_word == "meteorswarm?" then
        self.room:send(tostring(self.name) .. " says, 'Crazy old McCabe the Elementalist has developed")
        self.room:send("</>such a spell. If you can find him, you might be able to persuade him to teach")
        self.room:send("</>you <b:red>Meteorswarm</>.'")
        self.room:send("</>He likes the devastating effects of volcanoes.'")
    else
        self.room:send(tostring(self.name) .. " says, 'I'm afraid I can't help you with that particular")
        self.room:send("</>spell.'")
    end
end
return true$trig$, '010ab7dac575b5bb6939b4efb83072b8'),
  -- data/triggers/123/123_07_megalith_quest_priestess_speech_stage2.lua
  (123, 7, $trig$-- Converted from DG Script #12307: megalith_quest_priestess_speech_stage2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"under"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Preset item vars
local item = 0
local speech1 = "under the watchful eye of earth, air, fire, and water, we awaken this hallowed ground!"
local speech2 = "under the watchful eye of earth air fire and water we awaken this hallowed ground"
local speech3 = "under the watchful eye of earth air fire and water we awaken this hallowed ground!"
local speech4 = "under the watchful eye of earth, air, fire, and water, we awaken this hallowed ground"
local item1 = actor:get_quest_var("megalith_quest:item1")
local item2 = actor:get_quest_var("megalith_quest:item2")
local item3 = actor:get_quest_var("megalith_quest:item3")
local item4 = actor:get_quest_var("megalith_quest:item4")
-- DG `/=`: the speech contains the sentence (any case, any words around it)
local speech_lower = string.lower(speech)
if string.find(speech_lower, speech1, 1, true) or string.find(speech_lower, speech2, 1, true) or string.find(speech_lower, speech3, 1, true) or string.find(speech_lower, speech4, 1, true) then
    if actor:get_quest_stage("megalith_quest") == 2 then
        if item1 and item2 and item3 and item4 then
            actor:advance_quest("megalith_quest")
            -- Reset quest 'item' variables
            for slot = 1, 5 do
                actor:set_quest_var("megalith_quest", "item" .. tostring(slot), 0)
            end
            wait(1)
            self.room:send("<b:white>The menhir begin to hum with deep chthonic harmonics.</>")
            wait(3)
            self:say("It's working!  I can feel the energies of the stones returning to life.")
            wait(1)
            self:emote("closes her eyes and basks in the chthonic resonance.")
            wait(3)
            self:emote("opens her eyes, invigorated.")
            self:say("We're so close to success!")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'With the circle cast and the land prepared, I require three holy <b:cyan>reliquaries</> to summon our Goddess.'")
        end
    end
end$trig$, '1ed0d1b85687727fac72d877e9f08a35'),
  -- data/triggers/123/123_09_megalith_quest_priestess_speech_invocation1.lua
  (123, 9, $trig$-- Converted from DG Script #12309: megalith_quest_priestess_speech_invocation1
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"great"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech1 = "great lady of the stars hear our prayer"
local speech2 = "great lady of the stars, hear our prayer"
local speech3 = "great lady of the stars, hear our prayer!"
local stage = actor:get_quest_stage("megalith_quest")
-- DG `/=`: the speech contains the sentence (any case, any words around it)
local speech_lower = string.lower(speech)
if string.find(speech_lower, speech1, 1, true) or string.find(speech_lower, speech2, 1, true) or string.find(speech_lower, speech3, 1, true) then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:prayer") or 0) == 1) then
        run_room_trigger(123, 17)
        wait(5)
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("</>'We call you from the realm behind")
        self.room:send("</>One adrift beyond space and time.")
        -- (empty room echo)
        self.room:send("</>Ringing now the bell in three")
        self.room:send("</>Hear our prayer")
        self.room:send("</><b:cyan>We summon and stir thee</>!'")
        actor:set_quest_var("megalith_quest", "prayer", 2)
        actor:set_quest_var("megalith_quest", "summon", 1)
    end
end$trig$, '02025cfaab9802b64a4ef24c903c0840'),
  -- data/triggers/123/123_10_megalith_quest_priestess_speech_invocation2.lua
  (123, 10, $trig$-- Converted from DG Script #12310: megalith_quest_priestess_speech_invocation2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we summon and stir thee (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]we summon and stir thee[%s%p]") then
    return true  -- Not the phrase
end
local speech1 = "we summon and stir thee"
local speech2 = "we summon and stir thee!"
local stage = actor:get_quest_stage("megalith_quest")
local summon = actor:get_quest_var("megalith_quest:summon")
-- DG `/=`: the speech contains the sentence (any case, any words around it)
local speech_lower = string.lower(speech)
if string.find(speech_lower, speech1, 1, true) or string.find(speech_lower, speech2, 1, true) then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:prayer") or 0) == 2) then
        -- switch on summon
        do
            local _sw1 = string.lower(tostring(summon or ""))
            if tonumber(_sw1) == 1 then
                run_room_trigger(123, 18)
                wait(5)
                self.room:send(tostring(self.name) .. " chants:")
                self.room:send("'By Earth, Air, Water, and Fire,")
                self.room:send("</>To bring you home is our desire.'")
                wait(4)
                run_room_trigger(123, 19)
                actor:set_quest_var("megalith_quest", "summon", 2)
            elseif tonumber(_sw1) == 2 then
                run_room_trigger(123, 20)
                wait(2)
                self.room:send(tostring(self.name) .. " chants:")
                self.room:send("'Through the plane of vaulted sky")
                self.room:send("</>On shooting stars and moonbridge high.'")
                wait(4)
                run_room_trigger(123, 21)
                actor:set_quest_var("megalith_quest", "summon", 3)
            elseif tonumber(_sw1) == 3 then
                -- 
                -- 12320 is a wecho of just the phrase 'We summon and stir thee'
                -- It is intentionally repeated at the top of this case to echo the questor
                -- 
                run_room_trigger(123, 20)
                wait(2)
                self.room:send(tostring(mobiles.template(123, 1).name) .. " says, '<b:cyan>We invoke thee</>!")
            end
        end
    end
end$trig$, '418018c88d10d036a66f8d652f0e697f'),
  -- data/triggers/123/123_11_megalith_quest_priestess_speech_end.lua
  (123, 11, $trig$-- Converted from DG Script #12311: megalith_quest_priestess_speech_end
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we invoke thee (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]we invoke thee[%s%p]") then
    return true  -- Not the phrase
end
local _return_value = true
local speech1 = "we invoke thee"
local speech2 = "we invoke thee!"
local stage = actor:get_quest_stage("megalith_quest")
if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:summon") or 0) == 3) and (string.find(string.lower(speech), speech1, 1, true) or string.find(string.lower(speech), speech2, 1, true)) then
    local invoke = actor:get_quest_var("megalith_quest:invoke") or 0
    local chant = invoke + 1
    if chant == 1 then
        actor:set_quest_var("megalith_quest", "invoke", 1)
        wait(0.2)
        run_room_trigger(123, 22)
        wait(1)
        self:say("Again!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 2 then
        actor:set_quest_var("megalith_quest", "invoke", 2)
        wait(0.2)
        run_room_trigger(123, 22)
        wait(1)
        self:say("Once more!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 3 then
        actor:set_quest_var("megalith_quest", "invoke", 0)
        actor:set_quest_var("megalith_quest", "reliquary", 0)
        actor:set_quest_var("megalith_quest", "summon", 0)
        actor:set_quest_var("megalith_quest", "prayer", 0)
        local bad1 = actor:get_quest_var("megalith_quest:bad1") and 1 or 0
        local bad2 = actor:get_quest_var("megalith_quest:bad2") and 1 or 0
        local bad3 = actor:get_quest_var("megalith_quest:bad3") and 1 or 0
        local bad4 = actor:get_quest_var("megalith_quest:bad4") and 1 or 0
        run_room_trigger(123, 22)
        wait(2)
        self.room:send(tostring(self.name) .. " cries, 'Great Mother, come to me!'")
        wait(2)
        self.room:send("The chanting harmonizes with the vibrations of the standing stones.")
        self.room:send("<b:yellow>Radiant energy washes out of the ancient stones in waves!</>")
        wait(4)
        self.room:send("<b:white>Stars <blue>begin to fall from the swirling vortex above.</>")
        wait(5)
        -- The worst ending
        if bad4 == 1 then
            -- TODO(parity): the elixir name lookup uses zone 584 / id 26
            -- as a guess at the legacy 58426 split. Verify the canonical
            -- (zone, id) before relying on this.
            self.room:send("The energies of the megalith buckle suddenly as <magenta>" .. tostring(objects.template(584, 26).name) .. "</> shatters.")
            wait(4)
            self.room:send("<b:black>The harmonics shift into piercing discordant shrieks as</> <red>blood</> <b:black>begins to pour from the altar!</>")
            wait(2)
            self.room:send("With a horrified look, " .. tostring(self.name) .. " screams, 'The Great Invocation has been corrupted!  What was in that <b:red>elixir</>?!'")
            wait(7)
            self.room:send("Rays of <b:white>s</><b:yellow>ea</><b:white>ring light</> shoot out in all directions as the world spins!")
            wait(6)
            self.room:send("Suddenly <magenta>bpitch black</> energies erupt from the altar, engulfing " .. tostring(mobiles.template(123, 7).name) .. "!")
            wait(8)
            self.room:send(tostring(mobiles.template(123, 7).name) .. " is ripped apart from within in an explosion of blood and gore!")
            local envoy = self.room:find_actor("celestial-envoy")
            if envoy then world.destroy(envoy) end
            self.room:send("Remaining in her place is a huge blood-covered abomination from beyond time and space made completely of iridescent black slime.")
            wait(4)
            self.room:send("Hundreds of eyes float just below the viscous membrane surrounding the ameboid creature.")
            wait(5)
            self.room:send("Suddenly it mutates into a huge creature with six enormous muscular legs and a massive maw!")
            wait(3)
            self.room:send("It roars with the voices of a thousand flayed beasts and attacks!")
            self.room:spawn_mobile(123, 21)
            local shoggoth = self.room:find_actor("shoggoth")
            if shoggoth then shoggoth:command("kill " .. tostring(actor.name)) end
            -- Clear all the bads, in case you try again later
            for slot = 1, 4 do
                actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
            end
            actor:fail_quest("megalith_quest")
            return _return_value
        else
            local total = bad1 + bad2 + bad3
            -- The good ending - get two prizes
            if total == 0 then
                actor:advance_quest("megalith_quest")
                self.room:send("<b:white>Celestial light pours through the vortex.</>")
                self.room:send("<b:white>It forms a gentle <cyan>pool of radiance <white>in the eye of the cosmic maelstrom.</>")
                wait(5)
                self.room:send("<b:magenta>A beautiful tiny being with six gossamer butterfly wings descends from the moonbridge.</>")
                self.room:send("<b:white>She looks as old as time itself yet younger than a child.</>")
                wait(5)
                self.room:send(tostring(self.name) .. " exclaims, 'O Great Mother, Goddess of the moon and stars, joyously we welcome you!'")
                if world.count_mobiles(123, 0) == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                local mother = mobiles.template(123, 0).name
                local witch = mobiles.template(123, 7).name
                self.room:send(tostring(self.name) .. " and " .. tostring(witch) .. " kneel before " .. tostring(mother) .. ".")
                wait(4)
                self.room:send(tostring(mother) .. " embraces her children, weeping with joy.")
                wait(5)
                self.room:send(tostring(mother) .. " says, 'Your efforts shone a beacon in the dark, lighting my way back to you my children.'")
                wait(4)
                self.room:send(tostring(mother) .. " says, 'I have watched from afar as you and your mothers and your grandmothers struggled to keep our traditions alive.'")
                wait(5)
                self.room:send(tostring(mother) .. " proclaims, 'But now is our time to flourish again!'")
                wait(0.2)
                self.room:send(tostring(mother) .. " proclaims, 'Let this sacred megalith be home to our coven from here after!'")
                wait(5)
                self.room:send(tostring(mother) .. " proclaims, 'Let us reignite the flames of passion, be the clay of reason, give the breath of life, be the ocean of serenity.'")
                wait(5)
                self.room:send(tostring(mother) .. " cries, 'So mote it be!'")
                wait(3)
                self.room:send("The coven cheers in unison, 'So mote it be!'")
                wait(4)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                actor:send("Turning to you, " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                self.room:send("</>I wish to thank you for helping my daughters.  <b:cyan>Kneel</>, and receive my blessing.'")
                return _return_value
            -- The okay ending - get one prize
            elseif total == 1 then
                actor:advance_quest("megalith_quest")
                self.room:send("The stars coalesce into the nearly transparent form of a celestial, gossamer-winged goddess.")
                local mother = mobiles.template(123, 0).name
                local witch = mobiles.template(123, 7).name
                self.room:send(tostring(self.name) .. " and " .. tostring(witch) .. " bow before " .. tostring(mother) .. ".")
                self.room:send(tostring(self.name) .. " says, 'O Great Mother, watcher from the deep, we come to seek thy blessing!'")
                if world.count_mobiles(123, 0) == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                self.room:send(tostring(mother) .. " says, 'My daughters, you shall always have my blessing.'")
                self.room:send(tostring(mother) .. " gently kisses each member of the coven on their forehead, leaving a glowing mote of <b:white>silvery light</>.")
                wait(5)
                self.room:send(tostring(mother) .. " says, 'Long has it been since the Nine Hells opened wide and I was cut off from the mortal world.'")
                wait(3)
                self.room:send(tostring(mother) .. " says, 'Yet through you and your mothers and grandmothers before you, my presence has been kept alive.'")
                self.room:send(tostring(mother) .. " smiles serenely.")
                wait(6)
                self.room:send(tostring(mother) .. " declares, 'Let this sacred megalith be home to our coven once again!  Thus I charge you with the tending and care of this holy monument.  May you keep well this sacred duty.'")
                wait(7)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                actor:send("Turning to you, " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                self.room:send("</>I would thank you for helping my daughters.  If you wish to receive my blessing, <b:cyan>kneel</>.'")
                return _return_value
            -- The bad ending - get nothing
            elseif total >= 2 then
                self.room:send("<b:black>The harmonics of the monolith begin to shift, falling out of balance.</>")
                wait(3)
                self.room:send("The energy of the megalith begins to dim.")
                self.room:send("In a despondent voice, " .. tostring(self.name) .. " cries out, 'The circle is failing!  <b:red>The tools or the reliquaries must have been flawed!</>'")
                wait(4)
                self.room:send("<b:yellow>Rapidly the radiance leaks out of the area.</>")
                wait(2)
                self.room:send("<b:white>The swirling vortex in the sky swiftly fades away.</>")
                wait(4)
                self.room:send("The Great Rite of Invocation ends as if nothing had ever happened.")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'So this is how it ends... not with a bang, but a whimper.'")
                self:emote("collapses, exhausted.")
                -- Clear all the Bads, just in case you try again
                for slot = 1, 5 do
                    actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
                end
                actor:fail_quest("megalith_quest")
            end
        end
    end
end
return _return_value$trig$, '785102e5ab9aa85364ee964c998b9788'),
  -- data/triggers/123/123_14_megalith_quest_keeper_speech.lua
  (123, 14, $trig$-- Converted from DG Script #12314: megalith_quest_keeper_speech
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
end$trig$, '82e19df2bc20a3da6a59a1cd41f010d7'),
  -- data/triggers/237/237_24_unused.lua
  (237, 24, $trig$-- Converted from DG Script #23724: ***UNUSED***
-- Original: MOB trigger, flags: SPEECH, probability: 100%
-- Marked unused in original codebase; logic mirrors 23722/23723 (yes/no branches).

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("sunfire_rescue") == 1 then
    -- Responding to trigger 23723 in the rescue quest.
    -- I figure he'd be able to tell the difference between cursed items
    -- and besides it's harder to get them all individually.
    -- Fairly straightforward...
    if speech_word == "yes" then
        if actor.alignment > 349 then
            actor:start_quest("sunfire_rescue")
            self:emote("smiles brightly at " .. tostring(actor.name) .. " and looks hopeful.")
            self:say("Thank you! Please return to me with the items and I will be most grateful.")
            self:emote("pauses a moment.")
            self:say("Oh, do not bother with the cursed items.  I can tell the difference.")
            self.room:send("The prisoner looks apprehensive.")
            self:whisper(actor, "You should leave here before the guards come!")
            self:emote("relaxes back into a position of pain, though he smiles at you.")
        end
    end
    if speech_word == "no" then
        self:emote("frowns at " .. tostring(actor.name) .. " stormily.")
        self:say("Then waste my time no more, and begone!")
        actor:move("north")
        -- Oooh, he gets really mad here.
    end
end$trig$, 'a2593a0535f840f56d6a9edc08aa2e01'),
  -- data/triggers/481/481_102_jemnon_speak1.lua
  (481, 102, $trig$-- Converted from DG Script #48202: jemnon_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
if speech_word == "yes" then
    actor:send("Very inebriated, " .. tostring(self.name) .. " says, 'Then you come t' the right place!  Pull up a chair an' siddown!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Now, whaddya wan' kno 'bout??'")
else
    actor:send(tostring(self.name) .. " says, 'Well I dun wanna talk t' yous anyway!'")
    self:emote("crosses his arms in a huff and turns away.")
end$trig$, '987efc7f1f1e45646f7afaef6c7b8ff5')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
