// HUD overlay — title, leave prompt, hover label, first-visit welcome banner.
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// ===========================================
// TITLE — top-center
// ===========================================
draw_set_font(global.font_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _title = tr("interior_title");
draw_set_colour(make_colour_rgb(0, 0, 0));
draw_text(_cx + 2, 20, _title);
draw_set_colour(make_colour_rgb(255, 220, 140));
draw_text(_cx, 18, _title);

// ===========================================
// LEAVE PROMPT — top-right, below pause button
// ===========================================
draw_set_halign(fa_right);
draw_set_colour(make_colour_rgb(0, 0, 0));
draw_text(_gw - 19, 91, tr("interior_leave_prompt"));
draw_set_colour(make_colour_rgb(210, 230, 255));
draw_text(_gw - 20, 90, tr("interior_leave_prompt"));

// ===========================================
// HOVER LABEL — when standing near an object of interest
// ===========================================
if (hover_label != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(global.font_main);

    var _lw = string_width(hover_label) + 32;
    var _lh = 36;
    var _ly = _gh - 60;

    // Pill background
    draw_set_alpha(0.75);
    draw_set_colour(make_colour_rgb(20, 15, 30));
    draw_rectangle(_cx - _lw / 2, _ly - _lh, _cx + _lw / 2, _ly, false);
    draw_set_alpha(1);
    draw_set_colour(make_colour_rgb(220, 180, 80));
    draw_rectangle(_cx - _lw / 2, _ly - _lh, _cx + _lw / 2, _ly, true);

    // Label text
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_cx, _ly - _lh / 2, hover_label);
}

// ===========================================
// WELCOME BANNER — fades in at start of each visit
// ===========================================
if (welcome_timer > 0) {
    var _alpha_val = 1;
    if (welcome_timer < welcome_fade) {
        _alpha_val = welcome_timer / welcome_fade;
    }

    draw_set_alpha(_alpha_val * 0.6);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(0, _gh / 2 - 70, _gw, _gh / 2 + 50, false);

    draw_set_alpha(_alpha_val);
    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _welcome = tr("interior_welcome");
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_text(_cx + 3, _gh / 2 - 10 + 3, _welcome);
    draw_set_colour(make_colour_rgb(255, 220, 140));
    draw_text(_cx, _gh / 2 - 10, _welcome);

    draw_set_alpha(1);
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
