var _t = life / life_max;  // 0 → 1
var _alpha = (1 - _t) * 0.35;
var _expand = 1 + _t * 0.8;

draw_set_alpha(_alpha);
draw_set_colour(make_colour_rgb(200, 190, 170));

for (var i = 0; i < array_length(puffs); i++) {
    var _p = puffs[i];
    draw_circle(x + _p.ox * _expand, y + _p.oy * _expand - _t * 3, _p.r * _expand, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
