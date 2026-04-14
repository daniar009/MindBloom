// Room-space backdrop for the speech puzzle.
// The room itself is plain dark; we paint a soft gradient + a few
// floating "musical notes" to give it a stage-like feel instead of
// a flat black void.

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

// --- Vertical gradient: deep purple top → warm dark bottom ---
var _top_a    = make_colour_rgb(28, 18, 56);
var _bot_a    = make_colour_rgb(60, 28, 42);
draw_rectangle_colour(
    _cam_x, _cam_y, _cam_x + _cam_w, _cam_y + _cam_h,
    _top_a, _top_a, _bot_a, _bot_a, false
);

// --- Soft spotlight ellipse behind where the word will sit ---
var _spot_cx = _cam_x + _cam_w / 2;
var _spot_cy = _cam_y + _cam_h / 2 - 20;
for (var _r = 6; _r >= 1; _r--) {
    draw_set_alpha(0.06 * _r);
    draw_set_colour(make_colour_rgb(220, 180, 120));
    draw_ellipse(
        _spot_cx - 180 - _r * 10,
        _spot_cy - 90  - _r * 6,
        _spot_cx + 180 + _r * 10,
        _spot_cy + 90  + _r * 6,
        false
    );
}
draw_set_alpha(1);

// --- Floating decorative music notes (slow drift) ---
var _t = current_time / 1000;
for (var i = 0; i < 6; i++) {
    var _seed = i * 1.7;
    var _nx = _cam_x + 40 + (i * (_cam_w - 80) / 5);
    var _ny = _cam_y + _cam_h / 2 + sin(_t + _seed) * 18 + (i mod 2 == 0 ? -60 : 60);

    draw_set_alpha(0.18 + 0.08 * sin(_t * 1.4 + _seed));
    draw_set_colour(make_colour_rgb(220, 200, 240));
    // Note head
    draw_ellipse(_nx - 4, _ny - 3, _nx + 4, _ny + 3, false);
    // Stem
    draw_line_width(_nx + 4, _ny, _nx + 4, _ny - 14, 2);
    // Flag
    draw_line_width(_nx + 4, _ny - 14, _nx + 10, _ny - 9, 2);
}
draw_set_alpha(1);

draw_set_colour(c_white);
