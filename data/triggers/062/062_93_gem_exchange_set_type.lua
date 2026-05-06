-- Trigger: Gem Exchange set type
-- Zone: 62, ID: 93
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 29 if statements
--   Large script: 17275 chars
--
-- Original DG Script: #6293

-- Converted from DG Script #6293: Gem Exchange set type
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: amber agate amethyst aquamarine beryl bloodstone blood carnelian citrine diamond emerald garnet hematite jade jasper labradorite lapis lazuli lapis-lazuli malachite moonstone moon onyx opal pearl peridot sapphire ruby topaz tourmaline turquoise
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "amber") or string.find(string.lower(speech), "agate") or string.find(string.lower(speech), "amethyst") or string.find(string.lower(speech), "aquamarine") or string.find(string.lower(speech), "beryl") or string.find(string.lower(speech), "bloodstone") or string.find(string.lower(speech), "blood") or string.find(string.lower(speech), "carnelian") or string.find(string.lower(speech), "citrine") or string.find(string.lower(speech), "diamond") or string.find(string.lower(speech), "emerald") or string.find(string.lower(speech), "garnet") or string.find(string.lower(speech), "hematite") or string.find(string.lower(speech), "jade") or string.find(string.lower(speech), "jasper") or string.find(string.lower(speech), "labradorite") or string.find(string.lower(speech), "lapis") or string.find(string.lower(speech), "lazuli") or string.find(string.lower(speech), "lapis-lazuli") or string.find(string.lower(speech), "malachite") or string.find(string.lower(speech), "moonstone") or string.find(string.lower(speech), "moon") or string.find(string.lower(speech), "onyx") or string.find(string.lower(speech), "opal") or string.find(string.lower(speech), "pearl") or string.find(string.lower(speech), "peridot") or string.find(string.lower(speech), "sapphire") or string.find(string.lower(speech), "ruby") or string.find(string.lower(speech), "topaz") or string.find(string.lower(speech), "tourmaline") or string.find(string.lower(speech), "turquoise")) then
    return true  -- No matching keywords
end
wait(2)
if not actor:get_quest_stage("gem_exchange") then
    actor:start_quest("gem_exchange")
end
if string.find(speech, "amber") then
    if string.find(speech, "crushed") then
        local gem_id = 55575
    elseif string.find(speech, "dust") then
        local gem_id = 55567
    elseif string.find(speech, "uncut") then
        local gem_id = 55602
    elseif string.find(speech, "flawed") then
        local gem_id = 55624
    elseif string.find(speech, "shard") then
        local gem_id = 55583
    elseif string.find(speech, "enchanted") then
        local gem_id = 55723
    elseif string.find(speech, "radiant") then
        local gem_id = 55701
    elseif string.find(speech, "perfect") then
        local gem_id = 55679
    else
        local gem_id = 55646
    end
elseif string.find(speech, "agate") then
    if string.find(speech, "uncut") then
        local gem_id = 55599
    elseif string.find(speech, "flawed") then
        local gem_id = 55621
    elseif string.find(speech, "perfect") then
        local gem_id = 55676
    elseif string.find(speech, "radiant") then
        local gem_id = 55698
    elseif string.find(speech, "enchanted") then
        local gem_id = 55720
    else
        local gem_id = 55643
    end
elseif string.find(speech, "amethyst") then
    if string.find(speech, "crushed") then
        local gem_id = 55574
    elseif string.find(speech, "dust") then
        local gem_id = 55566
    elseif string.find(speech, "uncut") then
        local gem_id = 55601
    elseif string.find(speech, "flawed") then
        local gem_id = 55623
    elseif string.find(speech, "shard") then
        local gem_id = 55582
    elseif string.find(speech, "enchanted") then
        local gem_id = 55722
    elseif string.find(speech, "radiant") then
        local gem_id = 55700
    elseif string.find(speech, "perfect") then
        local gem_id = 55678
    else
        local gem_id = 55645
    end
