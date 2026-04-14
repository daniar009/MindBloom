var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// Title
draw_set_font(global.font_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(make_colour_rgb(220, 200, 240));
draw_text(_cx, 18, tr("memory_title"));

// Pairs counter (just a fraction -- language-neutral)
draw_set_halign(fa_left);
draw_set_colour(make_colour_rgb(160, 220, 160));
draw_text(20, 18, string(matched_pairs) + " / " + string(total_pairs));

// Level X / 4
var _level_num = 1;
if      (room == rm_memory_2) _level_num = 2;
else if (room == rm_memory_3) _level_num = 3;
else if (room == rm_memory_4) _level_num = 4;
draw_set_colour(make_colour_rgb(220, 200, 160));
draw_text(20, 50, tr_num("hud_level", _level_num));

// Peek hint
if (peek_active) {
    draw_set_halign(fa_center);
    draw_set_colour(make_colour_rgb(255, 240, 180));
    draw_text(_cx, 60, tr("memory_memorize"));
}

// R hint
draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(170, 170, 180));
draw_text(_gw - 20, 90, tr("hud_restart"));

// Skip button after several mismatches
if (skip_allowed && !solved) {
    var _sw = 180;
    var _sh = 50;
    var _sx1 = _gw - _sw - 30;
    var _sy1 = 130;
    var _sx2 = _sx1 + _sw;
    var _sy2 = _sy1 + _sh;
    skip_rect = [_sx1, _sy1, _sx2, _sy2];

    var _gmx = device_mouse_x_to_gui(0);
    var _gmy = device_mouse_y_to_gui(0);
    var _sk_hover = (_gmx >= _sx1 && _gmx <= _sx2 && _gmy >= _sy1 && _gmy <= _sy2);
    draw_set_colour(_sk_hover ? make_colour_rgb(220, 180, 80) : make_colour_rgb(170, 130, 50));
    draw_rectangle(_sx1, _sy1, _sx2, _sy2, false);
    draw_set_colour(make_colour_rgb(255, 230, 160));
    draw_rectangle(_sx1, _sy1, _sx2, _sy2, true);
    draw_set_font(global.font_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text((_sx1 + _sx2) / 2, (_sy1 + _sy2) / 2, tr("hud_skip"));
}

// Solved overlay
if (solved) {
    draw_set_alpha(0.55);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(0, _gh / 2 - 80, _gw, _gh / 2 + 60, false);
    draw_set_alpha(1);

    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _done_txt = tr("memory_all_matched");
    draw_set_colour(c_black);
    draw_text(_cx + 3, _gh / 2 - 10 + 3, _done_txt);
    draw_set_colour(make_colour_rgb(240, 200, 80));
    draw_text(_cx, _gh / 2 - 10, _done_txt);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
