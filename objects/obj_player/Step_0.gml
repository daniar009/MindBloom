// Freeze while paused, talking, or tutorial is showing
if (global.paused) exit;
if (instance_exists(obj_textbox)) exit;
if (instance_exists(obj_puzzle_controller) && obj_puzzle_controller.tutorial_active) exit;

// -----------------------------------------
// READ INPUT EVERY FRAME
// A tap moves exactly one tile. Holding past `hold_threshold` frames
// turns into continuous walking. This keeps precise one-tile movement
// while still supporting long walks.
// -----------------------------------------

// Track how long each direction has been held (keyboard OR touch D-pad)
var _kr = keyboard_check(vk_right) || global.touch_right;
var _kl = keyboard_check(vk_left)  || global.touch_left;
var _ku = keyboard_check(vk_up)    || global.touch_up;
var _kd = keyboard_check(vk_down)  || global.touch_down;

if (_kr) hold_right++; else hold_right = 0;
if (_kl) hold_left++;  else hold_left  = 0;
if (_ku) hold_up++;    else hold_up    = 0;
if (_kd) hold_down++;  else hold_down  = 0;

// Fresh press = 1 tile now. Long hold = continuous walk.
var _pr = keyboard_check_pressed(vk_right) || (hold_right == 1);
var _pl = keyboard_check_pressed(vk_left)  || (hold_left  == 1);
var _pd = keyboard_check_pressed(vk_down)  || (hold_down  == 1);
var _pu = keyboard_check_pressed(vk_up)    || (hold_up    == 1);

var _hin = 0;
if      (_pr)                              _hin =  1;
else if (_pl)                              _hin = -1;
else if (hold_right > hold_threshold)      _hin =  1;
else if (hold_left  > hold_threshold)      _hin = -1;

var _vin = 0;
if      (_pd)                              _vin =  1;
else if (_pu)                              _vin = -1;
else if (hold_down > hold_threshold)       _vin =  1;
else if (hold_up   > hold_threshold)       _vin = -1;

// No diagonals — horizontal takes priority
if (_hin != 0) _vin = 0;

// Buffering: only fresh presses during a slide queue the next tile.
// (If we buffered holds, a single tap would fire twice because the
// key is still held after the first tile's slide finishes.)
if (moving) {
    var _press_h = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
    var _press_v = keyboard_check_pressed(vk_down)  - keyboard_check_pressed(vk_up);
    if (_press_h != 0) _press_v = 0;
    if (_press_h != 0 || _press_v != 0) {
        buffered_h   = _press_h;
        buffered_v   = _press_v;
        buffer_timer = buffer_max;
    }
}

