-- Trigger: Hakujo refuse
-- Zone: 53, ID: 44
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5344

-- Converted from DG Script #5344: Hakujo refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local treasurestage = actor:get_quest_stage("elemental_chaos")
local visionstage = actor:get_quest_stage("monk_vision")
-- switch on object.id
if object.id == 390 or object.id == 59006 or object.id == 55582 or object.id == 391 or object.id == 18505 or object.id == 55591 or object.id == 392 or object.id == 8501 or object.id == 55623 or object.id == 393 or object.id == 12532 or object.id == 55655 or object.id == 394 or object.id == 16209 or object.id == 55665 or object.id == 395 or object.id == 43013 or object.id == 55678 or object.id == 396 or object.id == 53009 or object.id == 55710 or object.id == 397 or object.id == 58415 or object.id == 55722 or object.id == 398 or object.id == 58412 or object.id == 55741 or object.id == 5320 or object.id == 5321 or object.id == 5322 or object.id == 5323 or object.id == 5324 or object.id == 5325 or object.id == 5326 or object.id == 5327 or object.id == 5328 or object.id == 5329 then
    return _return_value
else
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
end
return _return_value