-- Trigger: mage_greet
-- Zone: 238, ID: 10
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #23810
--
-- The mage is the ice wand's step 6 crafter: a player on that step is asked about the upgrade
-- (the step, element and weapon come from the LOAD trigger 002_111 through `globals`), and
-- visitors wearing the Sunfire crest (object 237:16) get a nod to their service to his kin.
wait(0.2)
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the " .. tostring(globals.weapon) .. "?")
        end
    end
end

-- Only greet people wearing the Sunfire crest (object 237:16)
if actor:has_equipped(237, 16) then
    wait(2)
    self:command("blink")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Far be it from me to ask how you got that crest...  But it appears you have done a service for one of my kin.")
    wait(2)
    self:say("Perhaps you can help me also in solving a riddle.")
end
