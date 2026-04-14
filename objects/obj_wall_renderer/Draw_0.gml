// =========================================
// WOOD FLOOR PLANKS
// Soft lines drawn over the ground tiles so walkable space looks like
// wooden planks. Kept subtle so it doesn't fight the sprites.
// =========================================
var _plank_dark  = make_colour_rgb(90,  60, 35);   // plank seam / shadow
var _plank_light = make_colour_rgb(200, 160, 105); // plank highlight
var _grain       = make_colour_rgb(130, 90,  50);  // wood grain

for (var f = 0; f < array_length(floor_list); f++) {
    var _t  = floor_list[f];
    var _tx = _t.fx;
    var _ty = _t.fy;
    var _so = _t.seam_offset;

    // Horizontal plank edge (top of each plank strip — 16px tall planks)
    draw_set_alpha(0.35);
    draw_line_colour(_tx, _ty,      _tx + 32, _ty,      _plank_dark, _plank_dark);
    draw_line_colour(_tx, _ty + 16, _tx + 32, _ty + 16, _plank_dark, _plank_dark);

    // Thin highlight line just under each seam (fake bevel)
    draw_set_alpha(0.25);
    draw_line_colour(_tx, _ty + 1,  _tx + 32, _ty + 1,  _plank_light, _plank_light);
    draw_line_colour(_tx, _ty + 17, _tx + 32, _ty + 17, _plank_light, _plank_light);

    // Vertical plank seams — staggered per row so planks feel offset
    draw_set_alpha(0.4);
    var _seam1 = _tx + _so;
    var _seam2 = _tx + 16 + ((_so + 16) mod 32);
    draw_line_colour(_seam1, _ty,      _seam1, _ty + 16, _plank_dark, _plank_dark);
    draw_line_colour(_seam2, _ty + 16, _seam2, _ty + 32, _plank_dark, _plank_dark);

    // Little grain fleck for texture — placed deterministically so it
    // doesn't flicker between frames
    draw_set_alpha(0.2);
    var _gx = _tx + 6  + ((_t.fx + _t.fy) mod 18);
    var _gy = _ty + 6  + ((_t.fx * 3)     mod 12);
    draw_line_colour(_gx, _gy, _gx + 6, _gy, _grain, _grain);
}

draw_set_alpha(1);

// =========================================
// WALLS
// 32x32 sprites — one per collision tile, no vertical offset.
// =========================================
for (var i = 0; i < array_length(wall_list); i++) {
    var _w = wall_list[i];
    draw_sprite(spr_wall_2, 0, _w.wx, _w.wy);
}
