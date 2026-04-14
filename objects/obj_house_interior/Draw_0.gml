// Room-space drawing: walls, furniture, and all the cozy bric-a-brac.
// Coordinates are chosen for a 640x384 room. Player walks around freely
// inside the bounded area set up by RoomCreationCode.

// ===========================================
// BACKGROUND — warm ambient behind everything
// ===========================================
draw_set_colour(make_colour_rgb(50, 35, 30));
draw_rectangle(0, 0, 640, 384, false);

// ===========================================
// WOODEN FLOOR — plank stripes across the room
// ===========================================
var _floor_top = 80;
var _floor_bottom = 352;

// Base wood tone
draw_set_colour(make_colour_rgb(170, 120, 75));
draw_rectangle(32, _floor_top, 608, _floor_bottom, false);

// Plank seams (horizontal bands)
draw_set_colour(make_colour_rgb(140, 95, 55));
for (var _py = _floor_top + 24; _py < _floor_bottom; _py += 24) {
    draw_line(32, _py, 608, _py);
}
// Plank joints (staggered vertical ticks)
for (var _py = _floor_top + 12; _py < _floor_bottom; _py += 24) {
    var _joint_x = 80 + ((_py * 3) mod 128);
    draw_line(_joint_x, _py - 12, _joint_x, _py + 12);
}

// ===========================================
// WALLS — striped wallpaper with a chair rail
// ===========================================
// Top wall
draw_set_colour(make_colour_rgb(220, 200, 160));
draw_rectangle(0, 0, 640, _floor_top, false);
// Wallpaper stripes
draw_set_colour(make_colour_rgb(200, 175, 130));
for (var _sx = 0; _sx < 640; _sx += 16) {
    draw_line(_sx, 0, _sx, _floor_top);
}
// Chair rail
draw_set_colour(make_colour_rgb(120, 80, 50));
draw_rectangle(0, _floor_top - 4, 640, _floor_top, false);
draw_set_colour(make_colour_rgb(160, 115, 70));
draw_line(0, _floor_top - 6, 640, _floor_top - 6);

// Side walls (thin strips so the room feels enclosed)
draw_set_colour(make_colour_rgb(200, 175, 130));
draw_rectangle(0, _floor_top, 32, _floor_bottom, false);
draw_rectangle(608, _floor_top, 640, _floor_bottom, false);
// Baseboard
draw_set_colour(make_colour_rgb(110, 75, 45));
draw_rectangle(0, _floor_bottom - 4, 640, _floor_bottom, false);
// South wall (below floor)
draw_set_colour(make_colour_rgb(200, 175, 130));
draw_rectangle(0, _floor_bottom, 640, 384, false);

// ===========================================
// FIREPLACE — top-center, with crackling flames
// ===========================================
var _fx = 288;
var _fy1 = 8;
var _fy2 = 88;
var _fx2 = 352;

// Brick mantle backing
draw_set_colour(make_colour_rgb(140, 90, 70));
draw_rectangle(_fx - 12, _fy1, _fx2 + 12, _fy2, false);
// Brick lines
draw_set_colour(make_colour_rgb(110, 65, 50));
for (var _by = _fy1 + 8; _by < _fy2; _by += 10) {
    draw_line(_fx - 12, _by, _fx2 + 12, _by);
}
for (var _bx = _fx; _bx < _fx2; _bx += 14) {
    draw_line(_bx, _fy1 + 8, _bx, _fy2);
}
// Mantle shelf
draw_set_colour(make_colour_rgb(100, 60, 35));
draw_rectangle(_fx - 18, _fy2, _fx2 + 18, _fy2 + 6, false);

// Hearth opening
draw_set_colour(make_colour_rgb(25, 15, 10));
draw_rectangle(_fx, _fy1 + 16, _fx2, _fy2, false);

// Logs
draw_set_colour(make_colour_rgb(90, 55, 35));
draw_rectangle(_fx + 4, _fy2 - 16, _fx2 - 4, _fy2 - 8, false);
draw_set_colour(make_colour_rgb(70, 40, 25));
draw_line(_fx + 8, _fy2 - 12, _fx2 - 8, _fy2 - 12);

