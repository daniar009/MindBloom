// Don't show HUD on title screen
if (room == rm_title) exit;

// All coords are GUI-space (native pixel) for crisp text
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// =============================================
// PAUSE BUTTON (top-right)
// =============================================
var _pbx = _gw - pause_btn_w - pause_btn_margin;
var _pby = pause_btn_margin;
var _pbx2 = _pbx + pause_btn_w;
var _pby2 = _pby + pause_btn_h;

pause_btn_hover = (_mx > _pbx && _mx < _pbx2 && _my > _pby && _my < _pby2);

var _pb_base   = pause_btn_hover ? make_colour_rgb(70, 50, 100) : make_colour_rgb(30, 22, 50);
var _pb_border = pause_btn_hover ? make_colour_rgb(220, 180, 80) : make_colour_rgb(120, 100, 160);
draw_set_alpha(0.85);
draw_rectangle_colour(_pbx, _pby, _pbx2, _pby2, _pb_base, _pb_base, _pb_base, _pb_base, false);
draw_set_alpha(1);
draw_set_colour(_pb_border);
draw_rectangle(_pbx, _pby, _pbx2, _pby2, true);
draw_rectangle(_pbx + 2, _pby + 2, _pbx2 - 2, _pby2 - 2, true);

// Two pause bars
var _bar_c = pause_btn_hover ? make_colour_rgb(240, 210, 80) : make_colour_rgb(200, 180, 230);
draw_set_colour(_bar_c);
var _mid_y1 = _pby + 12;
var _mid_y2 = _pby2 - 12;
var _bar_lx = _pbx + 16;
var _bar_rx = _pbx + 36;
draw_rectangle(_bar_lx, _mid_y1, _bar_lx + 10, _mid_y2, false);
draw_rectangle(_bar_rx, _mid_y1, _bar_rx + 10, _mid_y2, false);

// Click pause button
if (mouse_check_button_pressed(mb_left) && pause_btn_hover) {
    global.paused = !global.paused;
}

// Escape key toggles pause too
if (keyboard_check_pressed(vk_escape)) {
    global.paused = !global.paused;
}

// =============================================
// PAUSE MENU OVERLAY
// =============================================
if (global.paused) {
    var _cx = _gw / 2;
    var _cy = _gh / 2;

    // Dim overlay
    draw_set_alpha(0.65);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Menu panel
    var _panel_w = 460;
    var _panel_h = 460;
    var _panel_x1 = _cx - _panel_w / 2;
    var _panel_y1 = _cy - _panel_h / 2;
    var _panel_x2 = _cx + _panel_w / 2;
    var _panel_y2 = _cy + _panel_h / 2;

    // Panel shadow
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(_panel_x1 + 8, _panel_y1 + 8, _panel_x2 + 8, _panel_y2 + 8, false);

    // Panel fill
    draw_rectangle_colour(_panel_x1, _panel_y1, _panel_x2, _panel_y2,
        make_colour_rgb(18, 12, 38), make_colour_rgb(18, 12, 38),
        make_colour_rgb(30, 20, 55), make_colour_rgb(30, 20, 55), false);

    // Panel border
    draw_set_colour(make_colour_rgb(120, 90, 180));
    draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);
    draw_set_colour(make_colour_rgb(220, 180, 80));
    draw_rectangle(_panel_x1 + 4, _panel_y1 + 4, _panel_x2 - 4, _panel_y2 - 4, true);

    // "PAUSED" header
    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _paused_txt = tr("pause_title");
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_text(_cx + 3, _panel_y1 + 60 + 3, _paused_txt);
    draw_set_colour(make_colour_rgb(240, 200, 80));
    draw_text(_cx, _panel_y1 + 60, _paused_txt);

    // Divider
    draw_set_colour(make_colour_rgb(100, 80, 150));
    draw_line_width(_panel_x1 + 30, _panel_y1 + 110, _panel_x2 - 30, _panel_y1 + 110, 2);

    // --- Menu buttons ---
    var _btn_gap = 24;
    var _btn_y1 = _panel_y1 + 140;
    var _btn_y2 = _btn_y1 + menu_btn_h + _btn_gap;
    var _btn_y3 = _btn_y2 + menu_btn_h + _btn_gap;
    var _bx1 = _cx - menu_btn_w / 2;
    var _bx2 = _cx + menu_btn_w / 2;

    menu_btn_hover1 = (_mx > _bx1 && _mx < _bx2 && _my > _btn_y1 && _my < _btn_y1 + menu_btn_h);
    menu_btn_hover2 = (_mx > _bx1 && _mx < _bx2 && _my > _btn_y2 && _my < _btn_y2 + menu_btn_h);
    menu_btn_hover3 = (_mx > _bx1 && _mx < _bx2 && _my > _btn_y3 && _my < _btn_y3 + menu_btn_h);

    var _menu_btns = [
        [_btn_y1, tr("pause_save"),     menu_btn_hover1],
        [_btn_y2, tr("pause_to_title"), menu_btn_hover2],
        [_btn_y3, tr("pause_exit"),     menu_btn_hover3]
    ];

    for (var _b = 0; _b < 3; _b++) {
        var _by     = _menu_btns[_b][0];
        var _label  = _menu_btns[_b][1];
        var _hover  = _menu_btns[_b][2];

        var _base   = _hover ? make_colour_rgb(65, 45, 95) : make_colour_rgb(35, 25, 60);
        var _border = _hover ? make_colour_rgb(220, 180, 80) : make_colour_rgb(120, 100, 160);
        var _text_c = _hover ? make_colour_rgb(240, 210, 80) : make_colour_rgb(220, 200, 240);

        draw_rectangle_colour(_bx1, _by, _bx2, _by + menu_btn_h, _base, _base, _base, _base, false);
        draw_set_colour(_border);
        draw_rectangle(_bx1, _by, _bx2, _by + menu_btn_h, true);
        draw_rectangle(_bx1 + 2, _by + 2, _bx2 - 2, _by + menu_btn_h - 2, true);

        draw_set_font(global.font_ui);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(_text_c);
        draw_text(_cx, _by + menu_btn_h / 2, _label);
    }

    // "Saved!" flash
    if (save_flash > 0) {
        save_flash--;
        draw_set_font(global.font_ui);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_colour(make_colour_rgb(80, 240, 120));
        draw_set_alpha(save_flash / 60);
        draw_text(_cx, _btn_y1 + menu_btn_h + 6, tr("pause_saved"));
        draw_set_alpha(1);
    }

    // Click handling
    if (mouse_check_button_pressed(mb_left)) {
        if (menu_btn_hover1) {
            save_game();
            save_flash = 60;
        }
        if (menu_btn_hover2) {
            global.paused = false;
            transition_to(rm_title);
        }
        if (menu_btn_hover3) {
            game_end();
        }
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
