function scr_game_text(_text_id) {

    // Each tr_pick() call draws a fresh random variant from the
    // translation table, so NPCs don't say the same exact thing
    // every interaction. All three languages share the same keys;
    // the language layer picks which locale's variants to draw from.

    switch (_text_id) {
        // ===== MAXWELL (NPC 1) — pushblock puzzles =====
        case "npc 1":
            if (global.puzzle_complete[0]) {
                scr_text(tr_pick("npc1_done_a"), tr("name_maxwell"), spr_npc_1_idle);
                scr_text(tr_pick("npc1_done_b"), tr("name_maxwell"), spr_npc_1_idle);
                break;
            }
            // First line intentionally uses "???" — the stranger-before-
            // introduction beat. From the second line on, we know them.
            scr_text(tr_pick("npc1_greet"), tr("name_unknown"), spr_npc_1_idle);
            scr_text(tr_pick("npc1_name"),  tr("name_maxwell"), spr_npc_1_idle);
            scr_text(tr_pick("npc1_intro"), tr("name_maxwell"), spr_npc_1_idle);
            scr_text(tr_pick("npc1_ask"),   tr("name_maxwell"), spr_npc_1_idle);
                scr_option(tr("npc1_opt_yes"), "npc 1 - yes");
                scr_option(tr("npc1_opt_no"),  "npc 1 - no");
            break;

        case "npc 1 - yes":
            scr_text(tr_pick("npc1_yes"), tr("name_maxwell"), spr_npc_1_idle);
            transition_to(rm_puzzle_1_1);
            break;

        case "npc 1 - no":
            scr_text(tr_pick("npc1_no"), tr("name_maxwell"), spr_npc_1_idle);
            break;

        // ===== MIRA (NPC 2) — memory card puzzles =====
        case "npc 2":
            if (global.puzzle_complete[1]) {
                scr_text(tr_pick("npc2_done_a"), tr("name_mira"), spr_npc_3_idle);
                scr_text(tr_pick("npc2_done_b"), tr("name_mira"), spr_npc_3_idle);
                break;
            }
            scr_text(tr_pick("npc2_greet"), tr("name_unknown"), spr_npc_3_idle);
            scr_text(tr_pick("npc2_name"),  tr("name_mira"),    spr_npc_3_idle);
            scr_text(tr_pick("npc2_intro"), tr("name_mira"),    spr_npc_3_idle);
            scr_text(tr_pick("npc2_ask"),   tr("name_mira"),    spr_npc_3_idle);
                scr_option(tr("npc2_opt_yes"), "npc 2 - yes");
                scr_option(tr("npc2_opt_no"),  "npc 2 - no");
            break;

        case "npc 2 - yes":
            scr_text(tr_pick("npc2_yes"), tr("name_mira"), spr_npc_3_idle);
            transition_to(rm_memory_1);
            break;

        case "npc 2 - no":
            scr_text(tr_pick("npc2_no"), tr("name_mira"), spr_npc_3_idle);
            break;

        // ===== SAGE (NPC 3) — animal quiz =====
        case "npc 3":
            if (global.puzzle_complete[2]) {
                scr_text(tr_pick("npc3_done_a"), tr("name_sage"), spr_npc_2_idle);
                scr_text(tr_pick("npc3_done_b"), tr("name_sage"), spr_npc_2_idle);
                break;
            }
            scr_text(tr_pick("npc3_greet"), tr("name_unknown"), spr_npc_2_idle);
            scr_text(tr_pick("npc3_name"),  tr("name_sage"),    spr_npc_2_idle);
            scr_text(tr_pick("npc3_intro"), tr("name_sage"),    spr_npc_2_idle);
            scr_text(tr_pick("npc3_ask"),   tr("name_sage"),    spr_npc_2_idle);
                scr_option(tr("npc3_opt_yes"), "npc 3 - yes");
                scr_option(tr("npc3_opt_no"),  "npc 3 - no");
            break;

        case "npc 3 - yes":
            scr_text(tr_pick("npc3_yes"), tr("name_sage"), spr_npc_2_idle);
            transition_to(rm_quiz_1);
            break;

        case "npc 3 - no":
            scr_text(tr_pick("npc3_no"), tr("name_sage"), spr_npc_2_idle);
            break;

        // ===== ECHO (NPC 4) — speech / pronunciation =====
        case "npc 4":
            if (global.puzzle_complete[3]) {
                scr_text(tr_pick("npc4_done_a"), tr("name_echo"), spr_npc_4_idle);
                scr_text(tr_pick("npc4_done_b"), tr("name_echo"), spr_npc_4_idle);
                break;
            }
            scr_text(tr_pick("npc4_greet"), tr("name_unknown"), spr_npc_4_idle);
            scr_text(tr_pick("npc4_name"),  tr("name_echo"),    spr_npc_4_idle);
            scr_text(tr_pick("npc4_intro"), tr("name_echo"),    spr_npc_4_idle);
            scr_text(tr_pick("npc4_ask"),   tr("name_echo"),    spr_npc_4_idle);
                scr_option(tr("npc4_opt_yes"), "npc 4 - yes");
                scr_option(tr("npc4_opt_no"),  "npc 4 - no");
            break;

        case "npc 4 - yes":
            scr_text(tr_pick("npc4_yes"), tr("name_echo"), spr_npc_4_idle);
            transition_to(rm_speech_1);
            break;

        case "npc 4 - no":
            scr_text(tr_pick("npc4_no"), tr("name_echo"), spr_npc_4_idle);
            break;
    }
}