// Flames (flickering)
var _t = current_time / 120;
draw_set_alpha(0.9);
draw_set_colour(make_colour_rgb(240, 140, 40));
var _flame_h1 = 18 + sin(_t) * 3;
var _flame_h2 = 14 + sin(_t * 1.4 + 1.2) * 3;
var _flame_h3 = 16 + sin(_t * 1.1 + 2.3) * 3;
draw_triangle(_fx + 10, _fy2 - 8,  _fx + 14, _fy2 - 8 - _flame_h1, _fx + 20, _fy2 - 8,  false);
draw_triangle(_fx + 22, _fy2 - 8,  _fx + 28, _fy2 - 8 - _flame_h2, _fx + 36, _fy2 - 8,  false);
draw_triangle(_fx + 36, _fy2 - 8,  _fx + 44, _fy2 - 8 - _flame_h3, _fx + 54, _fy2 - 8,  false);
draw_set_colour(make_colour_rgb(255, 210, 80));
draw_triangle(_fx + 14, _fy2 - 8,  _fx + 17, _fy2 - 8 - _flame_h1 * 0.6, _fx + 22, _fy2 - 8,  false);
draw_triangle(_fx + 28, _fy2 - 8,  _fx + 32, _fy2 - 8 - _flame_h2 * 0.6, _fx + 36, _fy2 - 8,  false);
draw_set_alpha(1);

// Sparks
for (var _i = 0; _i < array_length(sparks); _i++) {
    var _s = sparks[_i];
    var _frac = _s.life / _s.max_life;
    draw_set_alpha(clamp(_frac, 0, 0.8));
    draw_set_colour(make_colour_rgb(255, 220, 120));
    draw_circle(_s.x, _s.y, 1.2, false);
}
draw_set_alpha(1);

// Warm floor glow in front of hearth
draw_set_alpha(0.25);
draw_set_colour(make_colour_rgb(255, 180, 80));
draw_ellipse(_fx - 30, _fy2 + 4, _fx2 + 30, _fy2 + 40, false);
draw_set_alpha(1);

// ===========================================
// BOOKSHELF (LEFT WALL) — Sage's little library
// ===========================================
var _bs_x1 = 36;
var _bs_x2 = 96;
var _bs_y1 = 96;
var _bs_y2 = 224;

// Wooden shelf body
draw_set_colour(make_colour_rgb(110, 75, 45));
draw_rectangle(_bs_x1, _bs_y1, _bs_x2, _bs_y2, false);
// Shelves (horizontal)
draw_set_colour(make_colour_rgb(85, 55, 30));
draw_rectangle(_bs_x1, _bs_y1 + 34, _bs_x2, _bs_y1 + 38, false);
draw_rectangle(_bs_x1, _bs_y1 + 70, _bs_x2, _bs_y1 + 74, false);
draw_rectangle(_bs_x1, _bs_y1 + 106, _bs_x2, _bs_y1 + 110, false);

// Books — varied colours and heights
var _book_colors = [
    make_colour_rgb(180, 60, 50),
    make_colour_rgb(60, 120, 180),
    make_colour_rgb(80, 160, 80),
    make_colour_rgb(220, 180, 60),
    make_colour_rgb(160, 80, 180),
    make_colour_rgb(200, 120, 60),
    make_colour_rgb(120, 180, 200),
];
for (var _r = 0; _r < 3; _r++) {
    var _row_y = _bs_y1 + 4 + _r * 36;
    var _bx = _bs_x1 + 4;
    while (_bx < _bs_x2 - 6) {
        var _bw = 4 + ((_bx + _r * 7) mod 5);
        var _bh = 24 + (((_bx * 3) + _r) mod 6);
        draw_set_colour(_book_colors[((_bx + _r) mod array_length(_book_colors))]);
        draw_rectangle(_bx, _row_y + (28 - _bh), _bx + _bw, _row_y + 28, false);
        // Spine highlight
        draw_set_colour(make_colour_rgb(255, 255, 255));
        draw_set_alpha(0.15);
        draw_line(_bx, _row_y + (28 - _bh), _bx, _row_y + 28);
        draw_set_alpha(1);
        _bx += _bw + 1;
    }
}

