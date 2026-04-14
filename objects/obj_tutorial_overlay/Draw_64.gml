// Full-screen tutorial card — drawn in GUI space for crisp text
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// Dim background
draw_set_alpha(alpha * 0.7);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// Card panel
var _pw = 700;
var _ph = 460;
var _px1 = _cx - _pw / 2;
var _py1 = _cy - _ph / 2;
var _px2 = _cx + _pw / 2;
var _py2 = _cy + _ph / 2;

draw_set_alpha(alpha);

// Panel shadow
draw_set_colour(c_black);
draw_roundrect_ext(_px1 + 6, _py1 + 8, _px2 + 6, _py2 + 8, 22, 22, false);

// Panel fill — warm cream
draw_set_colour(make_colour_rgb(255, 248, 232));
draw_roundrect_ext(_px1, _py1, _px2, _py2, 22, 22, false);

// Border
draw_set_colour(make_colour_rgb(168, 120, 92));
draw_roundrect_ext(_px1, _py1, _px2, _py2, 22, 22, true);
draw_set_colour(make_colour_rgb(222, 178, 140));
draw_roundrect_ext(_px1 + 3, _py1 + 3, _px2 - 3, _py2 - 3, 18, 18, true);

// --- CONTENT varies by puzzle type ---
var _title = "";
var _line1 = "";
var _line2 = "";
var _line3 = "";

