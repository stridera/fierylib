-- Trigger: 3bl_trophy
-- Zone: 55, ID: 10
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: TODO(parity)
--
-- TODO(parity): Mirror of 3eg_trophy (055_09). The "items we're
-- interested in" list prints raw `%get.obj_shortdesc[%id_trophyN%]%`
-- placeholders -- swap to `objects.template(55, id_trophyN).name` once
-- the trophy items are re-mapped to (zone, local_id).
--
-- Original DG Script: #5510

-- Converted from DG Script #5510: 3bl_trophy
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
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local id_trophy1 = 5504
local id_trophy2 = 5506
local id_trophy3 = 5508
local id_trophy4 = 5510
local id_trophy5 = 5512
local id_trophy6 = 5514
local id_trophy7 = 5516
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Eldorian Guard you")
    actor:send("</>will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
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