// ===========================================
// FRAMED PHOTOS (LEFT WALL, LOWER) — the four friends
// ===========================================
// Two rows of two small 24x24 portraits
var _photo_specs = [
    [48,  240, make_colour_rgb(220, 170, 80),  "M"],  // Maxwell — yellow cat
    [78,  240, make_colour_rgb(180, 220, 240), "I"],  // Mira — sky blue
    [48,  272, make_colour_rgb(200, 160, 230), "S"],  // Sage — purple
    [78,  272, make_colour_rgb(255, 200, 130), "E"],  // Echo — warm peach
];
for (var _p = 0; _p < array_length(_photo_specs); _p++) {
    var _pxp = _photo_specs[_p][0];
    var _pyp = _photo_specs[_p][1];
    var _pcc = _photo_specs[_p][2];
    // Frame
    draw_set_colour(make_colour_rgb(100, 65, 35));
    draw_rectangle(_pxp, _pyp, _pxp + 22, _pyp + 22, false);
    // Portrait fill
    draw_set_colour(_pcc);
    draw_rectangle(_pxp + 2, _pyp + 2, _pxp + 20, _pyp + 20, false);
    // Tiny face (just eyes)
    draw_set_colour(c_black);
    draw_rectangle(_pxp + 7, _pyp + 10, _pxp + 9, _pyp + 12, false);
    draw_rectangle(_pxp + 13, _pyp + 10, _pxp + 15, _pyp + 12, false);
    // Smile
    draw_line(_pxp + 8, _pyp + 16, _pxp + 14, _pyp + 16);
}

// ===========================================
// WINDOW (RIGHT WALL, UPPER) — peaceful view
// ===========================================
var _wn_x1 = 544;
var _wn_y1 = 96;
var _wn_x2 = 608;
var _wn_y2 = 184;

// Sky
draw_set_colour(make_colour_rgb(140, 190, 230));
draw_rectangle(_wn_x1, _wn_y1, _wn_x2, _wn_y2, false);
// Sun
draw_set_colour(make_colour_rgb(255, 230, 150));
draw_circle(_wn_x1 + 18, _wn_y1 + 16, 6, false);
// Rolling hills
draw_set_colour(make_colour_rgb(120, 180, 100));
draw_rectangle(_wn_x1, _wn_y1 + 48, _wn_x2, _wn_y2, false);
// Hill bumps
draw_set_colour(make_colour_rgb(100, 160, 80));
draw_circle(_wn_x1 + 14, _wn_y1 + 50, 10, false);
draw_circle(_wn_x1 + 42, _wn_y1 + 52, 12, false);
// Tiny tree
draw_set_colour(make_colour_rgb(90, 60, 35));
draw_rectangle(_wn_x1 + 30, _wn_y1 + 58, _wn_x1 + 32, _wn_y1 + 66, false);
draw_set_colour(make_colour_rgb(60, 140, 60));
draw_circle(_wn_x1 + 31, _wn_y1 + 58, 4, false);

// Window frame + cross
draw_set_colour(make_colour_rgb(100, 65, 35));
draw_rectangle(_wn_x1 - 3, _wn_y1 - 3, _wn_x2 + 3, _wn_y1, false);
draw_rectangle(_wn_x1 - 3, _wn_y2, _wn_x2 + 3, _wn_y2 + 3, false);
draw_rectangle(_wn_x1 - 3, _wn_y1, _wn_x1, _wn_y2, false);
draw_rectangle(_wn_x2, _wn_y1, _wn_x2 + 3, _wn_y2, false);
draw_line_width((_wn_x1 + _wn_x2) / 2, _wn_y1, (_wn_x1 + _wn_x2) / 2, _wn_y2, 2);
draw_line_width(_wn_x1, (_wn_y1 + _wn_y2) / 2, _wn_x2, (_wn_y1 + _wn_y2) / 2, 2);

