// Draw — covers the entire current view with a black fade rectangle.
// Uses the active camera so it always matches the visible area, no matter
// which room we're in.
if (alpha <= 0) exit;

var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam);
var _cy = camera_get_view_y(_cam);
var _cw = camera_get_view_width(_cam);
var _ch = camera_get_view_height(_cam);

draw_set_alpha(alpha);
draw_set_colour(c_black);
draw_rectangle(_cx, _cy, _cx + _cw, _cy + _ch, false);
draw_set_alpha(1);
draw_set_colour(c_white);
