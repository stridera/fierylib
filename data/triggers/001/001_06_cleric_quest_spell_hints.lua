-- Trigger: Cleric Quest Spell Hints
-- Zone: 1, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #106

-- Converted from DG Script #106: Cleric Quest Spell Hints
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: heal heal? resurrect resurrect? group group? dragon dragon? dragons dragons? health health?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "heal") or string.find(string.lower(speech), "heal?") or string.find(string.lower(speech), "resurrect") or string.find(string.lower(speech), "resurrect?") or string.find(string.lower(speech), "group") or string.find(string.lower(speech), "group?") or string.find(string.lower(speech), "dragon") or string.find(string.lower(speech), "dragon?") or string.find(string.lower(speech), "dragons") or string.find(string.lower(speech), "dragons?") or string.find(string.lower(speech), "health") or string.find(string.lower(speech), "health?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
-- switch on speech
if string.find(self.class, "cleric") or string.find(self.class, "priest") then
    if speech == "heal" or speech == "heal?" or speech == "group" or speech == "group?" or speech == "armor" or speech == "armor?" then
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
    if string.find(self.class, "cleric") or string.find(self.class, "priest") or string.find(self.class, "diabolist") then
    elseif speech == "resurrect" or speech == "resurrect?" then
        self.room:send(tostring(self.name) .. " says, 'Yes, it is possible to <b:cyan>Resurrect</> the dead.'")
        self.room:send("'However the secrets of it have been lost over the centuries. Only'")
        self.room:send("'someone with knowledge of ages past may have a chance of still knowing such'")
        self.room:send("'magics.'")
        -- (empty room echo)
        self.room:send("'There are rumors that nigh-immortal supplicants orship in the darkest of'")
        self.room:send("'traditions. Perhaps someone in the most trecherous of religious houses would'")
        self.room:send("'know where to begin.'")
    elseif string.find(self.class, "necromancer") then
        self:say("Just use &9<blue>Animate Dead</>. Isn't that enough for you?")
    else
        self:say("I'm afraid I know little about returning the dead")
        self.room:send("'to life.'")
    end
    if string.find(self.class, "cleric") or self.class == "priest" then
    elseif speech == "dragon" or speech == "dragon?" or speech == "dragons" or speech == "dragons?" or speech == "health" or speech == "health?" then
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
    _return_value = false
end
return _return_value