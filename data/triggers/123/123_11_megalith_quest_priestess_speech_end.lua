-- Trigger: megalith_quest_priestess_speech_end
-- Zone: 123, ID: 11
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--   Large script: 11437 chars
--
-- Original DG Script: #12311

-- Converted from DG Script #12311: megalith_quest_priestess_speech_end
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: we invoke thee
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "we") or string.find(string.lower(speech), "invoke") or string.find(string.lower(speech), "thee")) then
    return true  -- No matching keywords
end
local speech1 = "we invoke thee"
local speech2 = "we invoke thee!"
local stage = actor:get_quest_stage("megalith_quest")
if (stage == 4) and (self.room == 12389) and (actor:get_quest_var("megalith_quest:summon") == 3) and (string.find(speech, "speech1") or string.find(speech, "speech2")) then
    local invoke = actor:get_quest_var("megalith_quest:invoke")
    local chant = invoke + 1
    -- switch on chant
    if chant == 1 then
        actor.name:set_quest_var("megalith_quest", "invoke", 1)
        wait(2)
        run_room_trigger(12322)
        wait(1)
        self:say("Again!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 2 then
        actor.name:set_quest_var("megalith_quest", "invoke", 2)
        wait(2)
        run_room_trigger(12322)
        wait(1)
        self:say("Once more!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 3 then
        actor.name:set_quest_var("megalith_quest", "invoke", 0)
        actor.name:set_quest_var("megalith_quest", "reliquary", 0)
        actor.name:set_quest_var("megalith_quest", "summon", 0)
        actor.name:set_quest_var("megalith_quest", "prayer", 0)
        if actor:get_quest_var("megalith_quest:bad1") then
            local bad1 = 1
        end
        if actor:get_quest_var("megalith_quest:bad2") then
            local bad2 = 1
        end
        if actor:get_quest_var("megalith_quest:bad3") then
            local bad3 = 1
        end
        if actor:get_quest_var("megalith_quest:bad4") then
            local bad4 = 1
        end
        run_room_trigger(12322)
        wait(2)
        self.room:send(tostring(self.name) .. " cries, 'Great Mother, come to me!'")
        wait(2)
        self.room:send("The chanting harmonizes with the vibrations of the standing stones.")
        self.room:send("<b:yellow>Radiant energy washes out of the ancient stones in waves!</>")
        wait(4)
        self.room:send("<b:white>Stars <blue>begin to fall from the swirling vortex above.</>")
        wait(5)
        -- 
        -- The worst ending
        -- 
        if bad4 then
            self.room:send("The energies of the megalith buckle suddenly as <magenta>" .. tostring(objects.template(584, 26).name) .. "</> shatters.")
            wait(4)
            self.room:send("&9<blue>The harmonics shift into piercing discordant shrieks as</> <red>blood</> &9<blue>begins to pour from the altar!</>")
            wait(2)
            self.room:send("With a horrified look, " .. tostring(self.name) .. " screams, 'The Great Invocation has been corrupted!  What was in that <b:red>elixir</>?!'")
            wait(7)
            self.room:send("Rays of <b:white>s</><b:yellow>ea</><b:white>ring light</> shoot out in all directions as the world spins!")
            wait(6)
            self.room:send("Suddenly <magenta>bpitch black</> energies erupt from the altar, engulfing " .. tostring(mobiles.template(123, 7).name) .. "!")
            wait(8)
            self.room:send(tostring(mobiles.template(123, 7).name) .. " is ripped apart from within in an explosion of blood and gore!")
            world.destroy(self.room:find_actor("celestial-envoy"))
            self.room:send("Remaining in her place is a huge blood-covered abomination from beyond time and space made completely of iridescent black slime.")
            wait(4)
            self.room:send("Hundreds of eyes float just below the viscous membrane surrounding the ameboid creature.")
            wait(5)
            self.room:send("Suddenly it mutates into a huge creature with six enormous muscular legs and a massive maw!")
            wait(3)
            self.room:send("It roars with the voices of a thousand flayed beasts and attacks!")
            self.room:spawn_mobile(123, 21)
            self.room:find_actor("shoggoth"):command("kill %actor.name%")
            -- 
            -- Clear all the bads, in case you try again later
            -- 
            local item = 1
            while item <= 4 do
                actor.name:set_quest_var("megalith_quest", "bad%item%", 0)
                local item = item + 1
            end
            actor.name:fail_quest("megalith_quest")
            return _return_value
        else
            local total = bad1 + bad2 + bad3
            -- 
            -- The good ending - get two prizes
            -- 
            if total == 0 then
                actor.name:advance_quest("megalith_quest")
                self.room:send("<b:white>Celestial light pours through the vortex.</>")
                self.room:send("<b:white>It forms a gentle <cyan>pool of radiance <white>in the eye of the cosmic maelstrom.</>")
                wait(5)
                self.room:send("<b:magenta>A beautiful tiny being with six gossamer butterfly wings descends from the moonbridge.</>")
                self.room:send("<b:white>She looks as old as time itself yet younger than a child.</>")
                wait(5)
                self.room:send(tostring(self.name) .. " exclaims, 'O Great Mother, Goddess of the moon and stars, joyously we welcome you!'")
                if world.count_mobiles("12300") == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                -- (empty room echo)
                self.room:send(tostring(self.name) .. " and " .. "%get.mob_shortdesc[12307]% kneel before %get.mob_shortdesc[12300]%.")
                wait(4)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " embraces her children, weeping with joy.")
                wait(5)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " says, 'Your efforts shone a beacon in the dark, lighting my way back to you my children.'")
                wait(4)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " says, 'I have watched from afar as you and your mothers and your grandmothers struggled to keep our traditions alive.'")
                wait(5)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " proclaims, 'But now is our time to flourish again!'")
                wait(2)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " proclaims, 'Let this sacred megalith be home to our coven from here after!'")
                wait(5)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " proclaims, 'Let us reignite the flames of passion, be the clay of reason, give the breath of life, be the ocean of serenity.'")
                wait(5)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " cries, 'So mote it be!'")
                wait(3)
                self.room:send("The coven cheers in unison, 'So mote it be!'")
                wait(4)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. "%get.mob_shortdesc[12300]% says, 'And you, %actor.name%.")
                actor:send("Turning to you, " .. "%get.mob_shortdesc[12300]% says, 'And you, %actor.name%.")
                self.room:send("</>I wish to thank you for helping my daughters.  <b:cyan>Kneel</>, and receive my blessing.'")
                return _return_value
                -- 
                -- The okay ending - get one prize
                -- 
            elseif total == 1 then
                actor.name:advance_quest("megalith_quest")
                self.room:send("The stars coalesce into the nearly transparent form of a celestial, gossamer-winged goddess.")
                self.room:send(tostring(self.name) .. " and " .. "%get.mob_shortdesc[12307]% bow before %get.mob_shortdesc[12300]%.")
                self.room:send(tostring(self.name) .. " says, 'O Great Mother, watcher from the deep, we come to seek thy blessing!'")
                if world.count_mobiles("12300") == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                self.room:send(tostring(mobiles.template(123, 0).name) .. " says, 'My daughters, you shall always have my blessing.'")
                self.room:send(tostring(mobiles.template(123, 0).name) .. " gently kisses each member of the coven on their forehead, leaving a glowing mote of <b:white>silvery light</>.")
                wait(5)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " says, 'Long has it been since the Nine Hells opened wide and I was cut off from the mortal world.'")
                wait(3)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " says, 'Yet through you and your mothers and grandmothers before you, my presence has been kept alive.'")
                self.room:send(tostring(mobiles.template(123, 0).name) .. " smiles serenely.")
                wait(6)
                self.room:send(tostring(mobiles.template(123, 0).name) .. " declares, 'Let this sacred megalith be home to our coven once again!  Thus I charge you with the tending and care of this holy monument.  May you keep well this sacred duty.'")
                wait(7)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. "%get.mob_shortdesc[12300]% says, 'And you, %actor.name%.")
                actor:send("Turning to you, " .. "%get.mob_shortdesc[12300]% says, 'And you, %actor.name%.")
                self.room:send("</>I would thank you for helping my daughters.  If you wish to receive my blessing, <b:cyan>kneel</>.'")
                return _return_value
                -- 
                -- The bad ending - get nothing
                -- 
            elseif total >= 2 then
                self.room:send("&9<blue>The harmonics of the monolith begin to shift, falling out of balance.</>")
                wait(3)
                self.room:send("The energy of the megalith begins to dim.")
                self.room:send("In a despondent voice, " .. tostring(self.name) .. " cries out, 'The circle is failing!  <b:red>The tools or the reliquaries must have been flawed!</>'")
                wait(4)
                self.room:send("<b:yellow>Rapidly the radiance leaks out of the area.</>")
                wait(2)
                self.room:send("<b:white>The swirling vortex in the sky swiftly fades away.</>")
                wait(4)
                self.room:send("The Great Rite of Invocation ends as if nothing had ever happened.")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'So this is how it ends... not with a bang, but a whimper.'")
                self:emote("collapses, exhausted.")
                -- 
                -- Clear all the Bads, just in case you try again
                -- 
                local item = 1
                while item <= 5 do
                    actor.name:set_quest_var("megalith_quest", "bad%item%", 0)
                    local item = item + 1
                end
                actor.name:fail_quest("megalith_quest")
            end
        end
    end
end