// Curtains
draw_set_colour(make_colour_rgb(180, 80, 80));
draw_rectangle(_wn_x1 - 8, _wn_y1 - 4, _wn_x1 + 4, _wn_y2 + 2, false);
draw_rectangle(_wn_x2 - 4, _wn_y1 - 4, _wn_x2 + 8, _wn_y2 + 2, false);
// Curtain folds
draw_set_colour(make_colour_rgb(150, 60, 60));
draw_line(_wn_x1 - 4, _wn_y1 - 4, _wn_x1 - 4, _wn_y2 + 2);
draw_line(_wn_x2 + 4, _wn_y1 - 4, _wn_x2 + 4, _wn_y2 + 2);

// ===========================================
// RIGHT SHELF — Mira's feather + Echo's bell
// ===========================================
var _rs_x1 = 520;
var _rs_x2 = 608;

// Shelf (feather)
draw_set_colour(make_colour_rgb(110, 75, 45));
draw_rectangle(_rs_x1, 208, _rs_x2, 214, false);
// Feather (Mira's trophy)
var _fex = _rs_x1 + 40;
var _fey = 206;
draw_set_colour(make_colour_rgb(100, 160, 240));
draw_ellipse(_fex - 3, _fey - 16, _fex + 3, _fey + 2, false);
draw_set_colour(make_colour_rgb(80, 130, 210));
draw_line_width(_fex, _fey - 16, _fex, _fey + 4, 2);
// Feather label tag
draw_set_colour(make_colour_rgb(255, 250, 220));
draw_rectangle(_fex - 10, _fey + 4, _fex + 10, _fey + 8, false);

// Shelf (bell)
draw_set_colour(make_colour_rgb(110, 75, 45));
draw_rectangle(_rs_x1, 248, _rs_x2, 254, false);
// Bell (Echo's trophy)
var _blx = _rs_x1 + 40;
var _bly = 244;
draw_set_colour(make_colour_rgb(230, 190, 80));
draw_rectangle(_blx - 6, _bly - 8, _blx + 6, _bly, false);
draw_triangle(_blx - 6, _bly - 8, _blx + 6, _bly - 8, _blx, _bly - 16, false);
draw_set_colour(make_colour_rgb(180, 140, 50));
draw_circle(_blx, _bly + 2, 2, false);
// Bell shine
draw_set_colour(make_colour_rgb(255, 230, 150));
draw_line(_blx - 3, _bly - 6, _blx - 3, _bly - 2);

// ===========================================
// RUG + MAXWELL (center floor) — pushblock callback
// ===========================================
var _rg_cx = 320;
var _rg_cy = 224;
// Big round rug
draw_set_colour(make_colour_rgb(180, 60, 60));
draw_ellipse(_rg_cx - 72, _rg_cy - 40, _rg_cx + 72, _rg_cy + 40, false);
draw_set_colour(make_colour_rgb(220, 180, 90));
draw_ellipse(_rg_cx - 64, _rg_cy - 34, _rg_cx + 64, _rg_cy + 34, true);
draw_set_colour(make_colour_rgb(200, 80, 80));
draw_ellipse(_rg_cx - 40, _rg_cy - 22, _rg_cx + 40, _rg_cy + 22, true);
// Rug diamond
draw_set_colour(make_colour_rgb(240, 210, 120));
draw_line(_rg_cx - 24, _rg_cy, _rg_cx, _rg_cy - 12);
draw_line(_rg_cx,      _rg_cy - 12, _rg_cx + 24, _rg_cy);
draw_line(_rg_cx + 24, _rg_cy, _rg_cx, _rg_cy + 12);
draw_line(_rg_cx,      _rg_cy + 12, _rg_cx - 24, _rg_cy);

