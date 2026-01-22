-- Trigger: Quest Journal
-- Zone: 4, ID: 0
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #400

-- Converted from DG Script #400: Quest Journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if not arg then
    actor:send("This journal tracks all your quest information as you journey through Ethilien!")
    actor:send("<yellow>=======================================</>")
    actor:send("<yellow>OVERVIEW</>")
    actor:send("Quests will be revealed in this journal as you become eligible to take them on.  There are main indexes organized around the type of quest, and then detailed entries for each individual quest.")
    actor:send("The quest journal will always have your most recent personal quest records in it, no matter which copy you look at.")
    actor:send("</>")
    actor:send("To look at a category of quests, type \"look journal (category name)\".")
    actor:send("To look at a specific quest, type: \"look journal (quest name)\".")
    actor:send("</>")
    actor:send("For more on the general quest system, see <b:cyan>[HELP QUEST]</>.")
    actor:send("<yellow>=======================================</>")
    actor:send("There are five types of quests:")
    actor:send("1. <b:yellow>ADVENTURE</> quests")
    actor:send("- These quests take you through areas and explore the story behind each place you encounter.  These quests often culminate in a boss battle and have excellent rewards!_")
    actor:send("2. <b:yellow>EQUIPMENT</> quests")
    actor:send("- These quests take you all across the world reward you with top-tier equipment.  These often take many levels to complete and require vast exploration, but some are focused on a particular zone.")
    actor:send("3. <b:yellow>HEROES FOR HIRE</> quests")
    actor:send("- These quests are types of bounty hunts, tasking you with hunting down a particular target.  They increase in difficulty across a hero's lifetime!")
    actor:send("4. <b:yellow>SPELL</> quests")
    actor:send("- These quests challenge you to take on the strongest monsters, find the most valuable treasures, and delve into the deepest secrets Fiery has to offer.  The rewards are supreme magic, unrivaled magic.  Quest songs and chants are included in this category.")
    actor:send("5. <b:yellow>SUBCLASS</> quests.")
    actor:send("- These quests can be undertaken by a low-level character to change from a core class to a subclass.  Much more information can be found in <b:cyan>[HELP SUBCLASS]</>.")
    actor:send("- Only characters in core classes within the proper level range will see what quests are available to them on this page.")
    actor:send("_")
    actor:send("Read or look at any of the five sections above to see what's currently available: ADVENTURE, EQUIPMENT, HIRE, SPELL, SUBCLASS.")
    _return_value = false
end
return _return_value