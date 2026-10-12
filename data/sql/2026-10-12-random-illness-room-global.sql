-- Fix bare global room (nil in runtime) -> self.room.actors; 22:15 also guards empty rooms
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
  -- data/triggers/016/016_89_fireplace_burns.lua
  (16, 89, $trig$-- Converted from DG Script #1689: Fireplace_burns
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if self.actor_count > 0 then
    local damage = random(1, 6) + 6
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            victim:send("The roaring fire flares up, but you are well protected from its blaze.")
            self.room:send_except(victim, "A flare within the fire engulfs " .. tostring(victim.name) .. ", but " .. tostring(victim.name) .. " is well protected against the inferno.")
        else
            victim:send("The roaring fire flares up, burning you! (<red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " cries out in pain as " .. tostring(victim.name) .. " is burned by the fire! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$, 'ff1b7c3a4bc2b013227f21fe3101b851'),
  -- data/triggers/022/022_11_succubus_emot_damage.lua
  (22, 11, $trig$-- Converted from DG Script #2211: Succubus_Emot_Damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local target = 0
local loop = 0
while target == 0 do
    local dice = random(1, 50)
    local damage = 75 + dice
    local victim = self.room.actors[random(1, #self.room.actors)]
    if (victim.is_npc) or (victim.gender ~= "Male") then
        if loop > 10 then
            target = 1
        else
            loop = loop + 1
        end
    else
        target = 1
        local message = random(1, 4)
        -- switch on message
        if message == 1 then
            self.room:send_except(victim, "A Succubus reaches in and fondles " .. tostring(victim.name) .. " gently. (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus reaches in and fondles you gently. (<b:red>" .. tostring(damage) .. "</>)")
        elseif message == 2 then
            self.room:send_except(victim, "A Succubus kisses " .. tostring(victim.name) .. " passionately... (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus kisses you passionately, it seems to last forever... (<b:red>" .. tostring(damage) .. "</>)")
        elseif message == 3 then
            self.room:send_except(victim, "A Succubus gropes at " .. tostring(victim.name) .. ". How inappropriate! (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus gropes you wildly! Boy does that feel good! (<b:red>" .. tostring(damage) .. "</>)")
        else
            self.room:send_except(victim, "A Succubus strokes " .. tostring(victim.name) .. "'s inner thigh. (<blue>" .. tostring(damage) .. "</>)")
            victim:send("A Succubus strokes your inner thigh. She's getting frisky! (<b:red>" .. tostring(damage) .. "</>)")
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
        target = 1
    end
end$trig$, '9f2d7e1898f52b3f300399c12c4f1221'),
  -- data/triggers/022/022_13_incubus_emot_damage.lua
  (22, 13, $trig$-- Converted from DG Script #2213: Incubus_Emot_Damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local dice = random(1, 50)
local damage = 100 + dice
local victim = self.room.actors[random(1, #self.room.actors)]
if victim.is_player then
    if victim.gender == "Female" then
        self.room:send_except(victim, "The Incubus grabs hold of " .. tostring(victim.name) .. " and gives her a passionate kiss. (<blue>" .. tostring(damage) .. "</>)")
        victim:send("The Incubus grabs you tenderly and gives you an amazingly passionate kiss... (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
end$trig$, '5e1e6c078ffb83ae878c8b82e325b654'),
  -- data/triggers/022/022_15_random_illness_trigger.lua
  (22, 15, $trig$-- Converted from DG Script #2215: Random_Illness_Trigger
-- Original: WORLD trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
local occupants = self.room.actors
if #occupants > 0 then
    local victim = occupants[random(1, #occupants)]
    if victim.is_player then
        local message = random(1, 3)
        -- switch on message
        if message == 1 then
            self.room:send_except(victim, "A tiny, vicious bug buzzes around " .. tostring(victim.name) .. ", landing on " .. tostring(victim.possessive) .. " arm and biting " .. tostring(victim.object) .. ".")
            victim:send("A tiny, vicious bug buzzes around you before landing on your arm and biting you!")
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " begins to look pale and starts shivering. (<blue>50</>)")
            victim:send("You turn pale and shiver as nausea begins to set in. (<b:red>50</>)")
            victim:damage(50)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " falls over in pain as " .. tostring(victim.name) .. " begins to purge his stomach (<blue>100</>)")
            victim:send("You fall over in pain as you being to vomit all over the floor. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
        elseif message == 2 then
            self.room:send_except(victim, tostring(victim.name) .. " trips on a rock and cuts " .. tostring(victim.object) .. "self on a rusted blade. (<blue>50</>)")
            victim:send("You trip on a rock, cutting yourself on a rusted blade. (<b:red>50</>)")
            wait(15)
            victim:damage(50)  -- type: physical
            self.room:send_except(victim, tostring(victim.name) .. " beings to twitch uncontrollably. (<blue>100</>)")
            victim:send("You begin to twitch uncomfortably as a cold shiver runs through your body. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " arches " .. tostring(victim.possessive) .. " back painfully and loses all control. (<blue>150</>)")
            victim:send("Uncontrollably you arch your back, causing extreme pain! (<b:red>150</>)")
            victim:damage(150)  -- type: physical
        else
            self.room:send_except(victim, tostring(victim.name) .. " beings to cough endlessly. (<blue>50</>)")
            victim:send("Something seems caught in your throat as you coughing harshly. (<b:red>50</>)")
            victim:damage(50)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " gasps for air as " .. tostring(victim.name) .. " continues to cough. (<blue>100</>)")
            victim:send("You gasp wildly for air as you continue to cough. (<b:red>100</>)")
            victim:damage(100)  -- type: physical
            wait(15)
            self.room:send_except(victim, tostring(victim.name) .. " chokes wildly in an attempt to get air. Nearly passing out! (<blue>150</>)")
            victim:send("Lack of air causes you to nearly pass out as you choke in an attempt to obtain oxygen. (<b:red>150</>)")
            victim:damage(150)  -- type: physical
        end
    end
end$trig$, '8d65a85cd0bc8466e6c0fde94a83e128'),
  -- data/triggers/022/022_22_nezer_head_rip_1.lua
  (22, 22, $trig$-- Converted from DG Script #2222: Nezer_head_rip_1
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(5)
-- Let's see how many casters we have in the room.
local casters = 0
for _, victim in ipairs(self:get_people()) do
    if (victim.is_player) and (victim.level < 100) then
        if string.find(victim.class, "Cleric") or string.find(victim.class, "Priest") or string.find(victim.class, "Druid") or string.find(victim.class, "Diabolist") or string.find(victim.class, "Sorcerer") or string.find(victim.class, "Cryomancer") or string.find(victim.class, "Pyromancer") or string.find(victim.class, "Necromancer") then
            casters = casters + 1
        end
    end
end
-- So if we have casters, pick one, we don't want the same
-- one or to have a set order, so lets pick a random caster.
if casters > 0 then
    local gotyou = 0
    local target = nil
    while gotyou == 0 do
        target = self.room.actors[random(1, #self.room.actors)]
        if string.find(target.class, "Cleric") or string.find(target.class, "Priest") or string.find(target.class, "Druid") or string.find(target.class, "Diabolist") or string.find(target.class, "Sorcerer") or string.find(target.class, "Cryomancer") or string.find(target.class, "Pyromancer") or string.find(target.class, "Necromancer") then
            gotyou = gotyou + 1
        end
    end
    victim = target
    -- Hello target, now you must die!
    local message = 1
    local keepgoing = 1
    while keepgoing == 1 do
        -- TODO(parity): legacy check `victim.room == 2216` (vnum) — verify victim is in arena room (22, 16)
        if victim.room and victim.room.zone_id == 22 and victim.room.local_id == 16 then
            -- switch on message
            if message == 1 then
                self.room:send_except(victim, tostring(victim.name) .. "'s magic catches the attention of one of Nezer's heads.")
                victim:send("One of Nezer's heads suddenly takes notice of you.'")
            elseif message == 2 then
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. ", who only barely side steps the attack.")
                victim:send("You just barely side step a bite by Nezer's head. Lucky you.")
            elseif message == 3 then
                local damage = random(1, 20)
                damage = damage + 105
                self.room:send_except(victim, "Nezer's head darts at " .. tostring(victim.name) .. " again, this time grabbing " .. tostring(victim.possessive) .. " in his razor sharp teeth! (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's head darts at you again, this time grabbing at you with it's shapr teeth, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 4 then
                local damage = random(1, 20)
                damage = damage + 150
                self.room:send_except(victim, "Nezer's second head notices the first chewing on something. (<blue>" .. tostring(damage) .. "</>)")
                victim:send("Nezer's second head notices you as the first chomps down on you hard, OUCH! (<b:red>" .. tostring(damage) .. "</>)")
                local damage_dealt = victim:damage(damage)  -- type: physical
            elseif message == 5 then
                self.room:send_except(victim, "Nezer's second head bites onto the half of " .. tostring(victim.name) .. " that was sticking out before RIPPING " .. tostring(victim.possessive) .. " in half! (<blue>DEAD</>)")
                victim:send("Nezer's second head bites onto the half of you that wasn't already being consumed before RIPPING you in half! You are DEAD! (<b:red>DEAD</>)")
                victim:damage(10000)  -- type: physical
                keepgoing = keepgoing + 1
            else
            end
        else
            self.room:send("Nezer looks around for something that is no longer there.")
            keepgoing = keepgoing + 1
        end
        wait(8)
        message = message + 1
    end
end$trig$, '96ca489e9af3bfaf3a31a36ab75ca1cf'),
  -- data/triggers/022/022_42_belial_return_banter.lua
  (22, 42, $trig$-- Converted from DG Script #2242: belial_return_banter
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Belial's Return Banter
local banter = random(1, 6)
local victim = self.room.actors[random(1, #self.room.actors)]
-- switch on banter
if banter == 1 then
    wait(2)
    self.room:send("Belial says in common, 'Once more must we play this game?'")
    self.room:send("Belial says in common, 'By now, you know you can't defeat a crowned Prince of the Nines.'")
elseif banter == 2 then
    wait(2)
    self.room:send("Belial says in common, 'How I tired of this foolishness...'")
    self.room:send("Belial says in common, 'You are but a gnat to be squished forthwith.'")
elseif banter == 3 then
    wait(2)
    self.room:send("Belial says in common, 'It will be pleasure to show you unimaginable pain once more!")
elseif banter == 4 then
    wait(2)
    self.room:send("Belial says in common, 'Your death will be as meaningless as your pathetic life!'")
elseif banter == 5 then
    wait(2)
    self.room:send("Belial says in common, 'I grow weary of your intrusions...'")
    self.room:send("Belial says in common, 'This time I shaill see you stay dead!'")
elseif banter == 6 then
    wait(2)
    self.room:send("Belial says in common, 'The Nine Hells take thee...'")
    self.room:send("Belial says in common, 'For your soul now belongs to me!'")
else
    wait(2)
    self.room:send("Belial says in common, 'Your life ends here!'")
end
self.room:find_actor("belial"):command("kill " .. tostring(victim.name))$trig$, '6b09a402bb24c7d145b15a5a07cae928'),
  -- data/triggers/022/022_43_belial_spawn_demon_belial.lua
  (22, 43, $trig$-- Converted from DG Script #2243: belial_spawn_demon_belial
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 100%
-- Spawn Demon Belial on 5% HP
-- Stage marker: belial_queue == 3 (post-transformation)
globals.belial_queue = 3
local victim = self.room.actors[random(1, #self.room.actors)]
self.room:spawn_mobile(22, 21)
self.room:send("Belial falls to one knee, his chest heaving in exhaustion from battle.")
wait(3)
self.room:send("Belial says in common, 'Fools!  You have yet to witness the true power of the Nines!'")
self.room:send("Belial contorts momentarily as wings and shadow tentacles sprout from his back.")
wait(3)
self.room:send("Belial slowly rises up, his demonic form dwarfing you in size.")
self.room:send("Belial throws back his head and roars with ferocity, causing your soul to quake.")
wait(1)
self:command("force destruction kill " .. tostring(victim.name))
world.destroy(self)$trig$, 'c72b6c8f81b6f50109646118178bd267'),
  -- data/triggers/022/022_44_belial_combat_ai_script.lua
  (22, 44, $trig$-- Converted from DG Script #2244: belial_combat_ai_script
-- Original: MOB trigger, flags: SPEECH, FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end

-- Speech keywords: test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
-- random combat events
local timer = random(1, 4)
if belial_ai > 0 then
    -- switch on action
    if action == 1 then
        -- Deadly Spell
        -- line 10
        run_room_trigger(22, 46)
    elseif action == 2 then
        -- Severe Spell
        run_room_trigger(22, 47)
    elseif action == 3 then
        -- Severe Spell
        run_room_trigger(22, 48)
        -- line 20
    elseif action == 4 then
        self.room:send("Belial says in common, 'Fear my wrath, puny mortal!'")
    elseif action == 5 then
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        -- line 30
        if which == 1 then
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- line 40
        -- Show random caster Fun Lovin's!
        if self:get_mexists(1000, 15) < 1 then
            run_room_trigger(22, 49)
        end
        -- Kick / Switch Opponents
        local victim = self.room.actors[random(1, #self.room.actors)]
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- line 50
            combat.engage(self, victim.name)
        elseif which == 2 then
            skills.execute(self, "kick", self.fighting)
        end
        -- Random Banter
        -- line 60
        -- Severe Spell
        run_room_trigger(22, 48)
        -- Severe Spell
        run_room_trigger(22, 47)
        -- line 70
        -- Deadly Spell
        run_room_trigger(22, 46)
        self:say("Your soul belongs to the Nines!")
        skills.execute(self, "kick", self.fighting)
        -- line 80
    end
    if belial_ai >= 1 then
        belial_ai = belial_ai - 1
    else
        local belial_ai = timer
    end
    globals.belial_ai = globals.belial_ai or true
end  -- auto-close block$trig$, '282209051f5ed337c452ca88edf1f990'),
  -- data/triggers/022/022_47_belial_enervation_script.lua
  (22, 47, $trig$-- Converted from DG Script #2247: belial_enervation_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- enervation spell = 375-450 random damage
local count = 3
wait(1)
self.room:send("Belial cackles madly, spreading his open hands apart!")
self.room:send("A blackened bolts of energy crackles from Belial's fingertips.")
while count > 0 do
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim.is_player then
        local damage = 375 + random(1, 75)
        local saved = random(1, 2)
        -- switch on saved
        if saved == 1 then
            damage = damage/2
            victim:send("You narrowly avoid a blackened bolt of energy! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " narrowly avoids a blackend bolt of energy! (<blue>" .. tostring(damage) .. "</>)")
        elseif saved == 2 then
            victim:send("You are hit dead on by a blackened bolt of energy! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " is hit dead on by a blackend bolt of energy! (<blue>" .. tostring(damage) .. "</>)")
        else
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    count = count - 1
end$trig$, '9fb850270af20e3517e10d32b5fe84ea'),
  -- data/triggers/022/022_48_belial_fissure_script.lua
  (22, 48, $trig$-- Converted from DG Script #2248: belial_fissure_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- trigger info here
local count = self.actor_count
if count > 3 then
    count = 3
end
while count > 0 do
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim.is_player then
        local damage = 225 + random(1, 75)
        local which = random(1, 3)
        local fireproof = not victim:has_effect(Effect.HeatResistance)
        -- switch on which
        if not (fireproof) then
            if which == 1 then
                damage = damage * 2
            end
            victim:send("Scorching flames burst out of a nearby fissure, scalding your skin! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "White-hot flames explode out of a fissure in the ground next to " .. tostring(victim.name) .. "! (<blue>" .. tostring(damage) .. "</>)")
            if not (fireproof) then
            elseif which == 2 then
                damage = damage * 2
            end
            victim:send("Bubbling, hot lava roils out of the ground onto your feet! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "Burning lava bubbles out of the ground onto " .. tostring(victim.name) .. "'s feet! Ouch! (<blue>" .. tostring(damage) .. "</>)")
        else
            if not (fireproof) then
                damage = damage * 3
            end
            victim:send("A torrent of molten lava consumes you, engulging you in flame! (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "A torrent of molten lava consumes " .. tostring(victim.name) .. ", engulfing " .. tostring(victim.name) .. " in flame. (<blue>" .. tostring(damage) .. "</>)")
        end
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
    count = count - 1
    wait(2)
end$trig$, 'b1b5ef882eed5e4078009c4cbb83baaa'),
  -- data/triggers/022/022_49_belial_soul_swarm_script.lua
  (22, 49, $trig$-- Converted from DG Script #2249: belial_soul_swarm_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- TODO(parity): debug placeholders "To Victim test"/"To Room test" left from
-- conversion; original DG had flavour text for the soul swarm hit on the target.
-- Also: while-loop has no escape if no caster is in room — consider iteration cap.
-- Class compares are case-mismatched (other triggers use "Sorcerer" capitalized);
-- verify actor.class capitalization at runtime.
wait(2)
self.room:send("Belial closes his eyes, raises his hands in the air and shouts, 'Fadre Zarku!'")
wait(1)
local person = 0
while person < 1 do
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim.is_player then
        if victim.class == "sorcerer" or victim.class == "cryomancer" or victim.class == "pyromancer" or victim.class == "priest" or victim.class == "druid" or victim.class == "cleric" then
            victim:send("Soul-wraiths phase out of Belial and lock onto your aura!")
            self.room:send_except(victim, "Soul-wraiths phase out of Belial, locking onto " .. tostring(victim.name) .. "!")
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            self.room:spawn_mobile(0, 15)
            self.room:find_actor("wraith"):command("kill " .. tostring(victim.name))
            person = person + 1
        end
    end
end$trig$, '396221a05f064fc08ec5a71f4514e08a'),
  -- data/triggers/052/052_78_lava_death_trig.lua
  (52, 78, $trig$wait(2)
while self.actor_count > 0 do
    local dice1 = random(1, 60)
    local dice2 = random(1, 60)
    local damage = dice1 + dice2
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", but " .. tostring(victim.possessive) .. " body absorbs the blast!")
            victim:send("A large lava bubble bursts right next to you.  Luckily, you are well-protected.")
        else
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", burning " .. tostring(victim.object) .. "! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("A large lava bubble bursts right next to you - OUCH, that burns! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
        if victim:get_quest_stage("meteorswarm") == 3 and victim:get_quest_var("meteorswarm:fire") == 1 then
            victim:advance_quest("meteorswarm")
            wait(1)
            victim:send("<red>You feel your mastery over fire growing!</>")
        end
    else
        return true
    end
    wait(2)
end$trig$, 'da41b84125ecf89d4ac5b731f6aa162d'),
  -- data/triggers/103/103_08_hot-spring.lua
  (103, 8, $trig$local who = actor
if not who then
    if room and self.room.actors and #self.room.actors > 0 then
        who = self.room.actors[random(1, #self.room.actors)]
    end
end
if not who or not who.is_player then
    return true
end

local heat_resistant = who:has_effect(Effect.HeatResistance)
if who.class == "Pyromancer" or heat_resistant then
    return true
end

local damage = random(1, 10) + random(1, 10)
self.room:send_except(who, who.name .. " starts to look a bit woozy from the extreme heat.")
who:send("The water is too hot for you....")
who:damage(damage)  -- physical heat damage
return true$trig$, 'eb3c82cf9a0c8f3c9af2d85e268af321'),
  -- data/triggers/117/117_01_branches_attack_rand.lua
  (117, 1, $trig$-- Converted from DG Script #11701: branches_attack_rand
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
if actor.is_player and actor.level < 100 then
    local dice1 = random(1, 55)
    local dice2 = random(1, 55)
    local damage = dice1 + dice2
    local victim = self.room.actors[random(1, #self.room.actors)]
    local damage_dealt = victim:damage(damage)  -- type: slash
    if damage_dealt == 0 then
        self.room:send_except(victim, "One of the branches suddenly whips out at " .. tostring(victim.name) .. "!")
        victim:send("A gnarled tree branch reached out and tried to slash you!")
    else
        self.room:send_except(victim, "One of the branches suddenly whips out at " .. tostring(victim.name) .. ", cutting " .. tostring(victim.object) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send("A gnarled tree branch reached out and slashed you!! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
    wait(3)
end$trig$, '81f199395509a31294cb5f9b2c3abc9d'),
  -- data/triggers/117/117_123_rock_fall_on_head.lua
  (117, 123, $trig$-- Converted from DG Script #11823: rock_fall_on_head
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
if actor.level < 100 then
    local die1 = random(1, 60)
    local die2 = random(1, 60)
    local damage = die1 + die2
    local victim = self.room.actors[random(1, #self.room.actors)]
    local damage_dealt = victim:damage(damage)  -- type: crush
    if damage_dealt == 0 then
        self.room:send_except(victim, "A large stone slipped off of the entrance to a cave, but " .. tostring(victim.name) .. " is unharmed.")
        victim:send("A large rock from the cave entrace to the west just missed you!")
    else
        self.room:send_except(victim, "A large stone slipped off of the entrance to a cave to the west and hit " .. tostring(victim.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send("A large rock from the cave entrace to the west hits you in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
    wait(3)
end$trig$, 'b4ff17b93d3dec58868ca639e80acde3'),
  -- data/triggers/185/185_15_almoner_give_food.lua
  (185, 15, $trig$if not percent_chance(25) then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if (victim.is_player) and (victim.level < 25) and (victim.can_be_seen) then
    self:command("smile " .. tostring(victim.name))
    self:say("Hello there, young one.  You look like you could use a bite to eat.")
    self:destroy_item("waybread")
    self.room:spawn_object(185, 8)
    self:command("give waybread " .. tostring(victim.name))
end$trig$, 'c7365389255b68ae3fefd5bf482992e9'),
  -- data/triggers/188/188_20_xcast_xcast.lua
  (188, 20, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: xcast
if not (cmd == "xcast") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- 
-- X-cast
-- This trigger works with 18821, x-decide, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.zone_id == 188 and actor.id >= 20 and actor.id <= 42) then
    _return_value = false
    -- Must use x-decide to select a spell first
    if not xname then
        actor:send("You have not chosen a spell to x-cast yet!")
        -- No x-casting damage on self, immortals, or people in other rooms
    elseif (xmode == "victim") and (arg.name == actor.name) then
        actor:send("You cannot x-cast at yourself.")
    elseif (xmode == "victim") and (arg.room ~= actor.room) then
        actor:send("You must be in the same room as " .. tostring(arg.name) .. "!")
    elseif (xmode == "victim") and (arg.level > 99) then
        actor:send("You cannot x-cast at immortals!")
    else
        local notarg
        local spell_stop
        local damage
        if xmode ~= "victim" then
            notarg = 1
        end
        -- Begin casting messages
        if xmode == "victim" then
            arg:send(tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</> at <b:red>You</>!!!...")
            self.room:send_except(arg, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
            actor:send("You start casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        elseif xmode == "self" then
            self.room:send_except(actor, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        end
        actor:send("You start chanting...")
        wait(2)
        -- Imitate casting stars
        local stars = xstars
        while stars > 0 do
            if notarg or (arg.room == actor.room) then
                actor:send(tostring(stars) .. " remaining on " .. tostring(xname))
                wait(2)
                stars = stars - 1
            else
                spell_stop = 1
                stars = 0
            end
        end
        -- If player is still here, make with the magic
        if spell_stop ~= 1 then
            if notarg or (arg.room == actor.room) then
                if xmode == "victim" then
                    arg:send(tostring(actor.name) .. " stares at you and utters the words, '" .. tostring(xmagic) .. "'.")
                    self.room:send_except(arg, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                elseif xmode == "self" then
                    self.room:send_except(actor, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                end
                actor:send("You complete your spell.")
                if xeffect == "damage" then
                    damage = xamount + random(1, 50)
                end
                -- Show the message
                if xid == 1 then
                    self.room:send_except(actor, "<yellow>" .. tostring(actor.name) .. " lets out a <red>soul-rending<yellow> screech</>!")
                    actor:send("<yellow>You let out shattering screech!</>")
                elseif xid == 2 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " waves a taloned paw, bring down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                    actor:send("<b:white>You wave a taloned paw at the room, bringing down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                elseif xid == 3 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " looks much healthier than before!</>")
                    actor:send("<b:white>You feel MUCH healthier than before!</>")
                elseif xid == 4 then
                    self.room:send_except(arg, tostring(actor.name) .. " waves a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                    actor:send("You wave a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                elseif xid == 5 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " speaks a holy word of sanctification!</>")
                    actor:send("<b:white>You speak a holy word of sanctification!</>")
                elseif xid == 6 then
                    arg:send("&9<blue>" .. tostring(actor.name) .. " chants an arcane word at you, locking you in an iron maiden!</>")
                    self.room:send_except(arg, "&9<blue>" .. tostring(actor.name) .. " chants an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                    actor:send("&9<blue>You chant an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                elseif xid == 7 then
                    self.room:send_except(actor, "<blue>Lightning streaks out from " .. tostring(actor.name) .. "'s body, sizzling through the air.</>")
                    actor:send("<blue>Lightning streaks out from your body, crackling through the air.</>")
                elseif xid == 8 then
                    arg:send(tostring(actor.name) .. " screams a commination at you, causing runes to appear on your skin!  (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, "Runes appear on " .. tostring(arg.name) .. " as " .. tostring(actor.name) .. " screams an obloquy at " .. tostring(arg.object) .. "!  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You scream a curse at " .. tostring(arg.name) .. ", causing runes to appear on " .. tostring(arg.possessive) .. " skin! (<yellow>" .. tostring(damage) .. "</>)")
                elseif xid == 9 then
                    arg:send(tostring(actor.name) .. " flings a ball of caustic acid at you, burning your flesh. (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, tostring(actor.name) .. " flings a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(actor.possessive) .. " flesh.  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You throw a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(arg.possessive) .. " flesh. (<yellow>" .. tostring(damage) .. "</>)")
                else
                    self.room:send_except(actor, "X-cast failure.  Nothing happens.")
                    actor:send("Unrecognized xid number.")
                end
                -- Do the deed
                if xeffect == "damage" then
                    local damage_dealt = arg:damage(damage)  -- type: physical
                elseif xeffect == "heal" then
                    actor:heal(xamount)
                end
                if xeffect == "transport" then
                    if xamount == -1 then
                        arg:send(tostring(actor.name) .. " waves a hand at you, whisking you away!")
                        local max_tries = 20
                        while max_tries > 0 do
                            arg:teleport(get_room(math.floor(random(1, 60000 / 100)), (random(1, 60000 % 100))))
                            if arg.room ~= actor.room then
                                max_tries = 0
                            end
                            max_tries = max_tries - 1
                        end
                        -- TODO(parity): legacy used `if not max_tries` to detect "never escaped",
                        -- but the loop now decrements past zero so the original safety net
                        -- is dead code. Decide whether to bail to (0,0) on failure.
                    else
                        arg:teleport(get_room(math.floor(xamount / 100), xamount % 100))
                    end
                    arg:command("look")
                elseif xeffect == "area" then
                    local max_tries = 20
                    local target_list = ""
                    while max_tries > 0 do
                        local victim = self.room.actors[random(1, #self.room.actors)]
                        if victim then
                            if (victim.id ~= actor.id) and not (string.find(target_list, victim.name, 1, true)) then
                                target_list = target_list .. victim.name .. ","
                                damage = xamount + random(1, 50)
                                if xid == 1 then
                                    victim:send("<yellow>The screech pierces into your head, causing great pain!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head in pain.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 2 then
                                    victim:send("<cyan>The sudden blizzard <b:white>chills</><cyan> you to the bone!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " shivers and turns blue in the blizzard.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif (xid == 5) and (victim.alignment <= -350) then
                                    victim:send("<b:white>You cry out in pain upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<b:white>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 7 then
                                    victim:send("<blue>The lightning strikes you in the chest, shocking your body!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<blue>" .. tostring(victim.name) .. " reels back, struck in the chest by the lightning!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                end
                            end
                        else
                            max_tries = 0
                        end
                        max_tries = max_tries - 1
                    end
                end
            else
                spell_stop = 1
            end
        end
        -- If the player left somewhere along the way, fail spell
        if spell_stop == 1 then
            actor:send("You stop invoking abruptly!")
            self.room:send_except(actor, tostring(actor.name) .. " stops invoking abruptly!")
        end
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = true
end
return _return_value$trig$, '2e58fc9c7c6709b28307d77b43cf9f5a'),
  -- data/triggers/188/188_70_smart_combat.lua
  (188, 70, $trig$local now = timestamp()
local level = self.level
local class = self.class
local flags = self.flags
local is_sor = class == "Sorcerer"
local is_cry = class == "Cryomancer"
local is_pyr = class == "Pyromancer"
local is_nec = class == "Necromancer"
local is_arc = is_sor  or  is_cry  or  is_pyr  or  is_nec
local is_war = class == "Warrior"
local is_ran = class == "Ranger"
local is_pal = class == "Paladin"
local is_ant = class ~= nil and string.find(tostring(class), "Anti") ~= nil
local is_mon = class == "Monk"
local is_com = is_ran  or  is_pal  or  is_ant
local is_fig = is_war  or  is_mon  or  is_com
local is_rog = class == "Rogue"
local is_thi = class == "Thief"
local is_ass = class == "Assassin"
local is_mer = class == "Mercenary"
local is_bac = is_rog  or  is_thi  or  is_ass  or  is_mer
local is_cle = class == "Cleric"
local is_pri = class == "Priest"
local is_dia = class == "Diabolist"
local is_dru = class == "Druid"
local is_div = is_cle  or  is_pri  or  is_dia  or  is_dru
local is_mag = is_arc  or  is_div  or  is_com
local cir_2 = level >= 9
local cir_3 = level >= 17
local cir_4 = level >= 25
local cir_5 = level >= 33
local cir_6 = level >= 41
local cir_7 = level >= 49
local cir_8 = level >= 57
local cir_9 = level >= 65
local cir_10 = level >= 73
local cir_11 = level >= 81
local cir_12 = level >= 89
local cir_13 = level >= 97
wait(1)
local mode = random(1, 10)
-- Do fighter/rogue type stuff
if is_fig or is_bac then
    if (mode < 4) and ((is_ran and (level > 34)) or (is_war and (level > 14)) or ((is_ant or is_pal) and (level > 9))) then
        local max_tries = 5
        local attempted
        while max_tries > 0 do
            local victim = self.room.actors[random(1, #self.room.actors)]
            if victim and (victim.is_npc) and (victim.class ~= "Warrior") and (victim.class ~= "Ranger") and (not (string.find(victim.class, "Anti"))) and (victim.class ~= "Paladin") and (victim.class ~= "Monk") then
                combat.rescue(self, victim.name)
                attempted = 1
            end
            max_tries = max_tries - 1
        end
        if attempted then
            return true
        end
    end
    if (is_war or is_ran or is_pal or is_ant or is_mer) and (level - actor.level >= 0) and (self:get_worn("11") ~= -1) then
        skills.execute(self, "bash", self.fighting)
    elseif (is_ass or is_thi or (is_rog and (level > 9)) or (is_mer and (level > 10))) and (self:get_worn("16") ~= -1) then
        skills.execute(self, "backstab", self.fighting)
    elseif (is_war and (level > 49)) or ((is_pal or is_ant) and (level > 79)) then
        self:attack_all()
    elseif ((is_war or is_ran or is_pal or is_ant or is_mon or is_mer) and (level >= 1)) or (is_ass and (level >= 36)) then
        skills.execute(self, "kick", self.fighting)
    end
    return true
end
-- Initialize chance to do support spells (per-mob persistent)
if not globals.defensive then
    globals.defensive = 5
end
local defensive = globals.defensive
-- Per-mob spell cooldown timestamps (default to far past so first cast fires)
local barkskin = globals.barkskin or -9999
local armor = globals.armor or -9999
local demonskin = globals.demonskin or -9999
local demonic = globals.demonic or -9999
local mirage = globals.mirage or -9999
-- Attempt to cast support spells
if mode <= defensive then
    -- TODO(parity): the `not (flags ~= "HASTE")` guards below mean "the mob is
    -- already affected by HASTE" (i.e. don't recast). Re-derive once the
    -- runtime exposes a real affect-bitvector check.
    if ((is_nec and cir_7) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "HASTE")) then
        spells.cast(self, "haste")
    elseif ((is_nec and cir_12) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "STONE")) then
        spells.cast(self, "stone skin")
    elseif ((is_ran and cir_3) or is_dru) and (barkskin + 6 + (level / 10) < now) then
        spells.cast(self, "barkskin")
        globals.barkskin = now
    elseif (is_cle or (is_pal and cir_2) or is_pri) and (armor + 10 < now) then
        spells.cast(self, "armor")
        globals.armor = now
    elseif (is_dia or (is_ant and cir_2)) and (demonskin + 10 + (level / 40) < now) then
        spells.cast(self, "demonskin")
        globals.demonskin = now
    elseif is_dia and cir_4 and (demonic + 11 < now) then
        spells.cast(self, "demonic aspect")
        globals.demonic = now
    elseif is_pyr and cir_4 and (mirage + 10 < now) then
        spells.cast(self, "mirage")
        globals.mirage = now
    else
        mode = 6  -- fall through to offensive branch
    end
end
if mode > 5 then
    if (is_sor or is_cry) and cir_8 then
        spells.cast(self, "chain lightning")
    elseif is_pyr and cir_6 then
        spells.cast(self, "firestorm")
    elseif (is_sor or is_cry) and cir_6 then
        spells.cast(self, "ice storm")
    elseif (self.alignment > 350) and ((is_cle and cir_6) or (is_pri and cir_9) or (is_pal and cir_10)) then
        spells.cast(self, "holy word")
    elseif (self.alignment < -350) and ((is_cle and cir_6) or (is_dia and cir_9) or (is_ant and cir_11)) then
        spells.cast(self, "unholy word")
    elseif is_sor and cir_9 and mode <= 2 then
        spells.cast(self, "disintegrate")
        -- elseif is_cry% && %cir_9%
        -- cast 'iceball'
        -- elseif is_pyr% && %cir_9%
        -- cast 'immolate'
    elseif is_dru and cir_9 and ((not (string.find(actor.flags, "BLIND"))) or not outside) then
        spells.cast(self, "sunray")
    elseif is_sor and cir_7 then
        spells.cast(self, "bigbys clenched fist")
    elseif outside and is_dru and cir_7 then
        spells.cast(self, "call lightning")
    elseif (is_cle and cir_7) or ((is_pri or is_dia) and cir_10) then
        spells.cast(self, "full harm")
    elseif is_arc and (not is_nec) and cir_4 and (not (string.find(actor.flags, "ENFEEB"))) then
        spells.cast(self, "ray of enfeeblement")
    elseif outdoors and ((is_dru and cir_4) or (is_div and (not is_dru) and cir_5)) then
        spells.cast(self, "earthquake")
    elseif is_pyr and cir_7 and mode <= 2 then
        spells.cast(self, "melt")
    elseif is_dia and cir_7 and (not (string.find(actor.flags, "INSANITY"))) then
        spells.cast(self, "insanity")
    elseif is_pri and cir_6 and (actor.alignment < 350) then
        spells.cast(self, "divine ray")
    elseif is_dia and cir_6 then
        spells.cast(self, "stygian eruption")
    elseif is_nec and cir_5 then
        spells.cast(self, "energy drain")
    elseif (is_sor or is_cry) and cir_5 then
        spells.cast(self, "cone of cold")
    elseif (is_cle or is_dru) and cir_5 then
        spells.cast(self, "harm")
    elseif is_pyr and cir_5 then
        spells.cast(self, "heatwave")
    elseif (is_cle or is_pri) and cir_4 and (actor.alignment <= 350) then
        spells.cast(self, "dispel evil")
    elseif (is_cle or is_dia) and cir_4 and (actor.alignment >= 350) then
        spells.cast(self, "dispel good")
    elseif ((is_div and (not is_dru) and cir_4) or (is_ant and cir_6)) and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "blindness")
    elseif (is_sor and cir_6) or (is_pyr and cir_4) then
        spells.cast(self, "fireball")
    elseif is_cle and cir_4 and (self.alignment >= 350) then
        spells.cast(self, "flamestrike")
    elseif (is_arc and (not is_pyr) and cir_4) or (is_dru and cir_6) then
        spells.cast(self, "lightning bolt")
    elseif is_pri and cir_3 and (self.alignment >= 350) and (actor.alignment < 350) then
        spells.cast(self, "divine bolt")
    elseif is_dia and cir_3 and (actor.alignment > 350) then
        spells.cast(self, "hell bolt")
    elseif is_div and (not is_dru) and cir_3 then
        spells.cast(self, "cause critical")
    elseif is_arc and (not is_pyr) and cir_3 then
        spells.cast(self, "shocking grasp")
    elseif is_pyr and cir_3 and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "smoke")
    elseif is_dru and cir_3 then
        spells.cast(self, "writhing weeds")
    elseif is_div and (not is_dru) and cir_2 then
        spells.cast(self, "cause serious")
    elseif is_arc and (not is_pyr) and cir_2 then
        spells.cast(self, "chill touch")
    elseif is_pyr and cir_2 then
        spells.cast(self, "fire darts")
    elseif is_pyr then
        spells.cast(self, "burning hands")
    elseif is_cry then
        spells.cast(self, "ice darts")
    elseif is_arc then
        spells.cast(self, "magic missile")
    elseif is_div and not is_dru then
        spells.cast(self, "cause light")
    end
end
globals.action = now$trig$, 'a8899f325e14067fbe549c7ce74607de'),
  -- data/triggers/302/302_02_sliding_into_the_abyss.lua
  (302, 2, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
-- Don't bother flying or levitating people.
if victim:has_effect(Effect.Flying) or victim:has_effect(Effect.Feather_Fall) then
    return true
end
-- Consider rangers and druids as too sure-footed to lose their footing.
if victim.class == "Ranger" or victim.class == "Druid" then
    self.room:send_except(victim, tostring(victim.name) .. "'s foot slips on a rock, but " .. tostring(victim.name) .. " quickly steps to one side.")
    victim:send("A rock shifts under your foot, and you step to steadier ground.")
    return true
end
wait(4)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " slips on a loose rock, and begins to slide downward!")
victim:send("Your foot slips on a loose rock.  You are sliding downward!")
wait(3)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " is sliding straight toward a sheer dropoff!")
victim:send("You are sliding right toward a deep ravine!")
wait(2)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " disappears off the edge with a yelp!")
victim:send("You slide off the edge into thin air!")
victim:teleport(get_room(302, 55))$trig$, '1f81cbf45ad896431e033494a4f1aa22'),
  -- data/triggers/302/302_03_sliding_into_the_abyss_ii.lua
  (302, 3, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
-- Don't bother flying or levitating people.
if victim:has_effect(Effect.Flying) or victim:has_effect(Effect.Feather_Fall) then
    return true
end
-- Consider rangers and druids as too sure-footed to lose their footing.
if victim.class == "Ranger" or victim.class == "Druid" then
    self.room:send_except(victim, "A rock shifts under " .. tostring(victim.name) .. "'s foot, but " .. tostring(victim.name) .. " quickly steps to one side.")
    victim:send("A rock shifts under your foot, and you step to steadier ground.")
    return true
end
wait(4)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " slips on a loose rock, and begins to slide downward!")
victim:send("Your foot slips on a loose rock.  You are sliding downward!")
wait(3)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " is sliding straight toward a sheer dropoff!")
victim:send("You are sliding right toward a deep ravine!")
wait(2)
if victim.room ~= startroom then
    return true
end
self.room:send_except(victim, tostring(victim.name) .. " disappears off the edge with a yelp!")
victim:send("You slide off the edge into thin air!")
victim:teleport(get_room(302, 51))$trig$, '45d8a279c186d6540196499659c9790c'),
  -- data/triggers/302/302_04_a_mild_avalanche.lua
  (302, 4, $trig$-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if #self.room.actors == 0 then
    return true
end
local victim = self.room.actors[random(1, #self.room.actors)]
if not victim or victim.is_npc then
    return true
end
local startroom = victim.room
self.room:send("A quiet noise from above attracts your attention.")
wait(2)
self.room:send("A few small pebbles and stones are falling down the hillside.")
self.room:send("They clatter as they tumble.")
wait(2)
self.room:send("Large rocks are tumbling past you!  They look heavy!")
wait(1)
local dest_local
if self.id == 34 then
    dest_local = self.id + 1
else
    dest_local = self.id - 1
end
local damage
if victim.level < 10 then
    damage = 3 + random(1, 5)
elseif victim.level < 20 then
    damage = 10 + random(1, 8)
elseif victim.level < 40 then
    damage = 30 + random(1, 30)
else
    damage = 80 + random(1, 50)
end
if victim.room == startroom then
    if victim.class == "Ranger" then
        self.room:send_except(victim, tostring(victim.name) .. " is nearly smacked by a large rock, but " .. tostring(victim.name) .. " steps aside at the last moment.")
        victim:send("A big rock comes hurtling toward you, but you step smoothly aside.")
    else
        local damage_dealt = victim:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(victim, "The rocks seem to pass right through " .. tostring(victim.name) .. ".")
            victim:send("The rocks seem to pass right through you.")
        else
            self.room:send_except(victim, "A big rock hits " .. tostring(victim.name) .. " right in the chest, and " .. tostring(victim.name) .. " is knocked over! (<blue>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, tostring(victim.name) .. " tumbles downhill!")
            victim:send("You try to dodge the boulders, but a large stone whacks you in the chest! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("You are knocked down!")
            victim:teleport(get_room(302, dest_local))
            self.room:send_except(victim, tostring(victim.name) .. " tumbles down the trail from above, and comes to a rest.")
            wait(1)
        end
    end
end
self.room:send("The remnants of the avalanche tumble past, then silence returns to the mountains.")$trig$, '12cadb2a3baae93a8ce6b4b88c1db732'),
  -- data/triggers/363/363_00_chief_guard_rant.lua
  (363, 0, $trig$-- Converted from DG Script #36300: chief_guard_rant
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
local rnd = self.room.actors[random(1, #self.room.actors)]
-- 36303 -> (zone_id 363, local_id 3) smuggler guard
if rnd and rnd.zone_id == 363 and rnd.local_id == 3 then
    self:command("poke 2.guard")
    self:command("glare 2.guard")
    self:say("My granny could do a better job guarding this place than you!")
    self:command("whap 2.guard")
    self:say("Chest out! Shoulders back!")
    self:command("steam")
end$trig$, 'f76e57fcc6f1b553edc920719ffb2f2d'),
  -- data/triggers/464/464_03_bittern_rand_attack.lua
  (464, 3, $trig$-- Converted from DG Script #46403: bittern_rand_attack
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
-- Random chance to attack!
local rnd = self.room.actors[random(1, #self.room.actors)]
if rnd.is_player then
    if rnd.level < 100 then
        wait(1)
        self.room:send_except(rnd, tostring(self.name) .. " flies into a rage!")
        rnd:send(tostring(self.name) .. " flies into a rage and attacks you!")
        combat.engage(rnd)
    end
end$trig$, '0b5d34e87b914471766dc9dc39adfb14'),
  -- data/triggers/481/481_00_falling_from_48191.lua
  (481, 0, $trig$-- Converted from DG Script #48100: falling_from_48191
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if direction == "west" then
    wait(5)
    local rndm = self.room.actors[random(1, #self.room.actors)]
    if not (rndm:get_eff_flagged("FLY")) then
        rndm:send("You feel your feet start slipping toward the pit!")
        wait(3)
        if rndm.room and rndm.room.zone_id == 481 and rndm.room.local_id == 91 then
            rndm:send("You slip into the pit!")
            self.room:send_except(rndm, "You watch in horror as " .. tostring(rndm.name) .. " slips into the pit!")
            rndm:teleport(get_room(481, 92))
            -- rndm looks around
        end
        rndm = nil
    end
end$trig$, '1c95b9f4c64e322cfd1d2abdcce4ab63'),
  -- data/triggers/484/484_08_lord-realm_fight.lua
  (484, 8, $trig$-- Converted from DG Script #48408: lord-realm fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if has_blur then
    if not (self:has_effect(Effect.Blur)) then
        self:emote("slows as " .. tostring(self.name) .. " returns to normal speed.")
        local has_blur = 0
        globals.has_blur = globals.has_blur or true
    end
end
local victim = self.room.actors[random(1, #self.room.actors)]
if victim then
    local action = random(1, 10)
    if action > 8 then
        wait(2)
        self.room:send_except(victim, tostring(self.name) .. " swings a rocky fist at " .. tostring(victim.name) .. ", toppling " .. tostring(victim.object) .. "!")
        victim:send(tostring(self.name) .. " swings a rocky fist at you, knocking you over!")
        self:send("You swing a rocky fist at " .. tostring(victim.name) .. ", knocking " .. tostring(victim.object) .. " over!")
        victim:teleport(get_room(11, 0))
        victim:command("recline")
        victim:teleport(self.room)
    elseif action > 7 then
        if victim.is_player then
            combat.engage(self, victim.name)
        end
    end
end$trig$, '316b748893739f966f588fb607a85ea2'),
  -- data/triggers/484/484_105_mighty_druid_entanglement.lua
  (484, 105, $trig$-- Converted from DG Script #48505: mighty_druid entanglement
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- TODO(parity): the converter emitted branch-scoped `local chance`,
--   `local victim`, `local secondary_victim`, `local paralysis_victim_N`,
--   and `local paralysis_expire_N` declarations inside if/elseif blocks,
--   so the outer `if chance > 3 then` and `if victim.is_player then`
--   tests reference undefined names and the per-victim slot bookkeeping
--   never escapes its branch. The body also still contains a
--   `bash %victim.name%` DG token. The whole entanglement state machine
--   needs a rewrite once we have a stable globals API for per-mob
--   paralysis tracking.
local now = time.stamp
if paralysis_victim_1 and ((paralysis_victim_1.room ~= self.room) or (paralysis_expire_1 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_1.room == self.room then
        self.room:send_except(paralysis_victim_1, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
        paralysis_victim_1:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
    end
    paralysis_victim_1 = nil
end
if paralysis_victim_2 and ((paralysis_victim_2.room ~= self.room) or (paralysis_expire_2 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_2.room == self.room then
        self.room:send_except(paralysis_victim_2, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
        paralysis_victim_2:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
    end
    paralysis_victim_2 = nil
end
if paralysis_victim_3 and ((paralysis_victim_3.room ~= self.room) or (paralysis_expire_3 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_3.room == self.room then
        self.room:send_except(paralysis_victim_3, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
        paralysis_victim_3:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
    end
    paralysis_victim_3 = nil
end
if paralysis_victim_4 and ((paralysis_victim_4.room ~= self.room) or (paralysis_expire_4 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_4.room == self.room then
        self.room:send_except(paralysis_victim_4, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
        paralysis_victim_4:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
    end
    paralysis_victim_4 = nil
end
-- 25% chance to do creeping doom proc
local mode = random(1, 4)
if mode == 1 then
    wait(2)
    run_room_trigger(484, 103)
    return _return_value
end
-- 75% chance to attempt to entangle
if (not paralysis_victim_1) or (not paralysis_victim_2) or (not paralysis_victim_3) or (not paralysis_victim_4) then
    local chance
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                if paralysis_victim_4 then
                    -- quit if four people already entangled
                    return _return_value
                else
                    -- 20% chance if three people are entangled
                    chance = random(1, 10)
                end
            else
                -- 25% chance if two people are entangled
                chance = random(1, 8)
            end
        else
            -- 33% chance if one person is already entangled
            chance = random(1, 6)
        end
    else
        -- 50% chance if no one is already entangled
        chance = random(1, 4)
    end
    if chance > 3 then
        return _return_value
    end
    local max_tries = 10
    while max_tries >= 0 do
        -- find a victim, preferably an assassin
        -- but will settle for any player if no assassin found
        local victim = self.room.actors[random(1, #self.room.actors)]
        if victim.is_player then
            if (paralysis_victim_1 and (paralysis_victim_1.name == victim.name)) or (paralysis_victim_2 and (paralysis_victim_2.name == victim.name)) or (paralysis_victim_3 and (paralysis_victim_3.name == victim.name)) then
                local victim = self
            elseif victim.class == "Assassin" then
                max_tries = 0
            else
                local secondary_victim = victim
            end
        end
        max_tries = max_tries - 1
    end
    -- quit if no players
    local victim
    if victim.is_player then
    elseif secondary_victim then
        victim = secondary_victim
    else
        return _return_value
    end
    wait(2)
    self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
    victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
    self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
    victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
    -- declare paralysis message
    local message = "&2The roots lock you in place, preventing movement!&0"
    globals.message = globals.message or true
    -- create a basher to force the player into a bashed stance
    if (victim.size == "Small") or (victim.size == "Tiny") then
        -- Basher is medium
        self.room:spawn_mobile(484, 115)
    elseif (victim.size == "Large") or (victim.size == "Huge") or (victim.size == "Giant") then
        -- Basher is huge
        self.room:spawn_mobile(484, 113)
    else
        -- Basher is large
        self.room:spawn_mobile(484, 114)
    end
    self.room:find_actor("bashing-roots"):spawn_object(10, 16)
    self.room:find_actor("bashing-roots"):command("mat 1100 wear shield")
    victim:command("stand")
    self.room:find_actor("bashing-roots"):command("bash %victim.name%")
    self.room:find_actor("bashing-roots"):destroy_item("shield")
    world.destroy(self.room:find_actor("bashing-roots"))
    -- reinitiate combat if victim was tanking
    if actor.name == victim.name then
        wait(2)
        combat.engage(self, victim.name)
    end
    -- save victim variable
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                local paralysis_victim_4 = victim
                globals.paralysis_victim_4 = globals.paralysis_victim_4 or true
                local paralysis_expire_4 = now + 1
                globals.paralysis_expire_4 = globals.paralysis_expire_4 or true
            else
                local paralysis_victim_3 = victim
                globals.paralysis_victim_3 = globals.paralysis_victim_3 or true
                local paralysis_expire_3 = now + 1
                globals.paralysis_expire_3 = globals.paralysis_expire_3 or true
            end
        else
            local paralysis_victim_2 = victim
            globals.paralysis_victim_2 = globals.paralysis_victim_2 or true
            local paralysis_expire_2 = now + 1
            globals.paralysis_expire_2 = globals.paralysis_expire_2 or true
        end
    else
        local paralysis_victim_1 = victim
        globals.paralysis_victim_1 = globals.paralysis_victim_1 or true
        local paralysis_expire_1 = now + 1
        globals.paralysis_expire_1 = globals.paralysis_expire_1 or true
    end
end$trig$, '70ee340672bfdf98d9119334f7b0f582'),
  -- data/triggers/484/484_231_ice_elemental_lord_-_damage.lua
  (484, 231, $trig$-- Converted from DG Script #48631: ice elemental lord - damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- TODO(parity): `self.actor_count` should be `self.room.actor_count`,
--   and the `victim.id ~= 48632` check uses a legacy vnum (the Ice
--   Elemental Lord). Remap to the (zone, local_id) once known.
-- Hit half as many people are in the room
local negatecold = "!COLD"
local pop = self.actor_count / 2
local max = 15
local count = 1
self.room:send("<b:cyan>The Ice Elemental Lord crashes into the wall, bringing down a shower of ice!</>")
while count <= pop do
    local victim = self.room.actors[random(1, #self.room.actors)]
    -- Don't hit the Ice Elemental Lord
    if (victim.zone_id ~= 484 or victim.id ~= 232) then
        local flags = victim.aff_flags
        -- Base damage between 100 and 130
        local damage = 100 + random(1, 30)
        if string.find(flags, "SANCT") then
            damage = damage / 2
        end
        if string.find(flags, "WATERFORM") then
            -- Heal players with waterform
            victim:send("<b:blue>The falling ice melts into your body!</> (<green>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. "'s body absorbs the falling ice!</> (<yellow>" .. tostring(damage) .. "</>)")
            victim:heal(damage)
        elseif (string.find(flags, "negatecold")) or (string.find(flags, "PROT_COLD")) then
            -- No effect for negate cold or elemental warding for ice
            victim:send("<cyan>The falling ice bounces off your skin, settling lightly on the floor.</>")
            self.room:send_except(victim, "<cyan>The falling ice bounces off " .. tostring(victim.name) .. "'s skin, settling lightly on the floor.</>")
        elseif string.find(flags, "FIRESHIELD") then
            -- No effect for fireshield
            victim:send("<cyan>The barrage of ice <yellow>vaporizes<cyan> as it touches the <red>flames<cyan> around your body!</>")
            self.room:send_except(victim, "<cyan>The barrage of ice <yellow>vaporizes<cyan> on the <red>flames<cyan> about " .. tostring(victim.name) .. "'s body!</>")
        elseif string.find(flags, "BLUR") then
            -- Decrease damage for blur
            damage = damage - 35
            victim:send("<cyan>You dance through the barrage and only a few blocks of ice strike you!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>Dancing through the barrage, " .. tostring(victim.name) .. " is struck by few ice blocks.</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        elseif string.find(flags, "FLY") then
            -- Decrease damage for fly
            damage = damage / 2
            victim:send("<cyan>You dart through the air, missing much of the falling ice!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " darts through the air, evading much of the falling ice!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        elseif string.find(flags, "STONE") then
            -- Increase damage for stone skin
            damage = damage + 60
            victim:send("<cyan>Slowed by your stony skin, you are unable to dodge a slab of falling ice!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>Unable to dodge, " .. tostring(victim.name) .. " takes the full brunt of the hail!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        else
            -- Hit everyone else
            victim:send("<cyan>As you look up, a huge block of ice strikes you on the head!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>A hail of icy shards crashes down upon " .. tostring(victim.name) .. "!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        end
        count = count + 1
    end
    max = max - 1
    if max < 1 then
        count = pop + 1
    end
end$trig$, '0846f564a26430f36e220e0cb4ad5c8e'),
  -- data/triggers/484/484_235_leviathan_fight.lua
  (484, 235, $trig$-- Converted from DG Script #48635: leviathan fight
-- Original: MOB trigger, flags: FIGHT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(2)
local mode = random(1, 10)
if mode < 6 then
    self:command("sweep")
else
    local victim = self.room.actors[random(1, #self.room.actors)]
    if (victim.name ~= actor.name) and ((victim.class == "Warrior") or (string.find(victim.class, "Anti")) or (victim.class == "Ranger") or (victim.class == "Paladin") or (victim.class == "Monk") or (victim.class == "Mercenary") or (victim.class == "Berserker")) then
        if victim.room == self.room then
            self:teleport(get_room(11, 0))
            self:teleport(actor.room)
            self.room:send("<b:white>The Leviathan thrashes about madly, switching opponents!</>")
            combat.engage(self, victim.name)
        end
    end
end$trig$, 'b32a7402c5f68fad1ac64f4f0e2f134f'),
  -- data/triggers/488/488_01_shrynn_fight.lua
  (488, 1, $trig$local mode = random(1, 10)
if mode < 7 then
    wait(2)
    if actor and (actor.room == self.room) and actor.is_player then
        -- Pick a random other player in the room as the secondary victim.
        local victim = nil
        local max_tries = 5
        while max_tries > 0 do
            local candidate = self.room.actors[random(1, #self.room.actors)]
            if candidate and candidate.is_player and (candidate.name ~= actor.name) then
                victim = candidate
                break
            end
            max_tries = max_tries - 1
        end
        if not victim then
            return true
        end
        local actor_damage = 310 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            actor_damage = actor_damage / 2
        end
        local victim_damage = 150 + random(1, 100)
        if victim:has_effect(Effect.Sanctuary) then
            victim_damage = victim_damage / 2
        end
        actor:send(tostring(self.name) .. " sucks you into his vortex, spinning you around in a blur!")
        self.room:send_except(actor, tostring(self.name) .. " sucks " .. tostring(actor.name) .. " into a vortex, spinning " .. tostring(actor.object) .. " around vigorously!")
        actor_damage = actor:damage(actor_damage)  -- type: crush
        victim_damage = victim:damage(victim_damage)  -- type: crush
        actor:send("The vortex spits you out and flings you into headlong into " .. tostring(victim.name) .. "! (<b:red>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        victim:send("The vortex flings " .. tostring(actor.name) .. " into you! (<b:red>" .. tostring(victim_damage) .. "</>) (<blue>" .. tostring(actor_damage) .. "</>)")
        victim:teleport(get_room(11, 0))
        self.room:send_except(actor, "The vortex flings " .. tostring(actor.name) .. " out, and right into " .. tostring(victim.name) .. "! (<blue>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        actor:teleport(get_room(11, 0))
        -- Teleport back and forth to break combat
        actor:teleport(self.room)
        victim:teleport(self.room)
    end
else
    wait(2)
    if actor and (actor.room == self.room) and actor.is_player then
        local damage = 120 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: crush
        actor:send("<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at you, throwing you from the area!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, "<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at " .. tostring(actor.name) .. ", throwing " .. tostring(actor.object) .. " from the area!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        if actor and (actor.room == self.room) then
            actor:teleport(get_room(488, 1 + random(1, 29)))
            -- actor looks around
        end
    end
end$trig$, '2a55d32aeabbdd83edbccad8ce8de82c'),
  -- data/triggers/488/488_09_stormlord_fight.lua
  (488, 9, $trig$local mode = random(1, 10)
if mode < 5 then
    wait(1)
    self.room:send("<cyan>Hurricane-force winds suddenly howl, throwing around lightning bolts!</>")
    wait(1)
    self.room:send("<blue>A massive lightning bolt strikes " .. tostring(self.name) .. " in the chest, causing " .. tostring(self.possessive) .. " eyes to glow!</>")
    self.room:find_actor("stormlord"):heal(1000)
elseif mode < 8 then
    wait(2)
    self:emote("lets out a thundering howl, causing the air around to vibrate.")
    local max_hits = 5
    local hit_names = {}
    while max_hits > 0 do
        local victim = self.room.actors[random(1, #self.room.actors)]
        if victim and victim.is_player and not hit_names[victim.name] then
            local damage = 150 + random(1, 50)
            if victim:has_effect(Effect.Sanctuary) then
                damage = damage / 2
            end
            local damage_dealt
            if victim:has_effect(Effect.Stone) then
                -- More damage for stoneskin
                damage = damage + 80
                damage_dealt = victim:damage(damage)  -- type: physical
                self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. "'s stone-like skin grows massive cracks as the thunder rolls into " .. tostring(victim.object) .. ".</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                victim:send("<yellow>The thundering howl shatters your stone-like skin, causing immense pain!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            else
                damage_dealt = victim:damage(damage)  -- type: crush
                if damage_dealt == 0 then
                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " holds " .. tostring(victim.possessive) .. " ground.</>")
                    victim:send("<yellow>You hold your ground.</>")
                else
                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " holds " .. tostring(victim.possessive) .. " head and cries out in pain!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                    victim:send("<yellow>Pain breaks out in your head as the thunder pounds your ears!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
                end
            end
            hit_names[victim.name] = true
        end
        max_hits = max_hits - 1
    end
else
    wait(1)
    self.room:send("<blue>Lightning begins to crackle around " .. tostring(self.name) .. "'s right arm.</>")
    wait(1)
    if actor and (actor.room == self.room) and (actor.is_player) then
        self.room:send("<blue>The glowing lightning flows into " .. tostring(self.name) .. "'s index finger.</>")
        self.room:send_except(actor, tostring(self.name) .. " points " .. tostring(self.possessive) .. " finger at " .. tostring(actor.name) .. ".")
        actor:send(tostring(self.name) .. " points " .. tostring(self.possessive) .. " finger at you.")
        local damage = 350 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: shock
        if damage_dealt == 0 then
            actor:send("A blast of lighting strikes you, lighting you up!")
            self.room:send_except(actor, "A blast of lighting strikes " .. tostring(actor.name) .. ", lighting " .. tostring(actor.object) .. " up!")
        else
            self.room:send_except(actor, "A tremendous blast of lightning strikes " .. tostring(actor.name) .. ", burning " .. tostring(actor.possessive) .. " skin! (<blue>" .. tostring(damage_dealt) .. "</>)")
            actor:send("A tremendous blast of lightning strikes you, tearing at your flesh! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$, 'fb2fa13de6742cd7f679834199de271a'),
  -- data/triggers/489/489_06_lokari_throw_player.lua
  (489, 6, $trig$-- TODO(parity): the converter botched the victim1/victim2 picking loops:
-- block-scoped `local max_tries = 0` rebinds didn't actually break the outer
-- loop, victim1 was scoped inside the loop so unreachable below, and the
-- `_return_value` orphan was undefined. The rewrite below restores intent.
local victim1
for _ = 1, 6 do
    local candidate = self.room.actors[random(1, #self.room.actors)]
    if candidate and (candidate.zone_id ~= 489) and (candidate.level < 100) then
        victim1 = candidate
        break
    end
end
if not victim1 then
    return true
end
local victim2
for _ = 1, 10 do
    local candidate = self.room.actors[random(1, #self.room.actors)]
    if candidate and (candidate.zone_id ~= 489) and (candidate.level < 100) and (victim1.name ~= candidate.name) then
        victim2 = candidate
        break
    end
end
if not victim2 then
    return true
end
local damage1 = 75 + random(1, 50)
local damage2 = 75 + random(1, 50)
if victim1:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage1 = damage1 / 2
end
if victim1:has_effect(Effect.Stone) then
    -- Another 50 damage for target2 if target1 has stoneskin
    damage2 = damage2 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage1 = damage1 / 2
elseif variant == 15 then
    damage1 = damage1 * 2
end
if victim2:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage2 = damage2 / 2
end
if victim2:has_effect(Effect.Stone) then
    -- Another 50 damage for target1 if target2 has stoneskin
    damage1 = damage1 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage2 = damage2 / 2
elseif variant == 15 then
    damage2 = damage2 * 2
end
self.room:send_except(victim1, "Lokari waves a hand at " .. tostring(victim1.name) .. ", picking " .. tostring(victim1.object) .. " up into the air!")
victim1:send("Lokari waves a hand at you, picking you up into the air!")
victim2:teleport(get_room(11, 0))
self.room:send_except(victim1, "Lokari smashes " .. tostring(victim1.name) .. " into " .. tostring(victim2.name) .. " with a flick of his wrist! (<blue>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim1:send("Lokari smashes you into " .. tostring(victim2.name) .. " with a flick of his wrist! (<b:red>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim2:send("Lokari smashes " .. tostring(victim1.name) .. " into you with a flick of his wrist! (<b:red>" .. tostring(damage2) .. "</>) (<blue>" .. tostring(damage1) .. "</>)")
victim2:teleport(get_room(489, 80))
local damage_dealt = victim1:damage(damage1)  -- type: physical
local damage_dealt = victim2:damage(damage2)  -- type: physical$trig$, 'd190366a24c8150859ffbd25d744da43'),
  -- data/triggers/489/489_25_dark_servant_fight.lua
  (489, 25, $trig$-- Stop combat if our current target is another doom mobile (48900-48999)
-- and rest in a holding room while we recover.
if (actor.zone_id == 489) then
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("dark-servant"):heal(1000)
    end)
end
wait(2)
local chance = random(1, 10)
if chance > 3 then
    -- 70% chance to do nothing this round.
    return true
elseif chance == 1 then
    -- 10% chance to hitall
    self:attack_all()
    return true
elseif (chance == 2) and (self.zone_id == 489 and self.id == 9) then
    -- 10% chance for the warrior dark-servant to re-target onto an
    -- Assassin or Thief in the room.
    local victim
    for _ = 1, 9 do
        local candidate = self.room.actors[random(1, #self.room.actors)]
        if candidate and (candidate.class == "Assassin" or candidate.class == "Thief") then
            victim = candidate
            break
        end
    end
    if victim and victim.is_player then
        combat.engage(victim)
    end
    return true
else
    -- Warrior servant: 10% chill-drain. Non-warrior servants: 20% chill-drain.
    -- Pick a non-doom player; fall back to the current attacker if it's the
    -- dark-servant's current victim and is itself a doom mob (matches the
    -- DG fallback path).
    local victim
    for _ = 1, 5 do
        local candidate = self.room.actors[random(1, #self.room.actors)]
        if candidate and (candidate.zone_id ~= 489) then
            victim = candidate
            break
        end
    end
    if not victim then
        if actor and (actor.zone_id == 489 and actor.id >= 1 and actor.id <= 98) then
            victim = actor
        else
            return true
        end
    end
    local casters = "Sorcerer Cryomancer Pyromancer Necromancer Cleric Priest Diabolist Druid Conjurer Shaman"
    -- Be nice to casters
    local damage
    if string.find(casters, tostring(victim.class)) then
        damage = 200 + random(1, 30)
    else
        damage = 380 + random(1, 30)
    end
    local damage_dealt = victim:damage(damage)  -- type: heal
    if damage_dealt == 0 then
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", but cannot draw out any life. (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, but cannot draw out any life. (<b:red>" .. tostring(damage_dealt) .. "</>)")
    else
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", <b:blue>chilling</> " .. tostring(victim.object) .. " to the <b:white>bone</>! (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, <b:blue>chilling</> you to the <b:white>bone</>! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
    local amount = damage_dealt * 2
    self.room:find_actor("dark-servant"):heal(amount)
end$trig$, '497c5acf70f1904ec3bdb9930fd1eac8'),
  -- data/triggers/520/520_00_rock_demon_call_rock.lua
  (520, 0, $trig$wait(1)
self.room:send("The demon has animated some rocks which spin around you!")
wait(1)
local numhits = random(1, 3) + 2
local thishit = 0
while thishit < numhits do
    local dmg = random(1, 50) + 50
    local rnd = self.room.actors[random(1, #self.room.actors)]
    -- 520:17 is the rock demon itself - it absorbs the rocks instead of being hit
    if rnd.zone_id == 520 and rnd.local_id == 17 then
        self.room:send_except(rnd, "A lump of rock merges with " .. tostring(rnd.name) .. " and he seems stronger! (<yellow>" .. tostring(dmg) .. "</>)")
        rnd:send("You absorb strength from the rock! (<yellow>" .. tostring(dmg) .. "</>)")
        rnd:heal(dmg)
    else
        if rnd:get_quest_stage("meteorswarm") == 2 or rnd:get_quest_var("meteorswarm:new") ~= "yes" then
            if rnd:get_quest_stage("meteorswarm") == 2 then
                rnd:advance_quest("meteorswarm")
            elseif rnd:get_quest_var("meteorswarm:new") ~= "yes" then
                rnd:set_quest_var("meteorswarm", "new", "no")
            end
            self.room:spawn_object(481, 152)
            rnd:send("<b:red>A flaming meteor shoots off the towering rock demon,</>")
            rnd:send("<b:red>soars through the sky, and begins to fall toward the ground!</>")
            self.room:send_except(rnd, "<b:red>A flaming meteor shoots off the towering rock demon,</>")
            self.room:send_except(rnd, "<b:red>but " .. tostring(rnd.name) .. " catches it!</>")
            rnd:command("get meteorite")
            rnd:send("<b:red>You now have an appropriate focus!</>")
        else
            local damage_dealt = rnd:damage(dmg)  -- type: crush
            if damage_dealt == 0 then
                rnd:send("A lump of rock whizzes right through you!")
                self.room:send_except(rnd, tostring(rnd.name) .. " watches a rock zip right through " .. tostring(rnd.possessive) .. " body.")
            else
                rnd:send("A lump of rock whizzes towards you.  You can't dodge! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(rnd, tostring(rnd.name) .. " gets whacked by a lump of flying rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    thishit = thishit + 1
end$trig$, 'a317add672d81b4fc84e0ad83f1d6e01'),
  -- data/triggers/520/520_20_sagece_squish.lua
  (520, 20, $trig$-- Converted from DG Script #52020: sagece squish
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Sagece's "squish" attack: she launches and drops onto a random non-self
-- victim for 5000 crush damage. Up to 10 reroll attempts to avoid landing
-- on herself (520:12); if no valid target, she lands gracefully.
self.room:send("<b:cyan>Sagece of Raymif beats her monstrous wings, launching herself into the air!</>")
wait(5)
local victim = nil
for attempt = 1, 10 do
    local pick = self.room.actors[random(1, #self.room.actors)]
    if pick and not (pick.zone_id == 520 and pick.local_id == 12) then
        victim = pick
        break
    end
end
if not victim then
    self.room:send("<yellow>Sagece of Raymif slowly returns to the floor, rattling the hall.</>")
    return true
end
local damage_dealt = victim:damage(5000)  -- crush
self.room:send_except(victim, "<cyan>Sagece of Raymif swoops down, dropping her bulk onto " .. tostring(victim.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
victim:send("<cyan>Sagece of Raymif swoops down, dropping her massive bulk on <b:red>YOU</><cyan>!</> (<red>" .. tostring(damage_dealt) .. "</>)")$trig$, 'de046eadafecf9d1db712f82c10c80d0'),
  -- data/triggers/520/520_21_sagece_fling.lua
  (520, 21, $trig$-- Converted from DG Script #52021: sagece fling
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Sagece's tail "fling" attack: random non-self victim takes 75-115 damage
-- and is thrown to a random satellite room (520:82, 83, 84, 85, 87). Room
-- 520:86 is excluded (re-route to 520:83).
local victim = self.room.actors[random(1, #self.room.actors)]
if victim and not (victim.zone_id == 520 and victim.local_id == 12) then
    local damage = 75 + random(1, 40)
    victim:damage(damage)
    self.room:send_except(victim, "<green>Sagece of Raymif sweeps with her enormous tail, throwing " .. tostring(victim.name) .. " from the area!</> (<blue>" .. tostring(damage) .. "</>)")
    victim:send("<green>Sagece of Raymif sweeps with her enormous tail, knocking you out of the area!</> (<b:red>" .. tostring(damage) .. "</>)")
    local dest_id = 82 + random(0, 4)
    if dest_id == 86 then
        dest_id = 83
    end
    victim:teleport(520, dest_id)
    victim:command("look")
end$trig$, '43209c76adefa6bc2121619f558b119a'),
  -- data/triggers/521/521_07_soldier_generate_assist.lua
  (521, 7, $trig$-- 6% chance to trigger
if not percent_chance(6) then
    return true
end
if world.count_mobiles(521, 18) < 6 then
    local rnd = self.room.actors[random(1, #self.room.actors)]
    self.room:send("The Platinum Knight lets out a horrid SCREAM!")
    wait(2)
    self:emote("starts to hum a strange mantra.")
    wait(2)
    self.room:send("A Bright flash of light fills the room and two soldiers crawl forth through it.")
    self.room:spawn_mobile(521, 18)
    self.room:spawn_mobile(521, 18)
    local soldier = self.room:find_actor("soldier")
    if soldier then
        local target = rnd.is_player and rnd or actor
        if target then
            soldier:command("hit " .. tostring(target.name))
        end
    end
end$trig$, 'e1a95d8340a88ee6327d669a2d68553a'),
  -- data/triggers/521/521_12_random_wind_damage.lua
  (521, 12, $trig$-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- WORLD/RANDOM triggers fire without an `actor` — pick a random occupant.
if not room or not self.room.actors or #self.room.actors == 0 then
    return true
end
wait(1)
local rndm = self.room.actors[random(1, #self.room.actors)]
if not rndm then
    return true
end
local dmg = 65
rndm:damage(dmg)  -- type: cold
rndm:send("A strong gust blows in from the north, giving you an awful chill. (<red>" .. tostring(dmg) .. "</>)")
self.room:send_except(rndm, "A strong gust blows in from the north, which seems to chill " .. rndm.name .. ". (<blue>" .. tostring(dmg) .. "</>)")$trig$, '87771046bef4fac4f443acab533ddb8f'),
  -- data/triggers/533/533_02_triaszp_helpers.lua
  (533, 2, $trig$-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
wait(1)
local value = random(1, 10)
if value == 1 then
    self:breath_attack("frost", nil)
elseif value == 2 or value == 3 then
    self:command("sweep")
elseif value == 4 or value == 5 then
    self:command("roar")
elseif value == 8 or value == 9 then
    if world.count_mobiles(533, 1) < 6 then
        local victim = self.room.actors[random(1, #self.room.actors)]
        self:emote("hisses in anger, calling to her children.")
        wait(1)
        self.room:spawn_mobile(533, 1)
        local baby = self.room:find_actor("baby-dragon")
        if baby then
            baby:emote("scampers in and attacks!")
            if victim and victim.is_player then
                baby:command("kill " .. tostring(victim.name))
            else
                baby:command("kill " .. tostring(actor.name))
            end
        end
    end
else
    self:command("growl")
end$trig$, '4a0528f2669ded35b9dd82cd5d866827'),
  -- data/triggers/534/534_02_slip_on_trail.lua
  (534, 2, $trig$-- Converted from DG Script #53402: slip_on_trail
-- Original: WORLD trigger, flags: PREENTRY, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
wait(2)
local rnd = self.room.actors[random(1, #self.room.actors)]
-- this trigger is in multiple rooms, socheck we are in right one
if rnd.room == actor.room then
    -- check for flying first...
    if not (rnd:has_effect(Effect.Flying)) then
        local dam = 0
        rnd:send("You slip on the icy path and fall!")
        self.room:send_except(rnd, tostring(rnd.name) .. " slips and falls!")
        -- TODO(parity): original DG compared room vnum to 53527-53530 (zone 535,
        -- ids 27-30). actor.room is now a Room object, not an integer. Rewrite
        -- using actor.room.zone_id / actor.room.local_id once those rooms map.
        local rzone = actor.room.zone_id
        local rid = actor.room.local_id
        if rzone == 535 and rid == 30 then
            dam = dam + 100
        elseif rzone == 535 and rid == 29 then
            dam = dam + 75
        elseif rzone == 535 and rid == 28 then
            dam = dam + 50
        elseif rzone == 535 and rid == 27 then
            dam = dam + 25
        end
        rnd:teleport(get_room(534, 17))
        local damage_dealt = rnd:damage(dam)  -- type: physical
        get_room(534, 17):at(function()
            -- rnd looks around
        end)
        get_room(534, 17):at(function()
            self.room:send_except(rnd, tostring(rnd.name) .. " comes tumbling down the ice trail from the east.")
        end)
    end
end$trig$, '5f60a1f2778a652b9d142ea1076726d3'),
  -- data/triggers/534/534_09_fv_aeron_entry.lua
  (534, 9, $trig$-- Converted from DG Script #53409: fv_Aeron_entry
-- Original: MOB trigger, flags: ENTRY, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
local rnd = self.room.actors[random(1, #self.room.actors)]
if rnd.is_player then
    self.room:send_except(rnd, tostring(self.name) .. " glances up at " .. tostring(rnd.name) .. " then goes back to reading.")
    rnd:send(tostring(self.name) .. " glances up at you then goes back to reading.")
else
end$trig$, '38c34be6968f3d7ce9790cbeed8f38e1'),
  -- data/triggers/580/580_100_exit_room_58196.lua
  (580, 100, $trig$if direction == "north" then
    if not running then
        local running = 1
        globals.running = globals.running or true
        wait(1)
        local rnd = self.room.actors[random(1, #self.room.actors)]
        rnd:send("An image of a goddess appears before you for a second - she holds her hands out to you.")
        wait(1)
        rnd:send("The goddess says, 'Speak my name to leave this room, Yajiro was ever the joker...'")
        wait(1)
        rnd:send("The goddess gets enfolded into a large pearl then suddenly she disappears.")
        running = nil
    end
end$trig$, '56f7df7808b298750186446eb98a9c8e'),
  -- data/triggers/590/590_38_agressive_attack3.lua
  (590, 38, $trig$-- Converted from DG Script #59038: agressive_attack3
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(8)
local victim = self.room.actors[random(1, #self.room.actors)]
if victim.level <100 and victim.is_player then
    combat.engage(self, victim.name)
end$trig$, 'a922d8d569418ddf0296ecaa5ea70a7a'),
  -- data/triggers/590/590_40_old_man_steal.lua
  (590, 40, $trig$-- Converted from DG Script #59040: old_man_steal
-- Original: MOB trigger, flags: GREET, probability: 100%
local target = self.room.actors[random(1, #self.room.actors)]
local rnd = random(1, 100)
local loot
if rnd > 99 then
    loot = "gem"
elseif rnd == 99 then
    loot = "iron"
elseif (rnd <= 98) and (rnd >= 97) then
    loot = "cloth"
elseif (rnd <= 96) and (rnd >= 95) then
    loot = "wood"
elseif (rnd <= 94) and (rnd >= 93) then
    loot = "white"
elseif (rnd <= 92) and (rnd >= 90) then
    loot = "red"
elseif (rnd <= 89) and (rnd >= 85) then
    loot = "blue"
elseif (rnd <= 84) and (rnd >= 80) then
    loot = "green"
elseif (rnd <= 79) and (rnd >= 76) then
    loot = "black"
elseif (rnd <= 75) and (rnd >= 71) then
    loot = "dagger"
elseif (rnd <= 70) and (rnd >= 66) then
    loot = "shield"
elseif (rnd <= 65) and (rnd >= 61) then
    loot = "sword"
elseif (rnd <= 60) and (rnd >= 56) then
    loot = "leather"
elseif (rnd <= 55) and (rnd >= 46) then
    loot = "raft"
elseif (rnd <= 45) and (rnd >= 36) then
    loot = "canoe"
elseif (rnd <= 35) and (rnd >= 26) then
    loot = "sack"
elseif (rnd <= 25) and (rnd >= 16) then
    loot = "bag"
elseif rnd <= 15 then
    loot = "gem"
end
if loot and target.is_player and target.level < 100 then
    self:command("steal " .. tostring(loot) .. " " .. tostring(target.name))
end$trig$, 'cffa8bd461e5194e14cea21c41769440'),
  -- data/triggers/615/615_02_fairy_tickles_people.lua
  (615, 2, $trig$-- Converted from DG Script #61502: Fairy tickles people
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
wait(4)
local val = random(1, 3)
-- switch on val
if val == 1 then
    local ch = self.room.actors[random(1, #self.room.actors)]
    self:command("tickle " .. tostring(ch.name))
else
    self:command("tickle gnome")
end$trig$, '6f0dc29a7d8d7958b749d80def05e20d'),
  -- data/triggers/615/615_43_the_tickler.lua
  (615, 43, $trig$-- Converted from DG Script #61543: The tickler
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
wait(1)
local val = random(1, 3)
-- switch on val
if val == 1 then
    local ch = self.room.actors[random(1, #self.room.actors)]
    self:command("tickle " .. tostring(ch.name))
else
end$trig$, '4252b433007450b33041399eb3b4aa17')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
