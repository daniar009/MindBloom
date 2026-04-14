breeze_t += 0.02;

// Butterflies drift in a lazy figure-eight around their home spot
for (var i = 0; i < array_length(butterflies); i++) {
    var _b = butterflies[i];
    _b.phase_a += _b.speed;
    _b.phase_b += _b.speed * 1.3;
    _b.wing_t  += 0.45;
    _b.x = _b.base_x + cos(_b.phase_a) * _b.radius;
    _b.y = _b.base_y + sin(_b.phase_b) * (_b.radius * 0.55);
}
