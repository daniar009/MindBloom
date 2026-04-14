var _tx = target_gui_x;
var _ty = target_gui_y;
var _bob = sin(bob_timer) * 12;  // vertical bob

// Arrow pointing down
var _ax = _tx;
var _ay = _ty - 50 + _bob;

draw_set_alpha(0.9);
draw_set_colour(make_colour_rgb(255, 240, 120));
// Arrow shaft
draw_line_width(_ax, _ay - 28, _ax, _ay - 4, 4);
// Arrow head
draw_triangle(_ax - 10, _ay - 8, _ax + 10, _ay - 8, _ax, _ay + 4, false);

// Finger circle (tap indicator)
var _pulse = 0.7 + 0.3 * sin(bob_timer * 2);
draw_set_alpha(_pulse * 0.5);
draw_set_colour(c_white);
draw_circle(_tx, _ty, 24, true);
draw_circle(_tx, _ty, 26, true);

// Hint text
if (hint_text != "") {
    draw_set_alpha(0.9);
    draw_set_font(global.font_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_rgb(255, 240, 160));
    draw_text(_ax, _ay - 34, hint_text);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
