// Title UI — drawn in GUI space so fonts stay crisp at native resolution.
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
if (_gw <= 0) { _gw = 1366; _gh = 768; }

var _cx = _gw / 2;
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _bounce = sin(anim_timer * 1.1) * 4;

// -----------------------------
// TITLE LOGO
// -----------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(global.font_title);

var _title_y = _gh * 0.22 + _bounce;

// Back shadow
draw_set_alpha(0.4);
draw_set_colour(c_black);
draw_text(_cx + 5, _title_y + 6, "Mind Bloom");
draw_set_alpha(1);

// Pink outline pass
draw_set_colour(make_colour_rgb(240, 140, 170));
draw_text(_cx - 3, _title_y, "Mind Bloom");
draw_text(_cx + 3, _title_y, "Mind Bloom");
draw_text(_cx,     _title_y - 3, "Mind Bloom");
draw_text(_cx,     _title_y + 3, "Mind Bloom");

// Main fill — warm gold
draw_set_colour(make_colour_rgb(255, 215, 110));
draw_text(_cx, _title_y, "Mind Bloom");

// Little hearts on either side of the title
var _heart_col = make_colour_rgb(240, 120, 150);
var _heart_pulse = 1 + sin(anim_timer * 2) * 0.15;
var _title_w_est = string_width("Mind Bloom");
var _hx_l = _cx - _title_w_est / 2 - 50;
var _hx_r = _cx + _title_w_est / 2 + 50;
var _hy   = _title_y;
var _hs   = 16 * _heart_pulse;
var _all_hearts = [[_hx_l, _hy], [_hx_r, _hy]];
for (var i = 0; i < array_length(_all_hearts); i++) {
    var _hpx = _all_hearts[i][0];
    var _hpy = _all_hearts[i][1];
    draw_set_colour(_heart_col);
    draw_circle(_hpx - _hs * 0.35, _hpy - _hs * 0.15, _hs * 0.45, false);
    draw_circle(_hpx + _hs * 0.35, _hpy - _hs * 0.15, _hs * 0.45, false);
    draw_triangle(
        _hpx - _hs * 0.7, _hpy + _hs * 0.05,
        _hpx + _hs * 0.7, _hpy + _hs * 0.05,
        _hpx,             _hpy + _hs * 0.75,
        false
    );
}

// Subtitle ribbon
draw_set_font(global.font_ui);
draw_set_colour(make_colour_rgb(180, 120, 160));
draw_text(_cx + 2, _title_y + 62 + 2, tr("title_subtitle"));
draw_set_colour(make_colour_rgb(255, 170, 200));
draw_text(_cx, _title_y + 62, tr("title_subtitle"));

// -----------------------------
// BUTTONS
// -----------------------------
var _btn_w   = 440;
var _btn_h   = 76;
var _btn_gap = 18;
var _btn_x1  = _cx - _btn_w / 2;
var _btn_x2  = _cx + _btn_w / 2;

// Keep an internal id alongside the label so we can rename freely
// per-language without breaking the click logic below.
var _btn_labels = [];
var _btn_ids    = [];
var _btn_count  = 0;

_btn_labels[_btn_count] = tr("title_new_game"); _btn_ids[_btn_count] = "new";      _btn_count++;
if (has_save) {
    _btn_labels[_btn_count] = tr("title_continue"); _btn_ids[_btn_count] = "continue"; _btn_count++;
}
_btn_labels[_btn_count] = tr("title_exit"); _btn_ids[_btn_count] = "exit"; _btn_count++;

var _btn_start_y = _gh * 0.50;

btn_new_hover      = false;
btn_continue_hover = false;
btn_exit_hover     = false;

draw_set_font(global.font_ui);

