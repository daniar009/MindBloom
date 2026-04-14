// Fade in quickly
if (fade_in) {
    alpha += 0.1;
    if (alpha >= 1) {
        alpha = 1;
        fade_in = false;
    }
}

// --- Pushblock demo animation (runs even during fade) ---
if (tut_type == "pushblock") {
    demo_timer++;

    if (demo_step == 0) {
        demo_maxwell_col = 0;
        demo_block_col   = 2;
        demo_solved      = false;
        if (demo_timer >= demo_pause) {
            demo_timer = 0;
            demo_step  = 1;
        }
    }
    else if (demo_step == 1) {
        var _t = clamp(demo_timer / demo_step_len, 0, 1);
        demo_maxwell_col = lerp(0, 1, _t);
        if (demo_timer >= demo_step_len) {
            demo_maxwell_col = 1;
            demo_timer = 0;
            demo_step  = 2;
        }
    }
    else if (demo_step == 2) {
        var _t = clamp(demo_timer / demo_step_len, 0, 1);
        demo_maxwell_col = lerp(1, 2, _t);
        demo_block_col   = lerp(2, 3, _t);
        if (demo_timer >= demo_step_len) {
            demo_maxwell_col = 2;
            demo_block_col   = 3;
            demo_timer = 0;
            demo_step  = 3;
        }
    }
    else if (demo_step == 3) {
        var _t = clamp(demo_timer / demo_step_len, 0, 1);
        demo_maxwell_col = lerp(2, 3, _t);
        demo_block_col   = lerp(3, 4, _t);
        if (demo_timer >= demo_step_len) {
            demo_maxwell_col = 3;
            demo_block_col   = 4;
            demo_solved      = true;
            demo_timer = 0;
            demo_step  = 4;
        }
    }
    else if (demo_step == 4) {
        if (demo_timer >= demo_pause * 1.5) {
            demo_timer = 0;
            demo_step  = 0;
        }
    }
}

// Dismiss on click (only after fully visible)
if (!fade_in && mouse_check_button_pressed(mb_left)) {
    instance_destroy();
}
