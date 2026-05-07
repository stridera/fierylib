-- Trigger: heavens_gate_starlight_status_checker
-- Zone: 133, ID: 31
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #13331
--
-- "commune" command from inside the Heavens Gate cavern. Reports the actor's
-- progress depending on quest stage:
--   stage 1: prompt for the silver prayer bowl on the pedestal
--   stage 2: list which gate keys have been brought / are still missing
--   stage 3: list which anomaly rifts have been sealed / still pending,
--            plus the cipher phrase revealed so far
--   stage 4: deliver the riddle of the final ritual
--   completed: short acknowledgement
--
-- Quest var schema (must stay in sync with 133_28_pedestal_put,
-- 133_29_key_seal, and 004_33_heavens_gate_progress_journal):
--   gate keys:  heavens_gate:<legacy_id>  (4005, 12142, 23709, 47009,
--                                          49008, 52012, 52013)
--   sealed:     heavens_gate:sealed       (running count, 0..7)
--   sealed rooms: heavens_gate:<room_legacy_id>
--                 (51077, 16407, 16094, 55735, 49024, 55126, 55112)

-- Command filter: must be exactly "commune". Reject the abbreviations
-- DG used to allow ("c", "co", "com", "comm") so they fall through to
-- the normal command interpreter.
if cmd ~= "commune" then
    return true
end

local stage = actor:get_quest_stage("heavens_gate")
local completed = actor:get_has_completed("heavens_gate")

if stage <= 0 and not completed then
    return true
end

actor:send("You extend your awareness to the stars above.")
self.room:send_except(actor, tostring(actor.name) .. " begins to commune with the beam of starlight.")
wait(2)

if stage == 1 then
    actor:send("<b:white>You receive a vision of a silver prayer bowl brought to this cavern and <b:cyan>[put] <b:white>on the <b:cyan>[pedestal]<b:white>.</>")
    return true
end

if stage == 2 then
    local key1 = actor:get_quest_var("heavens_gate:4005")
    local key2 = actor:get_quest_var("heavens_gate:12142")
    local key3 = actor:get_quest_var("heavens_gate:23709")
    local key4 = actor:get_quest_var("heavens_gate:47009")
    local key5 = actor:get_quest_var("heavens_gate:49008")
    local key6 = actor:get_quest_var("heavens_gate:52012")
    local key7 = actor:get_quest_var("heavens_gate:52013")

    actor:send("You receive a vision of seven keys to seven gates brought to the pedestal.")
    if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
        actor:send("You have returned:")
        if key1 then actor:send(tostring(objects.template(40, 5).name)) end
        if key2 then actor:send(tostring(objects.template(120, 142).name)) end
        if key3 then actor:send(tostring(objects.template(237, 9).name)) end
        if key4 then actor:send(tostring(objects.template(470, 9).name)) end
        if key5 then actor:send(tostring(objects.template(490, 8).name)) end
        if key6 then actor:send(tostring(objects.template(520, 12).name)) end
        if key7 then actor:send(tostring(objects.template(520, 13).name)) end
    end
    actor:send("In your mind, you see images of:")
    if not key1 then
        actor:send("<b:cyan>A small skeleton key forged of night and shadow</>")
        actor:send("</>hidden deep in a twisted labyrinth.</>")
    end
    if not key2 then
        actor:send("<b:cyan>A key made from a piece of the black and pitted wood</>")
        actor:send("</>typical of trees in the Twisted Forest near Mielikki.</>")
    end
    if not key3 then
        actor:send("<b:cyan>A large, black key humming with magical energy</>")
        actor:send("</>from a twisted cruel city in a huge underground cavern.</>")
    end
    if not key4 then
        actor:send("<b:cyan>A key covered in oil</>")
        actor:send("</>kept by a long-dead caretaker in a necropolis.</>")
    end
    if not key5 then
        actor:send("<b:cyan>A rusted but well cared for key</>")
        actor:send("</>carried by an enormous griffin.</>")
    end
    -- TODO(parity): legacy DG output the "wrought-iron key" (key6) under
    -- the `if not key7` condition and "fiery beast" (key7) under
    -- `if not key6`. Preserved here verbatim — likely a content-side bug
    -- but cannot be confirmed without the DG source.
    if not key7 then
        actor:send("<b:cyan>A golden plated, wrought-iron key</>")
        actor:send("</>held at the gates to a desecrated city.</>")
    end
    if not key6 then
        actor:send("<b:cyan>One nearly impossible to see</>")
        actor:send("</>guarded by a fiery beast with many heads.</>")
    end
    return true
