// Room-space drawing — only the animal portrait lives here.
// All HUD/buttons/text moved to Draw GUI for crisp text rendering.
//
// The four animal sprites live in the spr_animals group and are named
// after their answer (spr_cat, spr_elephant, spr_penguin, spr_octopus).
// Index order must match quiz_animal[] in Create_0.gml.

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cx    = _cam_x + _cam_w / 2;

var _pic_cx = _cx;
var _pic_cy = _cam_y + 110;

var _sprites = [spr_cat, spr_elephant, spr_penguin, spr_octopus];
var _spr = _sprites[question_index];

// Scale so the tallest side fits a ~140px portrait box, regardless of
// whatever native size the artist exported.
var _target = 140;
var _sw = sprite_get_width(_spr);
var _sh = sprite_get_height(_spr);
var _scale = _target / max(_sw, _sh);

// Gentle idle bob so the picture feels alive.
var _bob = sin(current_time / 400) * 2;

// Force the sprite's visual center onto (_pic_cx, _pic_cy) regardless of
// whatever origin the artist set in the sprite editor.
var _ox = sprite_get_xoffset(_spr);
var _oy = sprite_get_yoffset(_spr);
var _dx = _pic_cx + (_ox - _sw / 2) * _scale;
var _dy = _pic_cy + _bob + (_oy - _sh / 2) * _scale;

draw_set_alpha(1);
draw_set_colour(c_white);
draw_sprite_ext(_spr, 0, _dx, _dy, _scale, _scale, 0, c_white, 1);