// Wandering Maxwell the cat
var _mx = cat_x;
var _my = cat_y;
var _facing = cat_facing;
// Shadow
draw_set_alpha(0.25);
draw_set_colour(c_black);
draw_ellipse(_mx - 10, _my + 6, _mx + 10, _my + 10, false);
draw_set_alpha(1);
// Body
draw_set_colour(make_colour_rgb(220, 170, 80));
draw_ellipse(_mx - 10, _my - 2, _mx + 10, _my + 8, false);
// Head
draw_circle(_mx + _facing * 7, _my - 6, 7, false);
// Ears
draw_triangle(_mx + _facing * 3,  _my - 11, _mx + _facing * 6,  _my - 17, _mx + _facing * 8,  _my - 10, false);
draw_triangle(_mx + _facing * 11, _my - 11, _mx + _facing * 9,  _my - 17, _mx + _facing * 13, _my - 10, false);
// Inner ears
draw_set_colour(make_colour_rgb(240, 180, 180));
draw_triangle(_mx + _facing * 4,  _my - 11, _mx + _facing * 6,  _my - 15, _mx + _facing * 8,  _my - 10, false);
// Eyes (closed, contented)
draw_set_colour(c_black);
draw_line(_mx + _facing * 5, _my - 6, _mx + _facing * 7, _my - 6);
draw_line(_mx + _facing * 9, _my - 6, _mx + _facing * 11, _my - 6);
// Nose
draw_set_colour(make_colour_rgb(240, 140, 140));
draw_circle(_mx + _facing * 8, _my - 4, 1, false);
// Tail (wagging)
draw_set_colour(make_colour_rgb(220, 170, 80));
var _tail_wag = sin(current_time / 300) * 3;
draw_line_width(_mx - _facing * 8, _my + 2, _mx - _facing * 16, _my - 2 + _tail_wag, 3);

// ===========================================
// SOFA + COFFEE TABLE (lower left) — cozy spot
// ===========================================
var _so_x1 = 128;
var _so_x2 = 240;
var _so_y1 = 240;
var _so_y2 = 288;

// Sofa base
draw_set_colour(make_colour_rgb(90, 120, 150));
draw_rectangle(_so_x1, _so_y1 + 16, _so_x2, _so_y2, false);
// Cushions
draw_set_colour(make_colour_rgb(120, 150, 180));
draw_rectangle(_so_x1 + 4, _so_y1 + 18, _so_x1 + 54, _so_y2 - 4, false);
draw_rectangle(_so_x1 + 58, _so_y1 + 18, _so_x2 - 4, _so_y2 - 4, false);
// Backrest
draw_set_colour(make_colour_rgb(70, 100, 130));
draw_rectangle(_so_x1, _so_y1, _so_x2, _so_y1 + 16, false);
// Armrests
draw_rectangle(_so_x1, _so_y1 + 8, _so_x1 + 8, _so_y2, false);
draw_rectangle(_so_x2 - 8, _so_y1 + 8, _so_x2, _so_y2, false);
// Throw pillow
draw_set_colour(make_colour_rgb(220, 180, 90));
draw_rectangle(_so_x1 + 10, _so_y1 + 20, _so_x1 + 26, _so_y1 + 36, false);
draw_set_colour(make_colour_rgb(180, 140, 60));
draw_rectangle(_so_x1 + 10, _so_y1 + 20, _so_x1 + 26, _so_y1 + 36, true);