elseif string.find(speech, "aquamarine") then
    if string.find(speech, "crushed") then
        local gem_id = 55579
    elseif string.find(speech, "dust") then
        local gem_id = 55571
    elseif string.find(speech, "uncut") then
        local gem_id = 55613
    elseif string.find(speech, "flawed") then
        local gem_id = 55635
    elseif string.find(speech, "shard") then
        local gem_id = 55587
    elseif string.find(speech, "enchanted") then
        local gem_id = 55734
    elseif string.find(speech, "radiant") then
        local gem_id = 55712
    elseif string.find(speech, "perfect") then
        local gem_id = 55690
    else
        local gem_id = 55657
    end
elseif string.find(speech, "beryl") then
    if string.find(speech, "uncut") then
        local gem_id = 55606
    elseif string.find(speech, "flawed") then
        local gem_id = 55628
    elseif string.find(speech, "shard") then
        local gem_id = 55605
    elseif string.find(speech, "enchanted") then
        local gem_id = 55727
    elseif string.find(speech, "radiant") then
        local gem_id = 55705
    elseif string.find(speech, "perfect") then
        local gem_id = 55683
    else
        local gem_id = 55650
    end
elseif string.find(speech, "bloodstone") or string.find(speech, "blood") then
    if string.find(speech, "uncut") then
        local gem_id = 55598
    elseif string.find(speech, "flawed") then
        local gem_id = 55620
    elseif string.find(speech, "perfect") then
        local gem_id = 55675
    elseif string.find(speech, "radiant") then
        local gem_id = 55697
    elseif string.find(speech, "enchanted") then
        local gem_id = 55719
    else
        local gem_id = 55642
    end
elseif string.find(speech, "carnelian") then
    if string.find(speech, "uncut") then
        local gem_id = 55595
    elseif string.find(speech, "flawed") then
        local gem_id = 55617
    elseif string.find(speech, "perfect") then
        local gem_id = 55672
    elseif string.find(speech, "radiant") then
        local gem_id = 55694
    elseif string.find(speech, "enchanted") then
        local gem_id = 55716
    else
        local gem_id = 55639
    end
elseif string.find(speech, "citrine") then
    if string.find(speech, "crushed") then
        local gem_id = 55577
    elseif string.find(speech, "dust") then
        local gem_id = 55569
    elseif string.find(speech, "uncut") then
        local gem_id = 55604
    elseif string.find(speech, "flawed") then
        local gem_id = 55626
    elseif string.find(speech, "shard") then
        local gem_id = 55585
    elseif string.find(speech, "enchanted") then
        local gem_id = 55725
    elseif string.find(speech, "radiant") then
        local gem_id = 55703
    elseif string.find(speech, "perfect") then
        local gem_id = 55681
    else
        local gem_id = 55648
    end
elseif string.find(speech, "diamond") then
    if string.find(speech, "crushed") then
        local gem_id = 55591
    elseif string.find(speech, "uncut") then
        local gem_id = 55665
    elseif string.find(speech, "flawed") then
        local gem_id = 55664
    elseif string.find(speech, "enchanted") then
        local gem_id = 55741
    elseif string.find(speech, "radiant") then
        local gem_id = 55742
    elseif string.find(speech, "perfect") then
        local gem_id = 55745
    else
        local gem_id = 55668
    end
elseif string.find(speech, "emerald") then
    if string.find(speech, "crushed") then
        local gem_id = 55593
    elseif string.find(speech, "uncut") then
        local gem_id = 55663
    elseif string.find(speech, "flawed") then
        local gem_id = 55660
    elseif string.find(speech, "enchanted") then
        local gem_id = 55737
    elseif string.find(speech, "radiant") then
        local gem_id = 55740
    elseif string.find(speech, "perfect") then
        local gem_id = 55747
    else
        local gem_id = 55670
    end
elseif string.find(speech, "garnet") then
    if string.find(speech, "crushed") then
        local gem_id = 55578
    elseif string.find(speech, "dust") then
        local gem_id = 55570
    elseif string.find(speech, "uncut") then
        local gem_id = 55612
    elseif string.find(speech, "flawed") then
        local gem_id = 55634
    elseif string.find(speech, "shard") then
        local gem_id = 55586
    elseif string.find(speech, "enchanted") then
        local gem_id = 55733
    elseif string.find(speech, "radiant") then
        local gem_id = 55711
    elseif string.find(speech, "perfect") then
        local gem_id = 55689
    else
        local gem_id = 55656
    end
