-- Trigger: crowley_receive1
-- Zone: 490, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49015

-- Converted from DG Script #49015: crowley_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 49001 then
    _return_value = true
    wait(4)
    self:emote("examines the griffin skin carefully.")
    self.room:send(tostring(self.name) .. " says, 'This is fantastic!  You have defeated his earthly form!")
    self.room:send("</>However, this was merely a material manifestation, and his true incarnation")
    self.room:send("</>continues its nefarious existence.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Please, I beg of you, find and destroy him, before he")
    self.room:send("</>gathers the strength to return as Dagon yet again!'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Oh!  I nearly forgot.  This belongs to you, if you can")
    self.room:send("</>bear to touch it.'")
    self:command("give griffin-skin " .. tostring(actor.name))
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you can't bear to use it, give it to Awura who will")
    self.room:send("</>destroy it.  Maybe she will give you something more to your taste.'")
elseif object.id == 49042 then
    _return_value = true
    wait(8)
    self:emote("looks rather surprised.")
    wait(2)
    self:say("Well now, you found it!  How very resourceful of you!")
    wait(2)
    self:emote("peers suspiciously into " .. tostring(object.shortdesc) .. ".")
    wait(2)
    if object.val1 ~= 16 then
        self:command("glare " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Well you had to help yourself, now, didn't you!")
        self.room:send("</>You have no idea how thirs*HIC* I am!  Bah.'")
        wait(2)
        self:command("drop clear-glass-bottle")
    elseif object.val2 ~= 5 then
        self:say("What's this?  I'm not drinking that!")
        self:command("glare " .. "%actor.name")
        wait(2)
        self:command("drop clear-glass-bottle")
    else
        self:emote("smiles and takes a healthy swig from " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("Thank you, " .. tostring(actor.name) .. ".  You're a lifesaver!")
        self:destroy_item("clear-glass-bottle")
        wait(2)
        self:emote("staggers a bit as he carefully pours the whiskey into his waterskin.")
        self.room:spawn_object(490, 66)
        self:command("drop mirror-lettered-scroll")
    end
else
    _return_value = false
    wait(1)
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'No, thank you.'</>")
end
return _return_value