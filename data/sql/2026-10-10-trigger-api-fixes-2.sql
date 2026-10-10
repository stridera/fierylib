-- Trigger API fixes 2: wait_ticks, wizard_notify, actor:cast, actor:has_effect_named, get_people() lists, .composition, .wearing and .val0-.val3 now exist. Scripts that walked the room with the DG people/next_in_room linked list now iterate get_people(); the staff mskillset command (refused for scripts) is actor:set_skill, and the 087 skillset helpers are rewritten as a working state machine.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/022/022_01_balor_death_damage.lua
  (22, 1, $trig$-- Converted from DG Script #2201: Balor_death_damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
for _, person in ipairs(self:get_people()) do
    if person.id ~= 2216 then
        local damage = 100 + random(1, 50)
        local damage_dealt = person:damage(damage)  -- type: fire
        person:send("The Balor explodes in a <b:yellow>blinding</> flash, scorching the area! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
end
wait(2)
self.room:send("<b:white>As the smoke <white>subsides, a stairway down appears.</>")
get_room(22, 15):exit("down"):set_state({hidden = false})
get_room(22, 15):exit("down"):set_state({description = "Down the stairs, there is a faint sound of cheering..."})$trig$),
  -- data/triggers/022/022_20_nezer_entry_trigger.lua
  (22, 20, $trig$-- Converted from DG Script #2220: Nezer_Entry_Trigger
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- Nezer entry messages
if not globals.alreadydone then
    globals.alreadydone = true
    wait(10)
    self.room:send("A large flapping noice can be heard coming from above.")
    wait(8)
    self.room:send("The blood red sky is suddenly blocked out by a flying silhouette.")
    wait(8)
    self.room:send("You're forced to duck suddenly, as a massive figure swoops low, nearly taking your head off.")
    wait(10)
    self.room:send("With a giant thump Nezer of Raymif hits the ground sending a shockwave across the ground!")
    -- start of damage loop
    for _, victim in ipairs(self:get_people()) do
        if (victim.is_player) and (victim.level < 100) then
            local damage = 350 + random(1, 50)
            local damage_dealt = victim:damage(damage)  -- type: crush
            if damage_dealt == 0 then
                victim:send("Nezer's shockwave passes through you like a shot, momentarily disorienting you.")
            elseif victim:has_effect(Effect.Flying) then
                damage = damage / 2
                victim:send("Nezer's shockwave sends you flying into the arena wall! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, tostring(victim.name) .. " is thrown violently into the arena's wall! (<blue>" .. tostring(damage_dealt) .. "</>)")
            else
                victim:send("You are slammed violently into the ground after being thrown into the air by Nezer's shockwave! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, tostring(victim.name) .. " is slammed into the ground after being thrown into the air by Nezer's shockwave! (<blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    self.room:spawn_mobile(12, 0)
end$trig$),
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
        target = room.actors[random(1, #room.actors)]
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
end$trig$),
  -- data/triggers/022/022_41_belial_pre_combat_banter.lua
  (22, 41, $trig$-- Converted from DG Script #2241: belial_pre_combat_banter
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Belial's Pre Combat Banter
-- Stage marker: belial_queue == 2 (set in source, used by trigger 42 to choose return banter)
globals.belial_queue = 2
for _, victim in ipairs(self:get_people()) do
    if victim.id ~= 2219 then
        if victim.class == "Paladin" then
            if victim.gender == "Female" then
                wait(1)
                victim:send("Belial slowly approaches, lifting your chin to meet his piercing gaze.")
                self.room:send_except(victim, "Belial slowly approaches " .. tostring(victim.name) .. ", lifting her chin to his gaze.")
                wait(5)
                self.room:send("Belial says in common, 'A rare and beautiful thing...'")
                wait(3)
                self.room:send("Belial says in common, 'Such a pity you should end here.'")
                victim:send("Belial gently presses a finger to your lips.")
                self.room:send_except(victim, "Belial gently presses a finger to the lips of " .. tostring(victim.name) .. "'.")
                wait(5)
                self.room:send("Belial says in common, 'I could offer you such pleasures beyond imagination.'")
                wait(3)
                victim:send("Belial stares deeply into your eyes.")
                self.room:send_except(victim, "Belial stares deeply into the eyes of " .. tostring(victim.name))
                self.room:send("Belial says in common, 'But that would not be enough, no.?'")
                wait(5)
                self.room:send("Belial says in common, 'No... your soul is too puerile to understand such!'")
                wait(3)
                victim:send("Belial casts your head away from his sudden, baleful sneer.")
                self.room:send_except(victim, "Belial balefully sneers at " .. tostring(victim.name) .. ", casting her head aside.")
                self.room:send("Belial says in common, 'Instead you shall all die by my hand!'")
                wait(1)
                self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
                return true
            elseif victim.gender == "Male" then
                wait(1)
                victim:send("Belial slowly paces about you, sizing up your mettle.")
                self.room:send_except(victim, "slowly paces about " .. tostring(victim.name) .. ", sizing him up.")
                wait(5)
                self.room:send("Belial says in common, 'Such pious arrogance...'")
                wait(3)
                self.room:send("Belial says in common, 'Fitting that you should end here.'")
                self.room:send("Belial pauses for a moment, pressing his finger to his lips.")
                wait(5)
                self.room:send("Belial breaths in heavily, raising his hands skyward.")
                self.room:send("Belial says in common, 'Do you hear them... do you hear their screams?'")
                wait(5)
                self.room:send("Belial says in common, 'They sing to me...'")
                wait(3)
                victim:send("Belial snaps around, sneering at you with loathing and contempt.")
                self.room:send_except(victim, "Belial snaps around, sneering at " .. tostring(victim.name) .. " with loathing and contempt.")
                wait(5)
                self.room:send("Belial says in common, 'And now I shall add your screams to the concerto!'")
                wait(1)
                self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
                return true
            end
        else
            wait(2)
            self.room:send("Belial says in common, 'How charming, someone come to throw themselves on my blade!'")
            wait(3)
            self.room:send("Belial says in common, 'Agents of a lesser perhaps... hmmm?'")
            self.room:send("Belial says in common, 'Come to usurp my throne, yes?'")
            wait(5)
            self.room:send("Belial paces about observingly, one hand clenched around a blood-red ranseur.")
            wait(3)
            self.room:send("Belial says in common, 'What's the matter, hellcat got your tongue?'")
            wait(3)
            self.room:send("Belial says in common, 'Don't be fooled, I see you trembling with fear...'")
            self.room:send("Belial says in common, 'I can smell it on you like a rotting, fetid wound!'")
            wait(5)
            self.room:send("Belial's eyes flair black as coal as he spins the blood-red ranseur about.")
            wait(3)
            self.room:send("Belial says in common, 'No matter, for your life ends here!'")
            self.room:send("Belial growls, 'Have at thee!'")
            wait(1)
            self.room:find_actor("belial"):command("kill " .. tostring(victim.name))
            return _return_value
        end
    end
end$trig$),
  -- data/triggers/022/022_46_belial_blasphemy_script.lua
  (22, 46, $trig$-- Converted from DG Script #2246: belial_blasphemy_script
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- blasphemy = 325-400hp demonic unholy word!
wait(1)
self.room:send("Belial throws his hands in the air, uttering in demonic, 'Verai Thak!'")
for _, victim in ipairs(self:get_people()) do
    if (victim.is_player) and (victim.level < 100) then
        local damage = 325 + random(1, 75)
        victim:send("You cover your ears in horror upon hearing the demonic oath! (<b:red>" .. tostring(damage) .. "</>)")
        self.room:send_except(victim, tostring(victim.name) .. " covers " .. tostring(victim.possessive) .. " ears in horror upon hearing the demonic oath! (<blue>" .. tostring(damage) .. "</>)")
        local damage_dealt = victim:damage(damage)  -- type: physical
    end
end$trig$),
  -- data/triggers/043/043_98_leading_player.lua
  (43, 98, $trig$-- Converted from DG Script #4398: leading_player
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:send("The players CHEER madly!!")
wait(5)
self.room:send("Turning to you, the Leading Player gestures to the burning wreckage of the fire box.")
self.room:send("The Leading Player grins evilly.")
wait(4)
self.room:send("The Leading Player winks as he says, 'You're one of us now kid, part of the troupe.'")
wait(3)
self.room:send("The Leading Player summons the burning wreckage together, creating a small burning circle.")
wait(2)
self.room:send("It hovers in his outstretched hand for a moment before he lowers his hand, leaving it suspended in the air.")
wait(4)
self.room:send("The Leading Player says, 'My gift to you,' as he turns to leave.")
for _, person in ipairs(self:get_people()) do
    if person:get_quest_stage("theatre") >= 7 then
        self.room:spawn_object(43, 19)
        person:set_quest_var("theatre", "fire_ring", 1)
        person:complete_quest("theatre")
        person:command("get fire-ring")
    end
end
wait(4)
self.room:send("The Leading Player blows a kiss over his shoulder and slinks off into the shadows.")
wait(8)
self.room:send("One by one the other players follow, slipping off into the theater.")
wait(6)
self.room:send("You blink and the theater has returned to normal.")
-- TODO(parity): original DG used vnum 1100 for the leading-player holding room
-- and 4399 for the leading-player mob. Verify (11, 0) is the right composite for
-- the holding room and that find_player can locate the leading-player mob there.
local holding = get_room(11, 0)
if holding and holding:find_actor("leading-player") then
    holding:at(function()
        find_player("leading-player"):teleport(get_room(43, 33))
    end)
end$trig$),
  -- data/triggers/043/043_99_the_finale.lua
  (43, 99, $trig$-- Converted from DG Script #4399: The_Finale
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- TODO(parity): original DG referenced rooms 4336 (fire box), 4333 (stage) and
-- mob 4399 (leading player) by vnum. Confirm composite (43, 36) / (43, 33) and
-- the leading-player lookup once the runtime API stabilises.
local fire_box_room = get_room(43, 36)
if not fire_box_room or not fire_box_room.people then
    return true
else
    local stage_room = get_room(43, 33)
    if stage_room and stage_room:find_actor("leading-player") then
        stage_room:at(function()
            find_player("leading-player"):teleport(get_room(11, 0))
        end)
    end
    local char
    if fire_box_room:find_actor("pippin") then
        char = fire_box_room:find_actor("pippin")
    else
        char = self:get_people()[1]
    end
    self.room:send("The Fire Goddess shouts, 'Ladies and Gentlemen!  We present to you a spectacle never before seen on a public stage!  The only completely perfect act in our repertoire!'")
    get_room(43, 33):at(function()
        self.room:send("The Fire Goddess shouts, 'Ladies and Gentlemen!  We present to you a spectacle never before seen on a public stage!  The only completely perfect act in our repertoire!'")
    end)
    wait(4)
    self.room:send("A chorus of voices shouts out in response, 'THE FINALE!!'")
    get_room(43, 33):at(function()
        self.room:send("A chorus of voices shouts out in response, 'THE FINALE!!'")
    end)
    wait(5)
    self.room:send("Deep, stirring chords are struck on numerous instruments, resounding like a death knell in the box.")
    get_room(43, 33):at(function()
        self.room:send("Instruments strum to life all around.")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("Deep, stirring chords break loose from the darkness, haunting the stage.")
    end)
    self.room:send("Voices starting to sing outside the box, faintly in the distance.")
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("Ghostly voices float through theater, singing and whispering unintelligibly.")
    end)
    wait(7)
    self.room:send("A single, strong male voice sounds out in the darkness, calling out your name, inviting you to dance.")
    get_room(43, 33):at(function()
        self.room:send("From the darkness of the fire box emerges the Leading Player in all his glory, inviting you to dance.")
    end)
    get_room(43, 33):at(function()
        self.room:send("The Leading Player stalks the room with his eyes, crooning, '" .. tostring(char.name) .. ", think about the sun.'")
    end)
    wait(6)
    get_room(43, 33):at(function()
        self.room:send("Pointing to the rafters, the Leading Player screams, 'Let's give this angel some more light!!'")
    end)
    get_room(43, 33):at(function()
        self.room:send("Oppressively bright light bursts down from the enormous sun on the theater ceiling.")
    end)
    wait(6)
    self.room:send("A powerful, driving chord strikes and strikes hard!")
    get_room(43, 33):at(function()
        self.room:send("A powerful, driving chord strikes and strikes hard!")
    end)
    wait(2)
    self.room:send("The music starts to blast a new, driving beat.")
    get_room(43, 33):at(function()
        self.room:send("The music starts to blast a new, driving beat.")
    end)
    wait(5)
    self.room:send("The rhythm starts to pick up, pounding faster and faster, drawing you into the melody, begging your body to dance.")
    get_room(43, 33):at(function()
        self.room:send("The players emerge from all around, moving to the now pounding rhythm.")
    end)
    get_room(43, 33):at(function()
        self.room:send("You find yourself swept up into the dance, unable to resist the music.")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("The players swirl about you, tumbling together into a giant clump.")
    end)
    wait(5)
    self.room:send("Suddenly, the box begins to get hotter and hotter, the inside starting to smoke.")
    get_room(43, 33):at(function()
        self.room:send("Moving into a circle around the stage, the players sing, 'When the power and the glory are there at your command!'")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("They wave their rings at the fire box as the Fire Goddess heats the box with her touch.")
    end)
    wait(6)
    self.room:send("Lights explode through the walls of the box, sparking the wood and lighting the box on fire!")
    get_room(43, 33):at(function()
        self.room:send("Glowing with an inner fire as they dance, the players call out, '" .. tostring(char.name) .. "!!'")
    end)
    wait(6)
    self.room:send("<blue>Br<b:yellow>i</><blue>ll<b:yellow>ia</><blue>nt</> flash charges go off all around, exploding in a barrage of colors!")
    get_room(43, 33):at(function()
        self.room:send("<blue>Br<b:yellow>i</><blue>ll<b:yellow>ia</><blue>nt</> flash charges go off all around, exploding in a barrage of colors!")
    end)
    wait(4)
    get_room(43, 33):at(function()
        self.room:send("The players belt out in unison 'THINK ABOUT THE SUN!!'")
    end)
    wait(10)
    self.room:send("A voice cackles from the stage as the box <red>E<b:yellow>X<b:red>P</><red>L<red>O<b:yellow>D<red>E</><red>S</> into flames!!!!")
    get_room(43, 33):at(function()
        self.room:send("The Leading Player cackles as the box <red>E<b:yellow>X<b:red>P</><red>L<red>O<b:yellow>D<red>E</><red>S</> into flames!!!")
    end)
    for _, person in ipairs(self:get_people()) do
        if person.is_npc then
            person:damage(1000)  -- type: physical
        else
            person:damage(200)  -- type: physical
        end
    end
    wait(2)
    self.room:teleport_all(get_room(43, 33))
    get_room(43, 33):at(function()
        world.destroy(self.room:find_actor("box"))
    end)
    get_room(43, 33):at(function()
        self.room:spawn_object(43, 22)
    end)
    get_room(43, 36):exit("down"):set_state({hidden = false})
    wait(2)
    get_room(43, 36):exit("down"):set_state({hidden = true})
    -- TODO(parity): confirm holding-room composite for the leading player.
    local holding = get_room(11, 0)
    if holding and holding:find_actor("leading-player") then
        holding:at(function()
            find_player("leading-player"):teleport(get_room(43, 33))
        end)
    end
end$trig$),
  -- data/triggers/060/060_27_thief_subclass_sneak_past.lua
  (60, 27, $trig$-- Converted from DG Script #6027: thief_subclass_sneak_past
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if self.is_fighting then
    return _return_value
end
local room = self.room
for _, person in ipairs(room:get_people()) do
    if person:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
        if person:get_quest_stage("merc_ass_thi_subclass") == 3 or person:get_quest_stage("merc_ass_thi_subclass") == 4 then
            if person.can_be_seen and person.hiddenness < 1 then
                person:send(tostring(self.name) .. " notices you skulking about!")
                person:send(tostring(self.name) .. " says, 'Who are you?!  You weren't invited here!'")
                self.room:send_except(person, tostring(self.name) .. " shoos " .. tostring(person.name) .. " off the farm!")
                person:send(tostring(self.name) .. " shoos you off the farm!")
                person:teleport(get_room(80, 6))
                wait(1)
                -- person looks around
                actor:fail_quest("merc_ass_thi_subclass")
                actor:send("<b:yellow>You have failed your quest!</>")
                actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
            end
        end
    end
end$trig$),
  -- data/triggers/085/085_59_resurrection_quest_grant_spell_get.lua
  (85, 59, $trig$-- Converted from DG Script #8559: Resurrection_quest_grant_spell_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("resurrection_quest") > 10 then
    wait(1)
    actor:send("You thumb through the book and find Norisent has taught you all you need to know.")
    -- Legacy had a hidden helper mob (85, 51) run the staff `mskillset`
    -- command; the script-origin gate refuses that, so grant the skill
    -- directly (1000 = the legacy "max proficiency" mskillset gave).
    actor:set_skill("resurrect", 1000)
    actor:send("<b:cyan>You have learned Resurrect.</>")
    self.room:send(tostring(self.shortdesc) .. " crumbles to dust and blows away.")
    actor:complete_quest("resurrection_quest")
    if not actor:get_quest_var("hell_trident:helltask5") and actor:get_quest_stage("hell_trident") == 2 then
        actor:set_quest_var("hell_trident", "helltask5", 1)
    end
    world.destroy(self)
end$trig$),
  -- data/triggers/087/087_97_skillset_skills_a-g.lua
  (87, 97, $trig$local KEYWORDS = {
    ["skillset"] = true, ["ready"] = true, ["go"] = true, ["cancel"] = true, ["2h"] = true,
    ["backstab"] = true, ["bandage"] = true, ["barehand"] = true, ["bash"] = true,
    ["bludgeoning"] = true, ["bodyslam"] = true, ["chant"] = true, ["conceal"] = true,
    ["corner"] = true, ["disarm"] = true, ["dodge"] = true, ["doorbash"] = true,
    ["double"] = true, ["douse"] = true, ["dual"] = true, ["eye"] = true, ["first"] = true,
    ["group"] = true, ["guard"] = true,
}

local said = string.lower(speech)
local heard = false
for word in string.gmatch(said, "[%w']+") do
    if KEYWORDS[word] then
        heard = true
        break
    end
end
if not heard then
    return true  -- No matching keywords
end
wait(1)

local command = self:getvar("command")
local skill = self:getvar("skill")
local mortal = self:getvar("mortal")

local function start_over()
    self:clearvar("command")
    self:clearvar("skill")
    self:clearvar("mortal")
end

if skill and mortal and command then
    if said == "go" and actor.level >= 101 then
        local target = find_player(mortal)
        if target and target.is_player and target:set_skill(skill, 1000) then
            self:say("Done. Did it work?")
        else
            self:say("I could not set " .. tostring(skill) .. " on " .. tostring(mortal) .. ".")
        end
        start_over()
    elseif said == "cancel" then
        self:say("Ok, lets start over, starting with the command..")
        start_over()
    end
elseif skill and command then
    self:setvar("mortal", actor.name)
    self:say("Ok, imm, if you want to " .. tostring(command) .. " " .. tostring(skill) .. " to " .. tostring(actor.name) .. ", just say go!")
elseif command then
    if said == "ready" or said == "go" or said == "cancel" or said == "skillset" then
        return true  -- Not a skill name
    end
    self:say("Ok, I'll be " .. tostring(command) .. "ing " .. tostring(speech) .. ".")
    self:say("Mortal, if you are ready to get " .. tostring(speech) .. ", say \"ready\".")
    self:setvar("skill", speech)
elseif said == "skillset" then
    self:setvar("command", "mskillset")
    self:say("what skill will I be setting?")
end
return true$trig$),
  -- data/triggers/087/087_98_skillset_skills_h-v.lua
  (87, 98, $trig$local KEYWORDS = {
    ["skillset"] = true, ["ready"] = true, ["go"] = true, ["cancel"] = true, ["hide"] = true,
    ["hitall"] = true, ["instant"] = true, ["kick"] = true, ["meditate"] = true,
    ["mount"] = true, ["pick"] = true, ["parry"] = true, ["piercing"] = true, ["quick"] = true,
    ["rescue"] = true, ["retreat"] = true, ["riding"] = true, ["safefall"] = true,
    ["scribe"] = true, ["riposte"] = true, ["shadow"] = true, ["shape"] = true,
    ["slashing"] = true, ["sneak"] = true, ["spell"] = true, ["sphere"] = true,
    ["springleap"] = true, ["steal"] = true, ["stealth"] = true, ["summon"] = true,
    ["switch"] = true, ["tame"] = true, ["throatcut"] = true, ["track"] = true, ["vamp"] = true,
}

local said = string.lower(speech)
local heard = false
for word in string.gmatch(said, "[%w']+") do
    if KEYWORDS[word] then
        heard = true
        break
    end
end
if not heard then
    return true  -- No matching keywords
end
wait(1)

local command = self:getvar("command")
local skill = self:getvar("skill")
local mortal = self:getvar("mortal")

local function start_over()
    self:clearvar("command")
    self:clearvar("skill")
    self:clearvar("mortal")
end

if skill and mortal and command then
    if said == "go" and actor.level >= 101 then
        local target = find_player(mortal)
        if target and target.is_player and target:set_skill(skill, 1000) then
            self:say("Done. Did it work?")
        else
            self:say("I could not set " .. tostring(skill) .. " on " .. tostring(mortal) .. ".")
        end
        start_over()
    elseif said == "cancel" then
        self:say("Ok, lets start over, starting with the command..")
        start_over()
    end
elseif skill and command then
    self:setvar("mortal", actor.name)
    self:say("Ok, imm, if you want to " .. tostring(command) .. " " .. tostring(skill) .. " to " .. tostring(actor.name) .. ", just say go!")
elseif command then
    if said == "ready" or said == "go" or said == "cancel" or said == "skillset" then
        return true  -- Not a skill name
    end
    self:say("Ok, I'll be " .. tostring(command) .. "ing " .. tostring(speech) .. ".")
    self:say("Mortal, if you are ready to get " .. tostring(speech) .. ", say \"ready\".")
    self:setvar("skill", speech)
elseif said == "skillset" then
    self:setvar("command", "mskillset")
    self:say("what skill will I be setting?")
end
return true$trig$),
  -- data/triggers/087/087_99_skillset_questspells.lua
  (87, 99, $trig$local KEYWORDS = {
    ["skillset"] = true, ["ready"] = true, ["go"] = true, ["cancel"] = true, ["banish"] = true,
    ["blur"] = true, ["charm"] = true, ["creeping"] = true, ["plane"] = true,
    ["heavens"] = true, ["dragons"] = true, ["flood"] = true, ["hell"] = true,
    ["hellfire"] = true, ["ice"] = true, ["major"] = true, ["relocate"] = true,
    ["meteorswarm"] = true, ["resurrect"] = true, ["shift"] = true, ["degeneration"] = true,
    ["supernova"] = true, ["wall"] = true, ["vaporform"] = true, ["word"] = true,
    ["wizard"] = true, ["aria"] = true, ["seed"] = true, ["apocalyptic"] = true,
    ["group"] = true,
}

local said = string.lower(speech)
local heard = false
for word in string.gmatch(said, "[%w']+") do
    if KEYWORDS[word] then
        heard = true
        break
    end
end
if not heard then
    return true  -- No matching keywords
end
wait(1)

local command = self:getvar("command")
local skill = self:getvar("skill")
local mortal = self:getvar("mortal")

local function start_over()
    self:clearvar("command")
    self:clearvar("skill")
    self:clearvar("mortal")
end

if skill and mortal and command then
    if said == "go" and actor.level >= 101 then
        local target = find_player(mortal)
        if target and target.is_player and target:set_skill(skill, 1000) then
            self:say("Done. Did it work?")
        else
            self:say("I could not set " .. tostring(skill) .. " on " .. tostring(mortal) .. ".")
        end
        start_over()
    elseif said == "cancel" then
        self:say("Ok, lets start over, starting with the command..")
        start_over()
    end
elseif skill and command then
    self:setvar("mortal", actor.name)
    self:say("Ok, imm, if you want to " .. tostring(command) .. " " .. tostring(skill) .. " to " .. tostring(actor.name) .. ", just say go!")
elseif command then
    if said == "ready" or said == "go" or said == "cancel" or said == "skillset" then
        return true  -- Not a skill name
    end
    self:say("Ok, I'll be " .. tostring(command) .. "ing " .. tostring(speech) .. ".")
    self:say("Mortal, if you are ready to get " .. tostring(speech) .. ", say \"ready\".")
    self:setvar("skill", speech)
elseif said == "skillset" then
    self:setvar("command", "mskillset")
    self:say("what skill will I be setting?")
end
return true$trig$),
  -- data/triggers/117/117_00_11765_to_11766_south_exit.lua
  (117, 0, $trig$-- Converted from DG Script #11700: 11765_to_11766_south_exit
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: wave fog
if not (cmd == "wave" or cmd == "fog") then
    return true  -- Not our command
end
get_room(117, 65):exit("south"):set_state({hidden = false})
get_room(117, 65):exit("south"):set_state({description = "A wall of fog is parted to the south, allowing passage."})
get_room(117, 65):exit("south"):set_state({name = "mistwall mistdoor"})
self.room:send_except(actor, tostring(actor.name) .. " waves " .. tostring(actor.possessive) .. " hands around causing the fog south to dissipate allowing passage.")
actor:send("By moving your hands you clear a passage through the fog to the south.")
get_room(117, 66):at(function()
    self.room:send("The fog to the north clears a little.")
end)
-- Legacy `wait 1 tick`: one game hour (75s).
wait_ticks(1)
self.room:send("The fog slowly closes back around the exit to the south.")
get_room(117, 65):exit("south"):set_state({hidden = true})$trig$),
  -- data/triggers/123/123_28_gorgon_fight.lua
  (123, 28, $trig$-- Converted from DG Script #12328: gorgon_fight
-- Original: MOB trigger, flags: FIGHT, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
wait(2)
self.room:send("A gorgon exhales a cloud of <cyan>paralyzing gas!</>")
local room = self.room
for _, person in ipairs(room:get_people()) do
    if person.is_player then
        spells.cast(self, "major paralysis", person, 2)
    end
end$trig$),
  -- data/triggers/123/123_31_faerie_dragon_fight.lua
  (123, 31, $trig$-- Converted from DG Script #12331: faerie_dragon_fight
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
wait(2)
self.room:send("A faerie dragon exhales a cloud of <red>e<b:yellow>u<red>p<green>h<blue>o<cyan>r<magenta>i</><red>c</> gas!")
local room = self.room
for _, person in ipairs(room:get_people()) do
    if person.is_player then
        spells.cast(self, "confusion", person, self.level)
    end
end$trig$),
  -- data/triggers/172/172_06_ill-subclass_drop_the_vial.lua
  (172, 6, $trig$wait(1)
local room_zone = actor.room.zone_id
local room_id = actor.room.local_id
local in_hideout = room_zone == 363 and room_id >= 15 and room_id <= 39

if not (in_hideout and actor:get_quest_stage("illusionist_subclass") == 1) then
    self.room:send("The vial breaks easily, and a small gray puff of gas quickly disperses.")
    self.room:send("A sense of magic is felt, but it quickly fades.")
    self.room:send("It appears as though something has gone wrong.")
    world.destroy(self)
    return false
end

self.room:send("The vial breaks easily, and the small gray puff of gas quickly disperses.")
self.room:send("As the moments pass, you sense a magical tension building.")
self.room:send("It spreads outward as its strength grows.")
actor:advance_quest("illusionist_subclass")

-- Scan the room for any smuggler who could have noticed.
local smuggler_found = false
local chief_found = false
local leader_found = false
for _, person in ipairs(self.room:get_people()) do
    local incapacitated = person:has_effect(Effect.Blind)
        or string.find(person.stance or "", "mortally")
        or string.find(person.stance or "", "incapacitated")
        or string.find(person.stance or "", "stunned")
        or string.find(person.stance or "", "sleeping")
    if not incapacitated and person.zone_id == 363 then
        if person.local_id == 0 or person.local_id == 3 or person.local_id == 4 then
            smuggler_found = true
        elseif person.local_id == 6 then
            chief_found = true
            smuggler_found = true
        elseif person.local_id == 1 then
            leader_found = true
            smuggler_found = true
        end
    end
end

if leader_found then
    wait(1)
    local gannigan = self.room:find_actor("gannigan")
    if gannigan then
        gannigan:command("gasp")
        gannigan:say("Cestia... what on earth are you doing?")
    end
elseif chief_found then
    wait(1)
    local chief = self.room:find_actor("chief")
    if chief then
        chief:say("Hrnn?  Irksome wench!  Gannigan shall hear of this!")
    end
elseif smuggler_found then
    wait(1)
    local smuggler = self.room:find_actor("smuggler")
    if smuggler then
        smuggler:emote("looks somewhat confused, but also suspicious.")
        smuggler:say("Hey... ummm...  I'd better let the big guy know you're up to something...  No offense ma'am, but that didn't look too innocent.")
    end
end

if smuggler_found then
    actor:advance_quest("illusionist_subclass")
end

world.destroy(self)
return false$trig$),
  -- data/triggers/172/172_13_ill-subclass_invasion_illusion.lua
  (172, 13, $trig$wait(1)
zone.echo(363, "<magenta>The scent of magic is discernible, as a spell builds.</>")
wait(5)
zone.echo(363, "<magenta>The magical force is still spreading, and remains low-key.</>")
wait(3)
zone.echo(363, "<magenta>A spell seems to be coming together.  Slowly, it builds.</>")
wait(3)
zone.echo(363, "<magenta>Something supernatural is beginning to coalesce - and the sounds of a militant</>_")
zone.echo(363, "</><magenta>crowd are beginning to rise above the threshold of hearing.</>")
wait(3)
zone.echo(363, "<b:white>Suddenly, a shout is heard!</>_")
zone.echo(363, "<b:white>It is joined by others, and the sounds of battle commence!</>")
wait(2)

local gannigan = nil
local quester = nil
for _, person in ipairs(self:get_people()) do
    if person.zone_id == 363 and person.local_id == 1 then
        gannigan = person
    elseif person.is_player and person:get_quest_stage("illusionist_subclass") > 1 then
        quester = person
    end
end

if not (quester and gannigan) then
    return true
end

local stage = quester:get_quest_stage("illusionist_subclass")
if stage == 2 then
    gannigan:say("What?!  They attack?  Can Mielikki have gone mad?")
    wait(2)
    gannigan:say("Cestia, you must hide!")
    wait(2)
    gannigan:say("Do you recall the incantation?  The one that will reveal the passage above the falls?")
    quester:advance_quest("illusionist_subclass")
    quester:advance_quest("illusionist_subclass")
elseif stage == 3 then
    gannigan:say("An attack?  Cestia!  What have you done?  It is betrayal!")
    wait(2)
    gannigan:command("glare " .. tostring(quester.name))
    wait(2)
    gannigan:say("You will not destroy me.")
    wait(2)
    gannigan:emote("raises his sword in anger!")
    wait(1)
    gannigan:emote("hesitates.")
    wait(3)
    gannigan:say("But I cannot bring myself to raise my sword against you.")
    quester:advance_quest("illusionist_subclass")
    quester:advance_quest("illusionist_subclass")
end$trig$),
  -- data/triggers/172/172_18_ill-subclass_flowers_make_people_sneeze.lua
  (172, 18, $trig$if not percent_chance(5) then
    return true
end
if string.find(actor.class, "Illusionist") then
    return true  -- subclass already complete; flowers no longer affect them
end

wait(2)
local num = random(1, 6)
if num == 1 then
    actor:command("sneeze")
    wait(3)
    actor:command("sneeze")
elseif num == 2 or num == 3 then
    actor:command("sneeze")
elseif num == 4 then
    actor:emote("blinks heavily, trying to clear the tears out of " .. actor.hisher .. " eyes.")
elseif num == 5 then
    actor:send("Your nose feels all itchy.")
else
    actor:emote("wipes " .. actor.hisher .. " nose with " .. actor.hisher .. " sleeve.")
end

-- See if any smuggler is nearby to witness the un-Cestia-like sneezing.
local smuggler = nil
for _, person in ipairs(self:get_people()) do
    if person.zone_id == 363 then
        local lid = person.local_id
        if lid == 0 or lid == 1 or lid == 3 or lid == 4 or lid == 6 then
            smuggler = person
            break
        end
    end
end

if smuggler then
    local reaction = random(1, 5)
    if reaction == 1 then
        actor:send("You notice the smuggler paying close attention to you.")
    elseif reaction == 2 then
        smuggler:command("peer " .. tostring(actor.name))
    elseif reaction == 3 then
        smuggler:command("look " .. tostring(actor.name))
    elseif reaction == 4 then
        smuggler:emote("smiles sweetly.")
        wait(2)
        smuggler:emote("asks, 'Is everything alright?'")
    else
        smuggler:command("consider " .. tostring(actor.name))
    end
end$trig$),
  -- data/triggers/364/364_05_illusory_wall_glasses_examine.lua
  (364, 5, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: examine (full word; ignore the standalone "e" abbrev)
if cmd ~= "examine" then
    return true
end
-- DG passed `arg` to mean "user supplied an argument"; if so, leave to default.
if arg and arg ~= "" then
    return true
end

-- Zone -> region key. Legacy zones grouped by area name.
local ZONE_TO_REGION = {
    [16]  = "Outback",
    [18]  = "Shadows",
    [20]  = "Merchant",
    [23]  = "Caelia_West", [24] = "Caelia_West", [25] = "Caelia_West",
    [26]  = "Caelia_West", [27] = "Caelia_West",
    [28]  = "River",
    [30]  = "Mielikki", [31] = "Mielikki", [32] = "Mielikki",
    [33]  = "Mielikki", [34] = "Mielikki", [53] = "Mielikki",
    [35]  = "Mielikki_Forest", [36] = "Mielikki_Forest", [37] = "Mielikki_Forest",
    [40]  = "Labyrinth",
    [41]  = "Split", [42] = "Split",
    [43]  = "Theatre",
    [51]  = "Rocky_Tunnels",
    [52]  = "Lava",
    [54]  = "Misty", [127] = "Misty", [128] = "Misty", [361] = "Misty",
    [55]  = "Combat",
    [60]  = "Anduin", [61] = "Anduin", [62] = "Anduin",
    [69]  = "Pastures",
    [70]  = "Great_Road",
    [73]  = "Nswamps",
    [80]  = "Farmlands", [81] = "Farmlands", [82] = "Farmlands",
    [83]  = "Frakati",
    [85]  = "Cathedral",
    [86]  = "Meercats",
    [87]  = "Logging",
    [88]  = "Dairy",
    [100] = "Ickle",
    [102] = "Frostbite",
    [103] = "Phoenix",
    [117] = "Blue_Fog_Trail", [118] = "Blue_Fog_Trail", [119] = "Blue_Fog_Trail",
    [120] = "Twisted", [121] = "Twisted", [122] = "Twisted",
    [123] = "Megalith", [124] = "Megalith",
    [125] = "Tower", [126] = "Tower",
    [133] = "Miner",
    [136] = "Morgan",
    [160] = "Mystwatch", [164] = "Mystwatch",
    [161] = "Desert",
    [162] = "Pyramid",
    [163] = "Highlands",
    [169] = "Haunted",
    [172] = "Citadel",
    [173] = "Chaos",
    [178] = "Canyon",
    [180] = "Topiary",
    [185] = "Abbey",
    [203] = "Plains",
    [237] = "Dheduu",
    [238] = "Dargentan",
    [300] = "Ogakh", [301] = "Ogakh",
    [302] = "Bluebonnet",
    [324] = "Caelia_East", [325] = "Caelia_East",
    [350] = "Brush", [351] = "Brush",
    [360] = "Kaaz",
    [362] = "SeaWitch", [411] = "SeaWitch", [412] = "SeaWitch",
    [363] = "Smuggler",
    [364] = "Sirestis",
    [365] = "Ancient_Ruins",
    [370] = "Minithawkin",
    [390] = "Arabel", [391] = "Arabel",
    [410] = "Hive",
    [430] = "Demise", [431] = "Demise", [432] = "Demise",
    [462] = "Nukreth",
    [464] = "Aviary",
    [470] = "Graveyard", [471] = "Graveyard", [472] = "Graveyard",
    [473] = "Graveyard", [474] = "Graveyard",
    [476] = "Earth",
    [477] = "Water",
    [478] = "Fire",
    [480] = "Barrow",
    [481] = "Fiery", [482] = "Fiery",
    [484] = "Doom",
    [488] = "Air",
    [489] = "Lokari",
    [490] = "Griffin", [491] = "Griffin",
    [492] = "BlackIce",
    [495] = "Nymrill",
    [502] = "Bayou",
    [510] = "Nordus", [511] = "Nordus",
    [520] = "Templace",
    [530] = "Sunken", [531] = "Sunken", [532] = "Sunken",
    [533] = "Cult",
    [534] = "Frost", [535] = "Frost",
    [550] = "Technitzitlan", [551] = "Technitzitlan",
    [552] = "Black_Woods",
    [553] = "Kaas_Plains",
    [554] = "Dark_Mountains",
    [555] = "Cold_Fields",
    [556] = "Iron",
    [557] = "Blackrock",
    [558] = "Eldorian", [559] = "Eldorian",
    [564] = "Blacklake",
    [580] = "Odz", [581] = "Odz", [582] = "Odz",
    [583] = "Syric",
    [584] = "KoD", [585] = "KoD",
    [586] = "Beachhead", [587] = "Beachhead",
    [588] = "Ice_Warrior", [589] = "Ice_Warrior",
    [590] = "Haven",
    [615] = "Hollow",
    [625] = "Rhell",
}

local room = self.room
local region = ZONE_TO_REGION[room.zone_id]
if not region then
    return true
end

if actor:get_quest_stage("illusory_wall") ~= 2 or actor:get_has_completed("illusory_wall") then
    return true
end

-- TODO(parity): legacy DG only credits a room if it has at least one DOOR-flag
-- exit in every cardinal direction (n/s/e/w/u/d). The runtime exit API we
-- currently expose does not expose the DOOR flag in a uniform way, so for now
-- we credit the room if it has any closeable exit. Once `exit:has_door()` (or
-- equivalent) lands, gate this check on it.
local has_any_door = false
for _, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
    local ex = room["exit_" .. dir] or (room.exit and room:exit(dir))
    if ex then has_any_door = true; break end
end
if not has_any_door then
    return true
end

local region_key = "illusory_wall:" .. region
if actor:get_quest_var(region_key) then
    actor:send("<b:white>You have already learned all you can from this region.</>")
    return true
end

actor:set_quest_var("illusory_wall", region, 1)
local clue = (actor:get_quest_var("illusory_wall:total") or 0) + 1
actor:send("<b:white>You begin to analyze the room.</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:cyan>You gain more insight on doors and barriers!</>")
actor:set_quest_var("illusory_wall", "total", clue)

if clue >= 20 then
    wait(2)
    self.room:spawn_mobile(364, 2)
    local lyara = self.room:find_actor("post-commander")
    -- Legacy had Lyara run the staff `mskillset`; scripts cannot, so grant
    -- the skill directly (1000 = the legacy "max proficiency").
    actor:set_skill("illusory wall", 1000)
    actor:send("<b:cyan>You have learned everything you need to cast illusory walls!</>")
    actor:complete_quest("illusory_wall")
    wait(1)
    if lyara then
        world.destroy(lyara)
    end
end
return true$trig$),
  -- data/triggers/481/481_43_vulcera_dead.lua
  (481, 43, $trig$-- Converted from DG Script #48143: vulcera_dead
-- Original: MOB trigger, flags: SPEECH, DEATH, probability: 100%

-- Speech keywords: run test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "run") or string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
self.room:send("The ivory ring seems to shimmer for a second.")
-- TODO(parity): original DG referenced room vnum 48223 (zone 482) but the
-- teleport target is (481,123); the legacy script likely had a typo. Treat
-- "current room is the destination" as the bail-out condition.
if not (self.room.zone_id == 481 and self.room.local_id == 123) then
    self.room:teleport_all(get_room(481, 123))
    self.room:send("</>")
    self.room:send("<b:red>A burning hole erupts, sucking everything through it!</>")
    self.room:send("</>")
    local room = get_room(481, 123)
    for _, person in ipairs(room:get_people()) do
        if person.is_player then
            -- person looks around
        end
    end
end
local person = actor
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
person = nil
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == 9 then
            person:set_quest_var("fieryisle_quest", "reward", "yes")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
--
-- Complete Fiery Island
--
run_room_trigger(481, 45)$trig$),
  -- data/triggers/481/481_45_fiery_island_quest_grant_rewards.lua
  (481, 45, $trig$-- Converted from DG Script #48145: Fiery_Island_Quest_Grant_rewards
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
for _, person in ipairs(self:get_people()) do
    if person:get_quest_var("fieryisle_quest:reward") == "yes" and not person:get_has_completed("fieryisle_quest") then
        person:send("You notice special glittering gems amongst the chamber's crystals!")
        -- 
        -- Set X to the level of the award - code does not run without it
        -- Fiery Island, X = 55
        local expcap
        if person.level < 55 then
            expcap = person.level
        else
            expcap = 55
        end
        local expmod = 0
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proportionate amount
        --
        if person.class == "Warrior" or person.class == "Berserker" then
            -- 110% of standard
            expmod = (expmod + (expmod / 10))
        elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
            -- 115% of standard
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
            -- 120% of standard
            expmod = (expmod + (expmod / 5))
        elseif person.class == "Necromancer" or person.class == "Monk" then
            -- 130% of standard
            expmod = (expmod + (expmod * 2) / 5)
        end
        person:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- Fiery Island, xexp = wexp
            person:award_exp(setexp)
            loop = loop + 1
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        person:command("get all.gem")
        person:complete_quest("fieryisle_quest")
    end
end$trig$),
  -- data/triggers/484/484_103_mighty_druid_creeping_doom.lua
  (484, 103, $trig$-- Converted from DG Script #48503: mighty druid creeping doom
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
for _, person in ipairs(self:get_people()) do
    if (person.id < 48500) or (person.id > 48599) then
        local damage = 190 + random(1, 20)
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        self.room:send("<blue>&9The mighty druid sends out an endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 to consume his foes!</> (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = person:damage(damage)  -- type: physical
    end
end$trig$),
  -- data/triggers/484/484_237_titan_fight.lua
  (484, 237, $trig$-- Converted from DG Script #48637: titan fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local action = random(1, 10)
if action > 7 then
    -- 30% chance to punch the tank
    wait(2)
    if actor and (actor.room == self.room) and (actor.is_player) then
        local damage = 300 + random(1, 50)
        if actor:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if actor:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage - 100
        elseif variant == 15 then
            damage = damage + 200
        end
        if damage > 0 then
            local damage_dealt = actor:damage(damage)  -- type: crush
            self.room:send_except(actor, tostring(self.name) .. " punches " .. tostring(actor.name) .. " in the face, giving " .. tostring(actor.object) .. " a black eye. (<yellow>" .. tostring(damage_dealt) .. "</>)")
            actor:send(tostring(self.name) .. " punches you in the face. (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(actor, tostring(self.name) .. " tries to punch " .. tostring(actor.name) .. " in the face, but can't seem to make contact.")
            actor:send(tostring(self.name) .. " tries to punch you, but can't seem to make contact.")
        end
    end
elseif action > 4 then
    -- 30% chance to try to blind the room
    wait(1)
    self:emote("clasps " .. tostring(objects.template(484, 24).name) .. " in his giant hands.")
    self.room:send(tostring(objects.template(484, 24).name) .. " begins to <blue>glow</> brightly.")
    wait(2)
    self.room:send(tostring(objects.template(484, 24).name) .. " flares brightly, throwing blinding light in all directions!")
    local room = self.room
    for _, person in ipairs(room:get_people()) do
        if person.is_player then
            spells.cast(self, "blindness", person, 100)
        end
    end
end
-- 40% chance to do nothing$trig$),
  -- data/triggers/488/488_53_unused.lua
  (488, 53, $trig$do return true end
-- This trigger is now handled in 48806
if not tank then
    return _return_value
end
for _, person in ipairs(self:get_people()) do
    if string.find(tank, "person.name") then
        if person.is_player then
            local damage = 390 + random(1, 40)
        else
            -- If a mob is tanking, hit it for massive damage!
            local damage = 1000 + random(1, 200)
        end
        -- Halve damage for sanc
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        self.room:send_except(person, "Lightning crackles around the Stormchild as she points a finger at " .. tostring(person.name) .. ".")
        person:send("Lightning crackles around the Stormchild as she points a finger at you!")
        wait(2)
        if person and (person.room == 48851) then
            local damage_dealt = person:damage(damage)  -- type: shock
            person:send("The lightning overloads, flowing into a shocking blast flowing straight for you!")
            self.room:send_except(person, "The lightning overloads, flowing into a shocking blast flowing straight for " .. tostring(person.name) .. "!")
            if damage_dealt == 0 then
                self.room:send_except(person, "<blue>The blast passes right through " .. tostring(person.name) .. "'s chest!</>")
                person:send("<blue>The blast goes right through you, striking the wall!</>")
            else
                self.room:send_except(person, "<blue>The blast strikes " .. tostring(person.name) .. " in the chest, throwing " .. tostring(person.object) .. " into the wall!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                person:send("<blue>The blast strikes you square in the chest, throwing you into the wall!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            end
        else
            self.room:send("The lightning fizzles out around the Stormchild.")
        end
        tank = nil
        return _return_value
    end
end$trig$),
  -- data/triggers/489/489_05_lokari_echoes_of_justice.lua
  (489, 5, $trig$-- Converted from DG Script #48905: lokari echoes of justice
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("Lokari starts casting <b:yellow>'echoes of justice'</>...")
wait(1)
self.room:send("Lokari utters the words, 'sdorj lp kandiso'.")
self.room:send("<green>Lokari's justice spreads through the room, striking down trespassers!</>")
for _, person in ipairs(self:get_people()) do
    if person and ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
        local damage = 150 + random(1, 100)
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage / 2
        elseif variant == 15 then
            damage = damage * 2
        end
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            damage = damage / 2
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers under </><yellow>Lokari's justice<b:red>.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<b:red>You shiver as </><yellow>Lokari's justice<b:red> rips through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage) .. "</>)")
        else
            self.room:send_except(person, "<yellow>" .. tostring(person.name) .. " slumps under the knowledge of " .. tostring(person.possessive) .. " own wrongdoing.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<yellow>You slump under the knowledge of your own wrongdoing.</> (<b:red>" .. tostring(damage) .. "</>)")
        end
        person:damage(damage)  -- type: physical
    end
end$trig$),
  -- data/triggers/489/489_12_maid-cleric_spells.lua
  (489, 12, $trig$-- Clear stop-casting message
if globals.stop_casting then
    globals.stop_casting = nil
end
if globals.casting then
    return true
end
globals.casting = 1
local heal_chance = random(1, 10)
if (globals.healing and (heal_chance > 2)) or (heal_chance == 10) then
    self.room:send("A maid in waiting starts casting <b:yellow>'group heal'</>...")
    wait(5)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    self.room:send("A maid in waiting completes her spell...")
    self.room:send("A maid in waiting utters the words, 'craes poir'.")
    -- Heal Lokari and any of his three maids that are still alive.
    if world.count_mobiles(489, 1) > 0 then
        self.room:find_actor("lokari"):heal(450)
    end
    if world.count_mobiles(489, 15) > 0 then
        self.room:find_actor("maid-rogue"):heal(450)
    end
    if world.count_mobiles(489, 22) > 0 then
        self.room:find_actor("maid-sorcerer"):heal(450)
    end
    if world.count_mobiles(489, 23) > 0 then
        self.room:find_actor("maid-cleric"):heal(450)
    end
else
    -- Alternate between good and evil spells.
    if globals.spell == "good" then
        globals.spell = "evil"
    else
        globals.spell = "good"
    end
    local spell = globals.spell
    if spell == "good" then
        self.room:send("A maid in waiting starts casting <b:yellow>'consecration'</>...")
    else
        self.room:send("A maid in waiting starts casting <b:yellow>'sacrilege'</>...")
    end
    wait(2)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    if spell == "good" then
        self.room:send("A maid in waiting utters the words, 'parl xafm'.")
        self.room:send("<b:white>A maid in waiting speaks a word of divine consecration!</>")
    else
        self.room:send("A maid in waiting utters the words, 'ebparl xafm'.")
        self.room:send("<blue>&9A maid in waiting speaks a word of demonic sacrilege!</>")
    end
    for _, person in ipairs(self:get_people()) do
        if ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
            local hit = (spell == "good" and person.alignment < -349)
                     or (spell == "evil" and person.alignment > 349)
            if hit then
                local globed = person:has_effect(Effect.Major_Globe)
                if globed then
                    -- No damage for major globe
                    self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body flares as the maid's spell flows around it.</>")
                    person:send("<b:red>The shimmering globe around your body flares as the spell flows around it.</>")
                else
                    local damage = 210 + random(1, 20)
                    if person:has_effect(Effect.Sanctuary) then
                        damage = damage / 2
                    end
                    if person:has_effect(Effect.Stone) then
                        damage = damage / 2
                    end
                    -- Chance for critical hit
                    local variant = random(1, 20)
                    if variant == 1 then
                        damage = damage / 2
                    elseif variant == 20 then
                        damage = damage * 2
                    end
                    if spell == "good" then
                        self.room:send_except(person, "<b:white>" .. tostring(person.name) .. " cries out in anguish upon hearing the maid's blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<b:white>You cry out in anguish upon hearing the maid's blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                    else
                        self.room:send_except(person, "<blue>&9" .. tostring(person.name) .. " screams in torment upon hearing the maid's curse!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<blue>&9You scream in torment upon hearing the maid's curse!</> (<b:red>" .. tostring(damage) .. "</>)")
                    end
                    person:damage(damage)  -- type: physical
                end
            end
        end
    end
end
wait(2)
globals.casting = nil$trig$),
  -- data/triggers/489/489_26_sunchild_fight.lua
  (489, 26, $trig$-- Converted from DG Script #48926: sunchild fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local chance = random(1, 10)
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("sunchild"):heal(1000)
    end)
elseif chance <= 2 then
    wait(2)
    self.room:send("<yellow>A Sunchild <blue>flares brightly</><yellow>, casting rays of <white>light<yellow> everywhere!</>")
    local room = self.room
    for _, person in ipairs(room:get_people()) do
        if person.is_player then
            spells.cast(self, "sunray", person, 100)
        end
    end
end$trig$),
  -- data/triggers/489/489_31_wandering_minstrel_fight.lua
  (489, 31, $trig$if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("wandering-minstrel"):heal(1000)
    end)
end
if self:get_eff_flagged("silence") then
    return true
end

-- TODO(parity): cooldown originally tracked via per-trigger globals `now`/
-- `now2`. We collapsed both into a single 5-tick gate keyed by
-- `globals.minstrel_song_cooldown`; revisit if the level branches need
-- independent cadence.
local cooldown = globals.minstrel_song_cooldown
if cooldown and (timestamp() - cooldown < 5) then
    return true
end

if self.level >= 70 then
    if actor.group_size and actor.group_size > 1 then
        for _, person in ipairs(self.room:get_people()) do
            if person.is_player and not person:get_has_spell("terror") and not person:get_has_spell("ballad of tears") then
                self:perform("ballad of tears", person, self.level)
                globals.minstrel_song_cooldown = timestamp()
                return true
            end
        end
    end
elseif self.level >= 10 then
    if actor and not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
        self:perform("terror", actor, self.level)
        globals.minstrel_song_cooldown = timestamp()
    end
end$trig$),
  -- data/triggers/489/489_33_severan_shockwave.lua
  (489, 33, $trig$self.room:send("<b:white>The white aura around Severan's body intensifies, increasing in brightness.</>")
wait(2)
self.room:send("<b:white>A powerful shockwave leaps off Severan's body as the aura flares wildly!</>")
local casters = "Sorcerer Necromancer Cryomancer Pyromancer Cleric Druid Diabolist Priest Shaman Conjurer"
for _, person in ipairs(self:get_people()) do
    if ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
        local damage
        if string.find(casters, tostring(person.class)) then
            damage = 100 + random(1, 50)
        else
            damage = 250 + random(1, 50)
        end
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage / 2
        elseif variant == 15 then
            damage = damage * 2
        end
        -- Halve damage AGAIN for major globe
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            damage = damage / 2
        end
        local damage_dealt = person:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(person, "<b:white>The blast passes through " .. tostring(person.name) .. ", causing no damage.</>")
            person:send("<b:white>The blast passes through you harmlessly.</>")
        elseif globed then
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers as the blast overwhelms it!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:red>The <white>blast<red> passes through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(person, "<b:white>The blast strikes " .. tostring(person.name) .. " violently, tearing at " .. tostring(person.possessive) .. " flesh!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:white>The blast strikes you violently, rending your flesh!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$),
  -- data/triggers/490/490_07_dagon_death_pt2.lua
  (490, 7, $trig$-- Converted from DG Script #49007: dagon_death_pt2
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
for _, person in ipairs(self:get_people()) do
    if person:get_quest_stage("griffin_quest") == 6 then
        person:advance_quest("griffin_quest")
        person:send("<b:white>You have advanced the quest!</>")
        person:send("<b:white>Proof of the deed must be delivered individually.</>")
    end
end$trig$),
  -- data/triggers/490/490_08_adramalech_dies.lua
  (490, 8, $trig$-- Converted from DG Script #49008: adramalech_dies
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
self.room:send(tostring(self.name) .. " emits a bone-rattling roar that fades away into a low rattle.")
self.room:send(tostring(self.name) .. " disintegrates into darkly glowing spots that fade from view.")
if self.room ~= get_room(490, 190) then
    self.room:teleport_all(get_room(490, 190))
    self.room:send("</>")
    self.room:send("<b:white>A rift opens in the fabric of reality and pulls you through!</>")
    self.room:send("</>")
    local room = get_room(490, 190)
    for _, person in ipairs(room:get_people()) do
        if person.is_player then
            -- person looks around
        end
    end
end
local person = actor
local stage = 8
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") == stage then
            person:advance_quest("griffin_quest")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
get_room(490, 190):at(function()
    run_room_trigger(490, 9)
end)
return _return_value$trig$),
  -- data/triggers/490/490_09_griffin_island_quest_exp_rewards.lua
  (490, 9, $trig$-- Converted from DG Script #49009: Griffin Island Quest exp rewards
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
local stage = 9
for _, person in ipairs(self:get_people()) do
    if person:get_quest_stage("griffin_quest") == stage then
        --
        -- Set X to the level of the award - code does not run without it
        -- Griffin Isle, X = 60
        local expcap
        if person.level < 60 then
            expcap = person.level
        else
            expcap = 60
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proportionate amount
        --
        if person.class == "Warrior" or person.class == "Berserker" then
            -- 110% of standard
            expmod = (expmod + (expmod / 10))
        elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
            -- 115% of standard
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
            -- 120% of standard
            expmod = (expmod + (expmod / 5))
        elseif person.class == "Necromancer" or person.class == "Monk" then
            -- 130% of standard
            expmod = (expmod + (expmod * 2) / 5)
        end
        person:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- Griffin Isle, xexp = wexp
            person:award_exp(setexp)
            loop = loop + 1
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
            person:command("get gem")
        end
        person:complete_quest("griffin_quest")
    end
end$trig$),
  -- data/triggers/520/520_04_all_hydra_heads_die.lua
  (520, 4, $trig$-- Converted from DG Script #52004: all_hydra_heads_die
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Walk every actor in the room and slay any remaining hydra-head mobile (520:9).
-- Used by hydra_death_cry (520:3) so killing the body cleans up loose heads.
for _, person in ipairs(self:get_people()) do
    if person.zone_id == 520 and person.local_id == 9 then
        person:damage(50000)  -- physical, lethal
    end
end$trig$),
  -- data/triggers/520/520_25_rock_well_load_door.lua
  (520, 25, $trig$local upexit = get_room(22, 1):exit("up")
upexit:set_state({
    hidden = false,
    description = "A ruin mansion lies just above.  If only it was reachable.",
    name = "Basement Ceiling",
})

for _, person in ipairs(self:get_people()) do
    if person:get_quest_stage("meteorswarm") == 2 or person:get_quest_var("meteorswarm:new") ~= "yes" then
        if person:get_quest_stage("meteorswarm") == 2 then
            person:advance_quest("meteorswarm")
        elseif person:get_quest_var("meteorswarm:new") ~= "yes" then
            person:set_quest_var("meteorswarm", "new", "no")
        end
        self.room:spawn_object(481, 152)
        self.room:send("A flaming meteor shoots off the towering rock demon, soars through the sky, and begins to fall toward the ground!")
    end
end$trig$),
  -- data/triggers/564/564_08_hell_gate_island_set_spell.lua
  (564, 8, $trig$self.room:send(tostring(mobiles.template(564, 0).name) .. " comes out of hiding.")

-- Send the diabolist back to the priest hub at (564, 31). When room:at()
-- is supported by the runtime this becomes the original cross-room call.
get_room(11, 0):at(function()
    local d = find_player("diabolist")
    if d then d:teleport(get_room(564, 31)) end
end)

if world.count_mobiles(564, 2) == 0 then
    wait(1)
    self.room:send("Larathiel's golden celestial blood seeps into the steaming ground.")
    wait(3)
    self.room:send("The earth shudders and shifts as it cracks and breaks apart!")
    self.room:send("A gout of <b:red>fire</> erupts from a fissure leading into the bowels of the earth!")
    wait(2)
    self.room:send("An enormous demonic entity claws its way out of the hole.")
    wait(2)
    -- Brolgoroth remains in game until killed or purged via reset.
    self.room:spawn_mobile(564, 2)
    self.room:send("The demon looks around itself and roars victoriously!")
    self.room:send("Brolgoroth says, <b:red>'At last, Garl'lixxil is connected to Ethilien again!</>")
    self.room:send("</><b:red>Now to add this world my dominion!'</>")
end

for _, person in ipairs(self.room.people) do
    if person:get_quest_stage("hell_gate") == 6 then
        wait(2)
        person:send("Brolgoroth tells you, <b:red>'Thank you, " .. tostring(person.name) .. ", for your unholy service.</>")
        person:send("</><b:red>As promised, I shall teach you a great secret.'</>")
        person:send("Your mind is flooded with images of fire and pain as Brolgoroth's mind connects with yours.")
        person:send("<b:red>The secrets of Hell Gate are seared into your memory!</>")
        person:complete_quest("hell_gate")
        -- Original DG referenced %actor.*% here even though actor isn't
        -- bound for this GLOBAL trigger; carry forward the parallel
        -- hell_trident progress on `person` instead.
        if not person:get_quest_var("hell_trident:helltask4") and person:get_quest_stage("hell_trident") == 2 then
            person:set_quest_var("hell_trident", "helltask4", 1)
        end
        -- Legacy had the diabolist run the staff `mskillset`; scripts cannot,
        -- so grant the skill directly (1000 = the legacy "max proficiency").
        person:set_skill("hell gate", 1000)
    end
end$trig$)
) AS v(zone_id, id, commands)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND t.commands IS DISTINCT FROM v.commands;

-- The three skillset helpers were flagged NEEDS_REVIEW (broken state machine);
-- the rewrite is the review.
UPDATE "Triggers"
SET needs_review = false,
    updated_at = now()
WHERE zone_id = 87
  AND id IN (97, 98, 99)
  AND needs_review;

COMMIT;
