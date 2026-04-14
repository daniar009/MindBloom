// HUD drawn in GUI space at native resolution — crisp, no camera blur
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// ===================================================
// TUTORIAL OVERLAY — Maxwell demo (draws over everything)
// ===================================================
if (tutorial_active) {
    var _cx = _gw / 2;
    var _cy = _gh / 2;
    var _a  = tut_alpha;

    // Dim background
    draw_set_alpha(_a * 0.7);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);

    // Card panel
    var _pw = 700;
    var _ph = 460;
    var _px1 = _cx - _pw / 2;
    var _py1 = _cy - _ph / 2;
    var _px2 = _cx + _pw / 2;
    var _py2 = _cy + _ph / 2;

    draw_set_alpha(_a);

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

    // --- Title ---
    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _tut_title = tr("tut_title");
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_set_alpha(_a * 0.3);
    draw_text(_cx + 2, _py1 + 22, _tut_title);
    draw_set_alpha(_a);
    draw_set_colour(make_colour_rgb(240, 180, 80));
    draw_text(_cx, _py1 + 20, _tut_title);

    // --- Animated mini-level ---
    var _cell  = 48;
    var _cols  = 5;
    var _grid_w = _cols * _cell;
    var _grid_x = _cx - _grid_w / 2;
    var _grid_y = _cy - 40;

    // Grid floor tiles
    for (var _c = 0; _c < _cols; _c++) {
        var _gx = _grid_x + _c * _cell;
        draw_set_colour((_c mod 2 == 0) ? make_colour_rgb(120, 180, 100) : make_colour_rgb(110, 170, 90));
        draw_rectangle(_gx, _grid_y, _gx + _cell - 1, _grid_y + _cell - 1, false);
        draw_set_colour(make_colour_rgb(90, 140, 70));
        draw_rectangle(_gx, _grid_y, _gx + _cell - 1, _grid_y + _cell - 1, true);
    }

    // Target at column 4
    var _tgt_x = _grid_x + 4 * _cell;
    var _tgt_pulse = 0.3 + 0.2 * sin(current_time / 350);
    draw_set_alpha(_a * (tut_solved ? 0.6 : _tgt_pulse));
    draw_set_colour(tut_solved ? make_colour_rgb(100, 240, 120) : make_colour_rgb(255, 200, 100));
    draw_rectangle(_tgt_x + 2, _grid_y + 2, _tgt_x + _cell - 3, _grid_y + _cell - 3, false);
    draw_set_alpha(_a);
    draw_set_colour(c_white);
    draw_line_width(_tgt_x + 12, _grid_y + 12, _tgt_x + _cell - 12, _grid_y + _cell - 12, 2);
    draw_line_width(_tgt_x + _cell - 12, _grid_y + 12, _tgt_x + 12, _grid_y + _cell - 12, 2);

    // Pushblock
    var _bx = _grid_x + tut_block_col * _cell;
    draw_set_colour(tut_solved ? make_colour_rgb(100, 220, 100) : make_colour_rgb(160, 120, 80));
    draw_rectangle(_bx + 4, _grid_y + 4, _bx + _cell - 5, _grid_y + _cell - 5, false);
    draw_set_colour(tut_solved ? make_colour_rgb(60, 180, 60) : make_colour_rgb(120, 85, 50));
    draw_rectangle(_bx + 4, _grid_y + 4, _bx + _cell - 5, _grid_y + _cell - 5, true);
    var _bmx = _bx + _cell / 2;
    var _bmy = _grid_y + _cell / 2;
    draw_set_colour(tut_solved ? make_colour_rgb(80, 200, 80) : make_colour_rgb(140, 100, 60));
    draw_line(_bx + 8, _bmy, _bx + _cell - 8, _bmy);
    draw_line(_bmx, _grid_y + 8, _bmx, _grid_y + _cell - 8);

    // Maxwell (cat)
    var _mx = _grid_x + tut_cat_col * _cell + _cell / 2;
    var _my = _grid_y + _cell / 2;
    // Body
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_circle(_mx, _my + 2, 14, false);
    // Head
    draw_circle(_mx, _my - 8, 10, false);
    // Ears
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
    // Whiskers
    draw_set_colour(make_colour_rgb(200, 160, 100));
    draw_line(_mx - 5, _my - 3, _mx - 16, _my - 6);
    draw_line(_mx - 5, _my - 2, _mx - 15, _my);
    draw_line(_mx + 5, _my - 3, _mx + 16, _my - 6);
    draw_line(_mx + 5, _my - 2, _mx + 15, _my);

    // "Maxwell" label — uses the translated character name
    draw_set_font(global.font_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(make_colour_rgb(220, 170, 80));
    draw_text(_mx, _grid_y - 8, tr("name_maxwell"));

    // Solved text
    if (tut_solved) {
        draw_set_font(global.font_ui);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_colour(make_colour_rgb(120, 255, 140));
        var _bob = sin(current_time / 200) * 3;
        draw_text(_cx, _grid_y + _cell + 8 + _bob, tr("tut_solved"));
    }

    // --- Instructions ---
    draw_set_font(global.font_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(make_colour_rgb(80, 55, 35));
    draw_text(_cx, _cy + 70,  tr("tut_line1"));
    draw_text(_cx, _cy + 114, tr("tut_line2"));
    draw_text(_cx, _cy + 158, tr("tut_line3"));

    // --- "Tap to start" ---
    var _blink = 0.5 + 0.5 * sin(current_time / 300);
    draw_set_font(global.font_ui);
    draw_set_alpha(_a * _blink);
    draw_set_colour(make_colour_rgb(200, 140, 100));
    draw_text(_cx, _py2 - 50, tr("tut_start"));

    // Reset and skip normal HUD
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// --- Top-left: level + moves + best (smaller font, outlined for visibility) ---
draw_set_font(global.font_main);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Shadow pass for all top-left text
var _lvl_txt   = tr_num("hud_level", level_num);
var _moves_txt = tr_num("hud_moves", move_count);

draw_set_colour(make_colour_rgb(0, 0, 0));
draw_set_alpha(0.5);
draw_text(21, 19, _lvl_txt);
draw_text(21, 39, _moves_txt);
draw_set_alpha(1);

// Bright fills
draw_set_colour(make_colour_rgb(255, 240, 180));
draw_text(20, 18, _lvl_txt);

draw_set_colour(make_colour_rgb(140, 255, 160));
draw_text(20, 38, _moves_txt);

var _best = global.pushblock_best[level_num - 1];
if (_best > 0) {
    var _best_txt = tr_num("hud_best", _best);
    draw_set_colour(c_black);
    draw_set_alpha(0.5);
    draw_text(21, 59, _best_txt);
    draw_set_alpha(1);
    draw_set_colour(make_colour_rgb(180, 200, 255));
    draw_text(20, 58, _best_txt);
}

// --- Hints (right side, below the pause button — smaller) ---
draw_set_halign(fa_right);

var _restart_txt = tr("hud_restart");
draw_set_colour(c_black);
draw_set_alpha(0.5);
draw_text(_gw - 19, 79, _restart_txt);
draw_set_alpha(1);
draw_set_colour(make_colour_rgb(220, 210, 240));
draw_text(_gw - 20, 78, _restart_txt);

if (has_undo) {
    var _undo_txt = tr("hud_undo");
    draw_set_colour(c_black);
    draw_set_alpha(0.5);
    draw_text(_gw - 19, 99, _undo_txt);
    draw_set_alpha(1);
    draw_set_colour(make_colour_rgb(255, 240, 160));
    draw_text(_gw - 20, 98, _undo_txt);
}

// --- Stuck hint after long inactivity ---
if (!solved && idle_timer > stuck_hint_after) {
    var _pulse = 0.6 + 0.4 * (sin(current_time / 300) * 0.5 + 0.5);
    draw_set_halign(fa_center);
    draw_set_alpha(_pulse);
    draw_set_colour(make_colour_rgb(255, 220, 140));
    draw_text(_gw / 2, 80, tr("hud_stuck"));
    draw_set_alpha(1);
}

// --- Solved overlay ---
if (solved) {
    draw_set_alpha(0.55);
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_rectangle(0, _gh / 2 - 90, _gw, _gh / 2 + 90, false);
    draw_set_alpha(1);

    draw_set_font(global.font_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _cx = _gw / 2;
    var _cy = _gh / 2 - 20;
    var _solved_txt = tr("hud_solved");
    draw_set_colour(make_colour_rgb(0, 0, 0));
    draw_text(_cx + 3, _cy + 3, _solved_txt);
    draw_set_colour(make_colour_rgb(120, 255, 140));
    draw_text(_cx, _cy, _solved_txt);

    draw_set_font(global.font_ui);
    draw_set_colour(c_white);
    var _line = tr_num("hud_moves_line", move_count);
    if (_best > 0 && move_count > _best) {
        _line += "  " + tr_num("hud_best_suffix", _best);
    } else if (_best > 0 && move_count == _best) {
        _line += "  " + tr("hud_new_best");
    }
    draw_text(_cx, _cy + 50, _line);
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
