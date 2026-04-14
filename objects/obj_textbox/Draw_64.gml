// Dialogue box — drawn in GUI space so the text is crisp at native res.
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
if (_gw <= 0) { _gw = 1366; _gh = 768; }

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _accept = mouse_check_button_pressed(mb_left);

// -----------------------------
// LAYOUT (GUI pixels)
// -----------------------------
var _box_w   = min(1120, _gw - 100);
var _box_h   = 240;
var _box_x   = (_gw - _box_w) / 2;
var _box_y   = _gh - _box_h - 44;

var _pad         = 26;
var _portrait_sz = 148;

// -----------------------------
// ONE-TIME SETUP
// -----------------------------
if (!setup) {
    setup = true;
    draw_set_font(global.font_dialogue);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);

    for (var p = 0; p < page_number; p++) {
        text_length[p] = string_length(text[p]);
    }
}

// -----------------------------
// TYPING
// -----------------------------
if (draw_char < text_length[page]) {
    draw_char += text_speed;
    draw_char = clamp(draw_char, 0, text_length[page]);
}

var _fully_typed = (floor(draw_char) >= text_length[page]);
var _options_visible = (_fully_typed && page == page_number - 1 && option_number > 0);

// -----------------------------
// INPUT — only accept clicks that aren't on an option button
// (options handle their own clicks below)
// -----------------------------
var _click_handled_by_option = false;

// -----------------------------
// DRAW: SOFT SHADOW
// -----------------------------
draw_set_alpha(0.28);
draw_set_colour(c_black);
draw_roundrect_ext(
    _box_x + 6, _box_y + 10,
    _box_x + _box_w + 6, _box_y + _box_h + 10,
    22, 22, false
);
draw_set_alpha(1);

// -----------------------------
// DRAW: MAIN BOX
//   Cream background with a warm border
// -----------------------------
var _cream     = make_colour_rgb(255, 248, 232);
var _cream_top = make_colour_rgb(255, 252, 244);
var _border    = make_colour_rgb(168, 120,  92);
var _border_hl = make_colour_rgb(222, 178, 140);

// Fill (subtle top-highlight gradient via two stacked rounded rects)
draw_set_colour(_cream);
draw_roundrect_ext(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, 22, 22, false);
draw_set_colour(_cream_top);
draw_roundrect_ext(_box_x + 4, _box_y + 4, _box_x + _box_w - 4, _box_y + 60, 18, 18, false);

// Inner/outer border stroke
draw_set_colour(_border);
draw_roundrect_ext(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, 22, 22, true);
draw_set_colour(_border_hl);
draw_roundrect_ext(_box_x + 3, _box_y + 3, _box_x + _box_w - 3, _box_y + _box_h - 3, 18, 18, true);

// Corner hearts — tiny decorative accents
var _heart_col = make_colour_rgb(240, 150, 170);
draw_set_colour(_heart_col);
var _hearts = [
    [_box_x + 16,         _box_y + 16],
    [_box_x + _box_w - 16, _box_y + 16],
    [_box_x + 16,         _box_y + _box_h - 16],
    [_box_x + _box_w - 16, _box_y + _box_h - 16],
];
for (var i = 0; i < array_length(_hearts); i++) {
    var _hx = _hearts[i][0];
    var _hy = _hearts[i][1];
    // Simple "heart" built from two circles + a triangle
    draw_circle(_hx - 2, _hy - 1, 2.2, false);
    draw_circle(_hx + 2, _hy - 1, 2.2, false);
    draw_triangle(_hx - 4, _hy, _hx + 4, _hy, _hx, _hy + 4, false);
}

// -----------------------------
// DRAW: PORTRAIT + SPEAKER PILL
// -----------------------------
var _has_portrait = (portrait[page] != -1);
var _text_x = _box_x + _pad;
var _text_y = _box_y + _pad;

if (_has_portrait) {
    var _portrait_x = _box_x + _pad;
    var _portrait_y = _box_y + (_box_h - _portrait_sz) / 2;

    // Frame behind portrait
    draw_set_colour(make_colour_rgb(240, 220, 190));
    draw_roundrect_ext(
        _portrait_x - 6, _portrait_y - 6,
        _portrait_x + _portrait_sz + 6, _portrait_y + _portrait_sz + 6,
        14, 14, false
    );
    draw_set_colour(_border);
    draw_roundrect_ext(
        _portrait_x - 6, _portrait_y - 6,
        _portrait_x + _portrait_sz + 6, _portrait_y + _portrait_sz + 6,
        14, 14, true
    );

    // Portrait sprite — scaled to fit
    var _pw = sprite_get_width(portrait[page]);
    var _ph = sprite_get_height(portrait[page]);
    var _scale = min(_portrait_sz / _pw, _portrait_sz / _ph);
    var _drawn_w = _pw * _scale;
    var _drawn_h = _ph * _scale;
    draw_sprite_ext(
        portrait[page], 0,
        _portrait_x + (_portrait_sz - _drawn_w) / 2,
        _portrait_y + (_portrait_sz - _drawn_h) / 2,
        _scale, _scale, 0, c_white, 1
    );

    _text_x = _portrait_x + _portrait_sz + _pad;
}

