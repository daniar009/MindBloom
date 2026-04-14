if (global.paused) exit;

var _cam  = view_camera[0];

// Lock in the base view size on the very first frame so the zoom
// math always works from a stable reference (not last frame's zoomed size).
if (base_view_w == 0) {
    base_view_w = camera_get_view_width(_cam);
    base_view_h = camera_get_view_height(_cam);
}
var _camW = base_view_w;
var _camH = base_view_h;

if (instance_exists(obj_player)) {
    var _px = obj_player.x;
    var _py = obj_player.y;

    // Center of the current camera view
    var _cx = x + _camW / 2;
    var _cy = y + _camH / 2;

    // Distance from player to view center
    var _dx = _px - _cx;
    var _dy = _py - _cy;

    // Dead zone: camera only moves once the player crosses the edge
    var _target_x = x;
    var _target_y = y;

    if (_dx >  dead_zone_half_w) _target_x = x + (_dx - dead_zone_half_w);
    else if (_dx < -dead_zone_half_w) _target_x = x + (_dx + dead_zone_half_w);

    if (_dy >  dead_zone_half_h) _target_y = y + (_dy - dead_zone_half_h);
    else if (_dy < -dead_zone_half_h) _target_y = y + (_dy + dead_zone_half_h);

    // Snap instantly if a room transition teleported us far away
    if (abs(x - _target_x) > _camW || abs(y - _target_y) > _camH) {
        x = _target_x;
        y = _target_y;
    } else {
        // Smooth follow
        x = lerp(x, _target_x, follow_lerp);
        y = lerp(y, _target_y, follow_lerp);

        // Kill fractional drift once we're effectively there
        if (abs(x - _target_x) < 0.5) x = _target_x;
        if (abs(y - _target_y) < 0.5) y = _target_y;
    }
}

// Keep camera inside the room
x = clamp(x, 0, room_width - _camW);
y = clamp(y, 0, room_height - _camH);

// -----------------------------------------
// SCREEN SHAKE
// Random offset that decays each frame. Never affects the real x/y
// so the follow math stays clean.
// -----------------------------------------
if (shake_amount > 0) {
    shake_x = random_range(-shake_amount, shake_amount);
    shake_y = random_range(-shake_amount, shake_amount);
    shake_amount = max(0, shake_amount - shake_decay);
} else {
    shake_x = 0;
    shake_y = 0;
}

// Kiss zoom — slow, smooth zoom centered on the player
var _zw = _camW;
var _zh = _camH;
var _zoom_offset_x = 0;
var _zoom_offset_y = 0;

if (zoom_timer > 0) {
    zoom_timer--;
    // Smooth ease-in-out: peaks at the middle of the duration
    var _t = 1 - (zoom_timer / zoom_duration);  // 0 → 1
    var _zfrac = sin(_t * pi) * zoom_amount;     // 0 → peak → 0
    _zw = _camW * (1 - _zfrac);
    _zh = _camH * (1 - _zfrac);

    // Center the zoom on the player (not the camera corner)
    if (instance_exists(obj_player)) {
        var _px = obj_player.x;
        var _py = obj_player.y;
        // How far the player is from the camera's top-left, as a fraction
        var _fx = clamp((_px - x) / _camW, 0, 1);
        var _fy = clamp((_py - y) / _camH, 0, 1);
        _zoom_offset_x = (_camW - _zw) * _fx;
        _zoom_offset_y = (_camH - _zh) * _fy;
    } else {
        _zoom_offset_x = (_camW - _zw) / 2;
        _zoom_offset_y = (_camH - _zh) / 2;
    }
}

camera_set_view_size(_cam, _zw, _zh);
camera_set_view_pos(_cam,
    round(x + shake_x + _zoom_offset_x),
    round(y + shake_y + _zoom_offset_y)
);