for (var _b = 0; _b < _btn_count; _b++) {
    var _label = _btn_labels[_b];
    var _by    = _btn_start_y + _b * (_btn_h + _btn_gap);
    var _hover = (_mx > _btn_x1 && _mx < _btn_x2 && _my > _by && _my < _by + _btn_h);

    // Hover flags are tracked by id, not label, so renaming strings
    // across languages doesn't break detection.
    if (_btn_ids[_b] == "new")      btn_new_hover      = _hover;
    if (_btn_ids[_b] == "continue") btn_continue_hover = _hover;
    if (_btn_ids[_b] == "exit")     btn_exit_hover     = _hover;

    // Drop shadow
    draw_set_alpha(0.3);
    draw_set_colour(c_black);
    draw_roundrect_ext(_btn_x1 + 5, _by + 7, _btn_x2 + 5, _by + _btn_h + 7, 22, 22, false);
    draw_set_alpha(1);

    // Button fill
    var _fill_col = _hover
        ? make_colour_rgb(255, 210, 150)
        : make_colour_rgb(255, 245, 220);
    draw_set_colour(_fill_col);
    draw_roundrect_ext(_btn_x1, _by, _btn_x2, _by + _btn_h, 22, 22, false);

    // Top sheen
    var _sheen = _hover
        ? make_colour_rgb(255, 240, 200)
        : make_colour_rgb(255, 255, 240);
    draw_set_colour(_sheen);
    draw_roundrect_ext(_btn_x1 + 6, _by + 5, _btn_x2 - 6, _by + 22, 12, 12, false);

    // Double border
    var _border_outer = make_colour_rgb(168, 120, 92);
    var _border_inner = _hover
        ? make_colour_rgb(240, 120, 150)
        : make_colour_rgb(222, 178, 140);
    draw_set_colour(_border_outer);
    draw_roundrect_ext(_btn_x1, _by, _btn_x2, _by + _btn_h, 22, 22, true);
    draw_set_colour(_border_inner);
    draw_roundrect_ext(_btn_x1 + 3, _by + 3, _btn_x2 - 3, _by + _btn_h - 3, 18, 18, true);

    // Hover indicator hearts on the sides
    if (_hover) {
        var _hs2 = 10;
        var _hleft_x  = _btn_x1 + 24;
        var _hright_x = _btn_x2 - 24;
        var _hmid_y   = _by + _btn_h / 2;
        draw_set_colour(make_colour_rgb(240, 120, 150));
        var _sides = [[_hleft_x, _hmid_y], [_hright_x, _hmid_y]];
        for (var j = 0; j < 2; j++) {
            var _ix = _sides[j][0];
            var _iy = _sides[j][1];
            draw_circle(_ix - _hs2 * 0.35, _iy - _hs2 * 0.15, _hs2 * 0.45, false);
            draw_circle(_ix + _hs2 * 0.35, _iy - _hs2 * 0.15, _hs2 * 0.45, false);
            draw_triangle(
                _ix - _hs2 * 0.7, _iy + _hs2 * 0.05,
                _ix + _hs2 * 0.7, _iy + _hs2 * 0.05,
                _ix,              _iy + _hs2 * 0.75,
                false
            );
        }
    }

    // Label
    draw_set_colour(make_colour_rgb(100, 60, 40));
    draw_text(_cx, _by + _btn_h / 2, _label);
}

// -----------------------------
// CLICK HANDLING
// -----------------------------
if (mouse_check_button_pressed(mb_left)) {
    if (btn_new_hover) {
        delete_save();
        init_progress();
        transition_to(Room1);
    }
    if (btn_continue_hover && has_save) {
        load_game();
        transition_to(Room1);
    }
    if (btn_exit_hover) {
        game_end();
    }
}

// -----------------------------
// SKIP-TO-END BUTTON (bottom-left)
// Lets testers or parents jump straight to house_stage = 4
// so they can walk into the completed house without playing all puzzles.
// -----------------------------
draw_set_font(global.font_main);
var _skip_label = tr("title_skip_all");
var _skip_w  = string_width(_skip_label) + 36;
var _skip_h  = 48;
var _skip_x1 = 24;
var _skip_y1 = _gh - _skip_h - 24;
var _skip_x2 = _skip_x1 + _skip_w;
var _skip_y2 = _skip_y1 + _skip_h;
var _skip_hover = (_mx > _skip_x1 && _mx < _skip_x2 && _my > _skip_y1 && _my < _skip_y2);