// Speaker name as a rounded pill ABOVE the text area
if (speaker[page] != "") {
    draw_set_font(global.font_speaker);
    var _name = speaker[page];
    var _name_w = string_width(_name);
    var _name_h = string_height(_name);
    var _pill_pad_x = 14;
    var _pill_pad_y = 6;
    var _pill_x1 = _text_x;
    var _pill_y1 = _box_y + 10;
    var _pill_x2 = _pill_x1 + _name_w + _pill_pad_x * 2;
    var _pill_y2 = _pill_y1 + _name_h + _pill_pad_y * 2;

    draw_set_colour(make_colour_rgb(255, 210, 140));
    draw_roundrect_ext(_pill_x1, _pill_y1, _pill_x2, _pill_y2, 14, 14, false);
    draw_set_colour(_border);
    draw_roundrect_ext(_pill_x1, _pill_y1, _pill_x2, _pill_y2, 14, 14, true);
    draw_set_colour(make_colour_rgb(90, 55, 30));
    draw_text(_pill_x1 + _pill_pad_x, _pill_y1 + _pill_pad_y, _name);

    _text_y = _pill_y2 + 10;
}

// -----------------------------
// DRAW: DIALOGUE TEXT
// -----------------------------
draw_set_font(global.font_dialogue);
draw_set_colour(make_colour_rgb(70, 50, 35));
var _wrap_w = (_box_x + _box_w - _pad) - _text_x;
var _line_sep = 44;
var _visible = string_copy(text[page], 1, floor(draw_char));
draw_text_ext(_text_x, _text_y, _visible, _line_sep, _wrap_w);

// -----------------------------
// DRAW: CONTINUE ARROW (when text fully shown and no options)
// -----------------------------
if (_fully_typed && option_number == 0) {
    var _bob = sin(current_time / 220) * 3;
    var _ax = _box_x + _box_w - 30;
    var _ay = _box_y + _box_h - 28 + _bob;
    draw_set_colour(make_colour_rgb(240, 150, 170));
    draw_triangle(_ax - 8, _ay - 4, _ax + 8, _ay - 4, _ax, _ay + 6, false);
    draw_set_colour(_border);
    draw_triangle(_ax - 8, _ay - 4, _ax + 8, _ay - 4, _ax, _ay + 6, true);
}

// -----------------------------
// DRAW: OPTION BUTTONS (above box)
// -----------------------------
if (_options_visible) {
    draw_set_font(global.font_option);
    var _op_h      = 72;
    var _op_gap    = 12;
    var _op_pad    = 30;
    var _op_min_w  = 300;

    var _total_h = option_number * _op_h + (option_number - 1) * _op_gap;
    var _start_y = _box_y - _total_h - 18;

    for (var op = 0; op < option_number; op++) {
        var _tw  = string_width(option[op]);
        var _o_w = max(_tw + _op_pad * 2, _op_min_w);

        var _bx1 = _box_x + (_box_w - _o_w) / 2;
        var _by1 = _start_y + op * (_op_h + _op_gap);
        var _bx2 = _bx1 + _o_w;
        var _by2 = _by1 + _op_h;

        var _hovering = (_mx > _bx1 && _mx < _bx2 && _my > _by1 && _my < _by2);

        // Shadow
        draw_set_alpha(0.25);
        draw_set_colour(c_black);
        draw_roundrect_ext(_bx1 + 3, _by1 + 5, _bx2 + 3, _by2 + 5, 18, 18, false);
        draw_set_alpha(1);

        // Button body
        var _fill = _hovering
            ? make_colour_rgb(255, 220, 150)
            : make_colour_rgb(255, 245, 220);
        draw_set_colour(_fill);
        draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 18, 18, false);
        draw_set_colour(_border);
        draw_roundrect_ext(_bx1, _by1, _bx2, _by2, 18, 18, true);
        if (_hovering) {
            draw_set_colour(_heart_col);
            draw_roundrect_ext(_bx1 + 3, _by1 + 3, _bx2 - 3, _by2 - 3, 15, 15, true);
        }

        // Label
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(make_colour_rgb(90, 55, 30));
        draw_text((_bx1 + _bx2) / 2, (_by1 + _by2) / 2, option[op]);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        if (_hovering && _accept) {
            option_pos = op;
            _click_handled_by_option = true;
            create_textbox(option_link_id[option_pos]);
            instance_destroy();
            exit;
        }
    }
}

// -----------------------------
// ADVANCE / SKIP on click (if not consumed by an option)
// -----------------------------
if (_accept && !_click_handled_by_option) {
    if (!_fully_typed) {
        draw_char = text_length[page];
    } else {
        if (page < page_number - 1) {
            page++;
            draw_char = 0;
        } else if (option_number == 0) {
            instance_destroy();
            exit;
        }
    }
}

// Reset draw state
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
