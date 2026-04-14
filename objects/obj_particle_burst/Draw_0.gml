if (!setup_done || dots == -1) exit;

for (var i = 0; i < burst_count; i++) {
    var _d = dots[i];
    if (_d.life <= 0) continue;

    var _t = _d.life / _d.life_max;  // 1 → 0
    var _radius = _d.r * _t;
    var _alpha  = _t;

    draw_set_alpha(_alpha);
    draw_set_colour(burst_colour);
    draw_circle(_d.px, _d.py, max(_radius, 0.5), false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