elseif string.find(speech, "hematite") then
    if string.find(speech, "uncut") then
        local gem_id = 55594
    elseif string.find(speech, "flawed") then
        local gem_id = 55616
    elseif string.find(speech, "perfect") then
        local gem_id = 55671
    elseif string.find(speech, "radiant") then
        local gem_id = 55693
    elseif string.find(speech, "enchanted") then
        local gem_id = 55715
    else
        local gem_id = 55638
    end
elseif string.find(speech, "jade") then
    if string.find(speech, "uncut") then
        local gem_id = 55608
    elseif string.find(speech, "flawed") then
        local gem_id = 55630
    elseif string.find(speech, "shard") then
        local gem_id = 55610
    elseif string.find(speech, "enchanted") then
        local gem_id = 55729
    elseif string.find(speech, "radiant") then
        local gem_id = 55707
    elseif string.find(speech, "perfect") then
        local gem_id = 55685
    else
        local gem_id = 55652
    end
elseif string.find(speech, "jasper") then
    actor:send(tostring(self.name) .. " says, 'I'm sorry, we don't stock jasper.'")
    self:command("half")
elseif string.find(speech, "labradorite") then
    if string.find(speech, "uncut") then
        local gem_id = 55611
    elseif string.find(speech, "flawed") then
        local gem_id = 55633
    elseif string.find(speech, "perfect") then
        local gem_id = 55688
    elseif string.find(speech, "radiant") then
        local gem_id = 55710
    elseif string.find(speech, "enchanted") then
        local gem_id = 55732
    else
        local gem_id = 55655
    end
elseif string.find(speech, "lapis") or string.find(speech, "lapis")-lazuli or string.find(speech, "lazuli") then
    if string.find(speech, "uncut") then
        local gem_id = 55600
    elseif string.find(speech, "flawed") then
        local gem_id = 55622
    elseif string.find(speech, "enchanted") then
        local gem_id = 55721
    elseif string.find(speech, "radiant") then
        local gem_id = 55699
    elseif string.find(speech, "perfect") then
        local gem_id = 55677
    else
        local gem_id = 55644
    end
elseif string.find(speech, "malachite") then
    if string.find(speech, "uncut") then
        local gem_id = 55603
    elseif string.find(speech, "dust") then
        local gem_id = 55568
    elseif string.find(speech, "crushed") then
        local gem_id = 55576
    elseif string.find(speech, "shard") then
        local gem_id = 55584
    elseif string.find(speech, "flawed") then
        local gem_id = 55625
    elseif string.find(speech, "perfect") then
        local gem_id = 55680
    elseif string.find(speech, "radiant") then
        local gem_id = 55702
    elseif string.find(speech, "enchanted") then
        local gem_id = 55724
    elseif string.find(speech, "chunk") then
        actor:send(tostring(self.name) .. " says, 'That is not an item we trade in the gem exchange.'")
        self:command("half")
    else
        local gem_id = 55647
    end
elseif string.find(speech, "moonstone") or string.find(speech, "moon") then
    if string.find(speech, "uncut") then
        local gem_id = 55596
    elseif string.find(speech, "flawed") then
        local gem_id = 55618
    elseif string.find(speech, "perfect") then
        local gem_id = 55673
    elseif string.find(speech, "radiant") then
        local gem_id = 55695
    elseif string.find(speech, "enchanted") then
        local gem_id = 55717
    else
        local gem_id = 55640
    end
elseif string.find(speech, "onyx") then
    if string.find(speech, "uncut") then
        local gem_id = 55609
    elseif string.find(speech, "flawed") then
        local gem_id = 55631
    elseif string.find(speech, "perfect") then
        local gem_id = 55686
    elseif string.find(speech, "radiant") then
        local gem_id = 55708
    elseif string.find(speech, "enchanted") then
        local gem_id = 55730
    else
        local gem_id = 55653
    end
