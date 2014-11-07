-- 1 = local
-- 2 = yell
-- 4 = whisper

-- 1 = male
-- 2 = female

-- binary combinations.

--V.AddNewChatGesture( mode, gender, seq, len )

V.AddNewChatGesture( 1 + 2 + 4, 1 + 2, "b_head_back", 1.8 );
V.AddNewChatGesture( 1 + 2 + 4, 1 + 2, "b_head_forward", 1.8 );
V.AddNewChatGesture( 1 + 2 + 4, 1 + 2, "g_puncuate", 1.7 );
V.AddNewChatGesture( 1 + 2 + 4, 1 + 2, "g_right_openhand", 1.7 );
V.AddNewChatGesture( 1 + 2 + 4, 1 + 2, "hg_puncuate_down", 1.7 );

V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_accent_left", 1.7 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_accentFwd", 2.5 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_accentUp", 2.5 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_down", 2 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_left", 2.2 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_right", 2.2 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_up_l", 1.6 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "bg_up_r", 1.6 );
V.AddNewChatGesture( 1 + 2 + 4, 1, "g_chestup", 1.8 );
V.AddNewChatGesture( 4, 1, "g_Lhandease", 1.8 );
V.AddNewChatGesture( 1 + 2, 1, "g_righthandheavy", 2 );

V.AddNewChatGesture( 1 + 2 + 4, 2, "hg_punctuate_down", 1.7 );
V.AddNewChatGesture( 1 + 2, 2, "urgenthandsweep", 2.5 );

V.AddSpecialGestureLine( "points right", "g_pointright_l" );
V.AddSpecialGestureLine( "points left", "g_pointleft_l" );
V.AddSpecialGestureLine( "points forward", "g_point" );
V.AddSpecialGestureLine( "shakes fist", "g_fistshake" );
V.AddSpecialGestureLine( "claps", "g_clap" );
V.AddSpecialGestureLine( "applauds", "g_clap" );
V.AddSpecialGestureLine( "shakes head", "hg_nod_no" );
V.AddSpecialGestureLine( "nods", "hg_nod_yes" );
V.AddSpecialGestureLine( "nods right", "hg_nod_right" );
V.AddSpecialGestureLine( "nods left", "hg_nod_left" );
V.AddSpecialGestureLine( "motions left", "G_lefthandmotion" );
V.AddSpecialGestureLine( "shrugs", "g_shrug" );
V.AddSpecialGestureLine( "waves over", "g_wave" );
V.AddSpecialGestureLine( "salutes", "g_salute" );
V.AddSpecialGestureLine( "bellows prayer", "g_armsout_high" );
V.AddSpecialGestureLine( "bows", "gesture_bow" );
V.AddSpecialGestureLine( "signals forward", "gesture_signal_forward" );
V.AddSpecialGestureLine( "signals regroup", "gesture_signal_group" );
V.AddSpecialGestureLine( "signals halt", "gesture_signal_halt" );
V.AddSpecialGestureLine( "waves", "gesture_wave" );