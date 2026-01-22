-- Trigger: Armor Exchange set type
-- Zone: 30, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--   Large script: 8203 chars
--
-- Original DG Script: #3051

-- Converted from DG Script #3051: Armor Exchange set type
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: tarnished worn creased crushed burned corroded decayed rusted flimsy
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tarnished") or string.find(string.lower(speech), "worn") or string.find(string.lower(speech), "creased") or string.find(string.lower(speech), "crushed") or string.find(string.lower(speech), "burned") or string.find(string.lower(speech), "corroded") or string.find(string.lower(speech), "decayed") or string.find(string.lower(speech), "rusted") or string.find(string.lower(speech), "flimsy")) then
    return true  -- No matching keywords
end
wait(2)
if not actor:get_quest_stage("armor_exchange") then
    actor:start_quest("armor_exchange")
end
if string.find(speech, "rusted") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            local armor_vnum = 55304
        elseif string.find(speech, "bracer") then
            local armor_vnum = 55308
        else
            local armor_vnum = 55324
        end
    elseif string.find(speech, "boots") then
        local armor_vnum = 55304
    elseif string.find(speech, "bracer") then
        local armor_vnum = 55308
    elseif string.find(speech, "gauntlets") then
        local armor_vnum = 55300
    elseif string.find(speech, "helm") then
        local armor_vnum = 55312
    elseif string.find(speech, "vambraces") then
        local armor_vnum = 55316
    elseif string.find(speech, "greaves") then
        local armor_vnum = 55320
    end
elseif string.find(speech, "flimsy") then
    if string.find(speech, "gloves") then
        local armor_vnum = 55301
    elseif string.find(speech, "boots") then
        local armor_vnum = 55305
    elseif string.find(speech, "bracer") then
        local armor_vnum = 55309
    elseif string.find(speech, "cap") then
        local armor_vnum = 55313
    elseif string.find(speech, "sleeves") then
        local armor_vnum = 55317
    elseif string.find(speech, "leggings") then
        local armor_vnum = 55321
    elseif string.find(speech, "tunic") then
        local armor_vnum = 55325
    end
elseif string.find(speech, "decayed") then
    if string.find(speech, "mittens") then
        local armor_vnum = 55302
    elseif string.find(speech, "slippers") then
        local armor_vnum = 55306
    elseif string.find(speech, "bracelet") then
        local armor_vnum = 55310
    elseif string.find(speech, "turban") then
        local armor_vnum = 55314
    elseif string.find(speech, "sleeves") then
        local armor_vnum = 55318
    elseif string.find(speech, "leggings") then
        local armor_vnum = 55322
    elseif string.find(speech, "robe") then
        local armor_vnum = 55326
    end
elseif string.find(speech, "crushed") then
    if string.find(speech, "leather") then
        if string.find(speech, "gloves") then
            local armor_vnum = 55329
        elseif string.find(speech, "boots") then
            local armor_vnum = 55333
        elseif string.find(speech, "bracer") then
            local armor_vnum = 55337
        elseif string.find(speech, "sleeves") then
            local armor_vnum = 55345
        elseif string.find(speech, "leggings") then
            local armor_vnum = 55349
        elseif string.find(speech, "tunic") then
            local armor_vnum = 55353
        end
    elseif string.find(speech, "hood") then
        local armor_vnum = 55341
    elseif string.find(speech, "plate") then
        if string.find(speech, "boots") then
            local armor_vnum = 55332
        elseif string.find(speech, "bracer") then
            local armor_vnum = 55336
        else
            local armor_vnum = 55352
        end
    elseif string.find(speech, "gauntlets") then
        local armor_vnum = 55328
    elseif string.find(speech, "helm") then
        local armor_vnum = 55340
    elseif string.find(speech, "vambraces") then
        local armor_vnum = 55344
    elseif string.find(speech, "greaves") then
        local armor_vnum = 55348
    end
