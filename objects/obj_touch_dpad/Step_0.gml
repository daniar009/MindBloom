// Reset every per-frame "currently held" flag at the top of the step
global.touch_right         = false;
global.touch_left          = false;
global.touch_up            = false;
global.touch_down          = false;
global.touch_pressed       = false;
global.touch_reset_pressed = false;
global.touch_undo_pressed  = false;

if (!show_dpad) {
    // On non-mobile, activate the on-screen controls on first screen touch
    if (device_mouse_check_button(0, mb_left)
     || device_mouse_check_button(1, mb_left)) {
        show_dpad = true;
    }
    exit;
}

// Don't accept dpad/action input while paused, in dialogue, or during a
// tutorial overlay — those have their own UI surfaces and a stray touch
// underneath them shouldn't move the player.
if (global.paused) exit;
if (instance_exists(obj_textbox)) exit;
if (instance_exists(obj_tutorial_overlay)) exit;

// Don't render or accept input on the title screen
if (room == rm_title) exit;

// Direction buttons only listen in rooms with player movement, so a
// stray finger near the bottom-left of a non-movement room (e.g. the
// quiz) doesn't spuriously fire touch_left.
var _accept_directions = (room == Room1
                       || room == rm_puzzle_1_1 || room == rm_puzzle_1_2
                       || room == rm_puzzle_1_3 || room == rm_puzzle_1_4
                       || room == rm_house_interior);

// Track current-frame state for the action buttons so we can produce
// edge-triggered "pressed" globals.
var _reset_held = false;
var _undo_held  = false;

// Check up to 5 simultaneous touch points so multitouch (e.g. moving with
// the dpad while holding the reset button) works correctly.
for (var _t = 0; _t < 5; _t++) {
    if (!device_mouse_check_button(_t, mb_left)) continue;

    var _tx = device_mouse_x_to_gui(_t);
    var _ty = device_mouse_y_to_gui(_t);

    // ---------- D-pad ----------
    if (_accept_directions) {
        if (point_distance(_tx, _ty, dpad_cx + gap, dpad_cy) <= btn_r) {
            global.touch_right   = true;
            global.touch_pressed = true;
        }
        if (point_distance(_tx, _ty, dpad_cx - gap, dpad_cy) <= btn_r) {
            global.touch_left    = true;
            global.touch_pressed = true;
        }
        if (point_distance(_tx, _ty, dpad_cx, dpad_cy - gap) <= btn_r) {
            global.touch_up      = true;
            global.touch_pressed = true;
        }
        if (point_distance(_tx, _ty, dpad_cx, dpad_cy + gap) <= btn_r) {
            global.touch_down    = true;
            global.touch_pressed = true;
        }
    }

    // ---------- Action buttons ----------
    if (point_distance(_tx, _ty, act_reset_cx, act_reset_cy) <= act_btn_r) {
        _reset_held = true;
    }
    if (point_distance(_tx, _ty, act_undo_cx, act_undo_cy) <= act_btn_r) {
        _undo_held = true;
    }
}

// Edge-trigger: fire the *_pressed global only on the frame the touch
// first lands on the button. This matches the semantics of
// keyboard_check_pressed and keeps the puzzle controllers' existing
// fire-once behaviour intact.
if (_reset_held && !_reset_was_held) global.touch_reset_pressed = true;
if (_undo_held  && !_undo_was_held)  global.touch_undo_pressed  = true;
_reset_was_held = _reset_held;
_undo_was_held  = _undo_held;
