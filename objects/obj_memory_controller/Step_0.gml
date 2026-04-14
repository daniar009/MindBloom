if (global.paused) exit;
if (instance_exists(obj_tutorial_overlay)) exit;

// --- SETUP: spawn cards on first frame ---
if (!setup_done) {
    setup_done = true;
    total_pairs = pair_count;

    // Build shuffled card ID list: [0,0,1,1,2,2,...]
    var _total_cards = pair_count * 2;
    var _ids = array_create(_total_cards);
    for (var i = 0; i < pair_count; i++) {
        _ids[i * 2]     = i;
        _ids[i * 2 + 1] = i;
    }

    // Fisher-Yates shuffle
    for (var i = _total_cards - 1; i > 0; i--) {
        var j = irandom(i);
        var _tmp = _ids[i];
        _ids[i] = _ids[j];
        _ids[j] = _tmp;
    }

    // Card layout
    var _card_w = 48;
    var _card_h = 64;
    var _gap_x  = 12;
    var _gap_y  = 12;
    var _total_w = grid_cols * (_card_w + _gap_x) - _gap_x;
    var _total_h = grid_rows * (_card_h + _gap_y) - _gap_y;
    var _start_x = (room_width  - _total_w) / 2;
    var _start_y = (room_height - _total_h) / 2 + 10;

    for (var _row = 0; _row < grid_rows; _row++) {
        for (var _col = 0; _col < grid_cols; _col++) {
            var _idx = _row * grid_cols + _col;
            if (_idx >= _total_cards) break;

            var _cx = _start_x + _col * (_card_w + _gap_x);
            var _cy = _start_y + _row * (_card_h + _gap_y);

            var _card = instance_create_depth(_cx, _cy, -100, obj_memory_card);
            _card.card_id = _ids[_idx];
            // Force-flip face up for the peek window
            _card.flip_dir   = 0;
            _card.flip_timer = 1;
            _card.flipped    = true;
            _card.peek_card  = true;
        }
    }
}

// --- PEEK WINDOW: cards stay revealed, then auto-flip back ---
if (peek_active) {
    peek_timer--;
    if (peek_timer <= 0) {
        peek_active = false;
        with (obj_memory_card) {
            if (peek_card && !matched) {
                flip_dir   = -1;
                peek_card  = false;
            }
        }
    }
    exit; // no clicking during peek
}

// --- CHECK MATCH after 2 cards are flipped ---
if (flipped_count >= 2 && check_timer == 0) {
    check_timer = 70;  // ~1.15s — slower for kids
}

if (check_timer > 0) {
    check_timer--;

    if (check_timer <= 0) {
        var _c1 = flipped_cards[0];
        var _c2 = flipped_cards[1];

        if (instance_exists(_c1) && instance_exists(_c2)) {
            if (_c1.card_id == _c2.card_id) {
                // Match!
                _c1.matched = true;
                _c2.matched = true;
                _c1.match_glow = 30;
                _c2.match_glow = 30;
                matched_pairs++;
                audio_play_sound(Correct_Answer_Memory, 3, false);
                camera_shake(2);
                // Celebration particles on each card
                var _p1 = instance_create_depth(_c1.x + 24, _c1.y + 32, -5000, obj_particle_burst);
                _p1.burst_colour = make_colour_rgb(120, 255, 160);
                var _p2 = instance_create_depth(_c2.x + 24, _c2.y + 32, -5000, obj_particle_burst);
                _p2.burst_colour = make_colour_rgb(120, 255, 160);
            } else {
                // No match — flip both back, gentle red flash
                _c1.flip_dir = -1;
                _c2.flip_dir = -1;
                _c1.miss_flash = 20;
                _c2.miss_flash = 20;
                mismatch_count++;
                if (mismatch_count >= 4) skip_allowed = true;
            }
        }

        flipped_count = 0;
        flipped_cards[0] = noone;
        flipped_cards[1] = noone;
    }
}

// --- WIN CHECK ---
if (!solved && matched_pairs >= total_pairs && total_pairs > 0) {
    solved = true;
    solve_timer = 90;
    audio_play_sound(Level_complete, 4, false);
}

if (solved) {
    solve_timer--;
    if (solve_timer <= 0) {
        if (room == rm_memory_4) {
            // Last memory level — done!
            global.puzzle_complete[1] = 1;
            update_house_stage();
            save_game();
            transition_to(Room1);
        } else {
            transition_to(room_next(room));
        }
    }
}

// --- Skip click (GUI-space; poll here so card click can't steal it) ---
if (skip_allowed && !solved && mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (_mx >= skip_rect[0] && _mx <= skip_rect[2]
     && _my >= skip_rect[1] && _my <= skip_rect[3]) {
        // Mark all remaining cards matched and trigger win
        with (obj_memory_card) matched = true;
        matched_pairs = total_pairs;
    }
}

// Reset — keyboard R or on-screen reset button (mobile)
if (keyboard_check_pressed(ord("R")) || global.touch_reset_pressed) {
    room_restart();
}
