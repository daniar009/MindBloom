// On-screen D-pad + action buttons for mobile / touch devices.
// Injects virtual input events that obj_player and the puzzle
// controllers read via global.touch_*.
// The buttons render automatically on Android/iOS, and on desktop
// after the user touches the screen for the first time.

// =============================================
// LAYOUT — GUI space
// D-pad lives bottom-LEFT, action buttons live bottom-RIGHT.
// =============================================
dpad_cx = 160;
dpad_cy = display_get_gui_height() - 160;
btn_r   = 52;   // each directional button radius
gap     = 64;   // distance from centre to each direction's centre

// Action buttons (Reset + Undo) — bottom-right, mirrored from dpad
act_btn_r       = 48;
act_reset_cx    = display_get_gui_width()  - 90;
act_reset_cy    = display_get_gui_height() - 220;
act_undo_cx     = display_get_gui_width()  - 90;
act_undo_cy     = display_get_gui_height() - 110;

// =============================================
// VIRTUAL INPUT STATE — polled by gameplay objects
// =============================================
global.touch_right         = false;
global.touch_left          = false;
global.touch_up            = false;
global.touch_down          = false;
global.touch_pressed       = false;  // any direction held this frame
global.touch_reset_pressed = false;  // one-shot: fired the frame Reset is tapped
global.touch_undo_pressed  = false;  // one-shot: fired the frame Undo is tapped

// Edge detection state for the action buttons
_reset_was_held = false;
_undo_was_held  = false;

// =============================================
// VISIBILITY
// =============================================
// On mobile (Android/iOS), always show.
// On desktop, only after user touches the screen — set on first touch
// detected in Step.
show_dpad = (os_type == os_android || os_type == os_ios);
