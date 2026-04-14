if (!show_dpad) exit;

// Hide every on-screen control while dialogue, tutorial overlay or pause
// menu is up — those have their own input surfaces and the dpad/action
// buttons must not bleed clicks through them.
if (global.paused) exit;
if (instance_exists(obj_textbox)) exit;
if (instance_exists(obj_tutorial_overlay)) exit;
if (room == rm_title) exit;

// The D-pad only makes sense in rooms with player movement: the central
// hub and the pushblock levels. The other puzzle rooms (memory, quiz,
// speech) drive their input through taps and don't need direction
// buttons.
var _show_directions = (room == Room1
                     || room == rm_puzzle_1_1 || room == rm_puzzle_1_2
                     || room == rm_puzzle_1_3 || room == rm_puzzle_1_4
                     || room == rm_house_interior);

if (!_show_directions) {
    // Skip dpad rendering and input — but still allow action buttons
    // (Reset) below for puzzle rooms that have a "Try again" need.
}

// =============================================
// D-PAD (bottom-left)
// =============================================
if (_show_directions) {
var _cx = dpad_cx;
var _cy = dpad_cy;
var _r  = btn_r;
var _g  = gap;

draw_set_alpha(0.2);
draw_set_colour(make_colour_rgb(255, 255, 255));
draw_circle(_cx, _cy, _g + _r + 10, false);
draw_set_alpha(1);

var _dirs = [
    [_cx + _g, _cy,      global.touch_right, "▶"],
    [_cx - _g, _cy,      global.touch_left,  "◀"],
    [_cx,      _cy - _g, global.touch_up,    "▲"],
    [_cx,      _cy + _g, global.touch_down,  "▼"],
];

for (var i = 0; i < 4; i++) {
    var _bx = _dirs[i][0];
    var _by = _dirs[i][1];
    var _pressed = _dirs[i][2];
    var _sym = _dirs[i][3];

    draw_set_alpha(_pressed ? 0.6 : 0.35);
    draw_set_colour(_pressed ? make_colour_rgb(255, 220, 100) : make_colour_rgb(200, 200, 220));
    draw_circle(_bx, _by, _r, false);

    draw_set_alpha(0.5);
    draw_set_colour(c_white);
    draw_circle(_bx, _by, _r, true);

    draw_set_alpha(0.8);
    draw_set_colour(c_white);
    draw_set_font(global.font_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_bx, _by, _sym);
}
}  // end if (_show_directions)

// =============================================
// ACTION BUTTONS (bottom-right) — Reset + Undo
// Only render in puzzle rooms where they're meaningful. The hub
// (Room1) doesn't need either. House interior has nothing to reset.
// =============================================
var _show_reset = (room != Room1 && room != rm_house_interior);
var _show_undo  = (room == rm_puzzle_1_1 || room == rm_puzzle_1_2
                || room == rm_puzzle_1_3 || room == rm_puzzle_1_4);

if (_show_reset || _show_undo) {
    var _action_buttons = [];
    if (_show_reset) array_push(_action_buttons,
        [act_reset_cx, act_reset_cy, "↻", make_colour_rgb(220, 120, 100)]);
    if (_show_undo) array_push(_action_buttons,
        [act_undo_cx,  act_undo_cy,  "↶", make_colour_rgb(120, 200, 220)]);

    for (var j = 0; j < array_length(_action_buttons); j++) {
        var _ax = _action_buttons[j][0];
        var _ay = _action_buttons[j][1];
        var _sym = _action_buttons[j][2];
        var _tint = _action_buttons[j][3];

        draw_set_alpha(0.4);
        draw_set_colour(_tint);
        draw_circle(_ax, _ay, act_btn_r, false);

        draw_set_alpha(0.6);
        draw_set_colour(c_white);
        draw_circle(_ax, _ay, act_btn_r, true);

        draw_set_alpha(0.95);
        draw_set_colour(c_white);
        draw_set_font(global.font_ui);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_ax, _ay, _sym);
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
