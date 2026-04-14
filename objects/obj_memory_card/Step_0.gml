if (global.paused) exit;

// Flip animation
if (flip_dir != 0) {
    flip_timer += flip_dir * 0.08;

    if (flip_timer >= 1) {
        flip_timer = 1;
        flip_dir = 0;
        flipped = true;
    }
    if (flip_timer <= 0) {
        flip_timer = 0;
        flip_dir = 0;
        flipped = false;
    }
}

// Decay feedback timers
if (match_glow > 0) match_glow--;
if (miss_flash > 0) miss_flash--;

// Click to flip — gated by controller (no clicks during peek or check window)
if (mouse_check_button_pressed(mb_left) && !flipped && !matched && flip_dir == 0) {
    var _mx = mouse_x;
    var _my = mouse_y;

    if (_mx > x && _mx < x + card_w && _my > y && _my < y + card_h) {
        if (instance_exists(obj_memory_controller)) {
            with (obj_memory_controller) {
                if (!peek_active && check_timer == 0 && flipped_count < 2 && !solved) {
                    other.flip_dir = 1;
                    flipped_cards[flipped_count] = other.id;
                    flipped_count++;
                }
            }
        }
    }
}