// Shadow
draw_set_alpha(0.22);
draw_set_colour(c_black);
draw_roundrect_ext(_skip_x1 + 3, _skip_y1 + 4, _skip_x2 + 3, _skip_y2 + 4, 14, 14, false);
draw_set_alpha(1);

// Fill
draw_set_colour(_skip_hover
    ? make_colour_rgb(255, 240, 180)
    : make_colour_rgb(245, 230, 200));
draw_roundrect_ext(_skip_x1, _skip_y1, _skip_x2, _skip_y2, 14, 14, false);

// Border
draw_set_colour(_skip_hover
    ? make_colour_rgb(200, 140, 80)
    : make_colour_rgb(180, 140, 100));
draw_roundrect_ext(_skip_x1, _skip_y1, _skip_x2, _skip_y2, 14, 14, true);

// Label
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(make_colour_rgb(100, 65, 35));
draw_text((_skip_x1 + _skip_x2) / 2, (_skip_y1 + _skip_y2) / 2, _skip_label);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (_skip_hover && mouse_check_button_pressed(mb_left)) {
    // Complete everything in one shot
    delete_save();
    init_progress();
    for (var _pi = 0; _pi < 4; _pi++) {
        global.puzzle_complete[_pi] = 1;
    }
    global.house_stage = 4;
    save_game();
    transition_to(Room1);
}

// -----------------------------
// FOOTER
// -----------------------------
draw_set_font(global.font_main);
draw_set_colour(make_colour_rgb(150, 100, 130));
draw_text(_cx, _gh - 26, tr("title_tap"));

// -----------------------------
// LANGUAGE TOGGLE (top-right pill)
//   Tap to cycle EN -> RU -> KZ -> EN.
//   Kept small so it doesn't steal focus from the big menu buttons.
// -----------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(global.font_ui);

var _lang_w  = 120;
var _lang_h  = 56;
var _lang_x2 = _gw - 28;
var _lang_x1 = _lang_x2 - _lang_w;
var _lang_y1 = 28;
var _lang_y2 = _lang_y1 + _lang_h;
var _lang_hover = (_mx > _lang_x1 && _mx < _lang_x2 && _my > _lang_y1 && _my < _lang_y2);

// Shadow
draw_set_alpha(0.28);
draw_set_colour(c_black);
draw_roundrect_ext(_lang_x1 + 3, _lang_y1 + 5, _lang_x2 + 3, _lang_y2 + 5, 18, 18, false);
draw_set_alpha(1);

// Fill + sheen
var _lang_fill = _lang_hover
    ? make_colour_rgb(255, 220, 150)
    : make_colour_rgb(255, 245, 220);
draw_set_colour(_lang_fill);
draw_roundrect_ext(_lang_x1, _lang_y1, _lang_x2, _lang_y2, 18, 18, false);

// Border
draw_set_colour(make_colour_rgb(168, 120, 92));
draw_roundrect_ext(_lang_x1, _lang_y1, _lang_x2, _lang_y2, 18, 18, true);
draw_set_colour(_lang_hover
    ? make_colour_rgb(240, 120, 150)
    : make_colour_rgb(222, 178, 140));
draw_roundrect_ext(_lang_x1 + 3, _lang_y1 + 3, _lang_x2 - 3, _lang_y2 - 3, 15, 15, true);

// Current-language label (EN / RU / KZ)
draw_set_colour(make_colour_rgb(90, 55, 30));
draw_text((_lang_x1 + _lang_x2) / 2, (_lang_y1 + _lang_y2) / 2, lang_label());

if (_lang_hover && mouse_check_button_pressed(mb_left)) {
    lang_cycle();
}

// Reset state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_colour(c_white);
