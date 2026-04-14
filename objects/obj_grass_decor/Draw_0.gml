// Palette
var _col_grass_dark  = make_colour_rgb( 70, 140,  70);
var _col_grass_light = make_colour_rgb(130, 200, 100);
var _col_clover      = make_colour_rgb( 95, 180,  95);
var _col_stone       = make_colour_rgb(170, 170, 160);
var _col_stone_hl    = make_colour_rgb(210, 210, 200);
var _col_leaf        = make_colour_rgb(200, 140,  80);
var _col_mush_cap    = make_colour_rgb(220,  80,  80);
var _col_mush_stem   = make_colour_rgb(250, 240, 220);

var _flower_petals = [
    make_colour_rgb(255, 255, 255),  // white
    make_colour_rgb(255, 230, 120),  // yellow
    make_colour_rgb(255, 170, 200),  // pink
    make_colour_rgb(200, 180, 255),  // lilac
];
var _flower_center = make_colour_rgb(255, 210, 80);

// --- SCATTERED DECOR ---
for (var i = 0; i < array_length(decor); i++) {
    var _d = decor[i];
    var _k = _d[0];
    var _x = _d[1];
    var _y = _d[2];
    var _v = _d[3];
    var _p = _d[4];

    // Gentle per-decor sway
    var _sway = sin(breeze_t + _p) * 0.6;

    switch (_k) {
        case 0: // flower — 5 petals around a center
            var _pc = _flower_petals[_v mod array_length(_flower_petals)];
            // stem
            draw_set_colour(_col_grass_dark);
            draw_line_width(_x, _y + 4, _x + _sway, _y - 2, 2);
            // petals
            draw_set_colour(_pc);
            var _cx = _x + _sway;
            var _cy = _y - 3;
            for (var a = 0; a < 5; a++) {
                var _ang = a * (2 * pi / 5);
                draw_circle(_cx + cos(_ang) * 2.5, _cy + sin(_ang) * 2.5, 1.8, false);
            }
            // center
            draw_set_colour(_flower_center);
            draw_circle(_cx, _cy, 1.3, false);
        break;

        case 1: // clover — 3 small green circles
            draw_set_colour(_col_clover);
            var _cx = _x + _sway * 0.3;
            var _cy = _y;
            draw_circle(_cx - 2,     _cy - 1, 2, false);
            draw_circle(_cx + 2,     _cy - 1, 2, false);
            draw_circle(_cx,         _cy + 2, 2, false);
            // little highlight
            draw_set_colour(make_colour_rgb(160, 220, 140));
            draw_circle(_cx - 2.5, _cy - 1.5, 0.8, false);
        break;

        case 2: // pebble — oval with highlight
            draw_set_colour(_col_stone);
            draw_ellipse(_x - 3, _y - 1, _x + 3, _y + 1, false);
            draw_set_colour(_col_stone_hl);
            draw_ellipse(_x - 2, _y - 1, _x, _y, false);
        break;

        case 3: // mushroom — red cap + white stem + 1-2 dots
            draw_set_colour(_col_mush_stem);
            draw_rectangle(_x - 1, _y - 1, _x + 1, _y + 2, false);
            draw_set_colour(_col_mush_cap);
            draw_ellipse(_x - 4, _y - 4, _x + 4, _y, false);
            draw_set_colour(c_white);
            draw_circle(_x - 1.5, _y - 2, 0.7, false);
            draw_circle(_x + 1.5, _y - 3, 0.7, false);
        break;

        case 4: // grass tuft — 3 little blades that sway together
            draw_set_colour(_col_grass_dark);
            draw_line_width(_x - 2, _y + 2, _x - 2 + _sway, _y - 3, 1);
            draw_line_width(_x,     _y + 2, _x     + _sway, _y - 4, 1);
            draw_line_width(_x + 2, _y + 2, _x + 2 + _sway, _y - 3, 1);
            draw_set_colour(_col_grass_light);
            draw_line_width(_x,     _y + 2, _x     + _sway, _y - 2, 1);
        break;

        case 5: // leaf — tilted oval in autumn tone
            draw_set_colour(_col_leaf);
            var _lx = _x + _sway * 0.4;
            draw_ellipse(_lx - 3, _y - 1, _lx + 3, _y + 1, false);
            draw_set_colour(make_colour_rgb(240, 180, 120));
            draw_line(_lx - 2, _y, _lx + 2, _y);
        break;

        case 6: // grass fuzz — tiny fleck to add ground texture
            // Variant picks between a darker speck, a lighter speck, or
            // a short vertical blade so the texture doesn't look uniform.
            draw_set_alpha(0.55);
            if (_v == 0) {
                draw_set_colour(make_colour_rgb( 60, 120,  60));
                draw_rectangle(_x, _y, _x + 1, _y + 1, false);
            } else if (_v == 1) {
                draw_set_colour(make_colour_rgb(150, 210, 120));
                draw_rectangle(_x, _y, _x + 1, _y, false);
            } else if (_v == 2) {
                draw_set_colour(make_colour_rgb( 90, 160,  80));
                draw_line(_x, _y, _x, _y - 2);
            } else {
                draw_set_colour(make_colour_rgb(170, 220, 140));
                draw_rectangle(_x, _y, _x, _y, false);
            }
            draw_set_alpha(1);
        break;
    }
}

// --- BUTTERFLIES ---
for (var i = 0; i < array_length(butterflies); i++) {
    var _b = butterflies[i];
    var _wing = 0.6 + abs(sin(_b.wing_t)) * 0.8;  // 0.6 → 1.4 scale

    // Soft shadow on the ground
    draw_set_alpha(0.18);
    draw_set_colour(c_black);
    draw_ellipse(_b.x - 4, _b.y + 6, _b.x + 4, _b.y + 8, false);
    draw_set_alpha(1);

    // Wings
    draw_set_colour(_b.colour);
    draw_ellipse(_b.x - 4 * _wing, _b.y - 3, _b.x - 1, _b.y + 2, false);
    draw_ellipse(_b.x + 1, _b.y - 3, _b.x + 4 * _wing, _b.y + 2, false);

    // Body
    draw_set_colour(make_colour_rgb(60, 45, 30));
    draw_line_width(_b.x, _b.y - 2, _b.x, _b.y + 2, 1);
}

// Reset state so nothing else inherits our colour/alpha
draw_set_alpha(1);
draw_set_colour(c_white);
