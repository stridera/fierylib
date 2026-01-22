-- Trigger: ice_shards_khysan_receive2
-- Zone: 103, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10319

-- Converted from DG Script #10319: ice_shards_khysan_receive2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("ice_shards")
if stage == 2 then
    wait(2)
    actor.name:advance_quest("ice_shards")
    self:destroy_item("book")
    self:emote("cautiously takes " .. tostring(object.shortdesc) .. " and places it on the reception desk.")
    wait(2)
    self:say("Yikes, this looks pretty dangerous.")
    self:emote("opens " .. tostring(object.shortdesc) .. " and begins to read.")
    wait(3)
    self:emote("quietly continues to read.")
    wait(2)
    self:say("The Codex talks extensively about the wars fought in Frost Valley and the surrounding areas.  It says the Frost Elves have been here since long before people arrived in Technitzitlan.")
    wait(1)
    self:say("The Codex also says something catastrophic happened to the elves' majestic city Shiran \"ages ago,\" though it doesn't say what or when exactly.")
    wait(7)
    self:emote("closes " .. tostring(object.shortdesc) .. ".")
    wait(3)
    self:say("But the fact that the elves are still here must mean something, right?")
    wait(3)
    self:say("Frost Valley is one of the only places left in Caelia where elves are frequently spotted.")
    wait(3)
    self:say("They've been locked in combat with a group of Amazons just east of here.  Why, I don't know, but I do know they've been skirmishing for a long time.")
    wait(4)
    self:say("The commander of the ice warriors, Thraja, certainly knows more.  Go and see if she keeps any records or journals.")
    wait(3)
    self:say("Bring back anything you find and we can look over it together.")
end