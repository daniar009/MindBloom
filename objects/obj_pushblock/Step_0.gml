if (global.paused) exit;

// Keep depth in sync with Y so 3/4-view sorting stays correct
depth = -y;

// --- SLIDING ---
if (sliding) {
    move_timer++;
    var _t = clamp(move_timer / move_duration, 0, 1);

    x = lerp(startPointX, targetX, _t);
    y = lerp(startPointY, targetY, _t);

    if (_t >= 1) {
        x = targetX;
        y = targetY;
        sliding = false;
    }
}

// --- TARGET CHECK (respects color matching) ---
var _tgt = instance_position(x - 16, y - 16, obj_puzzle_target);
if (_tgt != noone) {
    on_target = (_tgt.target_colour == "any" || block_colour == "any"
                 || _tgt.target_colour == block_colour);
} else {
    on_target = false;
}

// Kick the camera + bounce on the frame we first land on a target
if (on_target && !was_on_target && !sliding) {
    camera_shake(3);
    bounce_timer = bounce_max;
    // Celebration particles
    var _p = instance_create_depth(x, y, -5000, obj_particle_burst);
    _p.burst_colour = c_lime;
    _p.burst_count = 10;
}
was_on_target = on_target;

// Tint: on-target = lime, off-target = base colour (white for "any")
var _colour_map = ds_map_create();
ds_map_add(_colour_map, "any",   c_white);
ds_map_add(_colour_map, "red",   make_colour_rgb(255, 100, 100));
ds_map_add(_colour_map, "blue",  make_colour_rgb(100, 140, 255));
ds_map_add(_colour_map, "green", make_colour_rgb(100, 230, 100));
var _base = ds_map_find_value(_colour_map, block_colour);
if (_base == undefined) _base = c_white;
ds_map_destroy(_colour_map);

if (on_target) {
    image_blend = c_lime;
} else {
    image_blend = _base;
}

// Scale bounce: 1.0 → 1.15 → 1.0 over `bounce_max` frames
if (bounce_timer > 0) {
    bounce_timer--;
    var _bt = 1 - (bounce_timer / bounce_max);   // 0..1
    var _scale = 1 + sin(_bt * pi) * 0.15;
    image_xscale = _scale;
    image_yscale = _scale;
} else {
    image_xscale = 1;
    image_yscale = 1;
}