elseif string.find(speech, "opal") then
    if string.find(speech, "uncut") then
        local gem_id = 55610
    elseif string.find(speech, "flawed") then
        local gem_id = 55632
    elseif string.find(speech, "enchanted") then
        local gem_id = 55731
    elseif string.find(speech, "radiant") then
        local gem_id = 55709
    elseif string.find(speech, "perfect") then
        local gem_id = 55687
    else
        local gem_id = 55654
    end
elseif string.find(speech, "pearl") then
    if string.find(speech, "uncut") then
        local gem_id = 55607
    elseif string.find(speech, "flawed") then
        local gem_id = 55629
    elseif string.find(speech, "enchanted") then
        local gem_id = 55728
    elseif string.find(speech, "radiant") then
        local gem_id = 55706
    elseif string.find(speech, "perfect") then
        local gem_id = 55684
    else
        local gem_id = 55651
    end
elseif string.find(speech, "peridot") then
    if string.find(speech, "uncut") then
        local gem_id = 55615
    elseif string.find(speech, "crushed") then
        local gem_id = 55581
    elseif string.find(speech, "dust") then
        local gem_id = 55573
    elseif string.find(speech, "shard") then
        local gem_id = 55589
    elseif string.find(speech, "flawed") then
        local gem_id = 55637
    elseif string.find(speech, "perfect") then
        local gem_id = 55692
    elseif string.find(speech, "radiant") then
        local gem_id = 55714
    elseif string.find(speech, "enchanted") then
        local gem_id = 55736
    else
        local gem_id = 55659
    end
elseif string.find(speech, "ruby") then
    if string.find(speech, "crushed") then
        local gem_id = 55590
    elseif string.find(speech, "uncut") then
        local gem_id = 55662
    elseif string.find(speech, "flawed") then
        local gem_id = 55661
    elseif string.find(speech, "enchanted") then
        local gem_id = 55738
    elseif string.find(speech, "radiant") then
        local gem_id = 55739
    elseif string.find(speech, "perfect") then
        local gem_id = 55744
    else
        local gem_id = 55667
    end
elseif string.find(speech, "sapphire") then
    if string.find(speech, "crushed") then
        local gem_id = 55592
    elseif string.find(speech, "uncut") then
        local gem_id = 55666
    elseif string.find(speech, "flawed") then
        local gem_id = 55689
    elseif string.find(speech, "radiant") then
        local gem_id = 55743
    elseif string.find(speech, "perfect") then
        local gem_id = 55746
    else
        local gem_id = 55669
    end
elseif string.find(speech, "topaz") then
    if string.find(speech, "uncut") then
        local gem_id = 55605
    elseif string.find(speech, "flawed") then
        local gem_id = 55627
    elseif string.find(speech, "enchanted") then
        local gem_id = 55726
    elseif string.find(speech, "radiant") then
        local gem_id = 55704
    elseif string.find(speech, "perfect") then
        local gem_id = 55682
    else
        local gem_id = 55649
    end
elseif string.find(speech, "tourmaline") then
    if string.find(speech, "crushed") then
        local gem_id = 55580
    elseif string.find(speech, "dust") then
        local gem_id = 55572
    elseif string.find(speech, "uncut") then
        local gem_id = 55614
    elseif string.find(speech, "flawed") then
        local gem_id = 55636
    elseif string.find(speech, "shard") then
        local gem_id = 55588
    elseif string.find(speech, "enchanted") then
        local gem_id = 55735
    elseif string.find(speech, "radiant") then
        local gem_id = 55713
    elseif string.find(speech, "perfect") then
        local gem_id = 55691
    else
        local gem_id = 55658
    end
elseif string.find(speech, "turquoise") then
    if string.find(speech, "uncut") then
        local gem_id = 55597
    elseif string.find(speech, "flawed") then
        local gem_id = 55619
    elseif string.find(speech, "enchanted") then
        local gem_id = 55718
    elseif string.find(speech, "radiant") then
        local gem_id = 55696
    elseif string.find(speech, "perfect") then
        local gem_id = 55674
    else
        local gem_id = 55641
    end
end
actor:send(tostring(self.name) .. " asks you, 'You want " .. "%get.obj_shortdesc[%gem_id%]%?'")
actor:set_quest_var("gem_exchange", "gem_id", gem_id)