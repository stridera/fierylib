-- Trigger: Mercenary Assassin Thief Subclass progress journal
-- Zone: 4, ID: 65
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #465

-- Converted from DG Script #465: Mercenary Assassin Thief Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local assassinraces = "none"
    local mercenaryraces = "none"
    local thiefraces = "none"
    if string.find(actor.class, "Rogue") and actor.level <= 25 then
        if string.find(arg, "Mercenary") and not (string.find(mercenaryraces, "actor.race")) then
            actor:send("&9<blue>Mercenary</>")
            local questname = "mercenary"
            local check = "yes"
        elseif string.find(arg, "Assassin") and not (string.find(assassinraces, "actor.race")) then
            actor:send("<red>Assassin</>")
            local questname = "assassin"
            local check = "yes"
        elseif string.find(arg, "Thief") and not (string.find(thiefraces, "actor.race")) then
            actor:send("<b:red>Thief</>")
            local questname = "thief"
            local check = "yes"
        end
    end
    if string.find(check, "yes") then
        _return_value = false
        actor:send("Quest Master: " .. tostring(mobiles.template(60, 50).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if questname == "assassin" then
            actor:send("This class is for evil characters only.")
        end
        if actor:get_quest_stage("merc_ass_thi_subclass") then
            actor:send(tostring(mobiles.template(60, 50).name) .. " said to you:")
            -- switch on actor:get_quest_stage("merc_ass_thi_subclass")
            if questname == "mercenary" then
                if actor:get_quest_stage("merc_ass_thi_subclass") == 1 then
                    actor:send("He would pay well.  Yes, that Lord would pay well indeed.")
                elseif quest_name == "assassin" then
                    actor:send("Yes, that would bring a good price.")
                elseif quest_name == "thief" then
                    actor:send("There is a package that someone could get back.")
                end
                if questname == "mercenary" then
                elseif actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
                    actor:send("Well, a great Lord, who shall remain unnamed, has lost a cloak.")
                    actor:send("He has come to me for its return.")
                    actor:send("If you went and procured it, he would be grateful.")
                    actor:send("And if he is grateful, I would be as well, and your training would be finished._")
                    actor:send("It would be quite a payday for a cloak.")
                elseif quest_name == "thief" then
                    actor:send("Some time ago it was sent and picked up by someone who should not have it._")
                    actor:send("Bloody farmers.")
                elseif questname == "assassin" then
                    actor:send("I have some rich men unhappy with the politics of the region in question.")
                    actor:send("You could help with those politics if you wish.")
                end
                if questname == "mercenary" then
                elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 or actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
                    actor:send("It was made off with in a raid on his castle by some bothersome insect warriors.")
                    actor:send("All the Lord was able to tell me is they said something about wanting it for their queen._")
                    actor:send("I think you should go find it now._")
                    actor:send("Come back when you ave the cloak, or do not come back at all.")
                elseif questname == "assassin" then
                    actor:send("Ah yes, the politics of it all.")
                    actor:send("Personally I am not one for them, but some people get all mixed up in those._")
                    actor:send("Go kill the Mayor of Mielikki._")
                    actor:send("He's probably holed up in his office in City Hall.")
                    actor:send("You'll have to break in, sneak past the guards, and kill him._")
                    actor:send("Get his cane as proof and come back and give it to me.")
                elseif questname == "thief" then
                    actor:send("That is right, a package was taken by a farmer who hould not have it._")
                    actor:send("I know this: he got it from the post office in Mielikki and he lives near there.")
                    actor:send("Go get it back and I will make it worth it to you._")
                    actor:send("Do not let anyone see you and do not leave a trail of bodies behind you.")
                    actor:send("And be careful!  If you jostle the package too much it just might explode.")
                end
            end
        end
    end
end
return _return_value