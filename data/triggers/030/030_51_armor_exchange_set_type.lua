-- Trigger: Armor Exchange set type
-- Zone: 30, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3051

-- Converted from DG Script #3051: Armor Exchange set type
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"tarnished", "worn", "creased", "crushed", "burned", "corroded", "decayed", "rusted", "flimsy"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("armor_exchange") == 0 then
    actor:start_quest("armor_exchange")
end
local armor_id
if string.find(speech, "rusted") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55304
        elseif string.find(speech, "bracer") then
            armor_id = 55308
        else
            armor_id = 55324
        end
    elseif string.find(speech, "boots") then
        armor_id = 55304
    elseif string.find(speech, "bracer") then
        armor_id = 55308
    elseif string.find(speech, "gauntlets") then
        armor_id = 55300
    elseif string.find(speech, "helm") then
        armor_id = 55312
    elseif string.find(speech, "vambraces") then
        armor_id = 55316
    elseif string.find(speech, "greaves") then
        armor_id = 55320
    end
elseif string.find(speech, "flimsy") then
    if string.find(speech, "gloves") then
        armor_id = 55301
    elseif string.find(speech, "boots") then
        armor_id = 55305
    elseif string.find(speech, "bracer") then
        armor_id = 55309
    elseif string.find(speech, "cap") then
        armor_id = 55313
    elseif string.find(speech, "sleeves") then
        armor_id = 55317
    elseif string.find(speech, "leggings") then
        armor_id = 55321
    elseif string.find(speech, "tunic") then
        armor_id = 55325
    end
elseif string.find(speech, "decayed") then
    if string.find(speech, "mittens") then
        armor_id = 55302
    elseif string.find(speech, "slippers") then
        armor_id = 55306
    elseif string.find(speech, "bracelet") then
        armor_id = 55310
    elseif string.find(speech, "turban") then
        armor_id = 55314
    elseif string.find(speech, "sleeves") then
        armor_id = 55318
    elseif string.find(speech, "leggings") then
        armor_id = 55322
    elseif string.find(speech, "robe") then
        armor_id = 55326
    end
elseif string.find(speech, "crushed") then
    if string.find(speech, "leather") then
        if string.find(speech, "gloves") then
            armor_id = 55329
        elseif string.find(speech, "boots") then
            armor_id = 55333
        elseif string.find(speech, "bracer") then
            armor_id = 55337
        elseif string.find(speech, "sleeves") then
            armor_id = 55345
        elseif string.find(speech, "leggings") then
            armor_id = 55349
        elseif string.find(speech, "tunic") then
            armor_id = 55353
        end
    elseif string.find(speech, "hood") then
        armor_id = 55341
    elseif string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55332
        elseif string.find(speech, "bracer") then
            armor_id = 55336
        else
            armor_id = 55352
        end
    elseif string.find(speech, "gauntlets") then
        armor_id = 55328
    elseif string.find(speech, "helm") then
        armor_id = 55340
    elseif string.find(speech, "vambraces") then
        armor_id = 55344
    elseif string.find(speech, "greaves") then
        armor_id = 55348
    end
elseif string.find(speech, "burned") then
    if string.find(speech, "gloves") then
        armor_id = 55330
    elseif string.find(speech, "mittens") then
        armor_id = 55331
    elseif string.find(speech, "boots") then
        armor_id = 55334
    elseif string.find(speech, "slippers") then
        armor_id = 55335
    elseif string.find(speech, "wristband") then
        armor_id = 55338
    elseif string.find(speech, "bracelet") then
        armor_id = 55339
    elseif string.find(speech, "cap") then
        armor_id = 55342
    elseif string.find(speech, "turban") then
        armor_id = 55343
    elseif string.find(speech, "vambraces") then
        armor_id = 55346
    elseif string.find(speech, "sleeves") then
        armor_id = 55347
    elseif string.find(speech, "pants") then
        armor_id = 55350
    elseif string.find(speech, "leggings") then
        armor_id = 55351
    elseif string.find(speech, "jerkin") then
        armor_id = 55354
    elseif string.find(speech, "robe") then
        armor_id = 55355
    end
elseif string.find(speech, "tarnished") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55360
        elseif string.find(speech, "bracer") then
            armor_id = 55364
        else
            armor_id = 55380
        end
    elseif string.find(speech, "boots") then
        armor_id = 55360
    elseif string.find(speech, "bracer") then
        armor_id = 55364
    elseif string.find(speech, "gauntlets") then
        armor_id = 55356
    elseif string.find(speech, "helm") then
        armor_id = 55368
    elseif string.find(speech, "vambraces") then
        armor_id = 55372
    elseif string.find(speech, "greaves") then
        armor_id = 55376
    end
elseif string.find(speech, "worn") then
    if string.find(speech, "mittens") then
        armor_id = 55359
    elseif string.find(speech, "slippers") then
        armor_id = 55363
    elseif string.find(speech, "bracelet") then
        armor_id = 55367
    elseif string.find(speech, "turban") then
        armor_id = 55371
    elseif string.find(speech, "sleeves") then
        armor_id = 55375
    elseif string.find(speech, "leggings") then
        armor_id = 55379
    elseif string.find(speech, "robe") then
        armor_id = 55383
    end
elseif string.find(speech, "corroded") then
    if string.find(speech, "gloves") then
        armor_id = 55358
    elseif string.find(speech, "boots") then
        armor_id = 55362
    elseif string.find(speech, "wristband") then
        armor_id = 55366
    elseif string.find(speech, "cap") then
        armor_id = 55370
    elseif string.find(speech, "vambraces") then
        armor_id = 55374
    elseif string.find(speech, "pants") then
        armor_id = 55378
    elseif string.find(speech, "jerkin") then
        armor_id = 55382
    end
elseif string.find(speech, "creased") then
    if string.find(speech, "gloves") then
        armor_id = 55357
    elseif string.find(speech, "boots") then
        armor_id = 55361
    elseif string.find(speech, "bracer") then
        armor_id = 55365
    elseif string.find(speech, "hood") then
        armor_id = 55369
    elseif string.find(speech, "sleeves") then
        armor_id = 55373
    elseif string.find(speech, "leggings") then
        armor_id = 55377
    elseif string.find(speech, "tunic") then
        armor_id = 55381
    end
end
if not armor_id then
    actor:send(tostring(self.name) .. " tells you, 'I'm sorry, I don't know what that is.'")
else
    actor:send(tostring(self.name) .. " asks you, 'You want " .. objects.template(math.floor(armor_id / 100), armor_id % 100).name .. "?'")
    actor:set_quest_var("armor_exchange", "armor_id", armor_id)
end