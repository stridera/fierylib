-- Capitalise Lua trigger messages that start with a lowercase article (runtime send no longer capitalises).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/023/023_48_stablehand_list.lua
  (23, 48, $trig$-- Converted from DG Script #2348: stablehand_list
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: list
if not (cmd == "list") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
actor:send("Available pets are:")
actor:send("A steady warhorse - <yellow>40</> c")
return _return_value$trig$, '086a948db99e6e25be016aa725433bd5'),
  -- data/triggers/085/085_53_bishop_room_trig.lua
  (85, 53, $trig$-- Converted from DG Script #8553: bishop room trig
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:find_actor("bishop"):command("abort")
self.room:send(tostring(mobiles.template(85, 14).name) .. " says, 'You've done it!  Norisent must have sent you.  He has great admiration for those of us who dedicate ourselves to restoration magic.  He's sure to be pleased to hear of your involvement.'")
wait(3)
self.room:find_actor("bishop"):say("I must go now, while I have a chance.  Thank you so much!")
wait(3)
self.room:find_actor("bishop"):command("abort")
self.room:send("The bishop starts casting <b:yellow>'word of recall'</>...")
self.room:send("The bishop completes her spell.")
self.room:send("The bishop closes her eyes and utters the words, 'word of recall'.")
self.room:send("The bishop vanishes in a flash of light.")
world.destroy(self.room:find_actor("bishop"))$trig$, '8c753934f3c27797979fab25cf72af18'),
  -- data/triggers/185/185_14_chalice_dropped.lua
  (185, 14, $trig$self.room:send("The DROP trigger for " .. tostring(self.name) .. " is RUNNING")$trig$, 'ed7e04cb6a46361ec59c199ad3edd1fb'),
  -- data/triggers/200/200_23_load_portal.lua
  (200, 23, $trig$-- Converted from DG Script #20023: load _portal
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Yix'Xyua
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yix'xyua")) then
    return true  -- No matching keywords
end
self.room:send("The giant obsidian statue makes a magical gesture and a large black portal erupts from the ground!")
self.room:spawn_object(200, 49)
self.room:send("A giant obsidian statue says, 'When you want to leave just say exit.'")$trig$, '2a1db0e55c651fdc5115b8b11ffd6c5e'),
  -- data/triggers/490/490_42_awura_receive1.lua
  (490, 42, $trig$-- Converted from DG Script #49042: awura_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 49001 then
    wait(2)
    self:destroy_item("griffin-skin")
    if world.count_mobiles(490, 10) == 0 then
        get_room(490, 190):at(function()
            self.room:spawn_mobile(490, 10)
        end)
    end
    if actor:get_quest_stage("griffin_quest") == 7 then
        get_room(490, 190):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 62)
        end)
        get_room(490, 190):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 19)
        end)
        actor:advance_quest("griffin_quest")
        actor:send("<b:white>You have advanced the quest!</>")
    end
    self.room:send("A look of disgust crosses Awura's features as she handles the skin.")
    self:emote("utters a short spell.")
    wait(8)
    self.room:send("The griffin skin turns to smoke and blows away in the breeze.")
    wait(4)
    actor:send("Awura studies you closely, to be sure of your intentions.")
    self.room:send_except(actor, "Awura studies " .. tostring(actor.name) .. " closely, to be sure of " .. tostring(actor.possessive) .. " intentions.")
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", thank you so much for saving our home from Dagon's rule.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'As a small token of gratitude, please accept this helmet.  It is not much, but I pray it will help you in the future.'")
    self.room:spawn_object(490, 61)
    self:command("give helmet " .. tostring(actor.name))
    wait(4)
    self:command("curtsey " .. tostring(actor.name))
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Now, seek out and destroy Dagon's demonic essence, Adramalech.  A portal to its home realm is locked beneath the well.  The cult leader must have had a key of some kind.'")
else
    _return_value = true
    actor:send("<b:white>" .. tostring(self.name) .. " tells you, 'No, thank you.'</>")
end
return _return_value$trig$, '438a34608ec3666dd61c0aebc3f3db42'),
  -- data/triggers/583/583_80_holy_burn_the_wicked.lua
  (583, 80, $trig$if actor.class == "Paladin" then
    if actor.alignment < 750 then
        wait(2)
        self.room:send("The holy blade of Godly vigor dulls in appearance.")
        actor:send("You are no longer holy enough to use this sacred weapon, you can no longer wield it.")
        self.room:send_except(actor, tostring(actor.name) .. "'s blade grows dull, unglowing.")
        actor:command("remove vigor")
    else  -- alignment >= 750
        wait(2)
        self.room:send("The holy blade of Godly vigor glows with a soft, white light.")
        actor:send("Your eyes widen with awe and splendor as you hold the holy blade of Godly vigor.")
        self.room:send_except(actor, tostring(actor.name) .. " is surrounded by a holy glow.")
    end
else  -- Non-paladin wielder
    if actor.alignment < -350 then
        wait(2)
        self.room:send("The holy blade of Godly vigor glows violently!")
        actor:send("The pain in your body is excruciating, you feel death.")
        local var_dam = random(1, 50) + 1517
        self.room:send_except(actor, tostring(actor.name) .. " convulses and life drains from his body. (<yellow>" .. tostring(var_dam) .. "</>)")
        actor:damage(var_dam)  -- type: physical
        -- Note: original DG warned this oforce can syserror if damage kills the victim.
        actor:command("remove vigor")
    else  -- alignment >= -350
        wait(2)
        self.room:send("The holy blade of Godly vigor vibrates unsteadily.")
        actor:send("This blade clearly is not happy to be in your hands.  Take care.")
        self.room:send_except(actor, tostring(actor.name) .. "'s hands shake unsteadily as he holds the blade.")
        actor:command("remove vigor")
    end
end$trig$, '2ca4ee7cfad5c8ebc45621107350a59e')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
