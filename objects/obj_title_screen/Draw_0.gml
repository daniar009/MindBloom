// Title screen background — cozy storybook scene in room space (640x360).

anim_timer += 0.04;
var _t = anim_timer;
var _W = 640;
var _H = 360;

// -----------------------------
// SKY — pastel sunset gradient
// -----------------------------
var _sky_top = make_colour_rgb(255, 195, 215);
var _sky_mid = make_colour_rgb(255, 220, 195);
var _sky_bot = make_colour_rgb(255, 240, 200);

draw_rectangle_colour(0, 0,   _W, 160, _sky_top, _sky_top, _sky_mid, _sky_mid, false);
draw_rectangle_colour(0, 160, _W, 260, _sky_mid, _sky_mid, _sky_bot, _sky_bot, false);

// -----------------------------
// SPARKLES — tiny twinkling dots
// -----------------------------
for (var i = 0; i < sparkle_count; i++) {
    var _alpha = 0.3 + 0.5 * abs(sin(_t * 2 + sparkle_phase[i]));
    draw_set_alpha(_alpha);
    draw_set_colour(c_white);
    draw_rectangle(sparkle_x[i], sparkle_y[i], sparkle_x[i] + 1, sparkle_y[i] + 1, false);
}
draw_set_alpha(1);

// -----------------------------
// SUN with cute face
// -----------------------------
var _sun_x = 110;
var _sun_y = 90 + sin(_t * 0.8) * 3;
var _sun_r = 32;

// Glow rings
draw_set_alpha(0.10);
draw_set_colour(make_colour_rgb(255, 240, 180));
draw_circle(_sun_x, _sun_y, _sun_r + 14, false);
draw_circle(_sun_x, _sun_y, _sun_r + 22, false);
draw_circle(_sun_x, _sun_y, _sun_r + 30, false);
draw_set_alpha(1);

// Body + outline
draw_set_colour(make_colour_rgb(255, 225, 120));
draw_circle(_sun_x, _sun_y, _sun_r, false);
draw_set_colour(make_colour_rgb(255, 205, 90));
draw_circle(_sun_x, _sun_y, _sun_r, true);

// Eyes
draw_set_colour(make_colour_rgb(100, 60, 30));
draw_circle(_sun_x - 10, _sun_y - 4, 2.4, false);
draw_circle(_sun_x + 10, _sun_y - 4, 2.4, false);
draw_set_colour(c_white);
draw_circle(_sun_x - 9,  _sun_y - 5, 0.9, false);
draw_circle(_sun_x + 11, _sun_y - 5, 0.9, false);

// Smile (simple arc from short line segments)
draw_set_colour(make_colour_rgb(100, 60, 30));
var _sa = -0.7;
while (_sa <= 0.7) {
    var _lx1 = _sun_x + sin(_sa) * 9;
    var _ly1 = _sun_y + 4 + cos(_sa) * 9;
    var _lx2 = _sun_x + sin(_sa + 0.14) * 9;
    var _ly2 = _sun_y + 4 + cos(_sa + 0.14) * 9;
    draw_line_width(_lx1, _ly1, _lx2, _ly2, 2);
    _sa += 0.14;
}

// Blush
draw_set_alpha(0.7);
draw_set_colour(make_colour_rgb(255, 160, 170));
draw_circle(_sun_x - 15, _sun_y + 2, 3, false);
draw_circle(_sun_x + 15, _sun_y + 2, 3, false);
draw_set_alpha(1);

// -----------------------------
// CLOUDS — drifting puffs
// -----------------------------
for (var i = 0; i < cloud_count; i++) {
    cloud_x[i] += cloud_speed[i];
    if (cloud_x[i] > _W + 60) cloud_x[i] = -60;

    var _cx = cloud_x[i];
    var _cy = cloud_y[i];
    var _s  = cloud_scale[i];

    draw_set_colour(c_white);
    draw_circle(_cx - 10 * _s, _cy,     9 * _s,  false);
    draw_circle(_cx + 10 * _s, _cy,     9 * _s,  false);
    draw_circle(_cx,           _cy - 4, 11 * _s, false);
    draw_ellipse(_cx - 18 * _s, _cy - 2, _cx + 18 * _s, _cy + 6, false);

    // Pink underside tint
    draw_set_colour(make_colour_rgb(255, 230, 240));
    draw_ellipse(_cx - 16 * _s, _cy + 2, _cx + 16 * _s, _cy + 6, false);
}

// -----------------------------
// HILLS — rolling layers
// -----------------------------
// Back hill
draw_set_colour(make_colour_rgb(150, 200, 140));
draw_primitive_begin(pr_trianglestrip);
for (var hx = 0; hx <= 640; hx += 8) {
    var _hy = 240 + sin((hx / 90) + 0.2) * 18;
    draw_vertex(hx, _hy);
    draw_vertex(hx, 360);
}
draw_primitive_end();

