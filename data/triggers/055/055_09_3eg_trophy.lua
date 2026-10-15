-- Trigger: 3eg_trophy
-- Zone: 55, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: TODO(parity)
--
-- The "items we're interested in" list resolves each trophy vnum (zone * 100 + id)
-- through proto_short().
--
-- Original DG Script: #5509

-- Converted from DG Script #5509: 3eg_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
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
    actor:send("- " .. proto_short(id_trophy1))
    actor:send("- " .. proto_short(id_trophy2))
    actor:send("- " .. proto_short(id_trophy3))
    actor:send("- " .. proto_short(id_trophy4))
    actor:send("- " .. proto_short(id_trophy5))
    actor:send("- " .. proto_short(id_trophy6))
    actor:send("- " .. proto_short(id_trophy7))
end