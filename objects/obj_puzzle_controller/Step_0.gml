if (global.paused) exit;

// ===================================================
// TUTORIAL — animated demo, blocks all gameplay
// ===================================================
if (tutorial_active) {
    // Fade in
    if (tut_alpha < 1) {
        tut_alpha += 0.08;
        if (tut_alpha > 1) tut_alpha = 1;
    }

    tut_timer++;

    // Step 0: pause — show starting layout
    if (tut_step == 0) {
        tut_cat_col   = 0;
        tut_block_col = 2;
        tut_solved    = false;
        if (tut_timer >= tut_pause) {
            tut_timer = 0;
            tut_step  = 1;
        }
    }
    // Step 1: Maxwell walks col 0 → 1
    else if (tut_step == 1) {
        var _t = clamp(tut_timer / tut_step_len, 0, 1);
        tut_cat_col = lerp(0, 1, _t);
        if (tut_timer >= tut_step_len) {
            tut_cat_col = 1;
            tut_timer = 0;
            tut_step  = 2;
        }
    }
    // Step 2: push — Maxwell 1→2, block 2→3
    else if (tut_step == 2) {
        var _t = clamp(tut_timer / tut_step_len, 0, 1);
        tut_cat_col   = lerp(1, 2, _t);
        tut_block_col = lerp(2, 3, _t);
        if (tut_timer >= tut_step_len) {
            tut_cat_col   = 2;
            tut_block_col = 3;
            tut_timer = 0;
            tut_step  = 3;
        }
    }
    // Step 3: push onto target — Maxwell 2→3, block 3→4
    else if (tut_step == 3) {
        var _t = clamp(tut_timer / tut_step_len, 0, 1);
        tut_cat_col   = lerp(2, 3, _t);
        tut_block_col = lerp(3, 4, _t);
        if (tut_timer >= tut_step_len) {
            tut_cat_col   = 3;
            tut_block_col = 4;
            tut_solved    = true;
            tut_timer = 0;
            tut_step  = 4;
        }
    }
    // Step 4: celebrate, then loop
    else if (tut_step == 4) {
        if (tut_timer >= tut_pause * 1.5) {
            tut_timer = 0;
            tut_step  = 0;
        }
    }

    // Dismiss on tap (after fade-in)
    if (tut_alpha >= 1 && mouse_check_button_pressed(mb_left)) {
        tutorial_active = false;
    }

    exit;  // block all gameplay while tutorial is showing
}

// Reset puzzle — keyboard R or on-screen reset button (mobile)
if (keyboard_check_pressed(ord("R")) || global.touch_reset_pressed) {
    room_restart();
}

// One-step undo — keyboard Z or on-screen undo button (mobile)
// Reverses the most recent push (block + player)
if (!solved && (keyboard_check_pressed(ord("Z")) || global.touch_undo_pressed) && has_undo) {
    if (instance_exists(undo_block)) {
        undo_block.x = undo_block_x;
        undo_block.y = undo_block_y;
        undo_block.targetX     = undo_block_x;
        undo_block.targetY     = undo_block_y;
        undo_block.startPointX = undo_block_x;
        undo_block.startPointY = undo_block_y;
        undo_block.sliding     = false;
        undo_block.move_timer  = 0;
    }
    if (instance_exists(obj_player)) {
        obj_player.x = undo_player_x;
        obj_player.y = undo_player_y;
        obj_player.move_to_x = undo_player_x;
        obj_player.move_to_y = undo_player_y;
        obj_player.move_from_x = undo_player_x;
        obj_player.move_from_y = undo_player_y;
        obj_player.moving = false;
    }
    has_undo = false;
    if (move_count > 0) move_count--;
    idle_timer = 0;
}

// Idle timer for the stuck hint — reset whenever the player or any block moves
var _player_busy = (instance_exists(obj_player) && obj_player.moving);
var _any_block_sliding = false;
with (obj_pushblock) {
    if (sliding) _any_block_sliding = true;
}
if (_player_busy || _any_block_sliding) {
    idle_timer = 0;
} else if (!solved) {
    idle_timer++;
}

// Check win: all targets must have a pushblock on them
if (!solved) {
    var _all_filled = true;

    with (obj_puzzle_target) {
        var _blk = instance_position(x + 16, y + 16, obj_pushblock);
        if (_blk != noone) {
            if (target_colour == "any" || _blk.block_colour == "any"
                || target_colour == _blk.block_colour) {
                occupied = true;
            } else {
                occupied = false;
            }
        } else {
            occupied = false;
        }
        if (!occupied) _all_filled = false;
    }

    if (_all_filled && instance_number(obj_puzzle_target) > 0) {
        solved = true;
        solve_timer = 90;
        audio_play_sound(Level_complete, 4, false);
        camera_zoom_kiss();

        var _idx = level_num - 1;
        if (global.pushblock_best[_idx] == 0 || move_count < global.pushblock_best[_idx]) {
            global.pushblock_best[_idx] = move_count;
        }
    }
}

// Advance to next room after delay
if (solved) {
    solve_timer--;
    if (solve_timer <= 0) {
        if (room == rm_puzzle_1_4) {
            global.puzzle_complete[0] = 1;
            update_house_stage();
            save_game();
            transition_to(Room1);
        } else {
            save_game();
            transition_to(room_next(room));
        }
    }
}