if (tut_type == "pushblock") {
    _title = "Push Puzzle!";
    _line1 = "Walk into a block to push it.";
    _line2 = "Push all blocks onto the glowing targets!";
    _line3 = "Press R to restart, Z to undo.";

    // --- Animated mini-level demo ---
    // 5 columns, 1 row. Maxwell walks right and pushes a block onto a target.
    var _cell  = 48;
    var _cols  = 5;
    var _grid_w = _cols * _cell;
    var _grid_x = _cx - _grid_w / 2;
    var _grid_y = _cy - 40;

    // Draw grid floor
    for (var _c = 0; _c < _cols; _c++) {
        var _gx = _grid_x + _c * _cell;
        // Alternating green tiles
        var _even = (_c mod 2 == 0);
        draw_set_colour(_even ? make_colour_rgb(120, 180, 100) : make_colour_rgb(110, 170, 90));
        draw_rectangle(_gx, _grid_y, _gx + _cell - 1, _grid_y + _cell - 1, false);
        draw_set_colour(make_colour_rgb(90, 140, 70));
        draw_rectangle(_gx, _grid_y, _gx + _cell - 1, _grid_y + _cell - 1, true);
    }

    // Draw target at column 4 (pulsing glow)
    var _tgt_x = _grid_x + 4 * _cell;
    var _tgt_pulse = 0.3 + 0.2 * sin(current_time / 350);
    var _tgt_col = demo_solved ? make_colour_rgb(100, 240, 120) : make_colour_rgb(255, 200, 100);
    draw_set_alpha(alpha * (demo_solved ? 0.6 : _tgt_pulse));
    draw_set_colour(_tgt_col);
    draw_rectangle(_tgt_x + 2, _grid_y + 2, _tgt_x + _cell - 3, _grid_y + _cell - 3, false);
    draw_set_alpha(alpha);
    // X mark on target
    draw_set_colour(c_white);
    draw_line_width(_tgt_x + 12, _grid_y + 12, _tgt_x + _cell - 12, _grid_y + _cell - 12, 2);
    draw_line_width(_tgt_x + _cell - 12, _grid_y + 12, _tgt_x + 12, _grid_y + _cell - 12, 2);

    // Draw pushblock (brown box with outline)
    var _bx = _grid_x + demo_block_col * _cell;
    var _block_col = demo_solved ? make_colour_rgb(100, 220, 100) : make_colour_rgb(160, 120, 80);
    draw_set_colour(_block_col);
    draw_rectangle(_bx + 4, _grid_y + 4, _bx + _cell - 5, _grid_y + _cell - 5, false);
    draw_set_colour(demo_solved ? make_colour_rgb(60, 180, 60) : make_colour_rgb(120, 85, 50));
    draw_rectangle(_bx + 4, _grid_y + 4, _bx + _cell - 5, _grid_y + _cell - 5, true);
    // Cross pattern on block face
    draw_set_colour(demo_solved ? make_colour_rgb(80, 200, 80) : make_colour_rgb(140, 100, 60));
    var _bmx = _bx + _cell / 2;
    var _bmy = _grid_y + _cell / 2;
    draw_line(_bx + 8, _bmy, _bx + _cell - 8, _bmy);
    draw_line(_bmx, _grid_y + 8, _bmx, _grid_y + _cell - 8);

    // Draw Maxwell (cat) at his animated position
    var _mx = _grid_x + demo_maxwell_col * _cell + _cell / 2;
    var _my = _grid_y + _cell / 2;
    // Body
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_circle(_mx, _my + 2, 14, false);
    // Head
    draw_circle(_mx, _my - 8, 10, false);
    // Ears
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_triangle(_mx - 9, _my - 14, _mx - 4, _my - 24, _mx - 1, _my - 12, false);
    draw_triangle(_mx + 9, _my - 14, _mx + 4, _my - 24, _mx + 1, _my - 12, false);
    // Inner ears (pink)
    draw_set_colour(make_colour_rgb(240, 180, 180));
    draw_triangle(_mx - 7, _my - 14, _mx - 4, _my - 21, _mx - 2, _my - 13, false);
    draw_triangle(_mx + 7, _my - 14, _mx + 4, _my - 21, _mx + 2, _my - 13, false);
    // Eyes
    draw_set_colour(c_black);
    draw_circle(_mx - 4, _my - 10, 2, false);
    draw_circle(_mx + 4, _my - 10, 2, false);
    // Eye shine
    draw_set_colour(c_white);
    draw_circle(_mx - 3, _my - 11, 1, false);
    draw_circle(_mx + 5, _my - 11, 1, false);
    // Nose
    draw_set_colour(make_colour_rgb(240, 140, 140));
    draw_triangle(_mx - 2, _my - 5, _mx + 2, _my - 5, _mx, _my - 2, false);
    // Mouth
    draw_set_colour(make_colour_rgb(180, 130, 60));
    draw_line(_mx, _my - 2, _mx - 3, _my);
    draw_line(_mx, _my - 2, _mx + 3, _my);
    // Whiskers
    draw_set_colour(make_colour_rgb(200, 160, 100));
    draw_line(_mx - 5, _my - 3, _mx - 16, _my - 6);
    draw_line(_mx - 5, _my - 2, _mx - 15, _my);
    draw_line(_mx + 5, _my - 3, _mx + 16, _my - 6);
    draw_line(_mx + 5, _my - 2, _mx + 15, _my);

    // "Maxwell" label above
    draw_set_font(global.font_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_text(_mx, _grid_y - 8, "Maxwell");

    // Solved sparkle
    if (demo_solved) {
        draw_set_font(global.font_ui);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_colour(make_colour_rgb(120, 255, 140));
        var _solve_bob = sin(current_time / 200) * 3;
        draw_text(_cx, _grid_y + _cell + 8 + _solve_bob, "Solved!");
    }
}
else if (tut_type == "memory") {
    _title = "Memory Match!";
    _line1 = "Tap a card to flip it over.";
    _line2 = "Find all the matching pairs!";
    _line3 = "Cards peek at the start — remember them!";

    // Illustration: two matched cards
    var _ix = _cx;
    var _iy = _cy - 20;
    // Card 1 (face up)
    draw_set_colour(make_colour_rgb(180, 220, 255));
    draw_roundrect_ext(_ix - 60, _iy - 24, _ix - 12, _iy + 24, 8, 8, false);
    draw_set_colour(make_colour_rgb(255, 100, 100));
    draw_circle(_ix - 36, _iy, 8, false);  // heart/star shape
    // Card 2 (face up, matching)
    draw_set_colour(make_colour_rgb(180, 220, 255));
    draw_roundrect_ext(_ix + 12, _iy - 24, _ix + 60, _iy + 24, 8, 8, false);
    draw_set_colour(make_colour_rgb(255, 100, 100));
    draw_circle(_ix + 36, _iy, 8, false);
    // Checkmark between them
    draw_set_colour(make_colour_rgb(80, 220, 100));
    draw_line_width(_ix - 4, _iy, _ix, _iy + 5, 3);
    draw_line_width(_ix, _iy + 5, _ix + 6, _iy - 5, 3);
}
else if (tut_type == "quiz") {
    _title = "Name That Animal!";
    _line1 = "Look at the picture above.";
    _line2 = "Tap the button with the right name!";
    _line3 = "Wrong? Try again — you'll get it!";

    // Illustration: simple cat face + buttons
    var _ix = _cx;
    var _iy = _cy - 25;
    // Cat head
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_circle(_ix, _iy, 16, false);
    // Ears
    draw_triangle(_ix - 14, _iy - 10, _ix - 6, _iy - 22, _ix - 2, _iy - 8, false);
    draw_triangle(_ix + 14, _iy - 10, _ix + 6, _iy - 22, _ix + 2, _iy - 8, false);
    // Eyes
    draw_set_colour(c_black);
    draw_circle(_ix - 6, _iy - 2, 2, false);
    draw_circle(_ix + 6, _iy - 2, 2, false);
    // Nose
    draw_set_colour(make_colour_rgb(240, 140, 140));
    draw_triangle(_ix - 2, _iy + 5, _ix + 2, _iy + 5, _ix, _iy + 8, false);
    // Two answer buttons below
    draw_set_colour(make_colour_rgb(200, 200, 220));
    draw_roundrect_ext(_ix - 55, _iy + 22, _ix - 5, _iy + 40, 6, 6, false);
    draw_roundrect_ext(_ix + 5, _iy + 22, _ix + 55, _iy + 40, 6, 6, false);
    // Correct one highlighted
    draw_set_colour(make_colour_rgb(80, 220, 100));
    draw_roundrect_ext(_ix - 55, _iy + 22, _ix - 5, _iy + 40, 6, 6, true);
}
else if (tut_type == "speech") {
    _title = "Say It Out Loud!";
    _line1 = "A word will appear on screen.";
    _line2 = "Tap the microphone, then say the word!";
    _line3 = "Speak clearly — any voice works!";

    // Illustration: microphone icon
    var _ix = _cx;
    var _iy = _cy - 20;
    draw_set_colour(make_colour_rgb(100, 100, 120));
    draw_roundrect_ext(_ix - 10, _iy - 20, _ix + 10, _iy + 6, 10, 10, false);
    draw_set_colour(make_colour_rgb(140, 140, 160));
    draw_roundrect_ext(_ix - 10, _iy - 20, _ix + 10, _iy + 6, 10, 10, true);
    // Stand
    draw_set_colour(make_colour_rgb(100, 100, 120));
    draw_line_width(_ix, _iy + 6, _ix, _iy + 18, 3);
    draw_line_width(_ix - 10, _iy + 18, _ix + 10, _iy + 18, 3);
    // Sound waves (small arcs as lines)
    draw_set_colour(make_colour_rgb(255, 200, 80));
    draw_set_alpha(alpha * 0.6);
    draw_line_width(_ix + 16, _iy - 14, _ix + 20, _iy - 7, 2);
    draw_line_width(_ix + 20, _iy - 7, _ix + 16, _iy, 2);
    draw_line_width(_ix + 22, _iy - 18, _ix + 28, _iy - 7, 2);
    draw_line_width(_ix + 28, _iy - 7, _ix + 22, _iy + 4, 2);
    draw_set_alpha(alpha);
}

// --- Title text ---
draw_set_font(global.font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// Shadow
draw_set_colour(make_colour_rgb(0, 0, 0));
draw_set_alpha(alpha * 0.3);
draw_text(_cx + 2, _py1 + 22, _title);
draw_set_alpha(alpha);

// Warm gold
draw_set_colour(make_colour_rgb(240, 180, 80));
draw_text(_cx, _py1 + 20, _title);

// --- Instruction lines ---
draw_set_font(global.font_dialogue);
draw_set_colour(make_colour_rgb(80, 55, 35));

var _ty = _cy + 60;
draw_text(_cx, _ty, _line1);
draw_text(_cx, _ty + 44, _line2);
draw_text(_cx, _ty + 88, _line3);

// --- "Tap to start!" prompt ---
var _blink = 0.5 + 0.5 * sin(current_time / 300);
draw_set_font(global.font_ui);
draw_set_alpha(alpha * _blink);
draw_set_colour(make_colour_rgb(200, 140, 100));
draw_text(_cx, _py2 - 50, "Tap anywhere to start!");

// Reset
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
