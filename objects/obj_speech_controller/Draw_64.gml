// Speech puzzle HUD — drawn in GUI space at native resolution
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// --- TOP STRIP: title, level, R hint ---
draw_set_font(global.font_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(make_colour_rgb(255, 220, 120));
draw_text(_cx, 18, tr("speech_title"));

draw_set_halign(fa_left);
draw_set_colour(make_colour_rgb(160, 220, 160));
draw_text(20, 18, tr_num("hud_level", word_index + 1));

draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(170, 170, 180));
draw_text(_gw - 20, 90, tr("hud_retry"));

// --- BIG WORD (center, top half of screen) ---
var _word_str = string_upper(words[word_index]);
var _word_y   = 200;

draw_set_font(global.font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Soft glow / shadow
draw_set_colour(make_colour_rgb(0, 0, 0));
draw_text(_cx + 4, _word_y + 4, _word_str);
draw_set_colour(c_white);
draw_text(_cx, _word_y, _word_str);

// --- PHONETIC BREAKDOWN: "C - A - T" ---
var _phonetic = "";
var _len = string_length(_word_str);
for (var _i = 1; _i <= _len; _i++) {
    if (_i > 1) _phonetic += "  -  ";
    _phonetic += string_char_at(_word_str, _i);
}
draw_set_font(global.font_ui);
draw_set_colour(make_colour_rgb(255, 230, 160));
draw_text(_cx, _word_y + 64, _phonetic);

// --- HINT (smaller, below phonetic) ---
draw_set_font(global.font_main);
draw_set_colour(make_colour_rgb(200, 200, 220));
draw_text(_cx, _word_y + 100, hints[word_index]);

// --- MIC BUTTON (lower half) ---
var _btn_cx = _cx;
var _btn_cy = _gh - 260;
var _btn_r  = 64;
mic_btn_x = _btn_cx;
mic_btn_y = _btn_cy;
mic_btn_r = _btn_r;

var _gmx = device_mouse_x_to_gui(0);
var _gmy = device_mouse_y_to_gui(0);

if (state == 0) {
    var _pulse = 1 + sin(pulse_timer * 3) * 0.08;
    var _r = _btn_r * _pulse;
    var _hover = (point_distance(_gmx, _gmy, _btn_cx, _btn_cy) <= _btn_r);

    draw_set_colour(_hover ? make_colour_rgb(100, 180, 255) : make_colour_rgb(60, 120, 200));
    draw_circle(_btn_cx, _btn_cy, _r, false);
    draw_set_colour(make_colour_rgb(120, 200, 255));
    draw_circle(_btn_cx, _btn_cy, _r, true);
    draw_circle(_btn_cx, _btn_cy, _r - 2, true);

    // Mic icon
    draw_set_colour(c_white);
    draw_roundrect(_btn_cx - 12, _btn_cy - 26, _btn_cx + 12, _btn_cy + 4, false);
    draw_line_width(_btn_cx, _btn_cy + 4, _btn_cx, _btn_cy + 22, 4);
    draw_line_width(_btn_cx - 14, _btn_cy + 22, _btn_cx + 14, _btn_cy + 22, 4);

    draw_set_font(global.font_ui);
    draw_set_colour(make_colour_rgb(180, 220, 255));
    draw_text(_btn_cx, _btn_cy + _btn_r + 28, tr("speech_tap"));
}
else if (state == 1) {
    var _vp    = clamp(current_amplitude / amplitude_threshold, 0, 2);
    var _pulse = 1 + (_vp * 0.25) + sin(pulse_timer * 6) * 0.05;
    var _r     = _btn_r * _pulse;

    draw_set_colour(make_colour_rgb(220, 60, 60));
    draw_circle(_btn_cx, _btn_cy, _r, false);
    draw_set_colour(make_colour_rgb(255, 140, 140));
    draw_circle(_btn_cx, _btn_cy, _r, true);
    draw_circle(_btn_cx, _btn_cy, _r - 2, true);

    draw_set_colour(c_white);
    draw_roundrect(_btn_cx - 12, _btn_cy - 26, _btn_cx + 12, _btn_cy + 4, false);
    draw_line_width(_btn_cx, _btn_cy + 4, _btn_cx, _btn_cy + 22, 4);
    draw_line_width(_btn_cx - 14, _btn_cy + 22, _btn_cx + 14, _btn_cy + 22, 4);

    draw_set_font(global.font_ui);
    draw_set_colour(make_colour_rgb(255, 160, 160));
    draw_text(_btn_cx, _btn_cy + _btn_r + 28, tr("speech_listening"));

    // Volume meter
    var _bar_w = 480;
    var _bar_h = 24;
    var _bar_x = _cx - _bar_w / 2;
    var _bar_y = _btn_cy + _btn_r + 70;

    draw_set_colour(make_colour_rgb(40, 40, 60));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);
    draw_set_colour(make_colour_rgb(120, 120, 160));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

    var _progress = clamp(loud_frames / loud_frames_needed, 0, 1);
    var _fill_w = _bar_w * _progress;
    draw_set_colour(make_colour_rgb(80, 220, 120));
    draw_rectangle(_bar_x + 2, _bar_y + 2, _bar_x + _fill_w - 2, _bar_y + _bar_h - 2, false);

    var _amp_frac = clamp(current_amplitude / (amplitude_threshold * 2), 0, 1);
    var _needle_x = _bar_x + _bar_w * _amp_frac;
    draw_set_colour(make_colour_rgb(255, 240, 120));
    draw_line_width(_needle_x, _bar_y - 6, _needle_x, _bar_y + _bar_h + 6, 3);

    var _thresh_x = _bar_x + _bar_w * 0.5;
    draw_set_colour(make_colour_rgb(220, 220, 100));
    draw_line_width(_thresh_x, _bar_y - 4, _thresh_x, _bar_y + _bar_h + 4, 2);
}
else if (state == 2) {
    draw_set_colour(make_colour_rgb(50, 200, 80));
    draw_circle(_btn_cx, _btn_cy, _btn_r, false);
    draw_set_colour(make_colour_rgb(120, 255, 160));
    draw_circle(_btn_cx, _btn_cy, _btn_r, true);

    draw_set_colour(c_white);
    draw_line_width(_btn_cx - 22, _btn_cy + 2, _btn_cx - 6, _btn_cy + 18, 6);
    draw_line_width(_btn_cx - 6,  _btn_cy + 18, _btn_cx + 26, _btn_cy - 18, 6);

    var _great_txt = tr("speech_great");
    draw_set_font(global.font_title);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_text(_cx + 3, _btn_cy + _btn_r + 50 + 3, _great_txt);
    draw_set_colour(make_colour_rgb(120, 255, 160));
    draw_text(_cx, _btn_cy + _btn_r + 50, _great_txt);
}
else if (state == 3) {
    draw_set_colour(make_colour_rgb(200, 140, 50));
    draw_circle(_btn_cx, _btn_cy, _btn_r, false);
    draw_set_colour(make_colour_rgb(255, 200, 120));
    draw_circle(_btn_cx, _btn_cy, _btn_r, true);

    draw_set_font(global.font_title);
    draw_set_colour(c_white);
    draw_text(_btn_cx, _btn_cy, "?");

    draw_set_font(global.font_ui);
    draw_set_colour(make_colour_rgb(255, 210, 140));
    draw_text(_cx, _btn_cy + _btn_r + 30, tr("speech_retry"));
}
else if (state == 4) {
    draw_set_colour(make_colour_rgb(120, 120, 40));
    draw_circle(_btn_cx, _btn_cy, _btn_r, false);

    draw_set_font(global.font_title);
    draw_set_colour(c_white);
    draw_text(_btn_cx, _btn_cy, "!");

    draw_set_font(global.font_ui);
    draw_set_colour(make_colour_rgb(220, 220, 100));
    draw_text(_cx, _btn_cy + _btn_r + 26, tr("speech_mic_unavailable"));
    draw_text(_cx, _btn_cy + _btn_r + 56, tr("speech_check_perms"));
}

// --- Skip button after fails (bottom-right) ---
if (skip_allowed && state == 0) {
    var _sw = 180;
    var _sh = 50;
    var _sx1 = _gw - _sw - 30;
    var _sy1 = _gh - _sh - 30;
    var _sx2 = _sx1 + _sw;
    var _sy2 = _sy1 + _sh;
    skip_rect = [_sx1, _sy1, _sx2, _sy2];

    var _sk_hover = (_gmx >= _sx1 && _gmx <= _sx2 && _gmy >= _sy1 && _gmy <= _sy2);
    draw_set_colour(_sk_hover ? make_colour_rgb(200, 200, 240) : make_colour_rgb(120, 120, 170));
    draw_rectangle(_sx1, _sy1, _sx2, _sy2, false);
    draw_set_colour(make_colour_rgb(220, 220, 255));
    draw_rectangle(_sx1, _sy1, _sx2, _sy2, true);

    draw_set_font(global.font_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text((_sx1 + _sx2) / 2, (_sy1 + _sy2) / 2, tr("hud_skip"));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