// -----------------------------------------
// MOVEMENT DECISION (only when free to move)
// -----------------------------------------
if (!moving) {
    var _hinput = _hin;
    var _vinput = _vin;

    // Nothing held right now? Fall back to buffered input from the slide
    if (_hinput == 0 && _vinput == 0 && buffer_timer > 0) {
        _hinput = buffered_h;
        _vinput = buffered_v;
    }

    // Buffer is either consumed or stale — clear it
    buffered_h   = 0;
    buffered_v   = 0;
    buffer_timer = 0;

    if (_hinput != 0 || _vinput != 0) {
        var _target_x = x + (_hinput * grid_size);
        var _target_y = y + (_vinput * grid_size);

        // Update facing (and remember horizontal for up/down walks)
        if (_hinput > 0) {
            face = RIGHT;
            last_h_face = RIGHT;
        } else if (_hinput < 0) {
            face = LEFT;
            last_h_face = LEFT;
        } else if (_vinput != 0) {
            face = last_h_face;
        }

        var _moved = false;

        // --- Try to push a block ---
        var _block = instance_position(_target_x - 16, _target_y - 16, obj_pushblock);

        if (_block != noone && !_block.sliding) {
            var _block_dest_x = _block.x + (_hinput * grid_size);
            var _block_dest_y = _block.y + (_vinput * grid_size);

            var _block_tile   = tilemap_get_at_pixel(collision_tilemap, _block_dest_x - 32, _block_dest_y - 32);
            var _block_solid  = place_meeting(_block_dest_x, _block_dest_y, obj_solid);
            var _block_behind = instance_position(_block_dest_x - 16, _block_dest_y - 16, obj_pushblock);

            if (!_block_tile && !_block_solid && _block_behind == noone) {
                // Record undo BEFORE the push so Z can rewind one step
                if (instance_exists(obj_puzzle_controller)) {
                    with (obj_puzzle_controller) {
                        has_undo      = true;
                        undo_block    = _block;
                        undo_block_x  = _block.x;
                        undo_block_y  = _block.y;
                        undo_player_x = other.x;
                        undo_player_y = other.y;
                        move_count++;
                        idle_timer = 0;
                    }
                }

                _block.startPointX = _block.x;
                _block.startPointY = _block.y;
                _block.targetX     = _block_dest_x;
                _block.targetY     = _block_dest_y;
                _block.move_timer  = 0;
                _block.sliding     = true;

                moving      = true;
                move_from_x = x;
                move_from_y = y;
                move_to_x   = _target_x;
                move_to_y   = _target_y;
                move_timer  = 0;
                anim_timer  = anim_duration;
                _moved = true;

                // Footstep dust puff on push too
                instance_create_depth(x - 16, y, -50, obj_dust_puff);
                audio_play_sound(PushBlock_Moving, 2, false);
            }
        }
        else if (_block == noone || !_block.sliding) {
            // --- Normal walking move ---
            var _tile_blocked = tilemap_get_at_pixel(collision_tilemap, _target_x - 32, _target_y - 32);
            var _obj_blocked  = place_meeting(_target_x, _target_y, obj_solid);

            if (!_tile_blocked && !_obj_blocked) {
                moving      = true;
                move_from_x = x;
                move_from_y = y;
                move_to_x   = _target_x;
                move_to_y   = _target_y;
                move_timer  = 0;
                anim_timer  = anim_duration;
                _moved = true;

                // Footstep dust puff at feet
                instance_create_depth(x - 16, y, -50, obj_dust_puff);
                audio_play_sound(Mc_Walk_sd, 2, false);

                // Reset stuck-hint timer; walking still counts as activity
                if (instance_exists(obj_puzzle_controller)) {
                    obj_puzzle_controller.idle_timer = 0;
                }
            }
        }

        // --- Blocked? Kick off a little bump toward the blocked side ---
        if (!_moved) {
            // Only play the bump sound on a fresh bump, not every frame
            // while the player holds into a wall.
            if (bump_timer <= 0) {
                audio_play_sound(MC_bump_to_other_objects, 2, false);
            }
            bump_x = _hinput * 2;
            bump_y = _vinput * 2;
            bump_timer = bump_max;
        }
    }
}

// -----------------------------------------
// SLIDE — with anticipation hold + ease-out
// -----------------------------------------
if (moving) {
    move_timer++;

    if (move_timer <= slide_start_delay) {
        // Anticipation frame(s): sprite facing is already flipped,
        // but the position hasn't started drifting yet. Makes the
        // direction change feel snappy and confirmed.
    } else {
        var _raw = (move_timer - slide_start_delay) / move_duration;
        var _t   = clamp(_raw, 0, 1);
        _t = _t * (2 - _t);  // ease-out

        x = lerp(move_from_x, move_to_x, _t);
        y = lerp(move_from_y, move_to_y, _t);

        if (_raw >= 1) {
            x = move_to_x;
            y = move_to_y;
            moving = false;
        }
    }
}

// -----------------------------------------
// BUMP DECAY
// -----------------------------------------
if (bump_timer > 0) {
    bump_timer--;
    var _bfrac = bump_timer / bump_max;
    bump_x *= _bfrac;
    bump_y *= _bfrac;
    if (bump_timer == 0) {
        bump_x = 0;
        bump_y = 0;
    }
}

// -----------------------------------------
// ANIMATION
// -----------------------------------------
if (anim_timer > 0) {
    anim_timer--;
} else {
    // Return to idle based on last horizontal direction faced
    face = (last_h_face == RIGHT) ? IDLER : IDLEL;
}

sprite_index = sprite[face];
