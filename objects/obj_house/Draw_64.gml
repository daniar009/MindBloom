// When the player stands at the door on a finished house, show a
// small prompt up on the HUD so the control is discoverable.
if (global.house_stage < 4) exit;
if (!near_door) exit;
if (instance_exists(obj_textbox)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _py = _gh - 90;

var _prompt = tr("house_enter_prompt");

draw_set_font(global.font_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _pw = string_width(_prompt) + 40;
var _ph = 44;
var _pulse = 0.85 + 0.15 * sin(current_time / 250);

// Pill background
draw_set_alpha(0.8);
draw_set_colour(make_colour_rgb(20, 15, 35));
draw_rectangle(_cx - _pw / 2, _py - _ph / 2, _cx + _pw / 2, _py + _ph / 2, false);
draw_set_alpha(_pulse);
draw_set_colour(make_colour_rgb(255, 220, 140));
draw_rectangle(_cx - _pw / 2, _py - _ph / 2, _cx + _pw / 2, _py + _ph / 2, true);
draw_rectangle(_cx - _pw / 2 + 2, _py - _ph / 2 + 2, _cx + _pw / 2 - 2, _py + _ph / 2 - 2, true);
draw_set_alpha(1);

// Prompt text
draw_set_colour(make_colour_rgb(255, 240, 200));
draw_text(_cx, _py, _prompt);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
