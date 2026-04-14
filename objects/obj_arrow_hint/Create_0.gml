// Animated arrow + finger-tap that points at a GUI location.
// Spawn with:
//   var _h = instance_create_depth(0, 0, -20000, obj_arrow_hint);
//   _h.target_gui_x = 400;   // GUI-space x to point at
//   _h.target_gui_y = 300;   // GUI-space y
//   _h.hint_text = "Tap here!";  // optional text
//   _h.dismiss_on_click = true;  // destroy on any click (default true)
//
// Disappears on first click anywhere by default.

target_gui_x = 0;
target_gui_y = 0;
hint_text    = "Tap here!";
dismiss_on_click = true;

bob_timer = 0;
alive = true;
