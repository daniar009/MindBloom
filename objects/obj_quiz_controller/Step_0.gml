if (global.paused) exit;
if (instance_exists(obj_tutorial_overlay)) exit;

// --- CLICK DETECTION on answer buttons (GUI space) ---
if (!solved && !wrong && mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    // Skip button takes priority once it's allowed
    if (skip_allowed) {
        if (_mx >= skip_rect[0] && _mx <= skip_rect[2]
         && _my >= skip_rect[1] && _my <= skip_rect[3]) {
            correct = true;
            solved  = true;
            solve_timer = 60;
            exit;
        }
    }

    // Buttons — coordinates cached by Draw GUI each frame
    for (var i = 0; i < 4; i++) {
        var _col = i mod 2;
        var _row = i div 2;
        var _x1 = btn_grid_x + _col * (btn_grid_w + btn_grid_gap);
        var _y1 = btn_grid_y + _row * (btn_grid_h + btn_grid_gap);
        var _x2 = _x1 + btn_grid_w;
        var _y2 = _y1 + btn_grid_h;

        if (_mx >= _x1 && _mx <= _x2 && _my >= _y1 && _my <= _y2) {
            selected = i;
            if (i == display_correct_index) {
                correct = true;
                solved  = true;
                solve_timer = 90;
                audio_play_sound(Correct_Answer_Choose_The_Right_Option, 3, false);
                audio_play_sound(Level_complete, 4, false);
                // Celebration particles
                var _p = instance_create_depth(mouse_x, mouse_y, -5000, obj_particle_burst);
                _p.burst_colour = make_colour_rgb(120, 255, 140);
                _p.burst_count = 14;
                camera_shake(2);
            } else {
                wrong = true;
                feedback_timer = 45;
                fail_count++;
                if (fail_count >= 3) skip_allowed = true;
            }
            break;
        }
    }
}

// Wrong-answer cooldown — reshuffle so they can't memorize a wrong slot
if (wrong) {
    feedback_timer--;
    if (feedback_timer <= 0) {
        wrong = false;
        selected = -1;
        build_question();
    }
}

// Correct — advance after delay
if (solved) {
    solve_timer--;
    if (solve_timer <= 0) {
        if (room == rm_quiz_4) {
            global.puzzle_complete[2] = 1;
            update_house_stage();
            save_game();
            transition_to(Room1);
        } else {
            transition_to(room_next(room));
        }
    }
}

// Reset — keyboard R or on-screen reset button (mobile)
if (keyboard_check_pressed(ord("R")) || global.touch_reset_pressed) {
    room_restart();
}
