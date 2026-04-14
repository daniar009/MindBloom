var _stage = global.house_stage;
var _hx = x;
var _hy = y;

// House dimensions (128x128 sprite area, origin top-left)
var _w = 128;
var _h = 128;

// ============================================
// STAGE 0 — Empty plot, just foundation outline
// ============================================

// Ground/dirt patch (always visible)
draw_set_colour(make_colour_rgb(90, 70, 50));
draw_rectangle(_hx + 4, _hy + 100, _hx + _w - 4, _hy + _h, false);
draw_set_colour(make_colour_rgb(75, 58, 42));
draw_rectangle(_hx + 4, _hy + 100, _hx + _w - 4, _hy + _h, true);

if (_stage == 0) {
    // Foundation outline — dashed stone blocks
    draw_set_colour(make_colour_rgb(120, 120, 120));
    draw_rectangle(_hx + 10, _hy + 90, _hx + _w - 10, _hy + 100, true);

    // Corner stakes
    draw_set_colour(make_colour_rgb(160, 120, 60));
    draw_rectangle(_hx + 8, _hy + 85, _hx + 14, _hy + 102, false);
    draw_rectangle(_hx + _w - 14, _hy + 85, _hx + _w - 8, _hy + 102, false);

    // "Empty lot" sign
    draw_set_colour(make_colour_rgb(140, 100, 50));
    draw_rectangle(_hx + 50, _hy + 60, _hx + 78, _hy + 90, false);
    draw_line_width(_hx + 64, _hy + 90, _hx + 64, _hy + 100, 3);
    draw_set_font(global.font_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_hx + 64, _hy + 75, "?");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ============================================
// STAGE 1+ — Stone foundation
// ============================================
if (_stage >= 1) {
    // Solid stone foundation
    draw_set_colour(make_colour_rgb(100, 100, 105));
    draw_rectangle(_hx + 10, _hy + 90, _hx + _w - 10, _hy + 102, false);
    // Stone lines
    draw_set_colour(make_colour_rgb(80, 80, 85));
    draw_line(_hx + 10, _hy + 95, _hx + _w - 10, _hy + 95);
    draw_line(_hx + 40, _hy + 90, _hx + 40, _hy + 95);
    draw_line(_hx + 70, _hy + 95, _hx + 70, _hy + 102);
    draw_line(_hx + 90, _hy + 90, _hx + 90, _hy + 95);

    // Wooden frame beams
    draw_set_colour(make_colour_rgb(140, 100, 55));
    // Left pillar
    draw_rectangle(_hx + 12, _hy + 42, _hx + 18, _hy + 90, false);
    // Right pillar
    draw_rectangle(_hx + _w - 18, _hy + 42, _hx + _w - 12, _hy + 90, false);
    // Top beam
    draw_rectangle(_hx + 12, _hy + 40, _hx + _w - 12, _hy + 46, false);
    // Middle support
    draw_rectangle(_hx + 62, _hy + 42, _hx + 66, _hy + 90, false);

    // Cross braces
    draw_set_colour(make_colour_rgb(130, 90, 45));
    draw_line_width(_hx + 18, _hy + 42, _hx + 62, _hy + 65, 2);
    draw_line_width(_hx + 66, _hy + 42, _hx + _w - 18, _hy + 65, 2);
}

// ============================================
// STAGE 2+ — Walls filled in
// ============================================
if (_stage >= 2) {
    // Main wall fill (warm wood)
    draw_set_colour(make_colour_rgb(180, 140, 85));
    draw_rectangle(_hx + 14, _hy + 44, _hx + _w - 14, _hy + 90, false);

    // Horizontal plank lines
    draw_set_colour(make_colour_rgb(160, 120, 70));
    for (var _py = _hy + 50; _py < _hy + 90; _py += 8) {
        draw_line(_hx + 14, _py, _hx + _w - 14, _py);
    }

    // Darker trim at edges
    draw_set_colour(make_colour_rgb(120, 85, 45));
    draw_rectangle(_hx + 12, _hy + 40, _hx + _w - 12, _hy + 44, false);
    draw_rectangle(_hx + 12, _hy + 42, _hx + 16, _hy + 90, false);
    draw_rectangle(_hx + _w - 16, _hy + 42, _hx + _w - 12, _hy + 90, false);

    // Door opening (dark)
    draw_set_colour(make_colour_rgb(50, 35, 25));
    draw_rectangle(_hx + 52, _hy + 62, _hx + 76, _hy + 90, false);
    // Door frame
    draw_set_colour(make_colour_rgb(110, 75, 35));
    draw_rectangle(_hx + 52, _hy + 62, _hx + 76, _hy + 90, true);
    draw_rectangle(_hx + 51, _hy + 61, _hx + 77, _hy + 91, true);
}

// ============================================
// STAGE 3+ — Roof
// ============================================
if (_stage >= 3) {
    // Roof triangle — dark red/brown shingles
    var _roof_peak_x = _hx + _w / 2;
    var _roof_peak_y = _hy + 16;
    var _roof_left   = _hx + 4;
    var _roof_right  = _hx + _w - 4;
    var _roof_base_y = _hy + 44;

    // Main roof fill
    draw_set_colour(make_colour_rgb(140, 50, 40));
    draw_triangle(_roof_peak_x, _roof_peak_y, _roof_left, _roof_base_y, _roof_right, _roof_base_y, false);

    // Shingle lines
    draw_set_colour(make_colour_rgb(120, 40, 35));
    for (var _ry = _roof_peak_y + 6; _ry < _roof_base_y; _ry += 6) {
        // Calculate width at this y
        var _frac = (_ry - _roof_peak_y) / (_roof_base_y - _roof_peak_y);
        var _lx = lerp(_roof_peak_x, _roof_left, _frac);
        var _rx = lerp(_roof_peak_x, _roof_right, _frac);
        draw_line(_lx, _ry, _rx, _ry);
    }

    // Roof edge highlight
    draw_set_colour(make_colour_rgb(160, 60, 50));
    draw_line_width(_roof_peak_x, _roof_peak_y, _roof_left, _roof_base_y, 2);
    draw_line_width(_roof_peak_x, _roof_peak_y, _roof_right, _roof_base_y, 2);

    // Eave overhang
    draw_set_colour(make_colour_rgb(100, 70, 40));
    draw_rectangle(_hx + 2, _roof_base_y - 2, _hx + _w - 2, _roof_base_y + 2, false);
}

// ============================================
// STAGE 4 — Full house! Windows, chimney, details
// ============================================
if (_stage >= 4) {
    // Windows (2 of them)
    // Left window
    draw_set_colour(make_colour_rgb(180, 210, 240));
    draw_rectangle(_hx + 22, _hy + 52, _hx + 42, _hy + 70, false);
    draw_set_colour(make_colour_rgb(100, 70, 40));
    draw_rectangle(_hx + 22, _hy + 52, _hx + 42, _hy + 70, true);
    draw_line(_hx + 32, _hy + 52, _hx + 32, _hy + 70);
    draw_line(_hx + 22, _hy + 61, _hx + 42, _hy + 61);

    // Right window
    draw_set_colour(make_colour_rgb(180, 210, 240));
    draw_rectangle(_hx + 86, _hy + 52, _hx + 106, _hy + 70, false);
    draw_set_colour(make_colour_rgb(100, 70, 40));
    draw_rectangle(_hx + 86, _hy + 52, _hx + 106, _hy + 70, true);
    draw_line(_hx + 96, _hy + 52, _hx + 96, _hy + 70);
    draw_line(_hx + 86, _hy + 61, _hx + 106, _hy + 61);

    // Window glow (warm light from inside)
    draw_set_alpha(0.3);
    draw_set_colour(make_colour_rgb(255, 240, 180));
    draw_rectangle(_hx + 23, _hy + 53, _hx + 41, _hy + 69, false);
    draw_rectangle(_hx + 87, _hy + 53, _hx + 105, _hy + 69, false);
    draw_set_alpha(1);

    // Door — now a proper door (not just opening)
    draw_set_colour(make_colour_rgb(100, 60, 30));
    draw_rectangle(_hx + 53, _hy + 63, _hx + 75, _hy + 89, false);
    draw_set_colour(make_colour_rgb(80, 45, 20));
    draw_rectangle(_hx + 53, _hy + 63, _hx + 75, _hy + 89, true);
    // Door handle
    draw_set_colour(make_colour_rgb(200, 180, 60));
    draw_circle(_hx + 71, _hy + 77, 2, false);
    // Door panels
    draw_set_colour(make_colour_rgb(90, 52, 25));
    draw_rectangle(_hx + 56, _hy + 66, _hx + 63, _hy + 75, true);
    draw_rectangle(_hx + 66, _hy + 66, _hx + 73, _hy + 75, true);

    // Chimney
    draw_set_colour(make_colour_rgb(120, 80, 60));
    draw_rectangle(_hx + 90, _hy + 8, _hx + 104, _hy + 34, false);
    draw_set_colour(make_colour_rgb(100, 65, 45));
    draw_rectangle(_hx + 90, _hy + 8, _hx + 104, _hy + 34, true);
    // Chimney cap
    draw_set_colour(make_colour_rgb(80, 80, 85));
    draw_rectangle(_hx + 87, _hy + 6, _hx + 107, _hy + 10, false);
    // Brick lines
    draw_set_colour(make_colour_rgb(105, 68, 48));
    draw_line(_hx + 90, _hy + 16, _hx + 104, _hy + 16);
    draw_line(_hx + 90, _hy + 24, _hx + 104, _hy + 24);
    draw_line(_hx + 97, _hy + 10, _hx + 97, _hy + 16);
    draw_line(_hx + 95, _hy + 16, _hx + 95, _hy + 24);
    draw_line(_hx + 97, _hy + 24, _hx + 97, _hy + 34);

    // Smoke puffs (animated)
    var _t = current_time / 1000;
    draw_set_alpha(0.4);
    draw_set_colour(make_colour_rgb(200, 200, 210));
    draw_circle(_hx + 97 + sin(_t) * 3, _hy + 2 - (_t mod 3) * 2, 4, false);
    draw_circle(_hx + 95 + cos(_t * 1.3) * 4, _hy - 6 - (_t mod 4) * 2, 3, false);
    draw_set_alpha(1);

    // Welcome mat
    draw_set_colour(make_colour_rgb(140, 80, 50));
    draw_rectangle(_hx + 50, _hy + 91, _hx + 78, _hy + 96, false);
    draw_set_colour(make_colour_rgb(120, 65, 35));
    draw_rectangle(_hx + 50, _hy + 91, _hx + 78, _hy + 96, true);

    // Flower pot left of door
    draw_set_colour(make_colour_rgb(160, 80, 40));
    draw_rectangle(_hx + 40, _hy + 84, _hx + 50, _hy + 92, false);
    draw_set_colour(make_colour_rgb(80, 180, 60));
    draw_circle(_hx + 45, _hy + 80, 4, false);
    draw_set_colour(make_colour_rgb(255, 100, 100));
    draw_circle(_hx + 45, _hy + 79, 2, false);
}

// ============================================
// PER-PUZZLE DECORATIONS — each solved puzzle adds a personal touch
// These appear regardless of house_stage so even a half-built house
// starts feeling "lived in" as the child progresses.
// ============================================

// Puzzle 0 (Pushblock / Maxwell): cozy rug on the ground
if (global.puzzle_complete[0]) {
    draw_set_colour(make_colour_rgb(180, 60, 60));
    draw_ellipse(_hx + 20, _hy + 96, _hx + 48, _hy + 108, false);
    draw_set_colour(make_colour_rgb(200, 80, 80));
    draw_ellipse(_hx + 24, _hy + 98, _hx + 44, _hy + 106, true);
    // Diamond pattern on rug
    draw_set_colour(make_colour_rgb(220, 180, 100));
    draw_line(_hx + 30, _hy + 102, _hx + 38, _hy + 102);
    draw_line(_hx + 34, _hy + 98, _hx + 34, _hy + 106);
}

// Puzzle 1 (Memory / Mira): bird perched on the roof
if (global.puzzle_complete[1] && _stage >= 3) {
    var _bx = _hx + 36;
    var _by = _hy + 22 + sin(current_time / 600) * 1.5;
    // Body
    draw_set_colour(make_colour_rgb(100, 160, 240));
    draw_ellipse(_bx - 5, _by - 3, _bx + 5, _by + 4, false);
    // Head
    draw_circle(_bx + 4, _by - 4, 3, false);
    // Beak
    draw_set_colour(make_colour_rgb(240, 180, 50));
    draw_triangle(_bx + 7, _by - 5, _bx + 7, _by - 3, _bx + 11, _by - 4, false);
    // Eye
    draw_set_colour(c_black);
    draw_circle(_bx + 5, _by - 5, 1, false);
    // Tail feathers
    draw_set_colour(make_colour_rgb(80, 130, 200));
    draw_line_width(_bx - 5, _by, _bx - 10, _by - 2, 2);
    draw_line_width(_bx - 5, _by + 1, _bx - 9, _by + 2, 2);
}

// Puzzle 2 (Quiz / Sage): small tree next to house
if (global.puzzle_complete[2]) {
    // Trunk
    draw_set_colour(make_colour_rgb(100, 70, 40));
    draw_rectangle(_hx + _w + 6, _hy + 78, _hx + _w + 12, _hy + 100, false);
    // Canopy
    draw_set_colour(make_colour_rgb(60, 160, 60));
    draw_circle(_hx + _w + 9, _hy + 72, 14, false);
    draw_set_colour(make_colour_rgb(80, 190, 80));
    draw_circle(_hx + _w + 4, _hy + 68, 9, false);
    draw_circle(_hx + _w + 14, _hy + 68, 9, false);
    // Little apples
    draw_set_colour(make_colour_rgb(240, 80, 80));
    draw_circle(_hx + _w + 6, _hy + 76, 2, false);
    draw_circle(_hx + _w + 15, _hy + 73, 2, false);
}

// Puzzle 3 (Speech / Echo): a cat sitting on the welcome mat
if (global.puzzle_complete[3]) {
    var _cat_x = _hx + 82;
    var _cat_y = _hy + 90;
    var _cat_bob = sin(current_time / 800) * 0.5;
    // Body
    draw_set_colour(make_colour_rgb(220, 160, 70));
    draw_ellipse(_cat_x - 6, _cat_y - 4 + _cat_bob, _cat_x + 6, _cat_y + 5 + _cat_bob, false);
    // Head
    draw_circle(_cat_x, _cat_y - 7 + _cat_bob, 5, false);
    // Ears
    draw_triangle(_cat_x - 5, _cat_y - 10 + _cat_bob, _cat_x - 2, _cat_y - 15 + _cat_bob, _cat_x, _cat_y - 9 + _cat_bob, false);
    draw_triangle(_cat_x + 5, _cat_y - 10 + _cat_bob, _cat_x + 2, _cat_y - 15 + _cat_bob, _cat_x, _cat_y - 9 + _cat_bob, false);
    // Eyes
    draw_set_colour(c_black);
    draw_circle(_cat_x - 2, _cat_y - 8 + _cat_bob, 1, false);
    draw_circle(_cat_x + 2, _cat_y - 8 + _cat_bob, 1, false);
    // Tail
    draw_set_colour(make_colour_rgb(220, 160, 70));
    draw_line_width(_cat_x + 5, _cat_y + 2 + _cat_bob, _cat_x + 14, _cat_y - 4 + _cat_bob, 2);
}

// ============================================
// DAY/NIGHT AMBIENT — tint shifts with progress
// Stage 0: dawn (cool blue), 1: morning (warm), 2: bright day,
// 3: evening (orange), 4: cozy night (deep warm, lit windows)
// ============================================
var _amb_colours = [
    make_colour_rgb(100, 120, 180),  // dawn
    make_colour_rgb(255, 230, 200),  // morning
    make_colour_rgb(255, 255, 240),  // midday (barely tinted)
    make_colour_rgb(255, 180, 120),  // evening
    make_colour_rgb(40, 30, 80),     // night
];
var _amb_alphas = [0.18, 0.08, 0.02, 0.15, 0.25];
var _idx = clamp(_stage, 0, 4);
draw_set_alpha(_amb_alphas[_idx]);
draw_set_colour(_amb_colours[_idx]);
draw_rectangle(_hx - 20, _hy - 20, _hx + _w + 20, _hy + _h + 20, false);
draw_set_alpha(1);

// Night stars (stage 4 only)
if (_stage >= 4) {
    draw_set_alpha(0.6);
    draw_set_colour(c_white);
    var _st = current_time / 2000;
    for (var _s = 0; _s < 8; _s++) {
        var _sx = _hx - 10 + (_s * 19) mod (_w + 30);
        var _sy = _hy - 20 + (_s * 13) mod 30;
        var _twinkle = 0.4 + 0.6 * abs(sin(_st + _s * 1.3));
        draw_set_alpha(_twinkle * 0.5);
        draw_circle(_sx, _sy, 1, false);
    }
    draw_set_alpha(1);
}

// ============================================
// PROGRESS LABEL (shows stage under house)
// ============================================
draw_set_font(global.font_main);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

if (_stage < 4) {
    var _label = tr_num("house_puzzles", _stage);
    // Dark outline for contrast on grass
    draw_set_colour(make_colour_rgb(40, 30, 20));
    draw_text(_hx + _w / 2 + 1, _hy + _h + 5, _label);
    // Warm cream fill — readable on green
    draw_set_colour(make_colour_rgb(255, 240, 200));
    draw_text(_hx + _w / 2, _hy + _h + 4, _label);
} else {
    var _label = tr("house_done");
    draw_set_colour(make_colour_rgb(40, 30, 20));
    draw_text(_hx + _w / 2 + 1, _hy + _h + 5, _label);
    draw_set_colour(make_colour_rgb(255, 220, 80));
    draw_text(_hx + _w / 2, _hy + _h + 4, _label);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