// Coffee table in front of sofa
var _tb_x1 = 150;
var _tb_x2 = 220;
var _tb_y1 = 296;
var _tb_y2 = 320;
draw_set_colour(make_colour_rgb(110, 75, 45));
draw_rectangle(_tb_x1, _tb_y1, _tb_x2, _tb_y2, false);
draw_set_colour(make_colour_rgb(85, 55, 30));
draw_rectangle(_tb_x1, _tb_y1, _tb_x2, _tb_y1 + 4, false);
// Teacup
draw_set_colour(c_white);
draw_circle(_tb_x1 + 18, _tb_y1 + 4, 5, false);
draw_set_colour(make_colour_rgb(160, 120, 200));
draw_rectangle(_tb_x1 + 14, _tb_y1 + 2, _tb_x1 + 22, _tb_y1 + 5, false);
// Steam
var _steam_t = current_time / 500;
draw_set_alpha(0.35);
draw_set_colour(c_white);
for (var _st = 0; _st < 3; _st++) {
    var _sty = _tb_y1 - 4 - _st * 4 + sin(_steam_t + _st) * 1;
    var _stx = _tb_x1 + 18 + sin(_steam_t * 1.3 + _st) * 2;
    draw_circle(_stx, _sty, 2, false);
}
draw_set_alpha(1);
// Open book on table
draw_set_colour(make_colour_rgb(250, 240, 210));
draw_rectangle(_tb_x1 + 36, _tb_y1 + 2, _tb_x1 + 60, _tb_y1 + 14, false);
draw_set_colour(make_colour_rgb(160, 120, 90));
draw_line(_tb_x1 + 48, _tb_y1 + 2, _tb_x1 + 48, _tb_y1 + 14);
draw_set_colour(make_colour_rgb(180, 160, 140));
draw_line(_tb_x1 + 38, _tb_y1 + 5, _tb_x1 + 46, _tb_y1 + 5);
draw_line(_tb_x1 + 38, _tb_y1 + 8, _tb_x1 + 46, _tb_y1 + 8);
draw_line(_tb_x1 + 50, _tb_y1 + 5, _tb_x1 + 58, _tb_y1 + 5);
draw_line(_tb_x1 + 50, _tb_y1 + 8, _tb_x1 + 58, _tb_y1 + 8);

// ===========================================
// POTTED PLANT (lower right, near door)
// ===========================================
var _pl_x = 448;
var _pl_y = 288;
// Pot
draw_set_colour(make_colour_rgb(170, 90, 50));
draw_rectangle(_pl_x - 12, _pl_y, _pl_x + 12, _pl_y + 20, false);
draw_set_colour(make_colour_rgb(140, 70, 35));
draw_rectangle(_pl_x - 14, _pl_y - 2, _pl_x + 14, _pl_y + 2, false);
// Leaves
draw_set_colour(make_colour_rgb(70, 160, 80));
draw_circle(_pl_x - 6, _pl_y - 4, 7, false);
draw_circle(_pl_x + 6, _pl_y - 4, 7, false);
draw_circle(_pl_x, _pl_y - 12, 7, false);
draw_set_colour(make_colour_rgb(90, 190, 100));
draw_circle(_pl_x - 4, _pl_y - 8, 3, false);
draw_circle(_pl_x + 4, _pl_y - 10, 3, false);
// Flower bloom
draw_set_colour(make_colour_rgb(240, 140, 200));
draw_circle(_pl_x - 2, _pl_y - 16, 3, false);
draw_set_colour(make_colour_rgb(255, 220, 130));
draw_circle(_pl_x - 2, _pl_y - 16, 1, false);

// ===========================================
// DOOR (south wall, center) — exit to exterior
// ===========================================
draw_set_colour(make_colour_rgb(100, 60, 30));
draw_rectangle(door_x1, door_y1 - 16, door_x2, door_y2, false);
draw_set_colour(make_colour_rgb(80, 45, 20));
draw_rectangle(door_x1, door_y1 - 16, door_x2, door_y2, true);
// Panels
draw_set_colour(make_colour_rgb(90, 52, 25));
draw_rectangle(door_x1 + 6, door_y1 - 10, door_x2 - 6, door_y1 + 18, true);
draw_rectangle(door_x1 + 6, door_y1 + 22, door_x2 - 6, door_y2 - 6, true);
// Handle
draw_set_colour(make_colour_rgb(220, 180, 60));
draw_circle(door_x2 - 10, door_y1 + 16, 2, false);

// Welcome mat in front of door
draw_set_colour(make_colour_rgb(140, 80, 50));
draw_rectangle(door_x1 - 8, door_y2 - 6, door_x2 + 8, door_y2, false);
draw_set_colour(make_colour_rgb(120, 65, 35));
draw_rectangle(door_x1 - 8, door_y2 - 6, door_x2 + 8, door_y2, true);

// ===========================================
// WARM VIGNETTE — subtle soft lighting overlay
// ===========================================
draw_set_alpha(0.1);
draw_set_colour(make_colour_rgb(255, 180, 100));
draw_rectangle(0, 0, 640, 384, false);
draw_set_alpha(1);

// Reset
draw_set_colour(c_white);