elseif string.find(speech, "burned") then
    if string.find(speech, "gloves") then
        local armor_vnum = 55330
    elseif string.find(speech, "mittens") then
        local armor_vnum = 55331
    elseif string.find(speech, "boots") then
        local armor_vnum = 55334
    elseif string.find(speech, "slippers") then
        local armor_vnum = 55335
    elseif string.find(speech, "wristband") then
        local armor_vnum = 55338
    elseif string.find(speech, "bracelet") then
        local armor_vnum = 55339
    elseif string.find(speech, "cap") then
        local armor_vnum = 55342
    elseif string.find(speech, "turban") then
        local armor_vnum = 55343
    elseif string.find(speech, "vambraces") then
        local armor_vnum = 55346
    elseif string.find(speech, "sleeves") then
        local armor_vnum = 55347
    elseif string.find(speech, "pants") then
        local armor_vnum = 55350
    elseif string.find(speech, "leggings") then
        local armor_vnum = 55351
    elseif string.find(speech, "jerkin") then
        local armor_vnum = 55354
    elseif string.find(speech, "robe") then
        local armor_vnum = 55355
    end
elseif string.find(speech, "tarnished") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            local armor_vnum = 55360
        elseif string.find(speech, "bracer") then
            local armor_vnum = 55364
        else
            local armor_vnum = 55380
        end
    elseif string.find(speech, "boots") then
        local armor_vnum = 55360
    elseif string.find(speech, "bracer") then
        local armor_vnum = 55364
    elseif string.find(speech, "gauntlets") then
        local armor_vnum = 55356
    elseif string.find(speech, "helm") then
        local armor_vnum = 55368
    elseif string.find(speech, "vambraces") then
        local armor_vnum = 55372
    elseif string.find(speech, "greaves") then
        local armor_vnum = 55376
    end
elseif string.find(speech, "worn") then
    if string.find(speech, "mittens") then
        local armor_vnum = 55359
    elseif string.find(speech, "slippers") then
        local armor_vnum = 55363
    elseif string.find(speech, "bracelet") then
        local armor_vnum = 55367
    elseif string.find(speech, "turban") then
        local armor_vnum = 55371
    elseif string.find(speech, "sleeves") then
        local armor_vnum = 55375
    elseif string.find(speech, "leggings") then
        local armor_vnum = 55379
    elseif string.find(speech, "robe") then
        local armor_vnum = 55383
    end
elseif string.find(speech, "corroded") then
    if string.find(speech, "gloves") then
        local armor_vnum = 55358
    elseif string.find(speech, "boots") then
        local armor_vnum = 55362
    elseif string.find(speech, "wristband") then
        local armor_vnum = 55366
    elseif string.find(speech, "cap") then
        local armor_vnum = 55370
    elseif string.find(speech, "vambraces") then
        local armor_vnum = 55374
    elseif string.find(speech, "pants") then
        local armor_vnum = 55378
    elseif string.find(speech, "jerkin") then
        local armor_vnum = 55382
    end
elseif string.find(speech, "creased") then
    if string.find(speech, "gloves") then
        local armor_vnum = 55357
    elseif string.find(speech, "boots") then
        local armor_vnum = 55361
    elseif string.find(speech, "bracer") then
        local armor_vnum = 55365
    elseif string.find(speech, "hood") then
        local armor_vnum = 55369
    elseif string.find(speech, "sleeves") then
        local armor_vnum = 55373
    elseif string.find(speech, "leggings") then
        local armor_vnum = 55377
    elseif string.find(speech, "tunic") then
        local armor_vnum = 55381
    end
end
if not armor_vnum then
    actor:send(tostring(self.name) .. " tells you, 'I'm sorry, I don't know what that is.'")
else
    actor:send(tostring(self.name) .. " asks you, 'You want " .. "%get.obj_shortdesc[%armor_vnum%]%?'")
    actor:set_quest_var("armor_exchange", "armor_vnum", armor_vnum)
end