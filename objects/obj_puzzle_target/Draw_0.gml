// Pulsing alpha so the target reads as "go here" instead of background art
var _pulse = 0.35 + 0.20 * (sin(current_time / 350) * 0.5 + 0.5);

// Target colour: "any" = orange, otherwise tinted to match
var _base_col = c_orange;
if (target_colour == "red")   _base_col = make_colour_rgb(255, 120, 100);
if (target_colour == "blue")  _base_col = make_colour_rgb(120, 160, 255);
if (target_colour == "green") _base_col = make_colour_rgb(120, 240, 120);
var _col = occupied ? c_lime : _base_col;

draw_set_alpha(occupied ? 0.55 : _pulse);
draw_rectangle_colour(x, y, x + 31, y + 31, _col, _col, _col, _col, false);

// Outline ring also pulses (slightly offset phase)
var _ring = 0.5 + 0.4 * (sin(current_time / 350 + 0.6) * 0.5 + 0.5);
draw_set_alpha(_ring);
draw_set_colour(occupied ? make_colour_rgb(180, 255, 180) : make_colour_rgb(255, 220, 140));
draw_rectangle(x, y, x + 31, y + 31, true);
draw_rectangle(x + 1, y + 1, x + 30, y + 30, true);

draw_set_alpha(1);

// X mark in center
draw_set_colour(c_white);
draw_line_width(x + 8, y + 8, x + 23, y + 23, 2);
draw_line_width(x + 23, y + 8, x + 8, y + 23, 2);
draw_set_colour(c_white);
