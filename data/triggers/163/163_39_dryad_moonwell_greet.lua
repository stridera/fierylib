-- Trigger: dryad_moonwell_greet
-- Zone: 163, ID: 39
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #16339
--
-- The bound dryad greets a druid visitor. Each moonwell_spell_quest stage gets
-- its own prompt asking for the next item. Pre-quest druids of sufficient
-- level get the introductory line; under-level druids get a "come back later".

if actor.class ~= "druid" then
    return true
end

if actor.level < 73 then
    wait(5)
    actor:send(tostring(self.name) .. " looks you over and says, 'It is good to see a druid again, but you\n"
        .. "</>have not yet seen enough of the world to help me.  Please come back when you\n"
        .. "</>are more experienced.'")
    self.room:send_except(actor, tostring(self.name) .. " tells " .. tostring(actor.name) .. " something.")
    return true
end

local stage = actor:get_quest_stage("moonwell_spell_quest")
if stage == 1 or stage == 2 then
    wait(5)
    if actor.gender == "male" then
        actor:send(tostring(self.name) .. " tells you, 'Welcome back Brother.'")
    elseif actor.gender == "female" then
        actor:send(tostring(self.name) .. " tells you, 'Welcome back Sister.'")
    end
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Have you recovered the Vine of Mielikki?!  Please give it\n"
        .. "</>to me.'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 3 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Do you have the stone?  Please, give it to me!'")
    self:command("smile " .. tostring(actor.name))
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 4 or stage == 5 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Do you have the flask?  Please give it to me if you do!'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 6 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Did you get the stone of power?  Please give it to me!'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 7 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Do you have the orb from the dark fortress?  Please give\n"
        .. "</>me the orb.'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 8 or stage == 9 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'The second stone of power, you have it?  Please give it\n"
        .. "</>to me, we are almost complete!'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 10 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'The orb to balance the ritual, do you have it?  Please\n"
        .. "</>give me the orb!'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
elseif stage == 11 or stage == 12 then
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'The last stone of power, do you have it?  Please give me\n"
        .. "</>the last relic and we are finished!'")
    self.room:send_except(actor, tostring(self.name) .. " asks " .. tostring(actor.name) .. " something.")
else
    wait(5)
    self.room:send(tostring(self.name) .. " weeps lightly.")
    wait(10)
    self.room:send_except(actor, tostring(self.name) .. " takes notice of " .. tostring(actor.name) .. " and quickly wipes her tears.")
    actor:send(tostring(self.name) .. " takes notice of you and quickly wipes her tears.")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Hello fellow of the Order.'")
    self.room:send_except(actor, tostring(self.name) .. " tells something to " .. tostring(actor.name) .. ".")
    wait(10)
    actor:send(tostring(self.name) .. " tells you, 'It is good to see a promising druid again.'")
    self.room:send(tostring(self.name) .. " smiles through her tears.")
end
