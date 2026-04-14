// Crisp HUD in GUI space
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// --- Title ---
draw_set_font(global.font_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(make_colour_rgb(220, 200, 240));
draw_text(_cx, 18, tr("quiz_prompt"));

// --- Level indicator (top-left) ---
draw_set_halign(fa_left);
draw_set_colour(make_colour_rgb(160, 220, 160));
draw_text(20, 18, tr_num("hud_level", question_index + 1));

// --- R hint (top-right, below pause button) ---
draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(170, 170, 180));
draw_text(_gw - 20, 90, tr("hud_restart"));

// --- ANSWER BUTTONS (2x2 grid, GUI-sized) ---
var _btn_w  = 280;
var _btn_h  = 80;
var _btn_gap = 24;
var _grid_w = _btn_w * 2 + _btn_gap;
var _grid_h = _btn_h * 2 + _btn_gap;
var _bx = (_gw - _grid_w) / 2;
var _by = _gh - _grid_h - 60;

// Cache rect for click detection in Step
btn_grid_x = _bx;
btn_grid_y = _by;
btn_grid_w = _btn_w;
btn_grid_h = _btn_h;
btn_grid_gap = _btn_gap;

var _gmx = device_mouse_x_to_gui(0);
var _gmy = device_mouse_y_to_gui(0);

for (var i = 0; i < 4; i++) {
    var _col = i mod 2;
    var _row = i div 2;
    var _x1 = _bx + _col * (_btn_w + _btn_gap);
    var _y1 = _by + _row * (_btn_h + _btn_gap);
    var _x2 = _x1 + _btn_w;
    var _y2 = _y1 + _btn_h;

    var _hover = (_gmx >= _x1 && _gmx <= _x2 && _gmy >= _y1 && _gmy <= _y2);

    if (solved && i == display_correct_index) {
        draw_set_colour(make_colour_rgb(50, 180, 80));
    } else if (wrong && i == selected) {
        draw_set_colour(make_colour_rgb(200, 50, 50));
    } else if (_hover && !solved && !wrong) {
        draw_set_colour(make_colour_rgb(80, 80, 130));
    } else {
        draw_set_colour(make_colour_rgb(45, 40, 80));
    }
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_colour(make_colour_rgb(140, 130, 180));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);

    draw_set_font(global.font_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, display_choices[i]);
}

// --- Skip button (after a few wrong tries) ---
if (skip_allowed && !solved) {
    var _sw = 180;
    var _sh = 50;
    var _sx1 = _gw - _sw - 30;
    var _sy1 = _by - _sh - 16;
    var _sx2 = _sx1 + _sw;
    var _sy2 = _sy1 + _sh;
    skip_rect = [_sx1, _sy1, _sx2, _sy2];

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

// --- SOLVED overlay ---
if (solved) {
    draw_set_alpha(0.55);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(0, _gh / 2 - 80, _gw, _gh / 2 + 60, false);
    draw_set_alpha(1);

    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _ty = _gh / 2 - 10;
    var _correct_txt = tr("quiz_correct");
    draw_set_colour(c_black);
    draw_text(_cx + 3, _ty + 3, _correct_txt);
    draw_set_colour(make_colour_rgb(120, 255, 140));
    draw_text(_cx, _ty, _correct_txt);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
