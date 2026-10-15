-- Trigger: 3eg_trophy
-- Zone: 55, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: TODO(parity)
--
-- TODO(parity): The list of "items we're interested in" prints raw
-- `%get.obj_shortdesc[%id_trophyN%]%` placeholders. Replace each line
-- with `objects.template(55, id_trophyN).name`. (The trophy IDs here
-- are already small integers -- 5503..5515 -- but those are legacy
-- 5-digit vnums; re-derive once the trophy items are catalogued under
-- (zone, local_id).)
--
-- Original DG Script: #5509

-- Converted from DG Script #5509: 3eg_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
local id_trophy1 = 5503
local id_trophy2 = 5505
local id_trophy3 = 5507
local id_trophy4 = 5509
local id_trophy5 = 5511
local id_trophy6 = 5513
local id_trophy7 = 5515
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Black")
    actor:send("</>Legion you will periodically find goods on their bodies that we will want in")
    actor:send("</>order to prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy1%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy2%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy3%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy4%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy5%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy6%]%")
    actor:send("- " .. "%get.obj_shortdesc[%id_trophy7%]%")
end