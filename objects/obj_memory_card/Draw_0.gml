// Skip drawing fully-matched cards (after the green glow has faded)
if (matched && match_glow <= 0) exit;

var _cx = x + card_w / 2;
var _cy = y + card_h / 2;

// Flip animation: card narrows to 0 width at midpoint, then widens showing face
var _scale_x = abs(cos(flip_timer * pi));
var _draw_w = (card_w / 2) * _scale_x;

if (_draw_w < 1) _draw_w = 1;

var _x1 = _cx - _draw_w;
var _x2 = _cx + _draw_w;
var _y1 = y;
var _y2 = y + card_h;

// Showing face or back?
var _showing_face = (flip_timer > 0.5);

if (_showing_face) {
    // === FACE SIDE — colored card with symbol ===
    var _col = card_colours[card_id % array_length(card_colours)];
    var _col_dark = merge_colour(_col, c_black, 0.3);

    // Card body
    draw_rectangle_colour(_x1, _y1, _x2, _y2, _col, _col, _col_dark, _col_dark, false);

    // Match-glow / mismatch-flash overlay
    if (match_glow > 0) {
        var _g = match_glow / 30;
        draw_set_alpha(_g * 0.6);
        draw_set_colour(make_colour_rgb(120, 255, 140));
        draw_rectangle(_x1 - 4, _y1 - 4, _x2 + 4, _y2 + 4, false);
        draw_set_alpha(1);
    } else if (miss_flash > 0) {
        var _r = miss_flash / 20;
        draw_set_alpha(_r * 0.4);
        draw_set_colour(make_colour_rgb(255, 120, 120));
        draw_rectangle(_x1, _y1, _x2, _y2, false);
        draw_set_alpha(1);
    }

    // Border
    draw_set_colour(match_glow > 0 ? make_colour_rgb(180, 255, 180) : c_white);
    draw_rectangle(_x1, _y1, _x2, _y2, true);

    // Symbol
    if (_scale_x > 0.3) {
        draw_set_font(global.font_title);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_colour(c_white);
        draw_text(_cx, _cy, card_symbols[card_id % array_length(card_symbols)]);
    }
} else {
    // === BACK SIDE — dark card with pattern ===
    var _back     = make_colour_rgb(35, 25, 60);
    var _back_dk  = make_colour_rgb(22, 15, 42);
    var _border_c = make_colour_rgb(100, 80, 150);

    // Card body
    draw_rectangle_colour(_x1, _y1, _x2, _y2, _back, _back, _back_dk, _back_dk, false);

    // Border
    draw_set_colour(_border_c);
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);

    // Center diamond pattern
    if (_scale_x > 0.3) {
        draw_set_colour(make_colour_rgb(80, 60, 120));
        draw_rectangle(_cx - 6, _cy - 8, _cx + 6, _cy + 8, true);
        draw_rectangle(_cx - 3, _cy - 5, _cx + 3, _cy + 5, true);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