// Middle hill
draw_set_colour(make_colour_rgb(120, 185, 115));
draw_primitive_begin(pr_trianglestrip);
for (var hx = 0; hx <= 640; hx += 8) {
    var _hy = 270 + sin((hx / 70) + 2.1) * 14;
    draw_vertex(hx, _hy);
    draw_vertex(hx, 360);
}
draw_primitive_end();

// Front hill
draw_set_colour(make_colour_rgb(95, 170, 95));
draw_primitive_begin(pr_trianglestrip);
for (var hx = 0; hx <= 640; hx += 8) {
    var _hy = 298 + sin((hx / 60) + 4.3) * 10;
    draw_vertex(hx, _hy);
    draw_vertex(hx, 360);
}
draw_primitive_end();

// Foreground grass strip
draw_rectangle_colour(
    0, 320, _W, _H,
    make_colour_rgb(95, 170, 95), make_colour_rgb(95, 170, 95),
    make_colour_rgb(70, 140, 75), make_colour_rgb(70, 140, 75),
    false
);

// Grass tufts along the ground
draw_set_colour(make_colour_rgb(130, 200, 120));
for (var gx = 4; gx < 640; gx += 11) {
    var _gy = 322 + sin(gx * 0.7) * 1.2;
    draw_line_width(gx,     _gy + 4, gx,     _gy - 2, 1);
    draw_line_width(gx - 2, _gy + 4, gx - 2, _gy,     1);
    draw_line_width(gx + 2, _gy + 4, gx + 2, _gy,     1);
}

// -----------------------------
// FLOWERS on grass
// -----------------------------
for (var i = 0; i < flower_count; i++) {
    var _fx   = flower_x[i];
    var _fy   = flower_y[i];
    var _sway = sin(_t + flower_phase[i]) * 1.2;

    // Stem
    draw_set_colour(make_colour_rgb(70, 130, 70));
    draw_line_width(_fx, _fy + 4, _fx + _sway, _fy - 3, 1);

    // Petals
    draw_set_colour(make_colour_rgb(flower_r[i], flower_g[i], flower_b[i]));
    var _cx = _fx + _sway;
    var _cy = _fy - 4;
    var _pa = 0;
    while (_pa < 6.283) {
        draw_circle(_cx + cos(_pa) * 2.6, _cy + sin(_pa) * 2.6, 1.9, false);
        _pa += 1.2566;
    }

    // Center
    draw_set_colour(make_colour_rgb(255, 220, 100));
    draw_circle(_cx, _cy, 1.4, false);
}

// -----------------------------
// BUTTERFLIES — drifting figure-eights
// -----------------------------
for (var i = 0; i < butterfly_count; i++) {
    butterfly_ph[i] += butterfly_sp[i];
    var _bx   = butterfly_bx[i] + cos(butterfly_ph[i]) * butterfly_rad[i];
    var _by   = butterfly_by[i] + sin(butterfly_ph[i] * 1.3) * (butterfly_rad[i] * 0.55);
    var _wing = 0.6 + abs(sin(_t * 6 + i)) * 0.8;

    // Shadow
    draw_set_alpha(0.15);
    draw_set_colour(c_black);
    draw_ellipse(_bx - 4, _by + 6, _bx + 4, _by + 8, false);
    draw_set_alpha(1);

    // Wings
    draw_set_colour(make_colour_rgb(butterfly_col_r[i], butterfly_col_g[i], butterfly_col_b[i]));
    draw_ellipse(_bx - 5 * _wing, _by - 3, _bx - 1, _by + 2, false);
    draw_ellipse(_bx + 1, _by - 3, _bx + 5 * _wing, _by + 2, false);

    // Body
    draw_set_colour(make_colour_rgb(60, 45, 30));
    draw_line_width(_bx, _by - 2, _bx, _by + 2, 1);
}

// -----------------------------
// RISING HEARTS
// -----------------------------
for (var i = 0; i < heart_count; i++) {
    heart_y[i] -= heart_speed[i];
    if (heart_y[i] < -10) {
        heart_y[i] = 370;
        heart_x[i] = irandom(_W);
    }

    var _hx = heart_x[i] + sin(_t * 1.5 + heart_phase[i]) * 4;
    var _hy = heart_y[i];
    var _hs = heart_scale[i];

    draw_set_alpha(0.6);
    draw_set_colour(make_colour_rgb(255, 150, 180));
    draw_circle(_hx - 2 * _hs, _hy - 1, 2.4 * _hs, false);
    draw_circle(_hx + 2 * _hs, _hy - 1, 2.4 * _hs, false);
    draw_triangle(
        _hx - 4 * _hs, _hy,
        _hx + 4 * _hs, _hy,
        _hx,           _hy + 4 * _hs,
        false
    );
    draw_set_alpha(1);
}

draw_set_colour(c_white);