end

if stage == 3 then
    local sealed = actor:get_quest_var("heavens_gate:sealed") or 0
    local seal1 = actor:get_quest_var("heavens_gate:51077")  -- Nordus
    local seal2 = actor:get_quest_var("heavens_gate:16407")  -- Mystwatch demon
    local seal3 = actor:get_quest_var("heavens_gate:16094")  -- Mystwatch fortress
    local seal4 = actor:get_quest_var("heavens_gate:55735")  -- Black rock trail
    local seal5 = actor:get_quest_var("heavens_gate:49024")  -- Griffin
    local seal6 = actor:get_quest_var("heavens_gate:55126")  -- Huitzipia (war)
    local seal7 = actor:get_quest_var("heavens_gate:55112")  -- Xapizo (death)

    actor:send("Visions of seven rifts in the fabric of reality which you must <b:cyan>seal</> float up in your mind.")

    if seal1 or seal2 or seal3 or seal4 or seal5 or seal6 or seal7 then
        actor:send("You have already sealed the rifts in:")
        if seal1 then actor:send(tostring(get_room(510, 77).name)) end
        if seal2 then actor:send(tostring(get_room(164, 7).name)) end
        if seal3 then actor:send(tostring(get_room(160, 94).name)) end
        if seal4 then actor:send(tostring(get_room(557, 35).name)) end
        if seal5 then actor:send(tostring(get_room(490, 24).name)) end
        if seal6 then actor:send(tostring(get_room(551, 26).name)) end
        if seal7 then actor:send(tostring(get_room(551, 12).name)) end
    end

    actor:send("You see visions of:")
    if not seal1 then
        actor:send("<b:cyan>An arch hidden in another plane</>")
        actor:send("</>granting demons access to an enchanted village of mutants.</>")
    end
    if not seal2 then
        actor:send("<b:cyan>An archway that delivers demons</>")
        actor:send("</>to the fortress of the dead.</>")
    end
    if not seal3 then
        actor:send("<b:cyan>A portal from a fortress of the undead</>")
        actor:send("</>to a realm of demons.</>")
    end
    if not seal4 then
        actor:send("<b:cyan>A portal from black rock</>")
        actor:send("</>to black ice.</>")
    end
    if not seal5 then
        actor:send("<b:cyan>A pool hidden under a well</>")
        actor:send("</>on an island filled with ferocious beasts.</>")
    end
    if not seal6 then
        actor:send("<b:cyan>A pool in a temple of ice and stone</>")
        actor:send("</>leading to the realm of a war god.</>")
    end
    if not seal7 then
        actor:send("<b:cyan>A pool in a temple of ice and stone</>")
        actor:send("</>leading to the realm of a death god.</>")
    end

    -- Cipher phrase reveal — one chunk per sealed rift.
    local phrase_steps = {
        "yamo lv",
        "yamo lv soeeiy",
        "yamo lv soeeiy vrtvln",
        "yamo lv soeeiy vrtvln eau okia khz",
        "yamo lv soeeiy vrtvln eau okia khz lrrvzryp",
        "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj",
        "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie",
    }
    local phrase = phrase_steps[sealed]
    if phrase then
        actor:send("Words float up in your mind: <b:cyan>" .. phrase .. "</>")
    end

    actor:send("If you need a new Key, beseech the starlight, <b:cyan>\"Grant me a new key\"</>.")
    return true
end

if stage == 4 then
    actor:send("The starlight manifests as the heavenly raven again.")
    actor:send("This time, at last, it speaks:_")
    actor:send("<b:cyan>'I I I I am the book.  Open me prophet; read; decypher.</>")
    actor:send("<b:cyan>On you, in you, in your blood, they write, have written.</>")
    actor:send("<b:cyan>Speak it but aloud to know the path of heaven for I I I I am the final key.</>")
    actor:send("<b:cyan>I I I I have shown you visions, and through me you shall read.'</>_")
    actor:send("<yellow>yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi</>")
    return true
end

if completed then
    actor:send("<b:cyan>You feel you have learned all you can from this place.</>")
end

return true
