-- Trigger: heavens_gate_key_seal
-- Zone: 133, ID: 29
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #13329
--
-- "seal <rift|portal|pool|arch>" command for the Key of Heaven (133, 51).
-- Lives on the key. The actor must be on stage 3 of the heavens_gate quest
-- and standing in one of the seven anomaly rooms. Sealing destroys the
-- room's anomaly object, marks the room sealed in quest vars, and reveals
-- one more word of the closing phrase. Sealing the seventh rift advances
-- the quest to stage 4 and beckons the actor back to the cavern.
--
-- Anomaly rooms (legacy IDs preserved as quest_var keys; same scheme as
-- 133_31_status_checker):
--   51077 (510, 77)  Nordus arch
--   16407 (164,  7)  Mystwatch demon arch
--   16094 (160, 94)  Mystwatch fortress portal
--   55735 (557, 35)  Black rock trail portal
--   49024 (490, 24)  Griffin pool
--   55126 (551, 26)  Huitzipia (war) pool
--   55112 (551, 12)  Xapizo (death) pool

-- Command filter: seal
if cmd ~= "seal" then
    return true
end

if not (string.find(arg, "rift") or string.find(arg, "portal")
     or string.find(arg, "pool") or string.find(arg, "arch")) then
    return true
end

if actor:get_quest_stage("heavens_gate") ~= 3 then
    return true
end

local room_legacy_id = self.room.zone_id * 100 + self.room.local_id

local anomaly_rooms = {
    [51077] = "arch",
    [16407] = "arch",
    [16094] = "portal",
    [55735] = "portal",
    [49024] = "energy",
    [55126] = "energy",
    [55112] = "energy",
}

local anomaly_keyword = anomaly_rooms[room_legacy_id]
if not anomaly_keyword then
    actor:send("There are no active rifts here to seal.")
    return true
end

local room_var = "heavens_gate:" .. tostring(room_legacy_id)
if actor:get_quest_var(room_var) then
    actor:send("You have already sealed this anomaly.")
    return true
end

actor:set_quest_var("heavens_gate", tostring(room_legacy_id), 1)
actor:send("You begin to chant...")
self.room:send_except(actor, tostring(actor.name) .. " begins to chant...")
actor:send("The power of the heavens courses through " .. tostring(self.shortdesc) .. ".")
wait(2)
self.room:send(tostring(self.shortdesc) .. " begins to burn with a fierce energy!")
wait(2)
self.room:send("Brilliant rays of light shoot out of " .. tostring(self.shortdesc) .. ", sealing the dimensional portal!")

world.destroy(self.room:find_object(anomaly_keyword))

-- Special case: Nordus seals also sweep the room contents to (510, 3).
if room_legacy_id == 51077 then
    self.room:teleport_all(get_room(510, 3))
end

local sealed = (actor:get_quest_var("heavens_gate:sealed") or 0) + 1
actor:set_quest_var("heavens_gate", "sealed", sealed)
wait(1)

-- Each step appends one more chunk of the cipher to be revealed.
local phrase_steps = {
    "yamo lv",
    "yamo lv soeeiy",
    "yamo lv soeeiy vrtvln",
    "yamo lv soeeiy vrtvln eau okia khz",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi",
}

local phrase = phrase_steps[sealed]
if phrase then
    actor:send("As the rift collapses, words float up in your mind:")
    actor:send("<b:white>" .. phrase .. "</>")
end

if sealed == 7 then
    wait(2)
    local room = get_room(133, 58)
    actor:send("<b:white>A vision of starlight beckons you back to " .. tostring(room.name) .. ".</>")
    actor:advance_quest("heavens_gate")
end

return true
